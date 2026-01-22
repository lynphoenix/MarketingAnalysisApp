package com.marketing.analysisapp

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.provider.OpenableColumns
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.google.android.material.button.MaterialButton
import com.google.android.material.card.MaterialCardView
import com.google.android.material.progressindicator.CircularProgressIndicator
import com.google.android.material.textview.MaterialTextView
import kotlinx.coroutines.launch
import java.io.File
import java.io.FileOutputStream

class MainActivity : AppCompatActivity() {

    private lateinit var uploadButton: MaterialButton
    private lateinit var voiceButton: MaterialButton
    private lateinit var progressIndicator: CircularProgressIndicator
    private lateinit var statusText: MaterialTextView
    private lateinit var reportCard: MaterialCardView
    private lateinit var reportText: MaterialTextView

    private val apiService = ApiService()
    private var currentReport: MarketingReport? = null

    // 文件选择器
    private val filePickerLauncher = registerForActivityResult(
        ActivityResultContracts.GetContent()
    ) { uri: Uri? ->
        uri?.let { handleFileSelected(it) }
    }

    // 权限请求
    private val permissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { permissions ->
        val allGranted = permissions.values.all { it }
        if (allGranted) {
            Toast.makeText(this, "权限已授予", Toast.LENGTH_SHORT).show()
        } else {
            Toast.makeText(this, "需要相关权限才能正常使用", Toast.LENGTH_LONG).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        initViews()
        requestPermissions()
        setupClickListeners()
    }

    private fun initViews() {
        uploadButton = findViewById(R.id.uploadButton)
        voiceButton = findViewById(R.id.voiceButton)
        progressIndicator = findViewById(R.id.progressIndicator)
        statusText = findViewById(R.id.statusText)
        reportCard = findViewById(R.id.reportCard)
        reportText = findViewById(R.id.reportText)

        // 初始隐藏进度和报告
        progressIndicator.hide()
        reportCard.visibility = android.view.View.GONE
    }

    private fun requestPermissions() {
        val permissions = mutableListOf<String>()

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
            != PackageManager.PERMISSION_GRANTED) {
            permissions.add(Manifest.permission.RECORD_AUDIO)
        }

        if (android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.P) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {
                permissions.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
            }
        }

        if (permissions.isNotEmpty()) {
            permissionLauncher.launch(permissions.toTypedArray())
        }
    }

    private fun setupClickListeners() {
        uploadButton.setOnClickListener {
            openFilePicker()
        }

        voiceButton.setOnClickListener {
            if (currentReport != null) {
                val intent = Intent(this, VoiceQueryActivity::class.java)
                intent.putExtra("report", currentReport)
                startActivity(intent)
            } else {
                Toast.makeText(this, "请先上传并分析数据", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun openFilePicker() {
        filePickerLauncher.launch("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    }

    private fun handleFileSelected(uri: Uri) {
        try {
            val fileName = getFileName(uri)
            statusText.text = "正在上传: $fileName"

            // 复制文件到临时位置
            val inputStream = contentResolver.openInputStream(uri)
            val tempFile = File(cacheDir, fileName)
            val outputStream = FileOutputStream(tempFile)

            inputStream?.use { input ->
                outputStream.use { output ->
                    input.copyTo(output)
                }
            }

            // 上传并分析
            uploadAndAnalyze(tempFile)

        } catch (e: Exception) {
            Toast.makeText(this, "文件读取失败: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    private fun getFileName(uri: Uri): String {
        var result = "file.xlsx"
        contentResolver.query(uri, null, null, null, null)?.use { cursor ->
            if (cursor.moveToFirst()) {
                val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (nameIndex != -1) {
                    result = cursor.getString(nameIndex)
                }
            }
        }
        return result
    }

    private fun uploadAndAnalyze(file: File) {
        lifecycleScope.launch {
            try {
                showLoading(true)
                statusText.text = "正在分析数据..."
                voiceButton.isEnabled = false

                val report = apiService.uploadAndAnalyze(file)
                currentReport = report

                showLoading(false)
                displayReport(report)
                statusText.text = "分析完成！"
                voiceButton.isEnabled = true

            } catch (e: Exception) {
                showLoading(false)
                statusText.text = "分析失败"
                Toast.makeText(
                    this@MainActivity,
                    "错误: ${e.message}",
                    Toast.LENGTH_LONG
                ).show()
            }
        }
    }

    private fun displayReport(report: MarketingReport) {
        reportCard.visibility = android.view.View.VISIBLE

        val reportContent = buildString {
            append("📊 ${report.month} 营销分析报告\n\n")

            append("=== 核心指标 ===\n")
            append("总曝光量: ${formatNumber(report.summary.totalImpressions)}\n")
            append("总点击量: ${formatNumber(report.summary.totalClicks)}\n")
            append("总转化数: ${formatNumber(report.summary.totalConversions)}\n")
            append("总成本: ¥${formatMoney(report.summary.totalCost)}\n")
            append("总收入: ¥${formatMoney(report.summary.totalRevenue)}\n")
            append("整体ROI: ${formatPercent(report.summary.overallROI)}%\n")
            append("点击率: ${formatPercent(report.summary.overallCTR)}%\n")
            append("转化率: ${formatPercent(report.summary.overallCR)}%\n\n")

            append("=== 各渠道表现 ===\n")
            report.channels.forEach { channel ->
                append("\n${channel.name}:\n")
                append("  曝光: ${formatNumber(channel.impressions)}\n")
                append("  点击: ${formatNumber(channel.clicks)} (CTR: ${formatPercent(channel.ctr)}%)\n")
                append("  转化: ${formatNumber(channel.conversions)} (CR: ${formatPercent(channel.cr)}%)\n")
                append("  ROI: ${formatPercent(channel.roi)}%\n")
            }

            append("\n\n=== 关键发现 ===\n")
            report.insights.forEachIndexed { index, insight ->
                append("${index + 1}. $insight\n")
            }

            append("\n=== 优化建议 ===\n")
            report.recommendations.forEachIndexed { index, recommendation ->
                append("${index + 1}. $recommendation\n")
            }
        }

        reportText.text = reportContent
    }

    private fun showLoading(show: Boolean) {
        if (show) {
            progressIndicator.show()
            uploadButton.isEnabled = false
        } else {
            progressIndicator.hide()
            uploadButton.isEnabled = true
        }
    }

    private fun formatNumber(num: Int): String {
        return String.format("%,d", num)
    }

    private fun formatMoney(amount: Double): String {
        return String.format("%,.2f", amount)
    }

    private fun formatPercent(percent: Double): String {
        return String.format("%.2f", percent)
    }
}
