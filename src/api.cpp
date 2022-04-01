#define NOMINMAX

#include <map>

#include "../include/api.h"

#include "../include/config.h"
#include "../include/rpc.h"
#include "../include/sharedvars.h"
#include "../include/utils.h"

// API delimiter strings
const std::string API_DELIM[] =
	{
		"GDRPC:",
		"&!STA!&",
		"&!DET!&",
		"&!LGK!&",
		"&!LGT!&",
		"&!SMK!&",
		"&!SMT!&"
		// insert new delimiter strings here
		// and update "../include/api.h" accordingly
};

// control strings
const std::string API_CONTROL[] =
	{
		"@LKW@",		// last known world
		"@MODNAME@",
		"@ANSI@",
		"@UTF8@"
		// insert new control strings here
		// and update "../include/api.h" accordingly
};

// language strings
const std::string API_LANG[] =
	{
		"@LANG_EN@",
		"@LANG_DE@",
		"@LANG_PL@",
		"@LANG_RU@",
		"@LANG_CZ@"
		// insert new language strings here
		// and update "../include/api.h" accordingly
};

size_t languageID = 0;
bool ansiEncoding = true;

std::string lastKnownWorld = "";
std::string locationPrefix = "";
std::string modName = "";
std::string modPrefix = "";

bool processApiString(std::string data)
{

	// if processed string (possible API request) starts with APIDN_PREFIX:
	if (
		(data.length() >= API_DELIM[APIDN_PREFIX].length())
		&& (data.substr(0, API_DELIM[APIDN_PREFIX].length()) == API_DELIM[APIDN_PREFIX])
		)
	{
		// replace control strings and set internal variables
		for (size_t i = 0; i < APICN_TOTAL; i++)
		{
			size_t pos = data.find(API_CONTROL[i]);

			while (pos != std::string::npos)
			{
				switch (i)
				{
				case APICN_LKWORLD:
					data.replace(pos, API_CONTROL[i].length(), WORLDNAME_SWITCH(lastKnownWorld));
					break;
				case APICN_MODNAME:
					data.replace(pos, API_CONTROL[i].length(), modName);
					break;
				case APICN_ANSI:
					data.erase(pos, API_CONTROL[i].length());
					ansiEncoding = true;
					break;
				case APICN_UTF8:
					data.erase(pos, API_CONTROL[i].length());
					ansiEncoding = false;
					break;
				default:
					break;
				}

				pos = data.find(API_CONTROL[i]);
			}
		}

		// set language variable
		for (size_t i = 0; i < APILN_TOTAL; i++)
		{
			size_t pos = data.find(API_LANG[i]);

			if (pos != std::string::npos)
			{
				languageID = i;
			}

			while (pos != std::string::npos)
			{
				data.erase(pos, API_LANG[i].length());
				pos = data.find(API_LANG[i]);
			}
		}

		if (ansiEncoding == true)
		{
			// convert from pseudo CZ (old) to normal CZ
			if (languageID == APILN_LANG_CZ)
			{
				data = utf8Encode(pseudoCzEncode(ansiEncode(data)));
			}
			else
			{
				data = utf8Encode(ansiEncode(data));
			}
		}

		std::map<size_t, size_t> apiUnparsed;
		std::map<size_t, std::string> apiParsed;

		// find delimiter positions in given API request for tokenization
		for (size_t i = 1; i < APIDN_TOTAL; i++)
		{
			size_t pos = data.find(API_DELIM[i]);

			if (pos != std::string::npos)
			{
				apiUnparsed.insert(std::pair<size_t, size_t>(pos, i));
			}
		}

		// insert single buffer "end of string" position
		apiUnparsed.insert(std::pair<size_t, size_t>(std::string::npos, APIDN_TOTAL));

		// tokenize API request
		{
			size_t currPos, currVal, nextPos, nextVal;

			nextPos = apiUnparsed.begin()->first;
			nextVal = apiUnparsed.begin()->second;

			while (apiUnparsed.size() >= 2)
			{
				currPos = nextPos;
				currVal = nextVal;
				apiUnparsed.erase(currPos);

				nextPos = apiUnparsed.begin()->first;
				nextVal = apiUnparsed.begin()->second;

				apiParsed.insert(std::pair<size_t, std::string>(currVal,
					data.substr(currPos + API_DELIM[currVal].length(), nextPos - currPos - API_DELIM[currVal].length())
				));
			}
		}

		// accommodate all changes from API request locally
		for (const auto &m : apiParsed)
		{
			preparePresence(m.first, m.second);
		}

		// update presence with (changed) contents
		updatePresence();

		// string indeed was an API request
		// only update presence with further API requests from now on
		return true;
	}

	else
	{
		// string wasn't an API request
		// if no other API request was yet made, continue processing non-API information
		return false;
	}
}
