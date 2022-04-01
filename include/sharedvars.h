#pragma once

#include <string>

// GDRPC.ini settings

// [GENERAL]
extern bool showTimeElapsed;

// [PRESENCE DEFAULTS]
extern std::string discordPresenceStateDef;
extern std::string discordPresenceDetailsDef;
extern std::string discordPresenceLgkeyDef;
extern std::string discordPresenceLgtextDef;
extern std::string discordPresenceSmkeyDef;
extern std::string discordPresenceSmtextDef;

// [LANGUAGE]
extern bool ansiEncoding;
extern size_t languageID;
extern std::string locationPrefix;
extern std::string modPrefix;

// other shared variables
extern std::string lastKnownWorld;
extern std::string modName;
