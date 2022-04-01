#include <windows.h>

#include "../include/discord.h"
#include "../include/hooks.h"
#include "../include/utils.h"

DWORD discordThreadID;

DWORD WINAPI discordThread(LPVOID lpParameter)
{
	discordInit();

	while (true)
	{
		Discord_RunCallbacks();
	};
}

extern "C" BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{

	if (
		(toUpperCase(getModuleFileName()) != "GOTHIC.EXE")
		&& (toUpperCase(getModuleFileName()) != "GOTHICMOD.EXE")
		&& (toUpperCase(getModuleFileName()) != "GOTHIC2.EXE")
		)
	{
		return true;
	}

	if (fdwReason == DLL_PROCESS_ATTACH)
	{
		createHooks();

		CreateThread(NULL, 0, discordThread, NULL, 0, &discordThreadID);
	}
	else if (fdwReason == DLL_PROCESS_DETACH)
	{
		ExitThread(discordThreadID);
		Discord_Shutdown();
	}

	return true;
}
