import SwiftUI

// 主界面 - App 的核心视图
struct ContentView: View {
    // 状态管理
    @StateObject private var voiceService = VoiceService()
    @State private var showFilePicker = false
    @State private var currentReport: MarketingReport?
    @State private var isAnalyzing = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showVoiceQuery = false

    var body: some View {
        NavigationView {
            ZStack {
                // 背景渐变色
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    // 顶部标题
                    headerView

                    // 主要内容区域
                    if let report = currentReport {
                        // 显示报告
                        reportView(report: report)
                    } else {
                        // 显示欢迎界面
                        welcomeView
                    }

                    Spacer()

                    // 底部按钮区域
                    bottomButtons
                }
                .padding()

                // 加载动画
                if isAnalyzing {
                    loadingView
                }
            }
            .navigationBarHidden(true)
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [.spreadsheet, .commaSeparatedText],
                allowsMultipleSelection: false
            ) { result in
                handleFileSelection(result)
            }
            .sheet(isPresented: $showVoiceQuery) {
                VoiceQueryView(
                    voiceService: voiceService,
                    report: currentReport
                )
            }
            .alert("错误", isPresented: $showError) {
                Button("确定") { showError = false }
            } message: {
                Text(errorMessage ?? "未知错误")
            }
        }
    }

    // MARK: - 子视图

    // 顶部标题
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 50))
                .foregroundStyle(.blue.gradient)

            Text("营销数据分析")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("AI 驱动的智能分析助手")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 40)
    }

    // 欢迎界面
    private var welcomeView: some View {
        VStack(spacing: 30) {
            Spacer()

            VStack(spacing: 15) {
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue.gradient)

                Text("开始分析")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("上传您的营销数据 Excel 文件\n获取 AI 智能分析报告")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
    }

    // 报告视图
    private func reportView(report: MarketingReport) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 报告标题
                HStack {
                    Text(report.month)
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: { currentReport = nil }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }

                // 核心指标卡片
                summaryCard(summary: report.summary)

                // 渠道表现
                channelsSection(channels: report.channels)

                // 关键发现
                insightsSection(insights: report.insights)

                // 优化建议
                recommendationsSection(recommendations: report.recommendations)
            }
            .padding()
        }
    }

    // 核心指标卡片
    private func summaryCard(summary: ReportSummary) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("核心指标")
                .font(.headline)
                .foregroundColor(.primary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MetricCard(title: "曝光量", value: "\(summary.totalImpressions.formatted())", icon: "eye.fill", color: .blue)
                MetricCard(title: "点击量", value: "\(summary.totalClicks.formatted())", icon: "hand.tap.fill", color: .green)
                MetricCard(title: "转化数", value: "\(summary.totalConversions.formatted())", icon: "checkmark.circle.fill", color: .orange)
                MetricCard(title: "ROI", value: String(format: "%.1f%%", summary.overallROI), icon: "chart.line.uptrend.xyaxis", color: .purple)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }

    // 渠道表现
    private func channelsSection(channels: [ChannelData]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("渠道表现")
                .font(.headline)

            ForEach(channels) { channel in
                ChannelRow(channel: channel)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }

    // 关键发现
    private func insightsSection(insights: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("关键发现")
                .font(.headline)

            ForEach(Array(insights.enumerated()), id: \.offset) { index, insight in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text(insight)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }

    // 优化建议
    private func recommendationsSection(recommendations: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("优化建议")
                .font(.headline)

            ForEach(Array(recommendations.enumerated()), id: \.offset) { index, recommendation in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    Text(recommendation)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }

    // 底部按钮
    private var bottomButtons: some View {
        HStack(spacing: 15) {
            // 上传文件按钮
            Button(action: { showFilePicker = true }) {
                Label(currentReport == nil ? "上传文件" : "重新上传", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            // 语音提问按钮（只在有报告时显示）
            if currentReport != nil {
                Button(action: { showVoiceQuery = true }) {
                    Label("语音提问", systemImage: "mic.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding(.bottom, 20)
    }

    // 加载动画
    private var loadingView: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)

                Text("AI 正在分析中...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(Color(.systemGray6))
            .cornerRadius(20)
        }
    }

    // MARK: - 处理文件选择

    private func handleFileSelection(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let fileURL = urls.first else { return }

            // 开始分析
            Task {
                await analyzeFile(fileURL)
            }

        case .failure(let error):
            errorMessage = "文件选择失败: \(error.localizedDescription)"
            showError = true
        }
    }

    // MARK: - 分析文件

    private func analyzeFile(_ fileURL: URL) async {
        isAnalyzing = true

        do {
            // 调用 API 上传并分析
            let report = try await APIService.shared.uploadExcelAndAnalyze(fileURL: fileURL)

            // 更新 UI（必须在主线程）
            await MainActor.run {
                currentReport = report
                isAnalyzing = false
            }
        } catch {
            await MainActor.run {
                isAnalyzing = false
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

// MARK: - 子组件

// 指标卡片
struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color.gradient)
                Spacer()
            }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

// 渠道行
struct ChannelRow: View {
    let channel: ChannelData

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(channel.name)
                .font(.headline)

            HStack {
                VStack(alignment: .leading) {
                    Text("ROI: \(String(format: "%.1f%%", channel.roi))")
                        .font(.caption)
                    Text("CTR: \(String(format: "%.2f%%", channel.ctr))")
                        .font(.caption)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("收入: ¥\(channel.revenue.formatted())")
                        .font(.caption)
                    Text("成本: ¥\(channel.cost.formatted())")
                        .font(.caption)
                }
            }
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
