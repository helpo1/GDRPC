#pragma once

#include <string>

#define NO_INI_INPUT	"NULL"

#define WORLDNAME_SWITCH(zenFile)		(((EXE_CURRENT) <= 2) ? getWorldNameG1(zenFile) : getWorldNameG2(zenFile))

// executable type number
#define EXE_G1			0
#define EXE_PK_108K		1
#define EXE_GS			2
#define EXE_G2			3
#define EXE_RV_130		4
#define EXE_G2A			5
#define EXE_RV_260		6
// insert new entries for executables with different addresses of hooked functions here
// and update EXES_TOTAL + contents of address table "fhAddrs[][]" in "../src/hooks.cpp" accordingly
#define EXES_TOTAL		7

// fallback (only invoked if not using compile time defines [g++ ... -D name=definition] through Makefile)
// choose one of aliases above depending on target
#ifndef EXE_CURRENT
	#define EXE_CURRENT		EXE_G1
#endif

// fallback (only invoked if not using mod.ini / GDRPC.ini overrides
// or compile time defines [g++ ... -D name=definition] through Makefile)
// choose one Discord RPC app ID depending on target
// or change to your own - https://discord.com/developers/applications/
#ifndef APP_ID
	const char *const APP_ID = "802668299514413066";			// "Gothic"
	// const char *const APP_ID = "868155280083533874";			// "Gothic Sequel"
	// const char *const APP_ID = "868103949528498206";			// "Gothic 2"
	// const char *const APP_ID = "870027346349002793";			// "Gothic 2: Night of the Raven" (EN)
	// const char *const APP_ID = "802668371388792902";			// "Gothic 2: Noc Havrana" (CZ)
	// const char *const APP_ID = "870027390275948555";			// "Gothic 2: Returning 2.0" (EN)
	// const char *const APP_ID = "801261476614373428";			// "Gothic 2: Návraty 2.0" (CZ)
	// const char *const APP_ID = "868105107726807040";			// "Gothic 2: New Balance"
#endif

std::string gdrpcReadAppID();
void gdrpcReadINI();
