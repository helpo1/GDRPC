#include <algorithm>
#include <cctype>
#include <utility>
#include <vector>
#include <windows.h>

#include "../include/utils.h"

#include "../include/api.h"
#include "../include/sharedvars.h"

std::string getFileName(const std::string &path)
{
	return { std::find_if(path.rbegin(), path.rend(),
		[](char c) { return c == '/' || c == '\\'; }).base(),
		path.end() };
}

std::string getModuleFileName()
{
	char modulePath[MAX_PATH];
	GetModuleFileName(NULL, modulePath, MAX_PATH);

	return getFileName(modulePath);
}

std::string toUpperCase(std::string str)
{
	std::transform(str.begin(), str.end(), str.begin(), ::toupper);

	return str;
}

std::string getWorldNameG1(std::string zenFile)
{
	std::string zen = toUpperCase(zenFile);

	static const std::map<std::string, std::vector<std::string>> zenNamesG1 = {

		// G1 (vanilla)
			// .ZEN						// EN				// DE				// PL					// RU					// CZ
		{	"FREEMINE.ZEN"	,		{	"Free Mine",		"Freie Mine",		"Wolna Kopalnia",		"Свободная шахта",		"Svobodný důl"		} },
		{	"OLDMINE.ZEN",			{	"Old Mine",			"Alte Mine",		"Stara Kopalnia",		"Старая шахта",			"Starý důl"			} },
		{	"ORCGRAVEYARD.ZEN",		{	"Orc Cemetery",		"Orkfriedhof",		"Cmentarzysko Orków",	"Кладбище орков",		"Skřetí hřbitov"	} },
		{	"ORCTEMPEL.ZEN",		{	"Sleeper's Temple",	"Schläfertempel",	"Świątynia Śniącego",	"Храм Спящего",			"Spáčův chrám"		} },
		{	"WORLD.ZEN",			{	"The Colony",		"Kolonie",			"Kolonia",				"Колония",				"Kolonie"			} },

		// Gothic Replay CZ/SK (v0.78)
			// .ZEN						// EN				// DE				// PL					// RU					// CZ
		{	"FREEMINE_TAKEN.ZEN",	{	"Free Mine",		"Freie Mine",		"Wolna Kopalnia",		"Свободная шахта",		"Svobodný důl"		} },
		{	"MODDUSTYMIND.ZEN",		{	"Dusty's Mind",		"Dustys Geist ",	"Umysł Dusty'ego",		"Разум Дасти",			"Dustyho mysl"		} }

		// insert new mod worlds here

	};

	auto it = zenNamesG1.find(zen);

	if (it != zenNamesG1.end())
	{
		return (it->second)[languageID];
	}
	else
	{
		// fallback
		return zenFile;
	}
}

std::string getWorldNameG2(std::string zenFile)
{
	std::string zen = toUpperCase(zenFile);

	static const std::map<std::string, std::vector<std::string>> zenNamesG2 = {

		// G2A (vanilla)
			// .ZEN						// EN							// DE							// PL						// RU						// CZ
		{	"ADDONWORLD.ZEN",		{	"Jharkendar",					"Jharkendar",					"Jarkendar",				"Яркендар",					"Jharkendar"				} },
		{	"DRAGONISLAND.ZEN",		{	"Irdorath",						"Irdorath",						"Wyspa Irdorath",			"Ирдорат",					"Irdorath"					} },
		{	"NEWWORLD.ZEN",			{	"Khorinis",						"Khorinis",						"Khorinis",					"Хоринис",					"Khorinis"					} },
		{	"OLDWORLD.ZEN",			{	"Valley of Mines",				"Minental",						"Górnicza Dolina",			"Долина Рудников",			"Hornické údolí"			} },

		// Returning 2.0 (v66.2)
			// .ZEN						// EN							// DE							// PL						// RU						// CZ
		{	"ABANDONEDMINE.ZEN",	{	"Abandoned Mine",				"Verlassene Mine",				"Opuszczona Kopalnia",		"Заброшенная шахта",		"Opuštěný důl"				} },
		{	"ADANOSVALLEY.ZEN",		{	"Plateau of the Ancients",		"Plateau der Ahnen",			"Płaskowyż Starożytnych",	"Плато Древних",			"Starověká plošina"			} },
		{	"ASHTARTEMPLE.ZEN",		{	"Ashtar's Sanctuary",			"Ashtars Heiligtum",			"Sanktuarium Ash'Tara",		"Святилище Аш'Тар",			"Svatyně Ashtara"			} },
		{	"AZGALORTEMPLE.ZEN",	{	"Raven's Nightmare",			"Albtraum des Raben",			"Koszmar Kruka",			"Кошмар Ворона",			"Ravenova noční můra"		} },
		{	"DEADGROT.ZEN",			{	"Fog Tower",					"Nebelturm",					"Wieża Mgieł",				"Грот туманов",				"Zamlžená věž"				} },
		{	"DEMONCAVE.ZEN",		{	"Cave of Pain",					"Höhle des Schmerzes",			"Jaskinia Bólu",			"Пещера боли",				"Jeskyně bolesti"			} },
		{	"DEMONSTOWER.ZEN",		{	"Sunken Tower",					"Versunkener Turm",				"Zatopiona Wieża",			"Затопленная башня",		"Zatopená věž"				} },
		{	"DRAGONTEMPLE.ZEN",		{	"Sanctuary of the Beast",		"Heiligtum der Bestie",			"Sanktuarium Bestii",		"Святилище Зверя",			"Svatyně Bestie"			} },
		{	"FIRECAVE.ZEN",			{	"Cave of Fire",					"Höhle des Feuers",				"Jaskinia Wulkaniczna",		"Пещера огня",				"Jeskyně Ohně"				} },
		{	"FREEMINE.ZEN",			{	"New Mine",						"Neue Mine",					"Nowa Kopalnia",			"Новая шахта",				"Nový důl"					} },
		{	"FREEMINELAGER.ZEN",	{	"Mountain Pass (to New Mine)",	"Bergpass zur Neuen Mine",		"Przełęcz Wolnej Kopalni",	"Горный перевал",			"Průsmyk k Novému dolu"		} },
		{	"GINNOKWORLD.ZEN",		{	"Ginnok's Tomb",				"Ginnoks Gruft",				"Ggrobowiec Ginnoka",		"Гробница Гиннока",			"Ginnokova hrobka"			} },
		{	"GOLDMINE.ZEN",			{	"Mountain Pass",				"Alte Goldmine",				"Przełęcz",					"Подгорный проход",			"Horský průchod"			} },
		{	"GUARDIANCHAMBERS.ZEN",	{	"Chambers of the Guardians",	"Halle der Hüter",				"Klasztor Opiekunów",		"Обитель хранителей",		"Příbytek Strážců"			} },
		{	"HAOSWORLD.ZEN",		{	"Halls of Vakhan",				"Hallen von Vakhan",			"Pałac Vakhana",			"Чертоги Вакханы",			"Vakhanské síně"			} },
		{	"HARADRIMARENA.ZEN",	{	"Arena of the Asgards",			"Arena der Asgarden",			"Arena Asgardów",			"Арена асгардов",			"Aréna Asgardů"				} },
		{	"ITUSELDTOWER.ZEN",		{	"Itu'Seld's Tower",				"Turm von Itu'Seld",			"Wieża Itu'Selda",			"Храм-башня Иту'Зельда",	"Itu'Seldova věž"			} },
		{	"LOSTISLAND.ZEN",		{	"Lost Island",					"Verschollene Insel",			"Zagubiona Wyspa",			"Затеряный остров",			"Ztracený ostrov"			} },
		{	"LOSTVALLEY.ZEN",		{	"Abode of the Lost Souls",		"Tal der verlorenen Seelen",	"Dolina Zagubionych Dusz",	"Обитель потерянных душ",	"Příbytek ztracených duší"	} },
		{	"OLDMINE.ZEN",			{	"Old Mine",						"Alte Mine",					"Stara Kopalnia",			"Старая шахта",				"Starý důl"					} },
		{	"ORCCITY.ZEN",			{	"Orc Town",						"Orkstadt",						"Miasto Orków",				"Город орков",				"Skřetí město"				} },
		{	"ORCGRAVEYARD.ZEN",		{	"Orc Cemetery",					"Orkfriedhof",					"Cmentarzysko Orków",		"Кладбище орков",			"Skřetí hřbitov"			} },
		{	"ORCMOUNTAIN.ZEN",		{	"Orc Mountains",				"Eiswüste",						"Góry Orków",				"Заснеженная локация",		"Zasněžené hory"			} },
		{	"ORCOREMINE.ZEN",		{	"Orc Mine",						"Orkmine",						"Kopalnia Orków",			"Шахта орков",				"Skřetí důl"				} },
		{	"ORCTEMPEL.ZEN",		{	"Sleeper's Temple",				"Schläfertempel",				"Świątynia Śniącego",		"Храм Спящего",				"Spáčův chrám"				} },
		{	"PALADINFORT.ZEN",		{	"Fort Azgan",					"Fort Azgan",					"Fort Azgan",				"Форт Азган",				"Pevnost Azgan"				} },
		{	"PASHALWORLD.ZEN",		{	"Egezart's World",				"Egezarts Welt",				"Świat Egezarta",			"Мир Эгезарта",				"Egezartův svět"			} },
		{	"PRIORATWORLD.ZEN",		{	"Masyaf's Lair",				"Versteck von Masyaf",			"Leże Masjafu",				"Масиаф",					"Doupě bratrstva Masyaf"	} },
		{	"PSICAMP.ZEN",			{	"Brotherhood of the Sleeper",	"Altes Lager der Bruderschaft",	"Obóz Bractwa Śniącego",	"Лагерь братства Спящего",	"Tábor Bratrstva Spáče"		} },
		{	"SECRETISLAND.ZEN",		{	"Etlu",							"Insel Etlu",					"Wyspa Etlu",				"Остров Этлу",				"Ostrov Etlu"				} },
		{	"SHVALLEY.ZEN",			{	"Valley of Shadows",			"Tal der Schatten",				"Dolina Cieni",				"Долина Теней",				"Údolí stínů"				} },
		{	"TEARSTEMPLE.ZEN",		{	"Temple of Tears",				"Tempel der Tränen",			"Świątynia Łez",			"Храм слез",				"Chrám slz"					} },
		{	"UNDEADZONE.ZEN",		{	"City of the Dead",				"Stadt der Toten",				"Miasto Umarłych",			"Город мертвых",			"Město mrtvých"				} }

		// insert new mod worlds here

	};

	auto it = zenNamesG2.find(zen);

	if (it != zenNamesG2.end())
	{
		return (it->second)[languageID];
	}
	else
	{
		// fallback
		return zenFile;
	}
}

std::string utf8Encode(const std::wstring &wstr)
{
	if (wstr.empty() == true)
	{
		return std::string();
	}

	size_t sizeRequired = WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), NULL, 0, NULL, NULL);

	std::string strTo(sizeRequired, 0);

	WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), &strTo[0], sizeRequired, NULL, NULL);

	return strTo;
}

std::wstring ansiEncode(const std::string &str)
{
	if (str.empty() == true)
	{
		return std::wstring();
	}

	size_t sizeRequired = MultiByteToWideChar(CP_ACP, 0, &str[0], (int)str.size(), NULL, 0);

	std::wstring wstrTo(sizeRequired, 0);

	MultiByteToWideChar(CP_ACP, 0, &str[0], (int)str.size(), &wstrTo[0], sizeRequired);

	return wstrTo;
}

std::wstring pseudoCzEncode(std::wstring str)
{
	static const wchar_t pseudoCzSymbols[] = {L'ë', L'ę', L'ŕ', L'â', L'ă', L'Ë', L'Ę', L'Ŕ', L'Â', L'Ă'};
	static const wchar_t normalCzSymbols[] = {L'ď', L'ě', L'ň', L'ř', L'ť', L'Ď', L'Ě', L'Ň', L'Ř', L'Ť'};
	static const size_t tableSize = std::extent<decltype(pseudoCzSymbols)>::value;

	for (size_t i = 0; i < tableSize; i++)
	{
		std::replace(str.begin(), str.end(), pseudoCzSymbols[i], normalCzSymbols[i]);
	}

	return str;
}

std::map<std::string, std::string> getCommandLineArgs()
{
	std::map<std::string, std::string> arguments;

	int argsCount;
	LPWSTR *argsList = CommandLineToArgvW(GetCommandLineW(), &argsCount);

	if (argsList != NULL)
	{
		for (int i = 1; i < argsCount; i++)
		{
			std::string arg = utf8Encode(argsList[i]);

			arg = arg.substr(arg.find("-") + 1);

			if (arg.find(":") != std::string::npos)
			{
				std::string value = arg.substr(arg.find(":") + 1);
				arg = arg.substr(0, arg.find_last_of(":"));

				arguments.insert(std::pair<std::string, std::string>(arg, value));
			}
			else
			{
				arguments.insert(std::pair<std::string, std::string>(arg, ""));
			}
		}
	}

	return arguments;
}

std::string getModTitle(std::string modIniPath)
{
	char modTitle[MAX_PATH];
	GetPrivateProfileString("INFO", "Title", "", modTitle, MAX_PATH, modIniPath.c_str());

	return modTitle;
}

std::string getExeDirectory()
{
	char buffer[MAX_PATH];
	GetModuleFileName(NULL, buffer, MAX_PATH);

	std::string exePath(buffer);

	return exePath.substr(0, exePath.find_last_of("\\"));
}

std::string getModText()
{
	std::map<std::string, std::string> args = getCommandLineArgs();

	if (args.empty() == true)
	{
		return std::string();
	}

	std::string modIni = args["game"];

	if (modIni != "" && toUpperCase(modIni) != "GOTHICGAME.INI")
	{
		std::string gothicExeDirectory = getExeDirectory();

		std::string modIniPath = gothicExeDirectory;
		modIniPath.append("\\");
		modIniPath.append(modIni);

		std::string modTitle = getModTitle(modIniPath);

		if (modTitle != "")
		{
			modName = modTitle;
			// return std::string("Mod: ") + std::string(modTitle);
			return modPrefix + std::string(modTitle);
		}
		else
		{
			return std::string();
		}
	}
	else
	{
		return std::string();
	}
}
