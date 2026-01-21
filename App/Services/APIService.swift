import Foundation

// API 服务类 - 负责与后端服务器通信
class APIService {
    // 单例模式 - 整个 App 共用一个 APIService 实例
    static let shared = APIService()

    // ⚠️ 重要：请将这个 URL 改成您的后端服务器地址
    // 示例：https://your-server.com 或 http://192.168.1.100:5000
    private let baseURL = "YOUR_BACKEND_SERVER_URL"

    private init() {}

    // MARK: - 上传 Excel 并获取分析报告

    /// 上传 Excel 文件到后端进行分析
    /// - Parameter fileURL: Excel 文件的本地 URL
    /// - Returns: 营销分析报告
    func uploadExcelAndAnalyze(fileURL: URL) async throws -> MarketingReport {
        // 1. 创建上传 URL
        guard let uploadURL = URL(string: "\(baseURL)/api/analyze") else {
            throw APIError.invalidURL
        }

        // 2. 读取文件数据
        let fileData = try Data(contentsOf: fileURL)

        // 3. 创建 multipart/form-data 请求
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // 4. 构建请求体
        var body = Data()

        // 添加文件
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // 5. 发送请求
        let (data, response) = try await URLSession.shared.data(for: request)

        // 6. 检查 HTTP 状态码
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError
        }

        // 7. 解析响应
        let analysisResponse = try JSONDecoder().decode(AnalysisResponse.self, from: data)

        guard analysisResponse.success, let report = analysisResponse.report else {
            throw APIError.analysisF

ailed(analysisResponse.error ?? "Unknown error")
        }

        return report
    }

    // MARK: - 语音问答

    /// 发送语音识别的文本到后端，获取 AI 回答
    /// - Parameters:
    ///   - question: 用户的问题文本
    ///   - reportContext: 当前的报告数据（可选，用于上下文）
    /// - Returns: AI 的回答文本
    func askQuestion(_ question: String, reportContext: MarketingReport?) async throws -> String {
        // 1. 创建请求 URL
        guard let queryURL = URL(string: "\(baseURL)/api/query") else {
            throw APIError.invalidURL
        }

        // 2. 准备请求数据
        var request = URLRequest(url: queryURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 3. 构建请求体
        let requestBody: [String: Any] = [
            "question": question,
            "context": reportContext != nil ? true : false
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        // 4. 发送请求
        let (data, response) = try await URLSession.shared.data(for: request)

        // 5. 检查响应
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError
        }

        // 6. 解析响应
        let queryResponse = try JSONDecoder().decode(VoiceQueryResponse.self, from: data)

        guard queryResponse.success else {
            throw APIError.queryFailed(queryResponse.error ?? "Unknown error")
        }

        return queryResponse.answer
    }
}

// MARK: - API 错误类型

enum APIError: LocalizedError {
    case invalidURL
    case serverError
    case analysisFailed(String)
    case queryFailed(String)
    case networkError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的服务器地址"
        case .serverError:
            return "服务器错误，请稍后再试"
        case .analysisFailed(let message):
            return "分析失败：\(message)"
        case .queryFailed(let message):
            return "查询失败：\(message)"
        case .networkError:
            return "网络连接失败"
        }
    }
}
