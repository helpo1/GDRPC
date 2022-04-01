#include <cstring>
#include <string>

#include "../include/discord.h"

#include "../include/config.h"
#include "../include/rpc.h"

void handleDiscordReady(const DiscordUser *connectedUser)
{
	initPresence();
}

void discordInit()
{
	DiscordEventHandlers handlers;
	memset(&handlers, 0, sizeof(handlers));
	handlers.ready = handleDiscordReady;

	std::string iniAppID = gdrpcReadAppID();

	if (iniAppID != NO_INI_INPUT)
	{
		Discord_Initialize(iniAppID.c_str(), &handlers, true, NULL);
	}
	else
	{
		Discord_Initialize(APP_ID, &handlers, true, NULL);
	}
}
