#!/bin/bash

# 设置项目信息
PROJECT_NAME="MarketingAnalysisApp"
BUNDLE_ID="com.marketing.analysisapp"
DEPLOYMENT_TARGET="15.0"

echo "🚀 正在创建 Xcode 项目..."

# 创建临时的项目模板
cat > project.yml << EOF
name: ${PROJECT_NAME}
options:
  bundleIdPrefix: com.marketing
  deploymentTarget:
    iOS: ${DEPLOYMENT_TARGET}
targets:
  ${PROJECT_NAME}:
    type: application
    platform: iOS
    deploymentTarget: "${DEPLOYMENT_TARGET}"
    sources:
      - App
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: ${BUNDLE_ID}
        INFOPLIST_FILE: App/Info.plist
        ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
        ENABLE_BITCODE: NO
        SWIFT_VERSION: "5.0"
      configs:
        Debug:
          SWIFT_OPTIMIZATION_LEVEL: "-Onone"
        Release:
          SWIFT_OPTIMIZATION_LEVEL: "-O"
    dependencies: []
    preBuildScripts: []
    postBuildScripts: []
EOF

echo "✅ 项目配置文件已创建"
echo ""
echo "⚠️  由于直接生成 Xcode 项目需要额外工具，请按以下步骤手动创建："
echo ""
echo "1. 打开 Xcode"
echo "2. 选择 File > New > Project"
echo "3. 选择 iOS > App，点击 Next"
echo "4. 填写项目信息："
echo "   - Product Name: ${PROJECT_NAME}"
echo "   - Team: 选择你的开发者账号"
echo "   - Organization Identifier: com.marketing"
echo "   - Bundle Identifier: ${BUNDLE_ID}"
echo "   - Interface: SwiftUI"
echo "   - Language: Swift"
echo "   - Storage: None"
echo "5. 选择当前目录作为保存位置"
echo "6. 创建后，将 App 目录下的所有文件添加到项目中"
echo ""
echo "📱 后续步骤将在脚本中自动完成"
