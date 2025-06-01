# 🎮 IV-CHAT - Enhanced Chat System for GTA:Connected

A real-time emoji processing system that intercepts all player chat messages and converts text emoticons into graphical emojis for GTA:Connected servers.

![GTA:Connected](https://img.shields.io/badge/Platform-GTA%3AConnected-blue)
![Status](https://img.shields.io/badge/Status-Working-brightgreen)
![Version](https://img.shields.io/badge/Version-1.0.0-orange)

## ✨ Features

- **🔄 Real-time Chat Interception**: Automatically processes all player chat messages
- **😊 15 Different Emojis**: Converts text emoticons like `:)` into graphical emojis like 😊
- **⚡ Performance Optimized**: Only processes messages containing emoticons
- **🎯 Smart Integration**: Works seamlessly with existing v-essentials modules
- **📝 Enhanced Commands**: `/emotes`, `/testchat`, and F8 debug functionality
- **🚀 Zero Conflicts**: Designed to work alongside v-joinquit, v-help, and other modules

## 📥 Installation

1. **Download** the IV-CHAT folder
2. **Place** it in your GTA:Connected server's `resources` folder
3. **Add** to your server config:
   ```
   <resource src="iv-chat" />
   ```
4. **Start** your server or use `/start iv-chat`

## 🎯 Usage

### For Players
Simply type emoticons in chat and they'll automatically convert:

```
Player types: "Hello everyone :) How are you? :D"
Displays as: "Player: Hello everyone 😊 How are you? 😃"
```

### Available Emoticons

| Text | Emoji | Description |
|------|-------|-------------|
| `:)` | 😊 | Smiling face |
| `:D` | 😃 | Grinning face |
| `:(` | 😞 | Disappointed face |
| `:P` | 😛 | Face with tongue |
| `;)` | 😉 | Winking face |
| `<3` | ❤️ | Red heart |
| `:o` | 😮 | Face with open mouth |
| `:\|` | 😐 | Neutral face |
| `:*` | 😘 | Face blowing a kiss |
| `:/` | 😕 | Confused face |
| `XD` | 😆 | Grinning squinting face |
| `:@` | 😠 | Angry face |
| `:'(` | 😢 | Crying face |
| `:')` | 😂 | Face with tears of joy |
| `8)` | 😎 | Smiling face with sunglasses |

### Commands

- **`/emotes`** - Display all available emoticons
- **`/testchat`** - Test emoji processing with sample message
- **F8** - Debug key for testing multiple processing methods

## 🔧 Technical Details

### Architecture
- **Client-side**: Emoji processing and command handling
- **Server-side**: Chat interception using `OnPlayerChat` event
- **Event-driven**: Uses GTA:Connected's native event system

### Chat Interception Process
1. Player sends chat message
2. `OnPlayerChat` event captures message
3. Server processes message for emoticons
4. If emojis found: cancels original message, sends processed version
5. If no emojis: allows original message through

### Performance
- **Conditional Processing**: Only processes messages containing emoticons
- **Regex Optimization**: Efficient pattern matching for emoticon replacement
- **Event Prevention**: Smart cancellation of original messages when needed

## 🛠️ Development

### File Structure
```
iv-chat/
├── client.js          # Client-side emoji processing and commands
├── server.js          # Server-side chat interception and processing
└── meta.xml          # Resource configuration
```

### Key Functions
- `processEmotes(messageText)` - Converts text emoticons to emojis
- `OnPlayerChat` event handler - Intercepts and processes all chat messages
- `addCommandHandler` - Handles `/emotes` and `/testchat` commands

### Compatibility
- ✅ **GTA:Connected** - Primary platform
- ✅ **v-essentials** - Full compatibility with existing modules
- ✅ **Unicode Support** - Confirmed emoji display support

## 🔍 Debugging

### Console Logging
The system provides detailed console output:
```javascript
[IV-CHAT] Intercepted chat from voidfnc: "Hello :) :D"
[IV-CHAT] Server replaced ":)" with "😊"
[IV-CHAT] Server replaced ":D" with "😃" 
[IV-CHAT] Processed message: "Hello 😊 😃"
```

### Debug Commands
- Use **F8** for comprehensive testing
- Use **`/testchat`** to verify processing
- Monitor server console for detailed logs

## 📋 Requirements

- **GTA:Connected Server** (any version with `OnPlayerChat` support)
- **JavaScript ES6+** support
- **Unicode/Emoji** font support (automatically handled by GTA:Connected)

## 🤝 Contributing

Contributions are welcome! Please feel free to:
- Report bugs
- Suggest new emoticons
- Improve performance
- Add new features

## 📄 License

This project is open source. Feel free to use, modify, and distribute.

## 🙏 Acknowledgments

- **GTA:Connected Team** - For the excellent multiplayer platform
- **v-essentials** - For the modular resource architecture inspiration
- **Community** - For testing and feedback

## 📞 Support

- **GitHub Issues**: Report bugs and feature requests
- **GTA:Connected Community**: General support and discussion

---

**Created by voidfnc** | **Date: 2025-06-01** | **Status: Production Ready** ✅

*Transform your GTA:Connected server chat with real-time emoji processing!* 🎮😊
