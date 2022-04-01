# Gothic Discord Rich Presence

C++ plugin to automatically broadcast game-related information through your Discord desktop client when playing any of the earlier Gothic titles (from G1 to G2A).

## Table of contents


1. **GDRPC**
   1. [Players](#players)
      1. [Installer (recommended)](#installer-recommended)
      2. [Manual installation](#manual-installation)
         1. [Download](#download)
         2. [Installation](#installation)
   2. [Modders (Daedalus)](#modders-daedalus)
	  1. [API](#api)
	  2. [Using custom apps](#using-custom-apps)
   3. [Builders (C++)](#builders-c)
      1. [Cloning](#cloning)
      2. [Tools and utilities](#tools-and-utilities)
         1. [Required](#required)
         2. [Recommended](#recommended)
         3. [Troubleshooting](#troubleshooting)
      3. [Building](#building)
         1. [Using build tasks](#using-build-tasks)
         2. [Directly](#directly)
      4. [Output](#output)
         1. [NSIS Installer](#nsis-installer)
   4. [Changelog](#changelog)

2. [Credits & Acknowledgments](#credits--acknowledgments)

---

## Players

### Installer **(recommended)**

You can use a provided NSIS installer, which will automatically determine game version and compatibility and set up GDRPC using a simple GUI. It also allows for easy uninstallation, if necessary.

1. [Download](https://github.com/helpo1/GDRPC/releases/latest) and run `GDRPC-[version]_Setup.exe`.
2. (uninstallation) Run `GDRPC-uninst.exe` located in your `[game]` directory.
   - It is unfortunately currently also necessary to uninstall existing version of GDRPC when updating to a newer version; the installer will notify you about this if you attempt to update GDRPC by installing another version over the existing one.

### Manual installation

Separate assets for manual installation for any game version are also provided in [releases](https://github.com/helpo1/GDRPC/releases).

#### Download

1. Check whether the `vdfs32g.dll` file in your `[game]\System` is equivalent to one of the [provided builds](docs/vdfs_hashes.md) and/or backup it.
2. Download assets for your version of the game in [releases](https://github.com/helpo1/GDRPC/releases).
3. *(optional)* Download "GDRPC Output Extender" (Ninja patch / ~~Union plugin~~).
   - Allows showing more detailed information even from vanilla versions of G1/G2A or mods without explicit GDRPC support.
   - Requires [Ninja](https://github.com/szapp/Ninja) v2.6.10+ ~~or [Union](https://worldofplayers.ru/threads/40376/) 1.0k+, depending on the version chosen~~.
   - May not work properly with mods incompatible with [LeGo](https://github.com/Lehona/LeGo)/[Ikarus](https://github.com/Lehona/Ikarus) (Ninja version) or altering core game variables.
   - ***note: Union plugin version not yet available as of 2022-04-01***

#### Installation

1. Extract and copy downloaded assets (`libdiscord-rpc.dll`, `orgVdfs32g.dll` and `vdfs32g.dll`) into the `[game]\System` directory.
2. (optional) Extract and copy "GDRPC Output Extender" (`GDRPCext.vdf`) into the `[game]\Data` directory.
3. Run the Discord app.
   - [Desktop client](https://discord.com/download) is required. PTB/Canary builds may or may not work.
   - Make sure you do not have multiple instances of Discord running concurrently.
   - Make sure your status is not set to "Invisible".
   - Make sure `Display current activity as a status message` is turned on in `User Settings -> Activity Status`.
   - Make sure game's sound systems are not turned off, e. g. in `GothicStarter_mod.exe` (necessary for handling API calls to GDRPC).
4. Run the game.
   - *Disclaimer: Playing unpatched versions (i. e. without SP 1.8+ / Union 1.0+) of any of these titles on modern hardware / operating system is **strongly discouraged**, even though appropriate builds of GDRPC *are* available (may require renaming the DLL files).*

---

## Modders (Daedalus)

### API

Rich Presence updates basic game information automatically on world (ZEN) change, but custom info may also be propagated by sending valid API strings through the hooked engine function `zCSndSys_MSS::LoadSoundFXScript`, corresponding to e. g. Daedalus's `Snd_Play3D()`. Once a valid API string is parsed, automatic updates cease and RPC information is fully in the modder's control from that point onwards.

API strings must start with the API prefix and adhere to the following format: `[APIprefix][Delim1][Text1][Delim2][Text2]...` (without brackets). Payload items are separated by delimiter prefixes; item data always range from the end of their respective prefix to the beginning of the following prefix (or end of string).

No payload item is mandatory and their order is irrelevant (except for the API prefix). Including a delimiter multiple times in one API string causes undefined behavior. Any payload item remains unchanged until manually updated (or reset).

Default delimiter prefixes:

```cpp
	"GDRPC:"		// API prefix			(no data)
	"&!STA!&"		// State				(max data: 127 bytes)
	"&!DET!&"		// Details				(max data: 127 bytes)
	"&!LGK!&"		// Large Image Key		(max data:  31 bytes)
	"&!LGT!&"		// Large Image Text		(max data: 127 bytes)
	"&!SMK!&"		// Small Image Key		(max data:  31 bytes)
	"&!SMT!&"		// Small Image Text		(max data: 127 bytes)
```

Valid API string example:

```cpp
	"GDRPC:&!STA!&World: Jharkendar&!SMK!&lvl_21&!SMT!&Level 21&!DET!&[Ch. 2] Militia"
```

Update function example (`GDRPC_getWorldName()` and `GDRPC_getGuildName()` being custom Daedalus functions):

```cpp
func void GDRPC_update()
{

	var string gdrpc_text;

	gdrpc_text = ConcatStrings("GDRPC:", "");

	// State
	gdrpc_text = ConcatStrings(gdrpc_text, "&!STA!&");
	gdrpc_text = ConcatStrings(gdrpc_text, "World: ");
	gdrpc_text = ConcatStrings(gdrpc_text, GDRPC_getWorldName());

	// Details
	gdrpc_text = ConcatStrings(gdrpc_text, "&!DET!&");
	gdrpc_text = ConcatStrings(gdrpc_text, "[Ch. ");
	gdrpc_text = ConcatStrings(gdrpc_text, IntToString(Kapitel));
	gdrpc_text = ConcatStrings(gdrpc_text, "] ");
	gdrpc_text = ConcatStrings(gdrpc_text, GDRPC_getGuildName());

	// Large Image Key
	gdrpc_text = ConcatStrings(gdrpc_text, "&!LGK!&");
	gdrpc_text = ConcatStrings(gdrpc_text, "gil_");
	gdrpc_text = ConcatStrings(gdrpc_text, IntToString(hero.guild));

	// Small Image Key
	gdrpc_text = ConcatStrings(gdrpc_text, "&!SMK!&");
	gdrpc_text = ConcatStrings(gdrpc_text, "lvl_");
	gdrpc_text = ConcatStrings(gdrpc_text, IntToString(hero.level));

	// Small Image Text
	gdrpc_text = ConcatStrings(gdrpc_text, "&!SMT!&");
	gdrpc_text = ConcatStrings(gdrpc_text, "Level ");
	gdrpc_text = ConcatStrings(gdrpc_text, IntToString(hero.level));

	if (Hlp_IsValidNpc(hero))
	{
		Snd_Play3D(hero,gdrpc_text);
	};

};
```

### Using custom apps

It is also possible to create your own [Discord Rich Presence application](https://discord.com/developers/applications) (useful for e. g. uploading and settings your own art assets). To use these with GDRPC, **do not** overwrite the `custom_app_id` setting in players' `GDRPC.ini` files. Instead, include a `[GDRPC]` section containing a field `custom_app_ID={your app ID here}` in your `{ModName}.ini`. Unless players specifically choose to override this value, your app's ID will take precedence over other provided app IDs and fallback options.

---

## Builders (C++)

Tested on Windows 8.1 Pro 64-bit and Windows 10 Home & Pro 64-bit (build 19042 / 20H2). Information below applies primarily to building on MS Windows.

### Cloning

Make sure to clone this repository with the `--recursive` flag:
* `git clone --recursive https://github.com/helpo1/GDRPC.git`

### Tools and utilities

Versions specified are the ones used for testing. Different versions or alternatives of said utilities may (or may not) work.

#### Required

* [CMake](https://cmake.org/) - 3.20.5
* [MinGW](http://mingw-w64.org) - i686-8.1.0-release-posix-dwarf-rt_v6-rev0
  * make - MinGW contains GNU Make 4.2.1 as `mingw32-make`, or you can get older versions separately, e. g. [make 3.81](http://gnuwin32.sourceforge.net/packages/make.htm)
* DLL function exports generator *(update `DLL_EXPORTER` accordingly if changed)*:
  * (default) [pexports](https://sourceforge.net/projects/mingw/files/MinGW/Extension/pexports/) - 0.47
  * (original) [expdef](https://web.archive.org/http://purefractalsolutions.com/show.php?a=utils/expdef) - no longer publicly available ([source code](https://web.archive.org/http://purefractalsolutions.com/show.php?a=src/expdefsrc)); cannot process some DLLs (esp. Union versions of `vdfs32g.dll`)
  * gendef - part of MinGW tools above (May 12 2018 build); cannot export both function names and ordinals (necessary to identify them, e. g. through [Dependency Walker](http://www.dependencywalker.com/), and add them to the `.def` file manually)
* [Golang](https://golang.org/) - go1.16.5 windows/amd64

#### Recommended

* [Visual Studio Code](https://code.visualstudio.com/) / [VSCodium](https://vscodium.com/)
* [Nullsoft Scriptable Install System (NSIS)](https://nsis.sourceforge.io) - 3.07
  * [MD5 plugin for NSIS](https://nsis.sourceforge.io/MD5_plugin) - 0.5

#### Troubleshooting
* Do not forget to **check** with [`which`/`where`](https://en.wikipedia.org/wiki/Which_(command)) (e. g. `where g++`), and, if necessary, **add the required utilities to the `PATH` system variable**. Make sure there are no older versions of said utilities present in `PATH`, especially before the newer ones.
* Keep paths to utilities short (e. g. `C:\MinGW\mingw32\bin` instead of `C:\Program Files (x86)\mingw-w64\i686-8.1.0-release-posix-dwarf-rt_v6-rev0\mingw32\bin`).

### Building

#### Using build tasks

Use provided example DLLs (in `\input`) and preconfigured build tasks (see [table](/.vscode/build-tasks.md)) for Visual Studio Code.

#### Directly

Use `make` command with following arguments:
* [req.] `ORIGINAL_VDFS_LIB_PATH` - location of `vdfs32g.dll` taken from your `[game]\System` folder (recommended to copy it to `\input`)
* [req.] `DLL_EXPORTER` - DLL function exports generator to be used (e. g. `pexports`)
* [rec.] `TARGET_VERSION` - label of target you are building for (e. g. `G2A_RV`)
* [opt.] `EXE_CURRENT` - address set (EXE version) you are building for (e. g. `EXE_RV_260`); [falls back](/include/config.h#L21-L25) if not provided
* [opt.] `APP_ID` - Discord RPC app to be linked (e. g. `870027346349002793`); [falls back](/include/config.h#L27-L40) if not provided

Example commands:

* `make ORIGINAL_VDFS_LIB_PATH=C:\Games\Gothic 2 Gold\System\vdfs32g.dll DLL_EXPORTER=expdef`
* `make ORIGINAL_VDFS_LIB_PATH=input\vdfs32g_G2G.dll TARGET_VERSION=G2A_SP DLL_EXPORTER=pexports EXE_CURRENT=EXE_RV_260 APP_ID=870027346349002793`

### Output

Files to be placed in the `[game]\System` directory will be in `\output\bin` directory (in `\TARGET_VERSION` subdirectory, if specified at build time).
Builds for vanilla G2/G2A (without any patches) may require renaming inputs and outputs between `vdfs32e.dll` and `vdfs32g.dll` to work properly depending on your version of the game (2.6 DE / 2.7 EN).

#### NSIS Installer

[NSI file](/setup/GDRPC.nsi) used to generate an NSIS installer for GDRPC is also provided. Requires all possible game platform builds to be present in `/output/bin/...` at installer compile time. Two Visual Studio Code build tasks are prepared, one including rebuilding all platforms first and one only recompiling the installer itself.

---

## Changelog

Full changelog for versions of GDRPC above v1.00 is available [here](CHANGELOG.md). Older (Szmyk's) changelog is available in the [respective repository](https://github.com/Szmyk/gothic2-discord-rpc/blob/master/CHANGELOG.md).

---

## Credits & Acknowledgments

Thanks to:
- [@Szmyk](https://github.com/Szmyk) for the original [Discord Rich Presence for Gothic 2 Night of the Raven](https://github.com/Szmyk/gothic2-discord-rpc) that this project was originally forked from.
- [@Auronen](https://github.com/auronen) and [@Fawkes](https://github.com/Fawkes-dev) for all the tips and how-tos related to Gothic modding and its capabilities.
- [@benhoyt](https://github.com/benhoyt) and all contributors for the [inih](https://github.com/benhoyt/inih) `.INI` file parser.

It has been brought to my attention (while putting the finishing touches on v1.00) that a similarly named and focused project - [GothicRichPresence](https://github.com/Lavalierre/GothicRichPresence) by [@Lavalierre](https://github.com/Lavalierre) - was released earlier in 2021. These works are in no way affiliated, have different requirements and offer different features. No source code and/or ideas were knowingly reused. The majority of work on this project was done in March 2019 as a companion project to my [main one at the time](https://github.com/helpo1/Navraty-CZ), but had never been published (outside of a small group of modders and testers). I do absolutely recommend checking out GRP to find out which version suits your needs better - for example, GRP is a bit easier to set up as a player if you already use G1/G2A with Union; GDRPC offers significantly wider platform/language support and finer customization, especially for mods with explicit GDRPC API calls.

[@Szmyk](https://github.com/Szmyk):
> "Huge thanks to Gynvael Coldwind for articles about DLL spoofing and other Windows related articles."
