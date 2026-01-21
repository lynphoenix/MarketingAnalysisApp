# 后端 API 文档

这份文档说明了 iPhone App 需要调用的后端 API 接口。

## 基础信息

- **Base URL**: `https://your-server.com` （请替换为您的服务器地址）
- **Content-Type**: `application/json` 或 `multipart/form-data`

---

## 1. 上传并分析 Excel 文件

### 端点
```
POST /api/analyze
```

### 请求

**Content-Type**: `multipart/form-data`

**参数**:
- `file` (文件) - Excel 文件 (.xlsx, .xls, .csv)

**示例（curl）**:
```bash
curl -X POST https://your-server.com/api/analyze \
  -F "file=@marketing-data.xlsx"
```

### 响应

**成功响应 (200 OK)**:
```json
{
  "success": true,
  "report": {
    "month": "2024年12月",
    "summary": {
      "totalImpressions": 8977333,
      "totalClicks": 244334,
      "totalConversions": 25376,
      "totalCost": 373598.59,
      "totalRevenue": 9612251.09,
      "overallROI": 2472.88,
      "overallCTR": 2.72,
      "overallCR": 10.39
    },
    "channels": [
      {
        "name": "电子邮件",
        "impressions": 936581,
        "clicks": 112492,
        "conversions": 17992,
        "cost": 56178.44,
        "revenue": 7239751.43,
        "ctr": 12.01,
        "cr": 15.99,
        "roi": 12787.06,
        "cpc": 0.5,
        "cac": 3.12
      },
      {
        "name": "搜索广告",
        "impressions": 1591528,
        "clicks": 47327,
        "conversions": 3803,
        "cost": 163305.47,
        "revenue": 1317739.93,
        "ctr": 2.97,
        "cr": 8.04,
        "roi": 706.92,
        "cpc": 3.45,
        "cac": 42.94
      }
      // ... 其他渠道
    ],
    "insights": [
      "电子邮件营销是当前最佳渠道，ROI 高达 12787.06%",
      "搜索广告表现稳健，ROI 达 706.92%，转化稳定",
      "展示广告需要优化，虽然曝光量最大，但 ROI 仅 546.71%"
    ],
    "recommendations": [
      "扩大电子邮件营销规模，增加邮件列表",
      "优化展示广告投放，重新定位目标受众",
      "强化月末促销策略，提前预热",
      "优化社交媒体内容策略，提高转化率"
    ]
  }
}
```

**错误响应 (400/500)**:
```json
{
  "success": false,
  "report": null,
  "error": "文件格式不支持或数据解析失败"
}
```

---

## 2. 语音问答

### 端点
```
POST /api/query
```

### 请求

**Content-Type**: `application/json`

**Body**:
```json
{
  "question": "这个月哪个渠道效果最好？",
  "context": true
}
```

**参数说明**:
- `question` (string, 必需) - 用户的问题文本
- `context` (boolean, 可选) - 是否有报告上下文，默认 false

**示例（curl）**:
```bash
curl -X POST https://your-server.com/api/query \
  -H "Content-Type: application/json" \
  -d '{
    "question": "这个月哪个渠道效果最好？",
    "context": true
  }'
```

### 响应

**成功响应 (200 OK)**:
```json
{
  "success": true,
  "answer": "根据数据分析，电子邮件营销是本月表现最佳的渠道。它的 ROI 高达 12787.06%，远超其他渠道。同时转化率为 15.99%，说明受众精准度很高。电子邮件营销贡献了总收入的 75.3%，是最值得投入的渠道。"
}
```

**错误响应 (400/500)**:
```json
{
  "success": false,
  "answer": "",
  "error": "Claude API 调用失败"
}
```

---

## 后端实现建议

### 技术栈选择

#### 选项 1: Python + Flask/FastAPI
```python
# 推荐使用 FastAPI
from fastapi import FastAPI, File, UploadFile
from anthropic import Anthropic
import pandas as pd

app = FastAPI()

# 实现上述 API 端点
```

#### 选项 2: Node.js + Express
```javascript
const express = require('express');
const Anthropic = require('@anthropic-ai/sdk');
const xlsx = require('xlsx');

const app = express();

// 实现上述 API 端点
```

### 核心流程

#### /api/analyze 端点实现逻辑

1. **接收 Excel 文件**
   ```python
   # 读取上传的文件
   df = pd.read_excel(file)
   ```

2. **数据处理**
   ```python
   # 计算各种指标
   total_clicks = df['点击量'].sum()
   total_impressions = df['曝光量'].sum()
   ctr = (total_clicks / total_impressions) * 100
   # ... 更多计算
   ```

3. **调用 Claude API 生成洞察**
   ```python
   from anthropic import Anthropic

   client = Anthropic(api_key="your-api-key")

   message = client.messages.create(
       model="claude-3-5-sonnet-20241022",
       max_tokens=2000,
       messages=[{
           "role": "user",
           "content": f"分析以下营销数据并给出关键发现和建议：\n{data_summary}"
       }]
   )

   insights = message.content[0].text
   ```

4. **返回 JSON 响应**

#### /api/query 端点实现逻辑

1. **接收问题**
2. **可选：获取报告上下文**
3. **调用 Claude API**
   ```python
   message = client.messages.create(
       model="claude-3-5-sonnet-20241022",
       max_tokens=1000,
       messages=[{
           "role": "user",
           "content": f"用户问题：{question}\n\n请基于营销数据回答。"
       }]
   )
   ```
4. **返回答案**

### 环境变量

创建 `.env` 文件：
```env
ANTHROPIC_API_KEY=your_api_key_here
PORT=5000
ALLOWED_ORIGINS=*
```

### 安全建议

1. **API 密钥保护** - 不要把 API 密钥硬编码，使用环境变量
2. **文件大小限制** - 限制上传文件大小（如 10MB）
3. **CORS 配置** - 正确配置跨域请求
4. **速率限制** - 防止 API 滥用
5. **输入验证** - 验证上传的文件格式和内容

### 部署建议

- **云服务器**: AWS EC2, 阿里云 ECS, 腾讯云 CVM
- **容器化**: 使用 Docker 部署
- **HTTPS**: 必须使用 HTTPS，iOS 要求安全连接

---

## 测试

### 测试 /api/analyze

```bash
# 上传测试文件
curl -X POST http://localhost:5000/api/analyze \
  -F "file=@test-data.xlsx" \
  | jq '.'
```

### 测试 /api/query

```bash
# 发送问题
curl -X POST http://localhost:5000/api/query \
  -H "Content-Type: application/json" \
  -d '{"question": "这个月ROI最高的是哪个渠道？"}' \
  | jq '.'
```

---

## 附录：完整的 Python 后端示例

见 `backend_example.py` 文件。
