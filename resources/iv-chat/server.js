"use strict";

console.log("[IV-CHAT] Server script initialized - Full Chat Interception");

// Enhanced emoji configuration (server-side copy)
const serverEmotes = {
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
};

// CRITICAL: Chat message interception
addEventHandler("OnPlayerChat", function(event, client, chatMessage) {
    console.log(`[IV-CHAT] Intercepted chat from ${client.name}: "${chatMessage}"`);
    
    // Process the message for emoticons
    const processedMessage = processEmotes(chatMessage);
    
    // Check if we actually processed any emojis
    if (processedMessage !== chatMessage) {
        console.log(`[IV-CHAT] Processed message: "${processedMessage}"`);
        
        // Cancel the original message
        event.preventDefault();
        
        // Send the processed message to all players
        const formattedMessage = `${client.name}: ${processedMessage}`;
        message(formattedMessage, COLOUR_WHITE);
        
        return false; // Prevent original message from being sent
    }
    
    // If no emojis were found, let the original message through
    console.log(`[IV-CHAT] No emojis found, allowing original message`);
    return true;
});

// Enhanced debug handler
addNetworkHandler("ivchat:debug", function(client) {
    if (!client) return;
    
    console.log(`[IV-CHAT] Debug request from ${client.name}`);
    
    // Test different message types
    const debugMessages = [
        "Direct message test: Hello :) :D",
        processEmotes("Processed test: Welcome everyone! :) How are you? :D"),
        `Broadcast: ${client.name} is testing chat emojis :) :D <3`
    ];
    
    // Send multiple test messages
    debugMessages.forEach((msg, index) => {
        setTimeout(() => {
            if (index === 2) {
                // Broadcast the last one
                message(msg, COLOUR_AQUA);
            } else {
                // Direct message for the first two
                messageClient(msg, client, COLOUR_YELLOW);
            }
        }, index * 1000); // 1 second delay between messages
    });
});

// Handle client-processed emoji messages
addNetworkHandler("ivchat:emojiProcessed", function(client, processedMessage) {
    console.log(`[IV-CHAT] Received processed message from client: ${processedMessage}`);
    message(`Client processed: ${processedMessage}`, COLOUR_LIME);
});

// Server-side emoji processing function
function processEmotes(messageText) {
    if (!messageText) return messageText;
    
    console.log(`[IV-CHAT] Server processing: "${messageText}"`);
    let processed = messageText;
    
    for (const emote in serverEmotes) {
        if (processed.includes(emote)) {
            processed = processed.replace(new RegExp(escapeRegExp(emote), "g"), serverEmotes[emote]);
            console.log(`[IV-CHAT] Server replaced "${emote}" with "${serverEmotes[emote]}"`);
        }
    }
    
    console.log(`[IV-CHAT] Server result: "${processed}"`);
    return processed;
}

function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// Player join handler (enhanced with emoji welcome)
addEventHandler("OnPlayerJoined", function(event, client) {
    if (!client) return;
    
    console.log(`[IV-CHAT] Player joined: ${client.name}`);
    
    // Send welcome message with emojis after a delay (so it doesn't conflict with v-joinquit)
    setTimeout(() => {
        const welcomeMsg = processEmotes(`Welcome ${client.name}! :) Use /emotes to see available emoticons :D`);
        messageClient(`[IV-CHAT] ${welcomeMsg}`, client, COLOUR_LIME);
    }, 3000); // 3 second delay after v-joinquit messages
});

console.log("[IV-CHAT] Server script loaded - Full chat interception ready");
