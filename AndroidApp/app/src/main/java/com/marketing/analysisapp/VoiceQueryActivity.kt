package com.marketing.analysisapp

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.speech.tts.TextToSpeech
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.google.android.material.button.MaterialButton
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.google.android.material.progressindicator.CircularProgressIndicator
import com.google.android.material.textview.MaterialTextView
import kotlinx.coroutines.launch
import java.util.Locale

class VoiceQueryActivity : AppCompatActivity(), TextToSpeech.OnInitListener {

    private lateinit var questionText: MaterialTextView
    private lateinit var answerText: MaterialTextView
    private lateinit var micButton: FloatingActionButton
    private lateinit var submitButton: MaterialButton
    private lateinit var progressIndicator: CircularProgressIndicator

    private val apiService = ApiService()
    private var report: MarketingReport? = null

    private var speechRecognizer: SpeechRecognizer? = null
    private var tts: TextToSpeech? = null
    private var isListening = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_voice_query)

        report = intent.getParcelableExtra("report")

        initViews()
        setupSpeechRecognizer()
        setupTTS()
        setupClickListeners()
    }

    private fun initViews() {
        questionText = findViewById(R.id.questionText)
        answerText = findViewById(R.id.answerText)
        micButton = findViewById(R.id.micButton)
        submitButton = findViewById(R.id.submitButton)
        progressIndicator = findViewById(R.id.progressIndicator)

        progressIndicator.hide()
    }

    private fun setupSpeechRecognizer() {
        if (!SpeechRecognizer.isRecognitionAvailable(this)) {
            Toast.makeText(this, "语音识别不可用", Toast.LENGTH_LONG).show()
            return
        }

        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)
        speechRecognizer?.setRecognitionListener(object : RecognitionListener {
            override fun onReadyForSpeech(params: Bundle?) {
                questionText.text = "请说话..."
            }

            override fun onBeginningOfSpeech() {
                questionText.text = "正在录音..."
            }

            override fun onRmsChanged(rmsdB: Float) {}

            override fun onBufferReceived(buffer: ByteArray?) {}

            override fun onEndOfSpeech() {
                isListening = false
                updateMicButton()
            }

            override fun onError(error: Int) {
                isListening = false
                updateMicButton()
                val errorMessage = when (error) {
                    SpeechRecognizer.ERROR_AUDIO -> "音频错误"
                    SpeechRecognizer.ERROR_CLIENT -> "客户端错误"
                    SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> "权限不足"
                    SpeechRecognizer.ERROR_NETWORK -> "网络错误"
                    SpeechRecognizer.ERROR_NETWORK_TIMEOUT -> "网络超时"
                    SpeechRecognizer.ERROR_NO_MATCH -> "没有匹配"
                    SpeechRecognizer.ERROR_RECOGNIZER_BUSY -> "识别器忙碌"
                    SpeechRecognizer.ERROR_SERVER -> "服务器错误"
                    SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> "语音超时"
                    else -> "未知错误"
                }
                Toast.makeText(this@VoiceQueryActivity, "语音识别错误: $errorMessage", Toast.LENGTH_SHORT).show()
            }

            override fun onResults(results: Bundle?) {
                val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                if (!matches.isNullOrEmpty()) {
                    val text = matches[0]
                    questionText.text = text
                }
            }

            override fun onPartialResults(partialResults: Bundle?) {}

            override fun onEvent(eventType: Int, params: Bundle?) {}
        })
    }

    private fun setupTTS() {
        tts = TextToSpeech(this, this)
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            val result = tts?.setLanguage(Locale.CHINESE)
            if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                Toast.makeText(this, "中文语音不支持", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun setupClickListeners() {
        micButton.setOnClickListener {
            if (checkAudioPermission()) {
                if (isListening) {
                    stopListening()
                } else {
                    startListening()
                }
            }
        }

        submitButton.setOnClickListener {
            val question = questionText.text.toString()
            if (question.isNotEmpty() && question != "点击麦克风开始提问" && question != "请说话..." && question != "正在录音...") {
                submitQuestion(question)
            } else {
                Toast.makeText(this, "请先输入或录音提问", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun checkAudioPermission(): Boolean {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
            != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.RECORD_AUDIO),
                AUDIO_PERMISSION_REQUEST
            )
            return false
        }
        return true
    }

    private fun startListening() {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, "zh-CN")
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 1)
        }

        isListening = true
        updateMicButton()
        speechRecognizer?.startListening(intent)
    }

    private fun stopListening() {
        isListening = false
        updateMicButton()
        speechRecognizer?.stopListening()
    }

    private fun updateMicButton() {
        if (isListening) {
            micButton.setImageResource(android.R.drawable.ic_btn_speak_now)
        } else {
            micButton.setImageResource(android.R.drawable.ic_btn_speak_now)
        }
    }

    private fun submitQuestion(question: String) {
        lifecycleScope.launch {
            try {
                showLoading(true)
                answerText.text = "正在思考..."

                val answer = apiService.askQuestion(question, report != null)

                showLoading(false)
                answerText.text = answer

                // 语音播报答案
                speakAnswer(answer)

            } catch (e: Exception) {
                showLoading(false)
                answerText.text = "查询失败"
                Toast.makeText(
                    this@VoiceQueryActivity,
                    "错误: ${e.message}",
                    Toast.LENGTH_LONG
                ).show()
            }
        }
    }

    private fun speakAnswer(text: String) {
        tts?.speak(text, TextToSpeech.QUEUE_FLUSH, null, null)
    }

    private fun showLoading(show: Boolean) {
        if (show) {
            progressIndicator.show()
            submitButton.isEnabled = false
            micButton.isEnabled = false
        } else {
            progressIndicator.hide()
            submitButton.isEnabled = true
            micButton.isEnabled = true
        }
    }

    override fun onDestroy() {
        speechRecognizer?.destroy()
        tts?.stop()
        tts?.shutdown()
        super.onDestroy()
    }

    companion object {
        private const val AUDIO_PERMISSION_REQUEST = 1001
    }
}
