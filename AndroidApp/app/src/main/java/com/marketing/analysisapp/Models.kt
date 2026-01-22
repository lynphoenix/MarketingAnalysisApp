package com.marketing.analysisapp

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import com.google.gson.annotations.SerializedName

/**
 * 营销报告
 */
@Parcelize
data class MarketingReport(
    val month: String,
    val summary: ReportSummary,
    val channels: List<ChannelData>,
    val insights: List<String>,
    val recommendations: List<String>
) : Parcelable

/**
 * 报告概览
 */
@Parcelize
data class ReportSummary(
    @SerializedName("totalImpressions")
    val totalImpressions: Int,

    @SerializedName("totalClicks")
    val totalClicks: Int,

    @SerializedName("totalConversions")
    val totalConversions: Int,

    @SerializedName("totalCost")
    val totalCost: Double,

    @SerializedName("totalRevenue")
    val totalRevenue: Double,

    @SerializedName("overallROI")
    val overallROI: Double,

    @SerializedName("overallCTR")
    val overallCTR: Double,

    @SerializedName("overallCR")
    val overallCR: Double
) : Parcelable

/**
 * 渠道数据
 */
@Parcelize
data class ChannelData(
    val name: String,
    val impressions: Int,
    val clicks: Int,
    val conversions: Int,
    val cost: Double,
    val revenue: Double,
    val ctr: Double,
    val cr: Double,
    val roi: Double,
    val cpc: Double,
    val cac: Double
) : Parcelable

/**
 * API 分析响应
 */
data class AnalysisResponse(
    val success: Boolean,
    val report: MarketingReport?,
    val error: String?
)

/**
 * API 语音查询响应
 */
data class VoiceQueryResponse(
    val success: Boolean,
    val answer: String,
    val error: String?
)
