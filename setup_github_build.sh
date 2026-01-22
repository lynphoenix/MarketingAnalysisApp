#!/bin/bash

echo "🚀 设置 GitHub 自动构建 APK"
echo "=============================="
echo ""

# 检查是否在正确的目录
if [ ! -d "AndroidApp" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi

# 初始化 git（如果还没有）
if [ ! -d ".git" ]; then
    echo "📝 初始化 Git 仓库..."
    git init
    echo "✅ Git 仓库已初始化"
else
    echo "✅ Git 仓库已存在"
fi

echo ""
echo "📦 添加所有文件到 Git..."
git add .

echo ""
echo "💾 提交代码..."
git commit -m "Add Android app with GitHub Actions build automation" || echo "没有新的更改需要提交"

echo ""
echo "=============================="
echo "📋 接下来的步骤:"
echo "=============================="
echo ""
echo "1️⃣ 创建 GitHub 仓库:"
echo "   访问: https://github.com/new"
echo "   - Repository name: MarketingAnalysisApp"
echo "   - 选择 Public 或 Private"
echo "   - 不要勾选 Initialize"
echo "   - 点击 Create repository"
echo ""
echo "2️⃣ 获取你的 GitHub 用户名"
echo "   例如: https://github.com/YOUR_USERNAME"
echo ""
read -p "请输入你的 GitHub 用户名: " GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo "❌ 未输入用户名"
    exit 1
fi

echo ""
echo "3️⃣ 添加远程仓库..."
git remote remove origin 2>/dev/null
git remote add origin "https://github.com/$GITHUB_USER/MarketingAnalysisApp.git"
echo "✅ 远程仓库已添加"

echo ""
echo "4️⃣ 推送到 GitHub..."
echo "注意: 可能需要输入 GitHub 密码或 Personal Access Token"
echo ""

git branch -M main

if git push -u origin main; then
    echo ""
    echo "=============================="
    echo "🎉 成功！"
    echo "=============================="
    echo ""
    echo "✅ 代码已推送到 GitHub"
    echo ""
    echo "📱 下一步: 获取 APK"
    echo ""
    echo "1. 访问: https://github.com/$GITHUB_USER/MarketingAnalysisApp"
    echo "2. 点击 'Actions' 标签"
    echo "3. 等待构建完成（约 5-10 分钟）"
    echo "4. 下载 APK 文件"
    echo ""
    echo "🌐 现在打开浏览器..."
    open "https://github.com/$GITHUB_USER/MarketingAnalysisApp"
else
    echo ""
    echo "=============================="
    echo "⚠️  推送失败"
    echo "=============================="
    echo ""
    echo "可能的原因:"
    echo "1. GitHub 仓库还未创建"
    echo "2. 需要 Personal Access Token"
    echo ""
    echo "📝 获取 Personal Access Token:"
    echo "   1. 访问: https://github.com/settings/tokens"
    echo "   2. Generate new token (classic)"
    echo "   3. 勾选 'repo' 权限"
    echo "   4. 生成并复制 token"
    echo "   5. 重新运行此脚本，使用 token 作为密码"
    echo ""
fi
