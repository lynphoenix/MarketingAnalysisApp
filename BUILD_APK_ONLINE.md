# 📦 在线构建 APK - 无需本地环境

## 问题
本地构建需要：
- ❌ Java 17+ （需要 sudo 权限安装）
- ❌ Android SDK
- ❌ Gradle

## ✅ 解决方案：使用 GitHub Actions 在线构建

完全免费，无需本地环境，5-10 分钟自动构建！

---

## 🚀 快速开始（3步完成）

### 步骤 1: 初始化 Git 并提交代码

```bash
cd /Users/linyining/Documents/code/diy/MarketingAnalysisApp

# 初始化 git（如果还没有）
git init

# 添加所有文件
git add .

# 提交
git commit -m "Add Android app with GitHub Actions build"
```

### 步骤 2: 创建 GitHub 仓库并推送

1. **访问 GitHub 创建仓库**
   - 打开: https://github.com/new
   - 仓库名: `MarketingAnalysisApp`
   - 设置为 Private（私有）或 Public（公开）
   - **不要**勾选 "Initialize this repository with a README"
   - 点击 "Create repository"

2. **推送代码到 GitHub**
   ```bash
   # 将 YOUR_USERNAME 替换为你的 GitHub 用户名
   git remote add origin https://github.com/YOUR_USERNAME/MarketingAnalysisApp.git

   git branch -M main
   git push -u origin main
   ```

### 步骤 3: 触发构建并下载 APK

1. **访问你的仓库**
   - https://github.com/YOUR_USERNAME/MarketingAnalysisApp

2. **查看 Actions**
   - 点击顶部的 "Actions" 标签
   - 你会看到一个构建任务正在运行（⚡️）

3. **等待构建完成**（约 5-10 分钟）
   - 构建完成后会显示 ✅ 绿色勾

4. **下载 APK**
   - 点击构建任务
   - 滚动到页面底部 "Artifacts" 部分
   - 点击 "app-debug-apk" 下载 ZIP
   - 解压 ZIP 得到 `app-debug.apk`

5. **安装到手机**
   - 将 APK 传到 Android/鸿蒙手机
   - 打开文件管理器，点击 APK 安装
   - 完成！

---

## 🔄 重新构建

每次修改代码后：

```bash
git add .
git commit -m "Update app"
git push
```

GitHub Actions 会自动重新构建！

---

## 💡 手动触发构建

如果没有修改代码，也想重新构建：

1. 访问仓库的 Actions 页面
2. 点击左侧的 "Build Android APK"
3. 点击右侧的 "Run workflow" 按钮
4. 点击绿色的 "Run workflow" 确认

---

## 📋 详细步骤（带截图说明）

### 创建 GitHub 账号（如果还没有）

1. 访问: https://github.com/signup
2. 填写邮箱、密码、用户名
3. 验证邮箱
4. 完成注册

### 创建新仓库

1. 登录 GitHub
2. 点击右上角 "+" → "New repository"
3. 填写：
   - Repository name: `MarketingAnalysisApp`
   - Description: `营销数据分析 App - Android 版`
   - 选择 Public 或 Private
4. 点击 "Create repository"

### 推送代码

在终端中：

```bash
cd /Users/linyining/Documents/code/diy/MarketingAnalysisApp

# 检查 git 状态
git status

# 如果还没有 git 仓库
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: Android app with build automation"

# 添加远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/MarketingAnalysisApp.git

# 推送
git branch -M main
git push -u origin main
```

**可能需要输入 GitHub 用户名和密码（或 Personal Access Token）**

### 获取 Personal Access Token（如果需要）

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token → Generate new token (classic)
3. 勾选 `repo` 权限
4. 点击 "Generate token"
5. 复制 token（只显示一次！）
6. 在 git push 时使用 token 作为密码

---

## ⚙️ GitHub Actions 构建过程

构建过程完全自动化：

1. ✅ 检出代码
2. ✅ 安装 JDK 17
3. ✅ 下载 Gradle 依赖
4. ✅ 构建 Debug APK
5. ✅ 上传 APK 文件

整个过程约 5-10 分钟。

---

## 📱 安装 APK 到手机

### Android 手机

1. 将下载的 APK 通过以下方式传到手机：
   - USB 数据线
   - 微信/QQ 发送给自己
   - 云盘（如百度网盘）
   - AirDrop（iPhone 到 Mac 后传到 Android）

2. 在手机上：
   - 打开文件管理器
   - 找到 APK 文件
   - 点击安装
   - 如果提示"未知来源"，允许安装

### 鸿蒙手机

步骤同 Android，但权限设置可能在：
- 设置 → 安全 → 更多安全设置 → 外部来源应用下载

---

## 🎯 优势

使用 GitHub Actions 构建的优势：

- ✅ **无需本地环境** - 不需要安装 Java、Android SDK
- ✅ **完全免费** - GitHub Actions 对公开仓库完全免费
- ✅ **自动化** - 推送代码自动构建
- ✅ **可重复** - 每次构建环境完全一致
- ✅ **历史记录** - 可以下载历史版本的 APK
- ✅ **云端存储** - APK 保存 7 天

---

## ❓ 常见问题

### Q: 构建失败怎么办？

A:
1. 点击失败的构建任务
2. 查看红色的步骤
3. 点击展开查看错误信息
4. 通常是依赖下载或代码问题

### Q: 私有仓库也免费吗？

A: 是的！GitHub Actions 对私有仓库也有免费额度（每月 2000 分钟）

### Q: 可以构建 Release 版本吗？

A: 可以！修改 workflow 文件中的 `assembleDebug` 为 `assembleRelease`

### Q: APK 保存多久？

A: 默认 7 天，可以在 workflow 中修改 `retention-days`

---

## 🎉 完成！

现在你有一个完整的自动化构建流程：

1. ✅ 修改代码
2. ✅ `git push`
3. ✅ 等待 5-10 分钟
4. ✅ 下载 APK
5. ✅ 安装到手机

---

## 📞 需要帮助？

如果有任何问题：
1. 检查 GitHub Actions 的构建日志
2. 查看本文档的故障排查部分
3. 或者询问我！

**祝你构建成功！** 🚀
