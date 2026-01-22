#!/bin/bash

set -e

echo "🤖 营销分析 Android App - 构建脚本"
echo "====================================="
echo ""

# 检查环境
echo "1️⃣ 检查构建环境..."

# 检查 JDK
if ! command -v java &> /dev/null; then
    echo "❌ 未找到 Java"
    echo "请安装 JDK 17 或更高版本"
    echo "下载地址: https://adoptium.net/"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
echo "✅ Java 版本: $JAVA_VERSION"

if [ "$JAVA_VERSION" -lt "17" ]; then
    echo "⚠️  警告: 推荐使用 Java 17 或更高版本"
fi

# 检查 Android SDK
if [ -z "$ANDROID_HOME" ]; then
    echo "⚠️  ANDROID_HOME 未设置"
    echo "尝试使用默认路径..."

    if [ -d "$HOME/Library/Android/sdk" ]; then
        export ANDROID_HOME="$HOME/Library/Android/sdk"
        echo "✅ 找到 Android SDK: $ANDROID_HOME"
    else
        echo "❌ 未找到 Android SDK"
        echo "请安装 Android Studio 或设置 ANDROID_HOME 环境变量"
        exit 1
    fi
else
    echo "✅ Android SDK: $ANDROID_HOME"
fi

echo ""
echo "2️⃣ 清理旧的构建..."
./gradlew clean

echo ""
echo "3️⃣ 构建 Debug APK..."
./gradlew assembleDebug

echo ""
echo "4️⃣ 构建完成！"
echo ""

APK_PATH="app/build/outputs/apk/debug/app-debug.apk"

if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo "✅ APK 文件已生成:"
    echo "   位置: $APK_PATH"
    echo "   大小: $APK_SIZE"
    echo ""
    echo "📱 安装到设备:"
    echo "   方法1: 直接拖拽 APK 到模拟器/真机"
    echo "   方法2: adb install $APK_PATH"
    echo "   方法3: 发送 APK 到手机，直接安装"
    echo ""

    # 尝试自动安装
    if command -v adb &> /dev/null; then
        DEVICES=$(adb devices | grep -v "List" | grep "device$" | wc -l)
        if [ "$DEVICES" -gt 0 ]; then
            echo "检测到 Android 设备，是否自动安装？(y/n)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                adb install -r "$APK_PATH"
                echo "✅ 安装完成！"
            fi
        fi
    fi

else
    echo "❌ APK 文件未找到"
    echo "构建可能失败，请查看上方错误信息"
    exit 1
fi

echo ""
echo "🎉 全部完成！"
