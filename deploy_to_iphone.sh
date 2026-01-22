#!/bin/bash

set -e  # 遇到错误立即退出

echo "🚀 营销分析 App - 直接部署到 iPhone 脚本"
echo "=========================================="
echo ""

# 项目配置
PROJECT_NAME="MarketingAnalysisApp"
SCHEME="MarketingAnalysisApp"
CONFIGURATION="Debug"
BUNDLE_ID="com.marketing.MarketingAnalysisApp"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查设备连接
echo "📱 检查 iPhone 连接..."
UDID=$(system_profiler SPUSBDataType 2>/dev/null | grep -A 10 "iPhone:" | grep "Serial Number" | awk '{print $3}')

if [ -z "$UDID" ]; then
    echo -e "${RED}❌ 错误: 未检测到 iPhone 设备${NC}"
    echo "请确保:"
    echo "  1. iPhone 已通过数据线连接到 Mac"
    echo "  2. 在 iPhone 上已点击'信任此电脑'"
    exit 1
fi

echo -e "${GREEN}✅ 检测到设备: $UDID${NC}"
echo ""

# 检查必要的工具
echo "🔧 检查必要工具..."
if ! command -v ideviceinstaller &> /dev/null; then
    echo -e "${YELLOW}⚠️  ideviceinstaller 未安装，正在安装...${NC}"
    brew install ideviceinstaller
fi

if ! command -v idevice_id &> /dev/null; then
    echo -e "${YELLOW}⚠️  libimobiledevice 未安装，正在安装...${NC}"
    brew install libimobiledevice
fi

echo -e "${GREEN}✅ 工具检查完成${NC}"
echo ""

# 获取开发者证书
echo "🔐 获取开发者证书..."
CERT_NAME=$(security find-identity -v -p codesigning | grep "Apple Development" | head -1 | sed 's/.*"\(.*\)"/\1/')

if [ -z "$CERT_NAME" ]; then
    echo -e "${RED}❌ 错误: 未找到 Apple Development 证书${NC}"
    echo "请在 Xcode 中登录你的 Apple ID"
    exit 1
fi

echo -e "${GREEN}✅ 找到证书: $CERT_NAME${NC}"
echo ""

# 清理旧的构建
echo "🧹 清理旧的构建文件..."
rm -rf build/
mkdir -p build

# 构建项目 - 使用 archive 方式绕过设备检查
echo "🔨 构建项目（这可能需要几分钟）..."
xcodebuild \
    -project "${PROJECT_NAME}.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "build/${PROJECT_NAME}.xcarchive" \
    -sdk iphoneos \
    -destination "generic/platform=iOS" \
    CODE_SIGN_IDENTITY="$CERT_NAME" \
    CODE_SIGN_STYLE=Automatic \
    DEVELOPMENT_TEAM="" \
    archive \
    2>&1 | grep -E "(error|warning|===|Compiling|Linking|Building|Archive)" || true

if [ ! -d "build/${PROJECT_NAME}.xcarchive" ]; then
    echo -e "${RED}❌ 构建失败${NC}"
    echo "尝试查看详细错误信息..."
    xcodebuild \
        -project "${PROJECT_NAME}.xcodeproj" \
        -scheme "$SCHEME" \
        -configuration "$CONFIGURATION" \
        -archivePath "build/${PROJECT_NAME}.xcarchive" \
        -sdk iphoneos \
        -destination "generic/platform=iOS" \
        CODE_SIGN_IDENTITY="$CERT_NAME" \
        CODE_SIGN_STYLE=Automatic \
        DEVELOPMENT_TEAM="" \
        archive
    exit 1
fi

echo -e "${GREEN}✅ 项目构建成功${NC}"
echo ""

# 导出 IPA
echo "📦 导出 IPA 文件..."

# 创建 ExportOptions.plist
cat > build/ExportOptions.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>teamID</key>
    <string></string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>uploadSymbols</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
EOF

xcodebuild \
    -exportArchive \
    -archivePath "build/${PROJECT_NAME}.xcarchive" \
    -exportPath "build/" \
    -exportOptionsPlist "build/ExportOptions.plist" \
    2>&1 | grep -E "(error|warning|===|Export)" || true

if [ ! -f "build/${PROJECT_NAME}.ipa" ]; then
    echo -e "${YELLOW}⚠️  IPA 导出失败，尝试直接使用 .app 文件${NC}"

    # 尝试直接找到 .app 文件
    APP_PATH=$(find build/${PROJECT_NAME}.xcarchive -name "${PROJECT_NAME}.app" | head -1)

    if [ -z "$APP_PATH" ]; then
        echo -e "${RED}❌ 错误: 无法找到 .app 文件${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ 找到 .app 文件: $APP_PATH${NC}"
else
    echo -e "${GREEN}✅ IPA 导出成功${NC}"

    # 解压 IPA 获取 .app
    unzip -q "build/${PROJECT_NAME}.ipa" -d build/Payload
    APP_PATH="build/Payload/Payload/${PROJECT_NAME}.app"
fi

echo ""

# 安装到设备
echo "📲 安装到 iPhone..."
ideviceinstaller -u "$UDID" -i "$APP_PATH"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 安装成功！${NC}"
    echo ""
    echo "✅ App 已安装到你的 iPhone"
    echo "📱 请在 iPhone 主屏幕查找'营销分析' App"
    echo ""
    echo "⚠️  首次运行提示:"
    echo "  如果 App 无法打开，需要在 iPhone 上:"
    echo "  设置 → 通用 → VPN与设备管理 → 信任开发者"
    echo ""
else
    echo -e "${RED}❌ 安装失败${NC}"
    echo "可能的原因:"
    echo "  1. 设备未信任此电脑"
    echo "  2. 设备锁定中"
    echo "  3. 需要先在 Xcode 中配置开发者证书"
    exit 1
fi
