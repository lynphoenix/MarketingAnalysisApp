# 🤖 Android 版本 - 快速开始指南

## ✅ Android 项目已创建完成！

### 📁 项目位置
```
MarketingAnalysisApp/AndroidApp/
```

### 🎯 功能完整对比

| 功能 | iOS | Android | 鸿蒙 4.2 |
|------|:---:|:-------:|:--------:|
| 文件上传 | ✅ | ✅ | ✅ |
| AI 分析 | ✅ | ✅ | ✅ |
| 报告展示 | ✅ | ✅ | ✅ |
| 语音识别 | ✅ | ✅ | ✅ |
| 语音播报 | ✅ | ✅ | ✅ |
| Material Design | - | ✅ | ✅ |

## 🚀 三种构建方式

### 方式 1: 使用 Android Studio（推荐，最简单）

1. **打开 Android Studio**
   ```bash
   open -a "Android Studio" AndroidApp
   ```
   或手动打开 Android Studio，然后 File → Open → 选择 `AndroidApp` 文件夹

2. **等待 Gradle 同步**（首次可能需要 5-10 分钟）
   - Android Studio 会自动下载所需依赖

3. **构建 APK**
   - 菜单: Build → Build Bundle(s) / APK(s) → Build APK(s)
   - 或点击工具栏的锤子图标 🔨

4. **找到 APK**
   - 构建成功后会弹出通知
   - 点击 "locate" 查看 APK 位置
   - 或在: `AndroidApp/app/build/outputs/apk/debug/app-debug.apk`

5. **安装到手机**
   - 连接 Android/鸿蒙手机到电脑
   - 点击绿色播放按钮 ▶️ 直接安装运行
   - 或将 APK 传输到手机手动安装

---

### 方式 2: 使用命令行脚本（快速）

```bash
cd AndroidApp
./build_apk.sh
```

脚本会自动:
- ✅ 检查 Java 环境
- ✅ 检查 Android SDK
- ✅ 清理旧构建
- ✅ 构建 Debug APK
- ✅ 提示安装方式

---

### 方式 3: 使用 Gradle 命令（开发者）

```bash
cd AndroidApp

# 首次构建（需要下载依赖）
./gradlew assembleDebug

# 清理后构建
./gradlew clean assembleDebug

# 构建并安装到连接的设备
./gradlew installDebug
```

## 📱 安装到手机

### Android 手机

1. **开启开发者选项**
   - 设置 → 关于手机 → 连续点击"版本号" 7次

2. **开启 USB 调试**
   - 设置 → 开发者选项 → USB 调试

3. **连接电脑**
   - 用数据线连接
   - 手机上点击"允许USB调试"

4. **安装 APK**
   ```bash
   adb install AndroidApp/app/build/outputs/apk/debug/app-debug.apk
   ```
   或直接在 Android Studio 点击运行

### 鸿蒙手机

1. **开启开发者模式**
   - 设置 → 关于手机 → 连续点击"版本号" 7次

2. **开启 USB 调试**
   - 设置 → 系统和更新 → 开发者选项 → USB 调试

3. **安装方式同 Android**
   - 或将 APK 传到手机，直接点击安装

### 无线安装（无需数据线）

1. **将 APK 传到手机**
   - 通过微信/QQ 发送
   - 或通过云盘下载

2. **在手机上安装**
   - 打开文件管理器
   - 找到 APK 文件
   - 点击安装
   - 允许"未知来源"安装（首次）

## 🎯 快速测试

安装后:

1. **打开应用** - 找到"营销分析"图标

2. **授予权限** - 允许文件访问和麦克风权限

3. **测试文件上传**
   - 点击"📤 上传 Excel 文件"
   - 选择测试数据文件
   - 等待分析完成

4. **测试语音功能**
   - 点击"🎤 语音提问"
   - 点击麦克风说话
   - 查看 AI 回答

## 🔧 故障排查

### 问题 1: Android Studio 打不开项目

**解决:**
```bash
# 删除缓存，重新同步
cd AndroidApp
rm -rf .gradle .idea
```
然后重新在 Android Studio 中打开

### 问题 2: Gradle 同步失败

**解决:**
1. 检查网络连接
2. Android Studio → Preferences → Build → Gradle → 选择合适的 Gradle JDK (建议 JDK 17)
3. File → Invalidate Caches → Invalidate and Restart

### 问题 3: 找不到 Android SDK

**解决:**
```bash
# 设置 ANDROID_HOME 环境变量
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

或安装 Android Studio，它会自动安装 SDK

### 问题 4: Java 版本不对

**解决:**
```bash
# 检查 Java 版本
java -version

# 如果版本低于 17，下载安装 JDK 17
# https://adoptium.net/
```

### 问题 5: 无法安装到手机

**Android 解决:**
- 设置 → 安全 → 允许未知来源

**鸿蒙解决:**
- 设置 → 安全 → 更多安全设置 → 外部来源应用下载

## 📋 系统要求

### 开发环境

- **macOS**: 10.14+
- **JDK**: 17+ ([下载](https://adoptium.net/))
- **Android Studio**: 最新版本 ([下载](https://developer.android.com/studio))
- **Gradle**: 8.0+ (Android Studio 自带)

### 运行设备

- **Android**: 7.0 (API 24) 及以上
- **鸿蒙**: HarmonyOS 4.2 及以上
- **架构**: ARM, ARM64, x86, x86_64

## 📂 项目文件说明

```
AndroidApp/
├── app/
│   ├── src/main/
│   │   ├── java/.../              # Kotlin 源代码
│   │   │   ├── MainActivity.kt    # 主界面 ✅
│   │   │   ├── VoiceQueryActivity.kt  # 语音界面 ✅
│   │   │   ├── ApiService.kt      # API 服务 ✅
│   │   │   └── Models.kt          # 数据模型 ✅
│   │   ├── res/
│   │   │   ├── layout/            # 布局文件 ✅
│   │   │   ├── values/            # 颜色、字符串 ✅
│   │   │   └── mipmap/            # 应用图标
│   │   └── AndroidManifest.xml    # 权限配置 ✅
│   └── build.gradle               # 应用配置 ✅
├── build.gradle                   # 项目配置 ✅
├── settings.gradle                # Gradle 设置 ✅
├── build_apk.sh                   # 构建脚本 ✅
└── README.md                      # 详细文档 ✅
```

## 🎉 下一步

### 现在你可以:

1. ✅ **使用 Android Studio 打开项目**
   ```bash
   open -a "Android Studio" AndroidApp
   ```

2. ✅ **或使用脚本快速构建**
   ```bash
   cd AndroidApp && ./build_apk.sh
   ```

3. ✅ **安装到 Android/鸿蒙手机测试**

4. ✅ **修改代码并重新构建**

### 对比 iOS 版本

| 特性 | iOS | Android |
|------|:---:|:-------:|
| 项目状态 | 需要 Xcode 下载支持文件 | ✅ 可以直接构建 |
| 兼容性 | iOS 15.4+ | Android 7.0+ 和鸿蒙 4.2+ |
| 构建难度 | 需要解决兼容性问题 | ✅ 开箱即用 |
| 安装方式 | 需要开发者证书 | ✅ 可直接安装 APK |
| 语言 | Swift | Kotlin |

## 💡 提示

- 首次构建可能需要 5-10 分钟（下载依赖）
- 后续构建通常只需 30秒-2分钟
- APK 大小约 15-20 MB
- 支持 Android 7.0+ 和鸿蒙 4.2+

---

**现在就开始构建吧！** 🚀

如有问题查看 `AndroidApp/README.md` 或询问我！
