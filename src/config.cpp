#include <algorithm>
#include <cctype>
#include <sys/stat.h>

#include "../include/config.h"
#include "../include/utils.h"

#include "../include/api.h"
#include "../libs/inih/cpp/INIReader.h"
#include "../include/sharedvars.h"

std::string discordPresenceStateDef = NO_INI_INPUT;
std::string discordPresenceDetailsDef = NO_INI_INPUT;
std::string discordPresenceLgkeyDef = NO_INI_INPUT;
std::string discordPresenceLgtextDef = NO_INI_INPUT;
std::string discordPresenceSmkeyDef = NO_INI_INPUT;
std::string discordPresenceSmtextDef = NO_INI_INPUT;

std::string defaultIniFilePath = "GDRPC.ini";

bool showTimeElapsed = true;

bool is_number(const std::string &s)
{
	return !s.empty() && std::find_if(s.begin(), s.end(), [](unsigned char c)
									  { return !std::isdigit(c); }) == s.end();
}

bool file_exists(const std::string &name)
{
	struct stat buffer;   
	return (stat (name.c_str(), &buffer) == 0); 
}

std::string gdrpcReadAppID()
{
	std::string customAppID = NO_INI_INPUT;

	std::map<std::string, std::string> localArgs = getCommandLineArgs();
	std::string localModIni = "";

	if (!localArgs.empty())
	{
		localModIni = localArgs["game"];
	}

	if (!localModIni.empty())
	{
		INIReader reader(localModIni);

		if (reader.ParseError() < 0)
		{
			// [GENERAL]
			// customAppID = NO_INI_INPUT;
		}
		else
		{
			// [GENERAL]
			customAppID = reader.Get("GDRPC", "custom_app_ID", customAppID);

			if (is_number(customAppID) == false)
			{
				customAppID = NO_INI_INPUT;
			}
		}
	}

	if (!file_exists(defaultIniFilePath) && file_exists("system\\" + defaultIniFilePath))
	{
		defaultIniFilePath = "system\\" + defaultIniFilePath;
	}

	INIReader reader(defaultIniFilePath);

	if (reader.ParseError() < 0)
	{
		// [GENERAL]
		// customAppID = NO_INI_INPUT;
	}
	else
	{
		// [GENERAL]
		if ((reader.GetBoolean("general", "override_mod_ini_app_ID", false)) || (customAppID == NO_INI_INPUT))
		{
			customAppID = reader.Get("general", "custom_app_ID", customAppID);
		}

		if (is_number(customAppID) == false)
		{
			customAppID = NO_INI_INPUT;
		}
	}

	return customAppID;
}

void gdrpcReadINI()
{
	INIReader reader(defaultIniFilePath);

	if (reader.ParseError() < 0)
	{
		// [GENERAL]
		showTimeElapsed = true;

		// [PRESENCE_DEFAULTS]
		discordPresenceStateDef = NO_INI_INPUT;
		discordPresenceDetailsDef = NO_INI_INPUT;
		discordPresenceLgkeyDef = NO_INI_INPUT;
		discordPresenceLgtextDef = NO_INI_INPUT;
		discordPresenceSmkeyDef = NO_INI_INPUT;
		discordPresenceSmtextDef = NO_INI_INPUT;

		// [LANGUAGE]
		ansiEncoding = true;
		languageID = APILN_LANG_EN;
		locationPrefix = "Svět: ";
		modPrefix = "Mod: ";
	}
	else
	{
		// [GENERAL]

		showTimeElapsed = reader.GetBoolean("general", "show_time_elapsed", true);

		// [PRESENCE_DEFAULTS]

		discordPresenceStateDef = reader.Get("presence_defaults", "state", NO_INI_INPUT);
		discordPresenceDetailsDef = reader.Get("presence_defaults", "details", NO_INI_INPUT);
		discordPresenceLgkeyDef = reader.Get("presence_defaults", "lgkey", NO_INI_INPUT);
		discordPresenceLgtextDef = reader.Get("presence_defaults", "lgtext", NO_INI_INPUT);
		discordPresenceSmkeyDef = reader.Get("presence_defaults", "smkey", NO_INI_INPUT);
		discordPresenceSmtextDef = reader.Get("presence_defaults", "smtext", NO_INI_INPUT);

		// [LANGUAGE]

		ansiEncoding = reader.GetBoolean("language", "ansi_encoding", true);
		
		languageID = reader.GetInteger("language", "language_id", APILN_LANG_EN);
		if ((languageID < 0) || (languageID >= APILN_TOTAL))
		{
			languageID = APILN_LANG_EN;
		}

		locationPrefix = reader.Get("language", "location_prefix", "Svět:");
		if (locationPrefix.empty() == false)
		{
			locationPrefix += " ";
		}

		modPrefix = reader.Get("language", "mod_prefix", "Mod:");
		if (modPrefix.empty() == false)
		{
			modPrefix += " ";
		}
	}
}