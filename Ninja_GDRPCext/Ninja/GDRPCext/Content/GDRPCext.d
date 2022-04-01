/*
 *                                              
 *   Output Extender for                     
 *                                              
 *     _____  _____   _____   _____    _____    
 *    / ____||  __ \ |  __ \ |  __ \  / ____|   
 *   | |  __ | |  | || |__) || |__) || |        
 *   | | |_ || |  | ||  _  / |  ___/ | |        
 *   | |__| || |__| || | \ \ | |     | |____    
 *    \_____||_____/ |_|  \_\|_|      \_____|   
 *                                              
 *                                  by helpo1   
 *                                              
 *            https://github.com/helpo1/GDRPC   
 *                                              
 */

/*
 * Guess localization (0 = EN, 1 = DE, 2 = PL, 3 = RU, 4 = CZ)
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes#localization
 */
func int Ninja_GDRPCext_GuessLocalization()
{
	var int chest; chest = MEM_GetSymbol("MOBNAME_CHEST");

	if (chest)
	{
		var zCPar_Symbol chestSymb; chestSymb = _^(chest);
		var string chestName; chestName = MEM_ReadString(chestSymb.content);
		
		if (Hlp_StrCmp(chestName, "Truhe")) { // DE (Windows 1252)
			return 1;
		} else if (Hlp_StrCmp(chestName, "Kufer") || Hlp_StrCmp(chestName, "Skrzynia")) { // PL (Windows 1250)
			return 2;
		} else if (Hlp_StrCmp(chestName, "Сундук") || Hlp_StrCmp(chestName, "Ларь")) { // RU (Windows 1251)
			return 3;
		} else if (Hlp_StrCmp(chestName, "Truhla") || Hlp_StrCmp(chestName, "Truhlice")) { // CZ (Windows 1250)
			return 4;
		};
	};

	return 0; // Otherwise EN
};

func void Ninja_GDRPCext_SetANSI()
{
	Snd_Play3D(self, "GDRPC:@ANSI@");
};

func void Ninja_GDRPCext_SetUTF8()
{
	Snd_Play3D(self, "GDRPC:@UTF8@");
};

func void Ninja_GDRPCext_SetLang()
{
	var int lang; lang = Ninja_GDRPCext_GuessLocalization();

		if (lang == 0)	{ Snd_Play3D(self, "GDRPC:@LANG_EN@"); }
	else if (lang == 1)	{ Snd_Play3D(self, "GDRPC:@LANG_DE@"); }
	else if (lang == 2)	{ Snd_Play3D(self, "GDRPC:@LANG_PL@"); }
	else if (lang == 3)	{ Snd_Play3D(self, "GDRPC:@LANG_RU@"); }
	else if (lang == 4)	{ Snd_Play3D(self, "GDRPC:@LANG_CZ@"); };
};

const string Ninja_GDRPCext_Loc_Chapter = "[Ch. ";

/*
 * Function called from content or menu initialization function
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes#localization
 */
func void Ninja_GDRPCext_LocalizeTexts()
{
	var int lang;
	lang = Ninja_GDRPCext_GuessLocalization();
	if (lang == 1) // DE (Windows 1252)
	{
		Ninja_GDRPCext_Loc_Chapter = "[Kap. ";		// Kapitel
	}
	else if (lang == 2) // PL (Windows 1250)
	{
		Ninja_GDRPCext_Loc_Chapter = "[Roz. ";		// Rozdział
	}
	else if (lang == 3) // RU (Windows 1251)
	{
		Ninja_GDRPCext_Loc_Chapter = "[Раз. ";		// Раздел
	}
	else if (lang == 4) // CZ (Windows 1250)
	{
		Ninja_GDRPCext_Loc_Chapter = "[Kap. ";		// Kapitola
	};
	// Else: Keep default -> English
};

/*
 * API update function for FrameFunctions auto updates
 */
func void Ninja_GDRPCext_FFUpdate()
{
	var string gdrpc_text;
	gdrpc_text = ConcatStrings("GDRPC:", "");

	// State
	gdrpc_text = ConcatStrings(gdrpc_text, "&!STA!&");
	gdrpc_text = ConcatStrings(gdrpc_text, MEM_ReadStringArray(_@s(TXT_GUILDS), hero.guild));
	gdrpc_text = ConcatStrings(gdrpc_text, " (lvl ");
	gdrpc_text = ConcatStrings(gdrpc_text, IntToString(hero.level));
	gdrpc_text = ConcatStrings(gdrpc_text, ") [HP: ");
	gdrpc_text = ConcatStrings(gdrpc_text, IntToString(hero.attribute[ATR_HITPOINTS]));
	gdrpc_text = ConcatStrings(gdrpc_text, "/");
	gdrpc_text = ConcatStrings(gdrpc_text, IntToString(hero.attribute[ATR_HITPOINTS_MAX]));
	gdrpc_text = ConcatStrings(gdrpc_text, "]");

	// Details
	gdrpc_text = ConcatStrings(gdrpc_text, "&!DET!&");
	gdrpc_text = ConcatStrings(gdrpc_text, Ninja_GDRPCext_Loc_Chapter);
	gdrpc_text = ConcatStrings(gdrpc_text, IntToString(Kapitel));
	gdrpc_text = ConcatStrings(gdrpc_text, "] @LKW@");

	Snd_Play3D(self, gdrpc_text);
};

/*
 * API update function for HookDaedalus auto updates
 */
func void Ninja_GDRPCext_HookUpdate(var int origParam)
{
	PassArgumentI(origParam);
	ContinueCall();

	var string gdrpc_text;
	gdrpc_text = ConcatStrings("GDRPC:", "");

	// State
	gdrpc_text = ConcatStrings(gdrpc_text, "&!STA!&");
	gdrpc_text = ConcatStrings(gdrpc_text, MEM_ReadStringArray(_@s(TXT_GUILDS), hero.guild));
	gdrpc_text = ConcatStrings(gdrpc_text, " (lvl ");
	gdrpc_text = ConcatStrings(gdrpc_text, IntToString(hero.level));
	gdrpc_text = ConcatStrings(gdrpc_text, ")");

	// Details
	gdrpc_text = ConcatStrings(gdrpc_text, "&!DET!&");
	gdrpc_text = ConcatStrings(gdrpc_text, Ninja_GDRPCext_Loc_Chapter);
	gdrpc_text = ConcatStrings(gdrpc_text, IntToString(Kapitel));
	gdrpc_text = ConcatStrings(gdrpc_text, "] @LKW@");

	Snd_Play3D(self, gdrpc_text);
};



/*
 * Set of variables and functions for updating GDRPC manually via console commands
 * All fields updated this way will be uppercased
 */

var string Ninja_GDRPCext_CC_State;
var string Ninja_GDRPCext_CC_Details;
var string Ninja_GDRPCext_CC_Lgkey;
var string Ninja_GDRPCext_CC_Lgtext;
var string Ninja_GDRPCext_CC_Smkey;
var string Ninja_GDRPCext_CC_Smtext;

func string Ninja_GDRPCext_CCSetState(var string state)
{
	var string msg;

	Ninja_GDRPCext_CC_State = ConcatStrings("&!STA!&", STR_SubStr(state, 1, STR_Len(state) - 1));
	msg = ConcatStrings("State set to '", Ninja_GDRPCext_CC_State);
	msg = ConcatStrings(msg, "'");

	return msg;
};

func string Ninja_GDRPCext_CCSetDetails(var string details)
{
	var string msg;

	Ninja_GDRPCext_CC_Details = ConcatStrings("&!DET!&", STR_SubStr(details, 1, STR_Len(details) - 1));
	msg = ConcatStrings("Details set to '", Ninja_GDRPCext_CC_Details);
	msg = ConcatStrings(msg, "'");

	return msg;
};

func string Ninja_GDRPCext_CCSetLgkey(var string lgkey)
{
	var string msg;

	Ninja_GDRPCext_CC_Lgkey = ConcatStrings("&!LGK!&", STR_SubStr(lgkey, 1, STR_Len(lgkey) - 1));
	msg = ConcatStrings("Lgkey set to '", Ninja_GDRPCext_CC_Lgkey);
	msg = ConcatStrings(msg, "'");

	return msg;
};

func string Ninja_GDRPCext_CCSetLgtext(var string lgtext)
{
	var string msg;

	Ninja_GDRPCext_CC_Lgtext = ConcatStrings("&!LGT!&", STR_SubStr(lgtext, 1, STR_Len(lgtext) - 1));
	msg = ConcatStrings("Lgtext set to '", Ninja_GDRPCext_CC_Lgtext);
	msg = ConcatStrings(msg, "'");

	return msg;
};

func string Ninja_GDRPCext_CCSetSmkey(var string smkey)
{
	var string msg;

	Ninja_GDRPCext_CC_Smkey = ConcatStrings("&!SMK!&", STR_SubStr(smkey, 1, STR_Len(smkey) - 1));
	msg = ConcatStrings("Smkey set to '", Ninja_GDRPCext_CC_Smkey);
	msg = ConcatStrings(msg, "'");

	return msg;
};

func string Ninja_GDRPCext_CCSetSmtext(var string smtext)
{
	var string msg;

	Ninja_GDRPCext_CC_Smtext = ConcatStrings("&!SMT!&", STR_SubStr(smtext, 1, STR_Len(smtext) - 1));
	msg = ConcatStrings("Smtext set to '", Ninja_GDRPCext_CC_Smtext);
	msg = ConcatStrings(msg, "'");

	return msg;
};

func string Ninja_GDRPCext_CCUpdate(var string param)
{
	// ignore "param" - exists purely for Ninja compatibility reasons

	var string msg;
	var string gdrpc_text;

	gdrpc_text = ConcatStrings("GDRPC:", "");
	gdrpc_text = ConcatStrings(gdrpc_text, Ninja_GDRPCext_CC_State);
	gdrpc_text = ConcatStrings(gdrpc_text, Ninja_GDRPCext_CC_Details);
	gdrpc_text = ConcatStrings(gdrpc_text, Ninja_GDRPCext_CC_Lgkey);
	gdrpc_text = ConcatStrings(gdrpc_text, Ninja_GDRPCext_CC_Lgtext);
	gdrpc_text = ConcatStrings(gdrpc_text, Ninja_GDRPCext_CC_Smkey);
	gdrpc_text = ConcatStrings(gdrpc_text, Ninja_GDRPCext_CC_Smtext);

	Snd_Play3D(self, gdrpc_text);

	msg = ConcatStrings("Updated GDRPC with API string '", gdrpc_text);
	msg = ConcatStrings(msg, "'");

	return msg;
};
