import Foundation
import Speech
import AVFoundation

// 语音服务类 - 处理语音输入和输出
class VoiceService: ObservableObject {
    // 语音识别器
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    // 语音合成器（朗读回答）
    private let synthesizer = AVSpeechSynthesizer()

    // 发布属性 - UI 可以监听这些变化
    @Published var isRecording = false
    @Published var recognizedText = ""
    @Published var errorMessage: String?

    // MARK: - 请求权限

    /// 请求语音识别和麦克风权限
    func requestPermissions() async -> Bool {
        // 请求语音识别权限
        let speechAuthStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }

        guard speechAuthStatus == .authorized else {
            errorMessage = "需要语音识别权限"
            return false
        }

        // 请求麦克风权限
        let audioAuthStatus = await AVAudioSession.sharedInstance().requestRecordPermission()

        guard audioAuthStatus else {
            errorMessage = "需要麦克风权限"
            return false
        }

        return true
    }

    // MARK: - 开始录音识别

    /// 开始录音并实时识别语音
    func startRecording() throws {
        // 如果已经在录音，先停止
        if audioEngine.isRunning {
            stopRecording()
        }

        // 重置识别文本
        recognizedText = ""

        // 配置音频会话
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        // 创建识别请求
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw VoiceError.recognitionFailed
        }

        recognitionRequest.shouldReportPartialResults = true

        // 配置音频输入
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        // 开始识别
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                // 更新识别的文本
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                }
            }

            if error != nil || (result?.isFinal ?? false) {
                // 识别完成或出错
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil

                DispatchQueue.main.async {
                    self.isRecording = false
                }
            }
        }

        // 启动音频引擎
        audioEngine.prepare()
        try audioEngine.start()

        isRecording = true
    }

    // MARK: - 停止录音

    /// 停止录音
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            isRecording = false
        }
    }

    // MARK: - 语音播报

    /// 将文本转换为语音播放
    /// - Parameter text: 要播放的文本
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.5 // 语速（0.0 - 1.0）
        utterance.pitchMultiplier = 1.0 // 音调
        utterance.volume = 1.0 // 音量

        synthesizer.speak(utterance)
    }

    /// 停止语音播放
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

// MARK: - 语音错误类型

enum VoiceError: LocalizedError {
    case recognitionFailed
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .recognitionFailed:
            return "语音识别失败"
        case .permissionDenied:
            return "需要语音识别和麦克风权限"
        }
    }
}
