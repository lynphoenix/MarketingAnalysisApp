import SwiftUI

// 语音问答界面
struct VoiceQueryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var voiceService: VoiceService
    let report: MarketingReport?

    @State private var isQuerying = false
    @State private var answer: String = ""
    @State private var showError = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ZStack {
                // 背景
                LinearGradient(
                    colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    // 麦克风动画
                    microphoneView

                    // 识别的文本
                    recognizedTextView

                    // AI 回答
                    if !answer.isEmpty {
                        answerView
                    }

                    Spacer()

                    // 控制按钮
                    controlButtons
                }
                .padding()

                // 查询加载动画
                if isQuerying {
                    loadingView
                }
            }
            .navigationTitle("语音提问")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") { dismiss() }
                }
            }
            .alert("错误", isPresented: $showError) {
                Button("确定") { showError = false }
            } message: {
                Text(errorMessage ?? "未知错误")
            }
            .task {
                // 请求权限
                let granted = await voiceService.requestPermissions()
                if !granted {
                    errorMessage = "需要语音识别和麦克风权限"
                    showError = true
                }
            }
        }
    }

    // MARK: - 子视图

    // 麦克风视图
    private var microphoneView: some View {
        ZStack {
            // 背景圆圈（录音时有动画）
            Circle()
                .fill(voiceService.isRecording ? Color.red.opacity(0.2) : Color.gray.opacity(0.2))
                .frame(width: 150, height: 150)
                .scaleEffect(voiceService.isRecording ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: voiceService.isRecording)

            // 麦克风图标
            Image(systemName: voiceService.isRecording ? "mic.fill" : "mic")
                .font(.system(size: 60))
                .foregroundColor(voiceService.isRecording ? .red : .gray)
        }
        .padding(.top, 40)
    }

    // 识别的文本
    private var recognizedTextView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("您的问题：")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(voiceService.recognizedText.isEmpty ? "点击麦克风开始说话..." : voiceService.recognizedText)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.05), radius: 3)
        }
    }

    // AI 回答
    private var answerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("AI 回答：")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Spacer()

                // 播放按钮
                Button(action: { voiceService.speak(answer) }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundColor(.blue)
                }
            }

            ScrollView {
                Text(answer)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: 200)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 3)
        }
    }

    // 控制按钮
    private var controlButtons: some View {
        VStack(spacing: 15) {
            // 录音/停止按钮
            Button(action: toggleRecording) {
                Label(
                    voiceService.isRecording ? "停止录音" : "开始录音",
                    systemImage: voiceService.isRecording ? "stop.circle.fill" : "record.circle"
                )
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(voiceService.isRecording ? Color.red.gradient : Color.blue.gradient)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(isQuerying)

            // 提交问题按钮（只在有文本时显示）
            if !voiceService.recognizedText.isEmpty && !voiceService.isRecording {
                Button(action: submitQuery) {
                    Label("提交问题", systemImage: "paperplane.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(isQuerying)
            }

            // 清空按钮
            if !voiceService.recognizedText.isEmpty || !answer.isEmpty {
                Button(action: clearAll) {
                    Label("清空", systemImage: "trash")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.bottom, 20)
    }

    // 加载视图
    private var loadingView: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)

                Text("AI 正在思考...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(Color(.systemGray6))
            .cornerRadius(20)
        }
    }

    // MARK: - 操作

    // 切换录音状态
    private func toggleRecording() {
        if voiceService.isRecording {
            voiceService.stopRecording()
        } else {
            do {
                try voiceService.startRecording()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    // 提交问题
    private func submitQuery() {
        guard !voiceService.recognizedText.isEmpty else { return }

        Task {
            isQuerying = true

            do {
                // 调用 API 获取回答
                let response = try await APIService.shared.askQuestion(
                    voiceService.recognizedText,
                    reportContext: report
                )

                await MainActor.run {
                    answer = response
                    isQuerying = false

                    // 自动播放回答
                    voiceService.speak(response)
                }
            } catch {
                await MainActor.run {
                    isQuerying = false
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }

    // 清空所有内容
    private func clearAll() {
        voiceService.recognizedText = ""
        answer = ""
        voiceService.stopSpeaking()
    }
}
