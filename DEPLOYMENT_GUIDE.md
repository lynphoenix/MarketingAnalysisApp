# iPhone App 部署指南

## 📱 快速部署步骤

### 第一步：创建 Xcode 项目

1. 打开 Xcode (已检测到 Xcode 26.2)

2. 选择 **File > New > Project**

3. 选择模板：
   - 平台：**iOS**
   - 模板：**App**
   - 点击 **Next**

4. 填写项目信息：
   ```
   Product Name: MarketingAnalysisApp
   Team: [选择你的 Apple ID 或开发者账号]
   Organization Identifier: com.marketing
   Bundle Identifier: com.marketing.MarketingAnalysisApp
   Interface: SwiftUI
   Language: Swift
   Storage: None (不勾选 Core Data)
   ```

5. 选择保存位置：
   - 选择当前目录：`/Users/linyining/Documents/code/diy/MarketingAnalysisApp`
   - 不要勾选 "Create Git repository"（已有 Git 仓库）
   - 点击 **Create**

### 第二步：替换默认文件

Xcode 会创建一些默认文件，我们需要用我们的代码替换它们：

1. **删除** Xcode 自动创建的以下文件（在项目导航器中右键删除）：
   - `ContentView.swift` (Xcode 创建的默认版本)
   - `MarketingAnalysisAppApp.swift` (如果名称不同)
   - `Assets.xcassets` (Xcode 创建的默认版本)

2. **添加我们的文件** (拖拽到 Xcode 项目导航器中)：
   - 选中 `App` 文件夹中的所有内容
   - 拖拽到 Xcode 左侧的项目导航器
   - 确保勾选 "Copy items if needed"
   - Target 选择 "MarketingAnalysisApp"

### 第三步：配置项目设置

#### 3.1 设置 Info.plist

已自动创建 `App/Info.plist`，包含以下权限：
- ✅ 麦克风权限
- ✅ 语音识别权限
- ✅ HTTP 网络权限（用于连接后端服务器）

在 Xcode 中：
1. 选择项目根节点 `MarketingAnalysisApp`
2. 选择 Target `MarketingAnalysisApp`
3. 点击 **Info** 标签
4. 确认 **Custom iOS Target Properties** 中包含权限设置

#### 3.2 添加 Speech Recognition Capability

1. 选择 Target `MarketingAnalysisApp`
2. 点击 **Signing & Capabilities** 标签
3. 点击 **+ Capability** 按钮
4. 搜索并添加 **Speech Recognition**

#### 3.3 配置签名

1. 在 **Signing & Capabilities** 标签中
2. **Team** 下拉菜单选择你的 Apple ID 或开发者账号
3. 勾选 **Automatically manage signing**
4. 确认 **Signing Certificate** 显示为 "Apple Development"

### 第四步：连接 iPhone 并信任设备

1. 用数据线连接 iPhone 到 Mac
2. 在 iPhone 上，如果弹出"信任此电脑"，点击**信任**
3. 在 Xcode 顶部工具栏，设备选择器中应该能看到你的 iPhone

### 第五步：构建和运行

1. 在 Xcode 顶部选择你的 iPhone 设备
2. 点击 **Product > Build** 或按 `⌘ + B` 构建项目
3. 如果构建成功，点击播放按钮 ▶️ 或按 `⌘ + R` 运行

### 第六步：首次运行的设备设置

首次在 iPhone 上运行时：

1. App 会安装到 iPhone 上，但可能无法立即打开
2. 在 iPhone 上，打开 **设置 > 通用 > VPN与设备管理**
3. 找到你的开发者账号，点击进入
4. 点击 **信任 "[你的开发者账号]"**
5. 确认信任

### 第七步：授予权限

App 首次运行时会请求权限：

1. **麦克风权限** - 点击**允许**
2. **语音识别权限** - 点击**好**

## ✅ 配置检查清单

- [x] 后端服务器 URL 已配置：`http://47.99.75.219:5000`
- [x] Info.plist 已配置麦克风和语音识别权限
- [x] Info.plist 已允许 HTTP 连接
- [ ] Xcode 项目已创建
- [ ] 代码文件已添加到项目
- [ ] Speech Recognition Capability 已添加
- [ ] 签名配置完成
- [ ] iPhone 已连接并信任
- [ ] App 已成功安装到 iPhone

## 🔍 常见问题

### Q: 构建失败，提示签名错误？

**A:**
1. 确保在 Signing & Capabilities 中选择了正确的 Team
2. 尝试取消勾选"Automatically manage signing"，然后重新勾选
3. 确保你的 Apple ID 已登录（Xcode > Preferences > Accounts）

### Q: App 安装到手机后无法打开？

**A:**
需要在 iPhone 设置中信任开发者账号（见第六步）

### Q: 语音识别不工作？

**A:**
1. 确保已添加 Speech Recognition Capability
2. 确保在 iPhone 上授予了麦克风和语音识别权限
3. 检查 iPhone 的"设置 > 隐私与安全性 > 语音识别"中是否允许了此 App

### Q: 无法连接到后端服务器？

**A:**
1. 确保后端服务器正在运行：`http://47.99.75.219:5000`
2. 确保 iPhone 和服务器之间网络连通
3. 确保 Info.plist 中已允许 HTTP 连接（NSAppTransportSecurity）

### Q: 找不到我的 iPhone 设备？

**A:**
1. 确保 iPhone 已用数据线连接（不是无线）
2. 在 iPhone 上信任此电脑
3. 重启 Xcode 和 iPhone 后重试
4. 检查 Window > Devices and Simulators 中是否显示设备

## 📞 技术支持

如果遇到其他问题：
1. 查看 Xcode 控制台的错误信息
2. 确保所有配置步骤都已正确完成
3. 尝试清理构建（Product > Clean Build Folder）后重新构建

## 🎉 部署成功！

成功运行后，你可以：
- 📤 上传 Excel 营销数据文件
- 📊 查看 AI 智能分析报告
- 🎤 使用语音提问功能
- 🔊 听取语音播报的分析结果

---

**祝你使用愉快！**
