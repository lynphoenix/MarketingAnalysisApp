import Foundation

// 营销报告的数据模型
// Codable 让它可以轻松转换为 JSON 格式，方便与后端通信
struct MarketingReport: Codable, Identifiable {
    let id = UUID()
    let month: String           // 报告月份，如 "2024年12月"
    let summary: ReportSummary  // 核心指标概览
    let channels: [ChannelData] // 各渠道数据
    let insights: [String]      // 关键发现
    let recommendations: [String] // 优化建议

    enum CodingKeys: String, CodingKey {
        case month, summary, channels, insights, recommendations
    }
}

// 报告概览数据
struct ReportSummary: Codable {
    let totalImpressions: Int    // 总曝光量
    let totalClicks: Int         // 总点击量
    let totalConversions: Int    // 总转化数
    let totalCost: Double        // 总成本
    let totalRevenue: Double     // 总收入
    let overallROI: Double       // 整体 ROI
    let overallCTR: Double       // 整体点击率
    let overallCR: Double        // 整体转化率
}

// 单个渠道的数据
struct ChannelData: Codable, Identifiable {
    let id = UUID()
    let name: String            // 渠道名称
    let impressions: Int        // 曝光量
    let clicks: Int             // 点击量
    let conversions: Int        // 转化数
    let cost: Double            // 成本
    let revenue: Double         // 收入
    let ctr: Double             // 点击率 (%)
    let cr: Double              // 转化率 (%)
    let roi: Double             // ROI (%)
    let cpc: Double             // 单次点击成本
    let cac: Double             // 客户获取成本

    enum CodingKeys: String, CodingKey {
        case name, impressions, clicks, conversions, cost, revenue
        case ctr, cr, roi, cpc, cac
    }
}

// API 响应模型
struct AnalysisResponse: Codable {
    let success: Bool
    let report: MarketingReport?
    let error: String?
}

// 语音问答响应
struct VoiceQueryResponse: Codable {
    let success: Bool
    let answer: String
    let error: String?
}
