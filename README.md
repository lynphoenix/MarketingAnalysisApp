# 营销数据分析 iPhone App

一个基于 AI 的营销数据分析 iPhone 应用，支持 Excel 数据上传、智能分析和语音交互。

## 功能特点

✨ **核心功能**
- 📊 上传 Excel 营销数据文件
- 🤖 AI 智能分析（基于 Claude API）
- 📈 可视化月度报告展示
- 🎤 语音提问与回答
- 🔊 语音播报分析结果

## 系统架构

```
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│   iPhone App    │ HTTP │   后端服务器     │ API  │   Claude API    │
│    (SwiftUI)    │◄────►│ (Python/FastAPI) │◄────►│   (Anthropic)   │
└─────────────────┘      └─────────────────┘      └─────────────────┘
```

## 项目结构

```
MarketingAnalysisApp/
├── App/                          # iOS App 源代码
│   ├── MarketingAnalysisApp.swift   # App 入口
│   ├── Models/                      # 数据模型
│   │   └── MarketingReport.swift
│   ├── Services/                    # 服务层
│   │   ├── APIService.swift        # API 通信
│   │   └── VoiceService.swift      # 语音服务
│   └── Views/                       # 界面
│       ├── ContentView.swift       # 主界面
│       └── VoiceQueryView.swift    # 语音问答界面
│
├── backend_example.py           # 后端示例代码
├── backend_requirements.txt     # 后端依赖
├── BACKEND_API.md              # API 文档
└── README.md                   # 本文件
```

## 快速开始

### 1. 设置后端服务器

#### 安装依赖

```bash
# 安装 Python 依赖
pip3 install -r backend_requirements.txt
```

#### 配置环境变量

创建 `.env` 文件或设置环境变量：

```bash
export ANTHROPIC_API_KEY="your_claude_api_key_here"
export PORT=5000
```

#### 启动后端

```bash
python3 backend_example.py
```

服务器将启动在 `http://0.0.0.0:5000`

#### 查看 API 文档

访问 `http://localhost:5000/docs` 查看自动生成的 API 文档。

### 2. 配置 iPhone App

#### 修改后端 URL

打开 `App/Services/APIService.swift`，修改第 12 行：

```swift
private let baseURL = "YOUR_BACKEND_SERVER_URL"
```

改为您的后端服务器地址，例如：
```swift
private let baseURL = "http://192.168.1.100:5000"  // 本地测试
// 或
private let baseURL = "https://your-domain.com"     // 生产环境
```

⚠️ **重要**：iOS 要求使用 HTTPS，本地测试可以临时使用 HTTP。

#### 在 Xcode 中打开项目

1. 打开 Xcode
2. 创建新项目：**iOS > App**
3. 选择 **SwiftUI** 和 **Swift** 语言
4. 将 `App/` 目录下的所有文件复制到项目中

#### 配置 Info.plist

添加以下权限：

```xml
<key>NSMicrophoneUsageDescription</key>
<string>需要使用麦克风进行语音提问</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>需要使用语音识别来理解您的问题</string>

<!-- 如果使用 HTTP（仅用于开发测试） -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

#### 添加 Capability

在 Xcode 中：
1. 选择项目 Target
2. **Signing & Capabilities** 标签
3. 点击 **+ Capability**
4. 添加 **Speech Recognition**

### 3. 运行 App

1. 在 Xcode 中选择目标设备（真机或模拟器）
2. 点击 ▶️ 运行
3. 首次运行会请求麦克风和语音识别权限，请允许

## 使用指南

### 上传并分析数据

1. 准备 Excel 文件，包含以下列：
   - 日期
   - 渠道
   - 曝光量
   - 点击量
   - 转化数
   - 成本
   - 收入

2. 在 App 中点击"上传文件"
3. 选择 Excel 文件
4. 等待 AI 分析完成
5. 查看分析报告

### 语音提问

1. 上传并分析数据后，点击"语音提问"
2. 点击麦克风按钮开始录音
3. 说出您的问题，例如：
   - "这个月哪个渠道效果最好？"
   - "ROI 最高的是哪个？"
   - "给我一些优化建议"
4. 点击"停止录音"
5. 点击"提交问题"
6. AI 会回答您的问题并自动语音播报

## Excel 数据格式示例

| 日期 | 渠道 | 曝光量 | 点击量 | 转化数 | 成本 | 收入 |
|------|------|--------|--------|--------|------|------|
| 2024-12-01 | 搜索广告 | 34918 | 898 | 65 | 2969.01 | 24363.92 |
| 2024-12-01 | 社交媒体 | 69739 | 1495 | 76 | 3044.11 | 18290.90 |
| 2024-12-01 | 展示广告 | 84912 | 621 | 18 | 843.29 | 5239.59 |
| 2024-12-01 | 电子邮件 | 27142 | 3178 | 467 | 1518.51 | 207495.59 |

## 技术栈

### iOS App
- **语言**: Swift 5+
- **框架**: SwiftUI
- **最低版本**: iOS 15.0+
- **核心功能**:
  - URLSession (网络请求)
  - Speech (语音识别)
  - AVFoundation (语音合成)
  - UniformTypeIdentifiers (文件类型)

### 后端
- **语言**: Python 3.11+
- **框架**: FastAPI
- **数据处理**: Pandas, OpenPyXL
- **AI**: Anthropic Claude API

## API 文档

详细的 API 文档请查看 [BACKEND_API.md](./BACKEND_API.md)

### 主要端点

- `POST /api/analyze` - 上传 Excel 并获取分析报告
- `POST /api/query` - 语音问答

## 常见问题

### Q: App 无法连接到后端？

**A:** 检查以下几点：
1. 后端服务器是否正在运行？
2. `APIService.swift` 中的 `baseURL` 是否正确？
3. 如果使用本地 IP，iPhone 和电脑是否在同一 WiFi？
4. 是否在 Info.plist 中允许了 HTTP 连接（开发环境）？

### Q: 语音识别不工作？

**A:** 确保：
1. 已授予麦克风和语音识别权限
2. 设备支持语音识别（真机测试）
3. 网络连接正常

### Q: Claude API 调用失败？

**A:** 检查：
1. `ANTHROPIC_API_KEY` 环境变量是否正确设置
2. API 密钥是否有效
3. 网络是否能访问 Anthropic API
4. 查看后端日志了解详细错误

### Q: Excel 文件解析失败？

**A:** 确保：
1. Excel 文件包含所有必需的列
2. 列名与示例完全一致
3. 数据格式正确（数字列不要有文本）
4. 文件没有损坏

## 开发建议

### 调试

1. **查看后端日志**: 运行后端时会输出详细日志
2. **使用 Xcode 调试器**: 设置断点查看变量值
3. **查看 Network**: 使用 Charles 或 Proxyman 抓包

### 生产部署

1. **后端部署**:
   - 使用 Docker 容器化
   - 配置 HTTPS (Let's Encrypt)
   - 设置环境变量
   - 添加日志和监控

2. **iOS App**:
   - 移除 `NSAllowsArbitraryLoads`
   - 使用 HTTPS 后端 URL
   - 添加错误追踪（Sentry、Firebase Crashlytics）
   - App Store 上架前测试

### 安全注意事项

⚠️ **重要安全提示**：

1. **不要在 App 中硬编码 API 密钥**
2. **后端必须验证上传文件的安全性**
3. **限制文件大小（建议 10MB）**
4. **实现速率限制防止滥用**
5. **生产环境必须使用 HTTPS**
6. **添加用户认证（如需要）**

## 扩展功能建议

可以考虑添加的功能：

- 📅 历史报告查看
- 📊 更多图表类型（折线图、饼图）
- 💾 本地缓存报告
- 📤 导出 PDF 报告
- 👥 多用户支持
- 🔔 数据异常提醒
- 📈 趋势预测
- 🎨 自定义主题

## 许可证

本项目仅供学习和参考使用。

## 联系方式

如有问题或建议，请联系开发者。

---

**祝您使用愉快！🎉**
