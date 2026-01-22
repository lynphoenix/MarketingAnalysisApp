package com.marketing.analysisapp

import com.google.gson.Gson
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.File
import java.util.concurrent.TimeUnit

class ApiService {

    // 后端服务器地址
    private val baseUrl = "http://47.99.75.219:5000"

    private val client = OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.SECONDS)
        .writeTimeout(30, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .build()

    private val gson = Gson()

    /**
     * 上传Excel文件并获取分析报告
     */
    suspend fun uploadAndAnalyze(file: File): MarketingReport = withContext(Dispatchers.IO) {
        val requestBody = MultipartBody.Builder()
            .setType(MultipartBody.FORM)
            .addFormDataPart(
                "file",
                file.name,
                file.asRequestBody("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet".toMediaType())
            )
            .build()

        val request = Request.Builder()
            .url("$baseUrl/api/analyze")
            .post(requestBody)
            .build()

        val response = client.newCall(request).execute()

        if (!response.isSuccessful) {
            throw Exception("服务器错误: ${response.code}")
        }

        val responseBody = response.body?.string()
            ?: throw Exception("响应为空")

        val analysisResponse = gson.fromJson(responseBody, AnalysisResponse::class.java)

        if (!analysisResponse.success || analysisResponse.report == null) {
            throw Exception(analysisResponse.error ?: "分析失败")
        }

        analysisResponse.report
    }

    /**
     * 语音问答
     */
    suspend fun askQuestion(question: String, hasContext: Boolean = true): String = withContext(Dispatchers.IO) {
        val jsonBody = gson.toJson(
            mapOf(
                "question" to question,
                "context" to hasContext
            )
        )

        val requestBody = jsonBody.toRequestBody("application/json".toMediaType())

        val request = Request.Builder()
            .url("$baseUrl/api/query")
            .post(requestBody)
            .build()

        val response = client.newCall(request).execute()

        if (!response.isSuccessful) {
            throw Exception("服务器错误: ${response.code}")
        }

        val responseBody = response.body?.string()
            ?: throw Exception("响应为空")

        val queryResponse = gson.fromJson(responseBody, VoiceQueryResponse::class.java)

        if (!queryResponse.success) {
            throw Exception(queryResponse.error ?: "查询失败")
        }

        queryResponse.answer
    }
}
