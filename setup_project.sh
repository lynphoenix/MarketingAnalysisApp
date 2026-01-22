#!/bin/bash

set -e  # 遇到错误立即退出

echo "🚀 营销分析 App - Xcode 项目设置脚本"
echo "======================================"
echo ""

PROJECT_NAME="MarketingAnalysisApp"
BUNDLE_ID="com.marketing.analysisapp"
PROJECT_DIR=$(pwd)

echo "📁 项目目录: $PROJECT_DIR"
echo "📦 Bundle ID: $BUNDLE_ID"
echo ""

# 检查 Xcode 是否已安装
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ 错误: 未检测到 Xcode"
    echo "请从 App Store 安装 Xcode"
    exit 1
fi

XCODE_VERSION=$(xcodebuild -version | head -n 1)
echo "✅ 检测到 $XCODE_VERSION"
echo ""

# 检查是否已存在项目文件
if [ -d "${PROJECT_NAME}.xcodeproj" ]; then
    echo "⚠️  检测到已存在的 Xcode 项目"
    read -p "是否删除并重新创建？(y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "${PROJECT_NAME}.xcodeproj"
        echo "✅ 已删除旧项目"
    else
        echo "❌ 取消操作"
        exit 0
    fi
fi

echo "📝 正在创建项目配置..."
echo ""

# 创建项目配置文件 (使用 XcodeGen 格式)
cat > project.yml << EOF
name: ${PROJECT_NAME}
options:
  bundleIdPrefix: com.marketing
  deploymentTarget:
    iOS: 15.0
  createIntermediateGroups: true

settings:
  base:
    DEVELOPMENT_TEAM: ""

targets:
  ${PROJECT_NAME}:
    type: application
    platform: iOS
    deploymentTarget: "15.0"

    sources:
      - path: App
        name: App

    settings:
      base:
        PRODUCT_NAME: ${PROJECT_NAME}
        PRODUCT_BUNDLE_IDENTIFIER: ${BUNDLE_ID}
        INFOPLIST_FILE: App/Info.plist
        ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
        ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME: AccentColor
        SWIFT_VERSION: "5.0"
        TARGETED_DEVICE_FAMILY: "1,2"
        ENABLE_BITCODE: NO
        CODE_SIGN_STYLE: Automatic

      configs:
        Debug:
          SWIFT_OPTIMIZATION_LEVEL: "-Onone"
          SWIFT_ACTIVE_COMPILATION_CONDITIONS: DEBUG

        Release:
          SWIFT_OPTIMIZATION_LEVEL: "-O"

    scheme:
      gatherCoverageData: true

    dependencies: []

    entitlements:
      properties:
        com.apple.developer.siri: true
EOF

echo "✅ 项目配置文件已创建: project.yml"
echo ""

# 检查是否安装了 XcodeGen
if command -v xcodegen &> /dev/null; then
    echo "🔧 使用 XcodeGen 生成项目..."
    xcodegen generate
    echo "✅ Xcode 项目已生成"
    echo ""
    echo "📱 接下来的步骤:"
    echo "1. 运行: open ${PROJECT_NAME}.xcodeproj"
    echo "2. 在 Xcode 中选择你的 Team（开发者账号）"
    echo "3. 连接你的 iPhone"
    echo "4. 点击运行按钮 ▶️"
else
    echo "⚠️  XcodeGen 未安装，将使用手动方式"
    echo ""
    echo "📋 请按以下步骤手动创建项目："
    echo ""
    echo "方法 1: 安装 XcodeGen (推荐)"
    echo "  brew install xcodegen"
    echo "  然后重新运行此脚本"
    echo ""
    echo "方法 2: 手动在 Xcode 中创建"
    echo "  详细步骤请查看: DEPLOYMENT_GUIDE.md"
    echo ""

    # 提供快捷方式
    echo "按回车键打开部署指南..."
    read
    open DEPLOYMENT_GUIDE.md
fi

echo ""
echo "======================================"
echo "✨ 设置完成！"
echo "======================================"
