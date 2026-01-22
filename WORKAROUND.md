# 🔧 Xcode 26.2 + iOS 15.4 兼容性解决方案

## 问题
Xcode 26.2 在连接 iOS 15.4 设备时错误地要求下载 iOS 26.2 支持文件。

## ✅ 解决方案：使用 Xcode Settings 禁用自动下载

### 方法 1: 在 Xcode 中手动操作（最简单）

1. **停止当前下载**：
   - 在 Xcode 顶部，如果看到下载进度，点击 ❌ 取消

2. **打开 Xcode Settings**：
   - 菜单栏: **Xcode → Settings** (或按 `⌘,`)
   - 点击 **Platforms** 标签

3. **在已安装列表中检查**：
   - 应该能看到 iOS 15.4 已经在支持列表中
   - 如果没有，iOS 15.0-16.4 都应该已经安装了

4. **关闭 Settings**

5. **重启 Xcode**：
   - 完全退出 Xcode (`⌘Q`)
   - 重新打开项目

6. **拔掉再插上 iPhone**：
   - 拔掉数据线
   - 等待 5 秒
   - 重新插入
   - 在 iPhone 上点击"信任"

7. **再次尝试运行**：
   - 选择你的设备
   - 点击 ▶️

### 方法 2: 使用无线调试（跳过 USB）

如果上面的方法还不行，可以尝试无线调试：

1. **设置无线调试**：
   - iPhone 连接 USB
   - 在 Xcode 菜单: **Window → Devices and Simulators**
   - 选择你的 iPhone
   - 勾选 **"Connect via network"**
   - 等待设备旁边出现网络图标

2. **拔掉 USB 线**

3. **在 Xcode 中选择网络设备运行**

### 方法 3: 降低部署目标（临时方案）

如果还是不行，可以暂时在模拟器上测试：

1. 在 Xcode 顶部设备选择器，选择任意 **iPhone 模拟器**
2. 点击 ▶️ 运行
3. 在模拟器中测试除了语音识别之外的所有功能

注意：模拟器无法测试语音识别功能，但可以测试 UI 和后端连接。

### 方法 4: 使用旧版本 Xcode（终极方案）

如果以上都不行，可以安装 Xcode 15.x：

1. 访问: https://developer.apple.com/download/all/
2. 下载 Xcode 15.4
3. 重命名为 Xcode15.app 并放到 Applications 文件夹
4. 使用 `xcode-select` 切换版本

## 🎯 推荐顺序

1. ✅ 先试方法 1（重启 + 重新插拔设备）
2. 如果不行，试方法 2（无线调试）
3. 如果不行，试方法 3（模拟器测试）
4. 最后才考虑方法 4（降级 Xcode）

## 📝 iOS 15.4 支持已安装确认

根据系统检查，iOS 15.4 的设备支持文件已经在：
```
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport/15.4
```

所以理论上应该可以工作，这是 Xcode 26.2 的一个 bug。

---

**当前状态**: 正在尝试安装 ios-deploy 工具作为备用方案
