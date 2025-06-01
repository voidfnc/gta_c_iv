"use strict";

console.log("[IV-CHAT] Client script initialized - Full Chat Interception");

// Enhanced emoji configuration
const config = {
    emotes: {
        ":)": "😊",
        ":D": "😃",
        ":(": "😞",
        ":P": "😛",
        ";)": "😉",
        "<3": "❤️",
        ":o": "😮",
        ":|": "😐",
        ":*": "😘",
        ":/": "😕",
        "XD": "😆",
        ":@": "😠",
        ":'(": "😢",
        ":')": "😂",
        "8)": "😎"
    }
};

// Initialize chat system
bindEventHandler("OnResourceStart", thisResource, function() {
    console.log("[IV-CHAT] Initializing full chat interception system");
    console.log("[IV-CHAT] Enhanced chat system initialized");
});

// Process emoticons in messages
function processEmotes(messageText) {
    if (!messageText) return messageText;
    
    console.log(`[IV-CHAT] Processing: "${messageText}"`);
    let processed = messageText;
    
    // Process each emoticon
    for (const emote in config.emotes) {
        if (processed.includes(emote)) {
            processed = processed.replace(new RegExp(escapeRegExp(emote), "g"), config.emotes[emote]);
            console.log(`[IV-CHAT] Replaced "${emote}" with "${config.emotes[emote]}"`);
        }
    }
    
    console.log(`[IV-CHAT] Result: "${processed}"`);
    return processed;
}

// Helper to escape special regex characters
function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// Enhanced emotes command showing all available emojis
addCommandHandler("emotes", function(command, params) {
    console.log("[IV-CHAT] Emotes command triggered");
    
    // Show available emoticons in a nice format
    message("📝 Available Emoticons:", COLOUR_YELLOW);
    
    const emoteEntries = Object.entries(config.emotes);
    let emoteLines = [];
    
    // Group emotes in lines of 5
    for (let i = 0; i < emoteEntries.length; i += 5) {
        const group = emoteEntries.slice(i, i + 5);
        const line = group.map(([text, emoji]) => `${text} ${emoji}`).join("  ");
        emoteLines.push(line);
    }
    
    emoteLines.forEach(line => {
        message(line, COLOUR_WHITE);
    });
    
    message("Type any of these in your chat messages! 😊", COLOUR_LIME);
});

// Test command to verify emoji processing
addCommandHandler("testchat", function(command, params) {
    console.log("[IV-CHAT] Test chat command triggered");
    
    const testMessage = "Test: Hello everyone :) How are you doing? :D I'm great! <3";
    const processedMessage = processEmotes(testMessage);
    
    message(`Original: ${testMessage}`, COLOUR_WHITE);
    message(`With emojis: ${processedMessage}`, COLOUR_YELLOW);
});

// Force a debug message when F8 is pressed
bindKey(SDLK_F8, KEYSTATE_DOWN, function() {
    console.log("[IV-CHAT] Debug key pressed");
    triggerNetworkEvent("ivchat:debug");
});

// Network handler for server emoji processing requests
addNetworkHandler("ivchat:processEmojis", function(originalMessage) {
    console.log(`[IV-CHAT] Server requested emoji processing for: ${originalMessage}`);
    const processed = processEmotes(originalMessage);
    triggerNetworkEvent("ivchat:emojiProcessed", processed);
});

console.log("[IV-CHAT] Client script fully loaded");
