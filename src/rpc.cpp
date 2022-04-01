#include <chrono>
#include <cstring>

#include "../include/rpc.h"

#include "../include/api.h"
#include "../include/config.h"
#include "../include/sharedvars.h"
#include "../include/utils.h"

#include "../libs/discord-rpc/include/discord_rpc.h"

using std::chrono::duration_cast;
using std::chrono::seconds;
using std::chrono::system_clock;

DiscordRichPresence discordPresence;

std::string discordPresenceState;
std::string discordPresenceDetails;
std::string discordPresenceLgkey;
std::string discordPresenceLgtext;
std::string discordPresenceSmkey;
std::string discordPresenceSmtext;

// API DRAFT FOR ANIMATED IMAGES (NOT IMPLEMENTED)
/*
	#define NOMINMAX

	int lgkeyAnimCount = 0;
	int lgkeyAnimSpeed = 0;
	int smkeyAnimCount = 0;
	int smkeyAnimSpeed = 0;
*/

void initPresence()
{
	memset(&discordPresence, 0, sizeof(discordPresence));

	gdrpcReadINI();
	std::string modText = getModText();

	if (discordPresenceStateDef == NO_INI_INPUT)
	{
		discordPresenceState = "";
	}
	else
	{
		discordPresenceState = discordPresenceStateDef;
	}

	if (discordPresenceDetailsDef == NO_INI_INPUT)
	{
		if (modText.empty() == false)
		{
			discordPresenceDetails = modText;
		}
	}
	else
	{
		discordPresenceDetails = discordPresenceDetailsDef;
	}

	if (discordPresenceLgkeyDef == NO_INI_INPUT)
	{
		discordPresenceLgkey = "logo";
	}
	else
	{
		discordPresenceLgkey = discordPresenceLgkeyDef;
	}

	if (discordPresenceLgtextDef == NO_INI_INPUT)
	{
		discordPresenceLgtext = "";
	}
	else
	{
		discordPresenceLgtext = discordPresenceLgtextDef;
	}

	if (discordPresenceSmkeyDef == NO_INI_INPUT)
	{
		if (modText.empty() == false)
		{
			discordPresenceSmkey = "mod";
		}
	}
	else
	{
		discordPresenceSmkey = discordPresenceSmkeyDef;
	}

	if (discordPresenceSmtextDef == NO_INI_INPUT)
	{
		if (modText.empty() == false)
		{
			discordPresenceSmtext = modText;
		}
	}
	else
	{
		discordPresenceSmtext = discordPresenceSmtextDef;
	}

	if (showTimeElapsed == true)
	{
		discordPresence.startTimestamp = duration_cast<seconds>(
			system_clock::now().time_since_epoch()
		).count();
	}

	updatePresence();
}

/*
	void updatePresenceState(std::string text)
	{
		discordPresenceState = text.substr(0, 127);
		updatePresence();
	}
*/

void preparePresence(size_t type, std::string text)
{
	switch (type)
	{
	case APIDN_PREFIX:
		break;
	case APIDN_STATE:
		discordPresenceState = text.substr(0, 127);
		break;
	case APIDN_DETAILS:
		discordPresenceDetails = text.substr(0, 127);
		break;
	case APIDN_LGKEY:
		discordPresenceLgkey = text.substr(0, 31);
		break;
	case APIDN_LGTEXT:
		discordPresenceLgtext = text.substr(0, 127);
		break;
	case APIDN_SMKEY:
		discordPresenceSmkey = text.substr(0, 31);
		break;
	case APIDN_SMTEXT:
		discordPresenceSmtext = text.substr(0, 127);
		break;
	// insert new delimiter types here

	default:
		break;

	// API DRAFT FOR ANIMATED IMAGES (NOT IMPLEMENTED)
	/*
		case APIDN_LGKEY:
			{
				// terminate child process (if exists)
				size_t countPos = text.find(API_FRAMECOUNT_POSTFIX);
				size_t speedPos = text.find(API_FRAMESPEED_POSTFIX);
				if ((countPos != std::string::npos) && (speedPos != std::string::npos))
				{
					lgkeyAnimCount = std::stoi(text.substr(countPos + strlen(API_FRAMECOUNT_POSTFIX), 3));
					lgkeyAnimSpeed = std::stoi(text.substr(speedPos + strlen(API_FRAMESPEED_POSTFIX), 3));
					text.erase(std::min(countPos, speedPos), (strlen(API_FRAMECOUNT_POSTFIX) + 3 + strlen(API_FRAMECOUNT_POSTFIX) + 3));
					discordPresenceLgkey = text.substr(0, 31);
				}
				else
				{
					lgkeyAnimCount = 0;
					lgkeyAnimSpeed = 0;
					discordPresenceLgkey = text.substr(0, 31);
				}
			}
			break;
		case APIDN_SMKEY:
			{
				// terminate child process (if exists)
				size_t countPos = text.find(API_FRAMECOUNT_POSTFIX);
				size_t speedPos = text.find(API_FRAMESPEED_POSTFIX);
				if ((countPos != std::string::npos) && (speedPos != std::string::npos))
				{
					smkeyAnimCount = std::stoi(text.substr(countPos + strlen(API_FRAMECOUNT_POSTFIX), 3));
					smkeyAnimSpeed = std::stoi(text.substr(speedPos + strlen(API_FRAMESPEED_POSTFIX), 3));
					text.erase(std::min(countPos, speedPos), (strlen(API_FRAMECOUNT_POSTFIX) + 3 + strlen(API_FRAMECOUNT_POSTFIX) + 3));
					discordPresenceSmkey = text.substr(0, 31);
				}
				else
				{
					smkeyAnimCount = 0;
					smkeyAnimSpeed = 0;
					discordPresenceSmkey = text.substr(0, 31);
				}
			}
			break;
	*/
	}
}

// API DRAFT FOR ANIMATED IMAGES (NOT IMPLEMENTED)
/*
	void animateImage() {
		// loop to update _001 to _xyz image suffixes in discordPresenceLgkey / discordPresenceSmkey and call updatePresence
		// needs (somewhat-)precise execution time management
		// (possibly busy waiting with chrono::steady_clock and this_thread::sleep_until ? - needs performance hit tests)
	}
*/

void updatePresence()
{
	discordPresence.state = discordPresenceState.c_str();
	discordPresence.details = discordPresenceDetails.c_str();
	discordPresence.largeImageKey = discordPresenceLgkey.c_str();
	discordPresence.largeImageText = discordPresenceLgtext.c_str();
	discordPresence.smallImageKey = discordPresenceSmkey.c_str();
	discordPresence.smallImageText = discordPresenceSmtext.c_str();
	Discord_UpdatePresence(&discordPresence);
}
