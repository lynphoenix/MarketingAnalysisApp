#!/usr/bin/env python3
"""
营销分析 iPhone App 的后端 API 示例
使用 FastAPI + Anthropic Claude API
"""

from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from anthropic import Anthropic
import pandas as pd
import os
from typing import Optional
import json

# 创建 FastAPI 应用
app = FastAPI(title="Marketing Analysis API")

# 配置 CORS（允许 iOS App 访问）
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 生产环境应该限制具体域名
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 初始化 Claude API 客户端
# ⚠️ 重要：请在环境变量中设置 ANTHROPIC_API_KEY
client = Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))

# ============= 数据模型 =============

class ReportSummary(BaseModel):
    totalImpressions: int
    totalClicks: int
    totalConversions: int
    totalCost: float
    totalRevenue: float
    overallROI: float
    overallCTR: float
    overallCR: float

class ChannelData(BaseModel):
    name: str
    impressions: int
    clicks: int
    conversions: int
    cost: float
    revenue: float
    ctr: float
    cr: float
    roi: float
    cpc: float
    cac: float

class MarketingReport(BaseModel):
    month: str
    summary: ReportSummary
    channels: list[ChannelData]
    insights: list[str]
    recommendations: list[str]

class AnalysisResponse(BaseModel):
    success: bool
    report: Optional[MarketingReport] = None
    error: Optional[str] = None

class QueryRequest(BaseModel):
    question: str
    context: bool = False

class VoiceQueryResponse(BaseModel):
    success: bool
    answer: str = ""
    error: Optional[str] = None

# ============= 辅助函数 =============

def analyze_excel_data(df: pd.DataFrame) -> dict:
    """
    分析 Excel 数据并计算所有指标
    """
    # 确保数据列存在
    required_columns = ['日期', '渠道', '曝光量', '点击量', '转化数', '成本', '收入']
    if not all(col in df.columns for col in required_columns):
        raise ValueError(f"Excel 文件必须包含以下列: {', '.join(required_columns)}")

    # 转换日期
    df['日期'] = pd.to_datetime(df['日期'])
    month = df['日期'].dt.strftime('%Y年%m月').iloc[0]

    # 计算整体指标
    total_impressions = int(df['曝光量'].sum())
    total_clicks = int(df['点击量'].sum())
    total_conversions = int(df['转化数'].sum())
    total_cost = float(df['成本'].sum())
    total_revenue = float(df['收入'].sum())

    overall_roi = ((total_revenue - total_cost) / total_cost * 100) if total_cost > 0 else 0
    overall_ctr = (total_clicks / total_impressions * 100) if total_impressions > 0 else 0
    overall_cr = (total_conversions / total_clicks * 100) if total_clicks > 0 else 0

    # 按渠道汇总
    channel_summary = df.groupby('渠道').agg({
        '曝光量': 'sum',
        '点击量': 'sum',
        '转化数': 'sum',
        '成本': 'sum',
        '收入': 'sum'
    }).reset_index()

    # 计算渠道级指标
    channels = []
    for _, row in channel_summary.iterrows():
        impressions = int(row['曝光量'])
        clicks = int(row['点击量'])
        conversions = int(row['转化数'])
        cost = float(row['成本'])
        revenue = float(row['收入'])

        ctr = (clicks / impressions * 100) if impressions > 0 else 0
        cr = (conversions / clicks * 100) if clicks > 0 else 0
        roi = ((revenue - cost) / cost * 100) if cost > 0 else 0
        cpc = (cost / clicks) if clicks > 0 else 0
        cac = (cost / conversions) if conversions > 0 else 0

        channels.append({
            'name': row['渠道'],
            'impressions': impressions,
            'clicks': clicks,
            'conversions': conversions,
            'cost': round(cost, 2),
            'revenue': round(revenue, 2),
            'ctr': round(ctr, 2),
            'cr': round(cr, 2),
            'roi': round(roi, 2),
            'cpc': round(cpc, 2),
            'cac': round(cac, 2)
        })

    return {
        'month': month,
        'summary': {
            'totalImpressions': total_impressions,
            'totalClicks': total_clicks,
            'totalConversions': total_conversions,
            'totalCost': round(total_cost, 2),
            'totalRevenue': round(total_revenue, 2),
            'overallROI': round(overall_roi, 2),
            'overallCTR': round(overall_ctr, 2),
            'overallCR': round(overall_cr, 2)
        },
        'channels': channels
    }

def get_insights_from_claude(data_summary: dict) -> tuple[list[str], list[str]]:
    """
    使用 Claude API 生成洞察和建议
    """
    # 准备数据摘要
    prompt = f"""
你是一位专业的营销数据分析师。请基于以下营销数据提供分析：

## 整体数据
- 总曝光量：{data_summary['summary']['totalImpressions']:,}
- 总点击量：{data_summary['summary']['totalClicks']:,}
- 总转化数：{data_summary['summary']['totalConversions']:,}
- 总成本：¥{data_summary['summary']['totalCost']:,.2f}
- 总收入：¥{data_summary['summary']['totalRevenue']:,.2f}
- 整体 ROI：{data_summary['summary']['overallROI']:.2f}%

## 各渠道表现
"""
    for channel in data_summary['channels']:
        prompt += f"\n### {channel['name']}\n"
        prompt += f"- ROI: {channel['roi']:.2f}%, CTR: {channel['ctr']:.2f}%, 转化率: {channel['cr']:.2f}%\n"
        prompt += f"- 收入: ¥{channel['revenue']:,.2f}, 成本: ¥{channel['cost']:,.2f}\n"

    prompt += """
请提供：
1. 3-4个关键发现（每个一句话，重点突出最重要的洞察）
2. 3-4个优化建议（每个一句话，具体可执行）

请用 JSON 格式返回：
{
  "insights": ["发现1", "发现2", "发现3"],
  "recommendations": ["建议1", "建议2", "建议3"]
}
"""

    # 调用 Claude API
    message = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=1500,
        messages=[{
            "role": "user",
            "content": prompt
        }]
    )

    # 解析响应
    response_text = message.content[0].text

    # 尝试提取 JSON
    try:
        # 查找 JSON 部分
        start = response_text.find('{')
        end = response_text.rfind('}') + 1
        json_str = response_text[start:end]
        result = json.loads(json_str)

        insights = result.get('insights', [])
        recommendations = result.get('recommendations', [])
    except:
        # 如果解析失败，使用默认值
        insights = ["数据分析完成", "请查看详细指标"]
        recommendations = ["持续优化营销策略", "关注高 ROI 渠道"]

    return insights, recommendations

# ============= API 端点 =============

@app.get("/")
async def root():
    """API 根路径"""
    return {
        "message": "Marketing Analysis API",
        "version": "1.0.0",
        "endpoints": ["/api/analyze", "/api/query"]
    }

@app.post("/api/analyze", response_model=AnalysisResponse)
async def analyze_marketing_data(file: UploadFile = File(...)):
    """
    上传 Excel 文件并进行营销数据分析
    """
    try:
        # 1. 检查文件类型
        if not file.filename.endswith(('.xlsx', '.xls', '.csv')):
            raise HTTPException(status_code=400, detail="只支持 Excel 或 CSV 文件")

        # 2. 读取文件
        contents = await file.read()

        # 3. 解析 Excel
        if file.filename.endswith('.csv'):
            df = pd.read_csv(pd.io.common.BytesIO(contents))
        else:
            df = pd.read_excel(pd.io.common.BytesIO(contents))

        # 4. 分析数据
        data_summary = analyze_excel_data(df)

        # 5. 使用 Claude API 生成洞察和建议
        insights, recommendations = get_insights_from_claude(data_summary)

        # 6. 构建完整报告
        report = MarketingReport(
            month=data_summary['month'],
            summary=ReportSummary(**data_summary['summary']),
            channels=[ChannelData(**ch) for ch in data_summary['channels']],
            insights=insights,
            recommendations=recommendations
        )

        return AnalysisResponse(success=True, report=report)

    except ValueError as e:
        return AnalysisResponse(success=False, error=str(e))
    except Exception as e:
        return AnalysisResponse(success=False, error=f"分析失败: {str(e)}")

@app.post("/api/query", response_model=VoiceQueryResponse)
async def query_marketing_data(request: QueryRequest):
    """
    语音问答接口 - 使用 Claude API 回答营销相关问题
    """
    try:
        # 构建提示词
        prompt = f"""
你是一位营销数据分析助手。用户问了以下问题：

{request.question}

请用简洁、专业的语言回答（2-3句话即可）。如果问题与营销数据无关，请礼貌地引导用户询问营销相关的问题。
"""

        # 调用 Claude API
        message = client.messages.create(
            model="claude-3-5-sonnet-20241022",
            max_tokens=500,
            messages=[{
                "role": "user",
                "content": prompt
            }]
        )

        answer = message.content[0].text

        return VoiceQueryResponse(success=True, answer=answer)

    except Exception as e:
        return VoiceQueryResponse(success=False, error=f"查询失败: {str(e)}")

# ============= 启动服务 =============

if __name__ == "__main__":
    import uvicorn

    # 从环境变量获取端口，默认 5000
    port = int(os.environ.get("PORT", 5000))

    print(f"🚀 启动服务器: http://0.0.0.0:{port}")
    print("📝 API 文档: http://0.0.0.0:{port}/docs")
    print("⚠️  请确保已设置环境变量 ANTHROPIC_API_KEY")

    uvicorn.run(app, host="0.0.0.0", port=port)
