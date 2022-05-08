const { Client } = require('discord.js');
const client = new Client;
const { updatePlayerCount, updateInGameTime } = require("./utils/")
global.config = require("./config.json")

// https://discordapp.com/oauth2/authorize?client_id=your_client_id&scope=bot&permissions=8
client.on('ready', () => {
    console.log(`Discord Bot logged in as ${client.user.tag}`);
    updatePlayerCount(client, 5)
});

client.login(config.token);