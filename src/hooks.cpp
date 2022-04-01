#include <windows.h>

#include "../include/hooks.h"

#include "../include/api.h"
#include "../include/config.h"
#include "../include/rpc.h"
#include "../include/sharedvars.h"
#include "../include/utils.h"

// function / hook address number
#define ADDR_FUNC_TOCHAR				0
#define ADDR_FUNC_LOADWORLDSTARTUP		1
#define ADDR_FUNC_LOADWORLDDYN			2
#define ADDR_FUNC_LOADSOUNDFXSCRIPT		3
#define ADDR_HOOK_LOADWORLDSTARTUP		4
#define ADDR_HOOK_LOADWORLDDYN			5
#define ADDR_HOOK_LOADSOUNDFXSCRIPT		6
// insert new function / hook address labels here
// and update ADDRS_TOTAL accordingly

#define ADDRS_TOTAL						7

#define GET_ADDR(addrName)				fhAddrs[(addrName)][EXE_CURRENT]

const int fhAddrs[ADDRS_TOTAL][EXES_TOTAL] = {

	// public: char * __thiscall zSTRING::ToChar(void)const
	//	G1:			PK 1.08k:	GSeq:		G2:			RV 1.30:	G2A:		RV 2.60:
	{	0x464770,	0x45E2E0,	0x465C00,	0x463230,	0x4631C0,	0x4639D0,	0x4639D0	},

	// private: virtual void __thiscall oCGame::LoadWorldStartup(class zSTRING const &)
	//	G1:			PK 1.08k:	GSeq:		G2:			RV 1.30:	G2A:		RV 2.60:
	{	0x6560A0,	0x63F190,	0x666080,	0x66CFD0,	0x66CE90,	0x6C9C30,	0x6C9C10	},

	// private: virtual void __thiscall oCGame::LoadWorldDyn(zSTRING const &)
	//	G1:			PK 1.08k:	GSeq:		G2:			RV 1.30:	G2A:		RV 2.60:
	{	0x6567B0,	0x63F800,	0x666790,	0x66D640,	0x66D500,	0x6CA2A0,	0x6CA280	},

	// public: virtual class zCSoundFX * __thiscall zCSndSys_MSS::LoadSoundFXScript(class zSTRING const &)
	//	G1:			PK 1.08k:	GSeq:		G2:			RV 1.30:	G2A:		RV 2.60:
	{	0x4EBEB0,	0x4E0B50,	0x4F2510,	0x4EB5B0,	0x4EB4A0,	0x4EE140,	0x4EE120	},

	// addresses of .rdata pointers to hooked functions
	//	G1:			PK 1.08k:	GSeq:		G2:			RV 1.30:	G2A:		RV 2.60:
	{	0x801BC8,	0x7DCC98,	0x81FBC4,	0x82E258,	0x82D258,	0x83C338,	0x83C338	},		// oCGame::LoadWorldStartup
	{	0x801BD0,	0x7DCCA0,	0x81FBCC,	0x82E260,	0x82D260,	0x83C340,	0x83C340	},		// oCGame::LoadWorldDyn
	{	0x7F8028,	0x7D3074,	0x816030,	0x8241DC,	0x8231DC,	0x831214,	0x831214	}		// zCSndSys_MSS::LoadSoundFXScript

};

bool inputOverrideApi = false;

template <class T>
void hook(ULONG_PTR address, T value)
{
	DWORD oldProtect = 0;
	VirtualProtect(LPVOID(address), sizeof(T), PAGE_EXECUTE_READWRITE, &oldProtect);

	*(T *)address = value;
	VirtualProtect(LPVOID(address), sizeof(T), oldProtect, NULL);
}

namespace zString
{
	char *(__thiscall *ToChar)(void *) = reinterpret_cast<__thiscall char *(*)(void *)>(GET_ADDR(ADDR_FUNC_TOCHAR));
}

namespace oCGame
{

	void(__thiscall *LoadWorldStartup)(void *, void *) = reinterpret_cast<__thiscall void (*)(void *, void *)>(GET_ADDR(ADDR_FUNC_LOADWORLDSTARTUP));

	void __thiscall LoadWorldStartup_Hook(void *self, void *zen)
	{

		lastKnownWorld = getFileName(zString::ToChar(zen));

		if (inputOverrideApi == false)
		{
			preparePresence(APIDN_STATE, locationPrefix + WORLDNAME_SWITCH(lastKnownWorld));
			updatePresence();
		}

		LoadWorldStartup(self, zen);
	}

	void(__thiscall *LoadWorldDyn)(void *, void *) = reinterpret_cast<__thiscall void (*)(void *, void *)>(GET_ADDR(ADDR_FUNC_LOADWORLDDYN));

	void __thiscall LoadWorldDyn_Hook(void *self, void *zen)
	{

		lastKnownWorld = getFileName(zString::ToChar(zen));

		if (inputOverrideApi == false)
		{
			preparePresence(APIDN_STATE, locationPrefix + WORLDNAME_SWITCH(lastKnownWorld));
			updatePresence();
		}

		LoadWorldDyn(self, zen);
	}

}

namespace zCSndSys_MSS
{

	void *(__thiscall *LoadSoundFXScript)(void *, void *) = reinterpret_cast<__thiscall void *(*)(void *, void *)>(GET_ADDR(ADDR_FUNC_LOADSOUNDFXSCRIPT));

	void *__thiscall LoadSoundFXScript_Hook(void *self, void *name)
	{

		if (processApiString(zString::ToChar(name)) == true)
		{
			inputOverrideApi = true;
		}

		return LoadSoundFXScript(self, name);
	}
}

void createHooks()
{
	hook(GET_ADDR(ADDR_HOOK_LOADWORLDSTARTUP), oCGame::LoadWorldStartup_Hook);
	hook(GET_ADDR(ADDR_HOOK_LOADWORLDDYN), oCGame::LoadWorldDyn_Hook);
	hook(GET_ADDR(ADDR_HOOK_LOADSOUNDFXSCRIPT), zCSndSys_MSS::LoadSoundFXScript_Hook);
}
