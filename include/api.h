#pragma once

#include <string>

// API delimiter type number
#define APIDN_PREFIX 0
#define APIDN_STATE 1
#define APIDN_DETAILS 2
#define APIDN_LGKEY 3
#define APIDN_LGTEXT 4
#define APIDN_SMKEY 5
#define APIDN_SMTEXT 6
// insert new delimiter types here
// and update APIDN_TOTAL accordingly
#define APIDN_TOTAL 7

// API control string number
#define APICN_LKWORLD 0
#define APICN_MODNAME 1
#define APICN_ANSI 2
#define APICN_UTF8 3
// insert new control strings here
// and update APICN_TOTAL accordingly
#define APICN_TOTAL 4

// API language string number
#define APILN_LANG_EN 0
#define APILN_LANG_DE 1
#define APILN_LANG_PL 2
#define APILN_LANG_RU 3
#define APILN_LANG_CZ 4
// insert new language strings here
// and update APILN_TOTAL accordingly
#define APILN_TOTAL 5

// API DRAFT FOR ANIMATED IMAGES (NOT IMPLEMENTED)
// if image is animated, e. g. Discord RPC for app contains assets "hero_main_001" to "hero_main_072"
/*
	#define API_FRAMECOUNT_POSTFIX "_ANIMFC_"		// correct API image key format: "hero_main_ANIMFC_072_ANIMFS_024"
	#define API_FRAMESPEED_POSTFIX "_ANIMFS_"		// 072 = total number of animation frames, 024 = number of frames per second
*/

bool processApiString(std::string data);
