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
 * Initialization function called by Ninja after "Init_Global" (G2) / "Init_<Levelname>" (G1)
 */
func void Ninja_GDRPCext_Init()
{
	// GDRPC Output Extender versions:
	//   0 - no auto update
	//   1 - FrameFunctions auto update (recommended)
	//   2 - HookDaedalus auto update (better compatibility w/ AST)
	const int gdrpc_ext_version = 1;

	// Exporting basic functions as callable console commands: on/off
	const int lego_cc = true;

	var int lego_flags;
	
	if (lego_cc == true)
	{
		lego_flags = (lego_flags | LeGo_ConsoleCommands);
	};

	if (gdrpc_ext_version == 1)
	{
		lego_flags = (lego_flags | LeGo_FrameFunctions);
	};

	// Wrapper for "LeGo_Init" to ensure correct LeGo initialization without breaking the mod
	LeGo_MergeFlags(lego_flags);

	// Set correct locale and translate strings
	Ninja_GDRPCext_SetLang();
	Ninja_GDRPCext_LocalizeTexts();

	// Update default world info once to apply localization
	Snd_Play3D(self, "GDRPC:&!STA!&@LKW@");

	if (lego_cc == true)
	{
		// ConsoleCommands
		CC_Register(Ninja_GDRPCext_CCSetState, "CC_SetState_GDRPC", "Sets internal GDRPC variable State to given string (uppercase).");
		CC_Register(Ninja_GDRPCext_CCSetDetails, "CC_SetDetails_GDRPC", "Sets internal GDRPC variable Details to given string (uppercase).");
		CC_Register(Ninja_GDRPCext_CCSetLgkey, "CC_SetLgkey_GDRPC", "Sets internal GDRPC variable Lgkey to given string (uppercase).");
		CC_Register(Ninja_GDRPCext_CCSetLgtext, "CC_SetLgtext_GDRPC", "Sets internal GDRPC variable Lgtext to given string (uppercase).");
		CC_Register(Ninja_GDRPCext_CCSetSmkey, "CC_SetSmkey_GDRPC", "Sets internal GDRPC variable Smkey to given string (uppercase).");
		CC_Register(Ninja_GDRPCext_CCSetSmtext, "CC_SetSmtext_GDRPC", "Sets internal GDRPC variable Smtext to given string (uppercase).");
		CC_Register(Ninja_GDRPCext_CCUpdate, "CC_Update_GDRPC", "Sends current contents of all internal variables to GDRPC through an API call.");
	};

	if (gdrpc_ext_version == 0)
	{
		// (no auto update)
	}
	else if (gdrpc_ext_version == 1)
	{
		// FrameFunctions
		FF_ApplyOnceExtGT(Ninja_GDRPCext_FFUpdate, 1000, -1);
	}
	else if (gdrpc_ext_version == 2)
	{
		// HookDaedalus
		HookDaedalusFuncS("B_GiveXP", "Ninja_GDRPCext_HookUpdate");			// G1 default
		HookDaedalusFuncS("B_GivePlayerXP", "Ninja_GDRPCext_HookUpdate");	// G2 default
	};
};
