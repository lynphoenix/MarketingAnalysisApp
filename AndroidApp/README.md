# 📱 营销分析 Android App

支持 Android 7.0+ 和鸿蒙 4.2+

## ✨ 功能特点

- 📤 上传 Excel 营销数据文件
- 🤖 AI 智能分析（基于 Claude API）
- 📊 可视化报告展示
- 🎤 语音提问与回答
- 🔊 语音播报分析结果
- ✅ 支持鸿蒙 HarmonyOS 4.2

## 🚀 快速开始

### 方法 1: 使用预编译 APK（最简单）

1. 下载 `app-debug.apk`
2. 传输到 Android/鸿蒙手机
3. 打开文件管理器，点击 APK 安装
4. 允许"未知来源"安装（如果需要）
5. 打开应用，开始使用

### 方法 2: 从源代码构建

#### 前置要求

- **JDK 17+** ([下载](https://adoptium.net/))
- **Android Studio** (推荐) 或 **Android Command Line Tools**
- **Gradle** (Android Studio 自带)

#### 构建步骤

**使用 Android Studio (推荐):**

1. 打开 Android Studio
2. File → Open → 选择 `AndroidApp` 文件夹
3. 等待 Gradle 同步完成
4. Build → Build Bundle(s) / APK(s) → Build APK(s)
5. APK 生成在: `app/build/outputs/apk/debug/app-debug.apk`

**使用命令行:**

```bash
cd AndroidApp
chmod +x build_apk.sh
./build_apk.sh
```

或手动执行:

```bash
cd AndroidApp
./gradlew assembleDebug
```

## 📋 系统要求

### Android
- **最低版本**: Android 7.0 (API 24)
- **目标版本**: Android 14 (API 34)
- **架构**: ARM, ARM64, x86, x86_64

### 鸿蒙 HarmonyOS
- **支持版本**: HarmonyOS 4.2+
- **兼容性**: 完全兼容 Android 应用

## 🔧 配置

### 后端服务器

后端地址已配置在 `ApiService.kt`:
```kotlin
private val baseUrl = "http://47.99.75.219:5000"
```

如需修改:
1. 打开 `app/src/main/java/com/marketing/analysisapp/ApiService.kt`
2. 修改第 17 行的 `baseUrl`
3. 重新构建 APK

### 权限说明

应用需要以下权限:
- **网络访问**: 连接后端服务器
- **文件访问**: 读取 Excel 文件
- **麦克风**: 语音识别
- **存储**: 保存文件（Android 9 及以下）

所有权限均会在首次使用时请求。

## 📱 使用指南

### 1. 上传分析

1. 点击"📤 上传 Excel 文件"
2. 选择你的营销数据 Excel 文件
3. 等待 AI 分析完成（约 10-30 秒）
4. 查看详细报告

### 2. 语音提问

1. 完成数据分析后，点击"🎤 语音提问"
2. 点击麦克风按钮开始录音
3. 说出你的问题，例如：
   - "这个月哪个渠道效果最好？"
   - "ROI 最高的是哪个？"
   - "给我一些优化建议"
4. 点击"提交问题"
5. AI 会回答你的问题并自动语音播报

## 📊 Excel 数据格式

Excel 文件应包含以下列:

| 列名 | 说明 | 类型 |
|------|------|------|
| 日期 | 营销日期 | 日期 |
| 渠道 | 营销渠道名称 | 文本 |
| 曝光量 | 广告曝光次数 | 数字 |
| 点击量 | 广告点击次数 | 数字 |
| 转化数 | 转化次数 | 数字 |
| 成本 | 营销成本 | 数字 |
| 收入 | 营销收入 | 数字 |

示例:
```
日期        渠道      曝光量  点击量  转化数  成本      收入
2024-12-01  搜索广告  34918   898     65      2969.01   24363.92
2024-12-01  社交媒体  69739   1495    76      3044.11   18290.90
```

## 🔍 故障排查

### 问题 1: 无法安装 APK

**解决方案:**
1. 确保允许"未知来源"安装
2. Android: 设置 → 安全 → 允许未知来源
3. 鸿蒙: 设置 → 安全 → 更多安全设置 → 外部来源应用下载

### 问题 2: 无法连接后端

**检查:**
1. 手机网络是否正常
2. 后端服务器是否运行: http://47.99.75.219:5000
3. 防火墙设置

### 问题 3: 语音识别不工作

**解决方案:**
1. 确保已授予麦克风权限
2. 检查系统语音识别服务是否启用
3. 在安静环境下尝试

### 问题 4: 文件选择失败

**解决方案:**
1. 确保已授予存储权限
2. 确认文件是 .xlsx 格式
3. 尝试将文件移到下载文件夹

## 🏗️ 项目结构

```
AndroidApp/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── java/com/marketing/analysisapp/
│   │       │   ├── MainActivity.kt          # 主界面
│   │       │   ├── VoiceQueryActivity.kt    # 语音问答界面
│   │       │   ├── ApiService.kt            # API 服务
│   │       │   └── Models.kt                # 数据模型
│   │       ├── res/
│   │       │   ├── layout/                  # 布局文件
│   │       │   ├── values/                  # 资源文件
│   │       │   └── drawable/                # 图片资源
│   │       └── AndroidManifest.xml          # 应用配置
│   └── build.gradle                         # 应用构建配置
├── build.gradle                             # 项目构建配置
├── settings.gradle                          # Gradle 设置
└── build_apk.sh                            # 构建脚本
```

## 🛠️ 技术栈

- **语言**: Kotlin
- **最小 SDK**: 24 (Android 7.0)
- **目标 SDK**: 34 (Android 14)
- **UI**: Material Design 3
- **网络**: OkHttp + Retrofit
- **JSON**: Gson
- **异步**: Kotlin Coroutines
- **语音**: Android Speech Recognition & TTS

## 🌐 鸿蒙兼容性

此应用使用标准 Android API 开发，完全兼容鸿蒙 HarmonyOS 4.2+:

- ✅ 文件上传
- ✅ 网络请求
- ✅ 语音识别
- ✅ 语音合成
- ✅ Material Design UI

## 📝 开发说明

### 添加新功能

1. 在对应的 Activity 中添加 UI 和逻辑
2. 如需新的 API，在 `ApiService.kt` 中添加
3. 如需新的数据模型，在 `Models.kt` 中添加
4. 更新 `AndroidManifest.xml`（如需新权限）

### 调试

```bash
# 查看日志
adb logcat | grep MarketingAnalysis

# 安装调试版本
adb install -r app/build/outputs/apk/debug/app-debug.apk

# 卸载应用
adb uninstall com.marketing.analysisapp
```

## 📄 许可证

本项目仅供学习和参考使用。

## 🎉 完成！

现在你可以:
1. 构建 APK
2. 安装到 Android/鸿蒙手机
3. 上传数据并获取 AI 分析
4. 使用语音提问功能

祝使用愉快！🚀
