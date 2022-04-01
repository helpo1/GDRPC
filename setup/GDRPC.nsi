#                                              
#   NSIS installer script for                  
#                                              
#     _____  _____   _____   _____    _____    
#    / ____||  __ \ |  __ \ |  __ \  / ____|   
#   | |  __ | |  | || |__) || |__) || |        
#   | | |_ || |  | ||  _  / |  ___/ | |        
#   | |__| || |__| || | \ \ | |     | |____    
#    \_____||_____/ |_|  \_\|_|      \_____|   
#                                              
#                                  by helpo1   
#                                              
#            https://github.com/helpo1/GDRPC   
#                                              

; Script generated by the HM NIS Edit Script Wizard.

!include ".\Sections.nsh"
!define /date cBuildYear %Y

; Version Info
!define VER_MAJOR 1
!define VER_MINOR 00
!define VER_PATCH ""

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "GDRPC"
!define PRODUCT_NAME_FULL "Gothic Discord Rich Presence"
!define PRODUCT_VERSION "v${VER_MAJOR}.${VER_MINOR}${VER_PATCH}"
!define PRODUCT_PUBLISHER "helpo1"
!define PRODUCT_COPYRIGHT "Copyright � ${cBuildYear} helpo1"
!define PRODUCT_WEB_SITE "https://github.com/helpo1/GDRPC/"

; MUI 1.67 compatible ------
;   - updated to MUI2
!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
; !define MUI_UNFINISHPAGE_NOAUTOCLOSE

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH
 
; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

; File Properties Info
VIProductVersion "${VER_MAJOR}.${VER_MINOR}.0.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName"      "${PRODUCT_NAME_FULL} (${PRODUCT_NAME})"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion"   "${VER_MAJOR}.${VER_MINOR}${VER_PATCH}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription"  "${PRODUCT_NAME_FULL} installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion"      "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "OriginalFilename" "${PRODUCT_NAME}-${PRODUCT_VERSION}_Setup.exe"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright"   "${PRODUCT_COPYRIGHT}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments"         "${PRODUCT_WEB_SITE}"

Name "${PRODUCT_NAME_FULL} ${PRODUCT_VERSION}"
OutFile "..\output\bin\${PRODUCT_NAME}-${PRODUCT_VERSION}_Setup.exe"
InstallDir "$EXEDIR\"
ShowInstDetails show
ShowUnInstDetails show

Var MD5vdfs
Var MD5exe
Var Platform

Section "GDRPC (main module)" SEC_MAIN
  SectionIn RO
  SetOutPath "$INSTDIR\System"
  SetOverwrite on
  
  Call CheckMD5vdfs
  Call CheckMD5exe
  Call SetPlatform

  IfFileExists $INSTDIR\System\_backupGDRPC\*.* +2 0
    CreateDirectory $INSTDIR\System\_backupGDRPC

  IfFileExists $INSTDIR\System\vdfs32g.dll 0 +3
    IfFileExists $INSTDIR\System\_backupGDRPC\vdfs32g.dll +2 0
      CopyFiles $INSTDIR\System\vdfs32g.dll $INSTDIR\System\_backupGDRPC\vdfs32g.dll

  IfFileExists $INSTDIR\System\vdfs32e.dll 0 +3
    IfFileExists $INSTDIR\System\_backupGDRPC\vdfs32e.dll +2 0
      CopyFiles $INSTDIR\System\vdfs32e.dll $INSTDIR\System\_backupGDRPC\vdfs32e.dll

  ${Switch} $Platform
    ${Case} "G1"
      File "..\output\bin\G1\vdfs32g.dll"
      File "..\output\bin\G1\orgVdfs32g.dll"
      File "..\output\bin\G1\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G1_PK"
      File "..\output\bin\G1_PK\vdfs32g.dll"
      File "..\output\bin\G1_PK\orgVdfs32g.dll"
      File "..\output\bin\G1_PK\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G1_SP"
      File "..\output\bin\G1_SP\vdfs32g.dll"
      File "..\output\bin\G1_SP\orgVdfs32g.dll"
      File "..\output\bin\G1_SP\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G1_Union_10k"
      File "..\output\bin\G1_Union_10k\vdfs32g.dll"
      File "..\output\bin\G1_Union_10k\orgVdfs32g.dll"
      File "..\output\bin\G1_Union_10k\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G1_Union_10l"
      File "..\output\bin\G1_Union_10l\vdfs32g.dll"
      File "..\output\bin\G1_Union_10l\orgVdfs32g.dll"
      File "..\output\bin\G1_Union_10l\libdiscord-rpc.dll"
      ${Break}
    ${Case} "GS"
      File "..\output\bin\GS\vdfs32g.dll"
      File "..\output\bin\GS\orgVdfs32g.dll"
      File "..\output\bin\GS\libdiscord-rpc.dll"
      ${Break}
    ${Case} "GS_SP"
      File "..\output\bin\GS_SP\vdfs32g.dll"
      File "..\output\bin\GS_SP\orgVdfs32g.dll"
      File "..\output\bin\GS_SP\libdiscord-rpc.dll"
      ${Break}
    ${Case} "GS_Union_10k"
      File "..\output\bin\GS_Union_10k\vdfs32g.dll"
      File "..\output\bin\GS_Union_10k\orgVdfs32g.dll"
      File "..\output\bin\GS_Union_10k\libdiscord-rpc.dll"
      ${Break}
    ${Case} "GS_Union_10l"
      File "..\output\bin\GS_Union_10l\vdfs32g.dll"
      File "..\output\bin\GS_Union_10l\orgVdfs32g.dll"
      File "..\output\bin\GS_Union_10l\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2"
      File "..\output\bin\G2\vdfs32g.dll"
      IfFileExists $INSTDIR\System\vdfs32e.dll 0 +2
        File /oname=vdfs32e.dll "..\output\bin\G2\vdfs32g.dll"
      File "..\output\bin\G2\orgVdfs32g.dll"
      File "..\output\bin\G2\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2_RV"
      File "..\output\bin\G2_RV\vdfs32g.dll"
      File "..\output\bin\G2_RV\orgVdfs32g.dll"
      File "..\output\bin\G2_RV\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2_SP"
      File "..\output\bin\G2_SP\vdfs32g.dll"
      File "..\output\bin\G2_SP\orgVdfs32g.dll"
      File "..\output\bin\G2_SP\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2_Union_10k"
      File "..\output\bin\G2_Union_10k\vdfs32g.dll"
      File "..\output\bin\G2_Union_10k\orgVdfs32g.dll"
      File "..\output\bin\G2_Union_10k\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2_Union_10l"
      File "..\output\bin\G2_Union_10l\vdfs32g.dll"
      File "..\output\bin\G2_Union_10l\orgVdfs32g.dll"
      File "..\output\bin\G2_Union_10l\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2A"
      File "..\output\bin\G2A\vdfs32g.dll"
      IfFileExists $INSTDIR\System\vdfs32e.dll 0 +2
        File /oname=vdfs32e.dll "..\output\bin\G2A\vdfs32g.dll"
      File "..\output\bin\G2A\orgVdfs32g.dll"
      File "..\output\bin\G2A\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2A_RV"
      File "..\output\bin\G2A_RV\vdfs32g.dll"
      File "..\output\bin\G2A_RV\orgVdfs32g.dll"
      File "..\output\bin\G2A_RV\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2A_SP"
      File "..\output\bin\G2A_SP\vdfs32g.dll"
      File "..\output\bin\G2A_SP\orgVdfs32g.dll"
      File "..\output\bin\G2A_SP\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2A_Union_10k"
      File "..\output\bin\G2A_Union_10k\vdfs32g.dll"
      File "..\output\bin\G2A_Union_10k\orgVdfs32g.dll"
      File "..\output\bin\G2A_Union_10k\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2A_Union_10l"
      File "..\output\bin\G2A_Union_10l\vdfs32g.dll"
      File "..\output\bin\G2A_Union_10l\orgVdfs32g.dll"
      File "..\output\bin\G2A_Union_10l\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2A_R2"
      File "..\output\bin\G2A_R2\vdfs32g.dll"
      File "..\output\bin\G2A_R2\orgVdfs32g.dll"
      File "..\output\bin\G2A_R2\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2A_NB_20xx"
      File "..\output\bin\G2A_NB_20xx\vdfs32g.dll"
      File "..\output\bin\G2A_NB_20xx\orgVdfs32g.dll"
      File "..\output\bin\G2A_NB_20xx\libdiscord-rpc.dll"
      ${Break}
    ${Case} "G2A_NB_21xx"
      File "..\output\bin\G2A_NB_21xx\vdfs32g.dll"
      File "..\output\bin\G2A_NB_21xx\orgVdfs32g.dll"
      File "..\output\bin\G2A_NB_21xx\libdiscord-rpc.dll"
      ${Break}
;    ${Case} "G2A_NB_22xx"
;      File "..\output\bin\G2A_NB_22xx\vdfs32g.dll"
;      File "..\output\bin\G2A_NB_22xx\orgVdfs32g.dll"
;      File "..\output\bin\G2A_NB_22xx\libdiscord-rpc.dll"
;      ${Break}
    ${Default}
      Abort "Unrecognized version of the game.$\r$\n$\r$\nAborting installation..."
      ${Break}
  ${EndSwitch}
  
SectionEnd

SectionGroup /e ".INI File" SEC_INI

Section "English .INI" SEC_INI_EN
  Delete $INSTDIR\System\GDRPC.ini
  File /oname=GDRPC.ini "..\input\ini-defaults\GDRPC-EN.ini"
;  Rename $INSTDIR\System\GDRPC-EN.ini $INSTDIR\System\GDRPC.ini
SectionEnd

Section /o "German .INI" SEC_INI_DE
  Delete $INSTDIR\System\GDRPC.ini
  File /oname=GDRPC.ini "..\input\ini-defaults\GDRPC-DE.ini"
;  Rename $INSTDIR\System\GDRPC-DE.ini $INSTDIR\System\GDRPC.ini
SectionEnd

Section /o "Polish .INI" SEC_INI_PL
  Delete $INSTDIR\System\GDRPC.ini
  File /oname=GDRPC.ini "..\input\ini-defaults\GDRPC-PL.ini"
;  Rename $INSTDIR\System\GDRPC-PL.ini $INSTDIR\System\GDRPC.ini
SectionEnd

Section /o "Russian .INI" SEC_INI_RU
  Delete $INSTDIR\System\GDRPC.ini
  File /oname=GDRPC.ini "..\input\ini-defaults\GDRPC-RU.ini"
;  Rename $INSTDIR\System\GDRPC-RU.ini $INSTDIR\System\GDRPC.ini
SectionEnd

Section /o "Czech .INI" SEC_INI_CZ
  Delete $INSTDIR\System\GDRPC.ini
  ${If} $Platform == "G2A_R2"
    File /oname=GDRPC.ini "..\input\ini-defaults\GDRPC-CZ-R2.ini"
  ${ElseIf} $Platform == "G2A"
  ${OrIf} $Platform == "G2A_RV"
  ${OrIf} $Platform == "G2A_SP"
  ${OrIf} $Platform == "G2A_Union_10k"
  ${OrIf} $Platform == "G2A_Union_10l"
    File /oname=GDRPC.ini "..\input\ini-defaults\GDRPC-CZ-G2A.ini"
  ${Else}
    File /oname=GDRPC.ini "..\input\ini-defaults\GDRPC-CZ.ini"
  ${EndIf}
;  Rename $INSTDIR\System\GDRPC-CZ.ini $INSTDIR\System\GDRPC.ini
SectionEnd

SectionGroupEnd

SectionGroup /e "GDRPC Output Extender" SEC_OE

Section "Ninja - FF" SEC_OE_FF
  SetOutPath "$INSTDIR\Data"
  File /oname=GDRPCext.vdf "..\Ninja_GDRPCext\GDRPCext-FF.vdf"
;  Rename $INSTDIR\Data\GDRPCext-FF.vdf $INSTDIR\Data\GDRPCext.vdf
SectionEnd

Section /o "Ninja - HD" SEC_OE_HD
  SetOutPath "$INSTDIR\Data"
  File /oname=GDRPCext.vdf "..\Ninja_GDRPCext\GDRPCext-HD.vdf"
;  Rename $INSTDIR\Data\GDRPCext-HD.vdf $INSTDIR\Data\GDRPCext.vdf
SectionEnd

SectionGroupEnd


Section -Post
  WriteUninstaller "$INSTDIR\GDRPC-uninst.exe"
;  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
;  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
;  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
;  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
;  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_MAIN} "Main GDRPC module."

  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_INI} "Preconfigured versions of GDRPC.ini for different languages.$\r$\n$\r$\nChoose one at most.$\r$\n$\r$\nChoosing none will NOT create default GDRPC.ini at runtime."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_INI_EN} "Preconfigured versions of GDRPC.ini for different languages.$\r$\n$\r$\nChoose one at most.$\r$\n$\r$\nEnglish version."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_INI_DE} "Preconfigured versions of GDRPC.ini for different languages.$\r$\n$\r$\nChoose one at most.$\r$\n$\r$\nGerman version."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_INI_PL} "Preconfigured versions of GDRPC.ini for different languages.$\r$\n$\r$\nChoose one at most.$\r$\n$\r$\nPolish version."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_INI_RU} "Preconfigured versions of GDRPC.ini for different languages.$\r$\n$\r$\nChoose one at most.$\r$\n$\r$\nRussian version."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_INI_CZ} "Preconfigured versions of GDRPC.ini for different languages.$\r$\n$\r$\nChoose one at most.$\r$\n$\r$\nCzech version."

  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_OE} "Extends information output to GDRPC through LeGo GDRPC API using LeGo functions either as a Ninja patch or a Union plugin (Union version not yet available)."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_OE_FF} "Extends information output to GDRPC through LeGo FrameFunctions and GDRPC API.$\r$\n$\r$\nNinja (tiny.cc/GothicNinja) required."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_OE_HD} "Extends information output to GDRPC through LeGo HookDaedalus and GDRPC API.$\r$\n$\r$\nNinja (tiny.cc/GothicNinja) required."
!insertmacro MUI_FUNCTION_DESCRIPTION_END


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\GDRPC-uninst.exe"
  Delete "$INSTDIR\Data\GDRPCext.vdf"
  Delete "$INSTDIR\System\GDRPC.ini"
  Delete "$INSTDIR\System\libdiscord-rpc.dll"
  Delete "$INSTDIR\System\orgVdfs32g.dll"

  Delete "$INSTDIR\System\vdfs32g.dll"
  IfFileExists $INSTDIR\System\_backupGDRPC\vdfs32g.dll 0 +2
    Rename $INSTDIR\System\_backupGDRPC\vdfs32g.dll $INSTDIR\System\vdfs32g.dll

  IfFileExists $INSTDIR\System\_backupGDRPC\vdfs32e.dll 0 +3
    Delete "$INSTDIR\System\vdfs32e.dll"
    Rename $INSTDIR\System\_backupGDRPC\vdfs32e.dll $INSTDIR\System\vdfs32e.dll

  IfFileExists $INSTDIR\System\_backupGDRPC\*.* 0 +2
    RMDir $INSTDIR\System\_backupGDRPC

;  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd





Function CheckMD5vdfs

  IfFileExists $INSTDIR\System\vdfs32g.dll MD5vdfsG MD5vdfsGend

  MD5vdfsG:
;  StrCpy $VdfsVersion "vdfs32g.dll"
  md5dll::GetMD5File "$INSTDIR\System\vdfs32g.dll"
  Pop $1
  DetailPrint "Vdfs32g.dll MD5 hash: [$1]"
  StrCpy $MD5vdfs $1
  Goto MD5vdfsDone

  MD5vdfsGend:
  IfFileExists $INSTDIR\System\vdfs32e.dll MD5vdfsE MD5vdfsNone

  MD5vdfsE:
;  StrCpy $VdfsVersion "vdfs32e.dll"
  md5dll::GetMD5File "$INSTDIR\System\vdfs32e.dll"
  Pop $1
  DetailPrint "Vdfs32e.dll MD5 hash: [$1]"
  StrCpy $MD5vdfs $1
  Goto MD5vdfsDone

  MD5vdfsNone:
  DetailPrint ""
  DetailPrint "Error:"
  DetailPrint "Vdfs32g.dll / Vdfs32e.dll are of unrecognized version."
  DetailPrint "Please contact helpo1 using contact info at https://github.com/helpo1/GDRPC/."
  DetailPrint ""
  Abort "Aborting installation..."

  MD5vdfsDone:

FunctionEnd



Function CheckMD5exe

  IfFileExists $INSTDIR\System\Gothic.exe MD5exeG1 MD5exeG1end

  MD5exeG1:
  md5dll::GetMD5File "$INSTDIR\System\Gothic.exe"
  Pop $1
  DetailPrint "Gothic.exe MD5 hash: [$1]"
  StrCpy $MD5exe $1
  Goto MD5exeDone

  MD5exeG1end:
  IfFileExists $INSTDIR\System\Gothic2.exe MD5exeG2 MD5exeNone

  MD5exeG2:
  md5dll::GetMD5File "$INSTDIR\System\Gothic2.exe"
  Pop $1
  DetailPrint "Gothic2.exe MD5 hash: [$1]"
  StrCpy $MD5exe $1
  Goto MD5exeDone

  MD5exeNone:
  DetailPrint ""
  DetailPrint "Error:"
  DetailPrint "Gothic.exe / Gothic2.exe are of unrecognized version."
  DetailPrint "Please contact helpo1 using contact info at https://github.com/helpo1/GDRPC/."
  DetailPrint ""
  Abort "Aborting installation..."

  MD5exeDone:

FunctionEnd



Function SetPlatform

  StrCpy $Platform ""

  ${Switch} $MD5exe
    ${Case} "C8F76B6AAA457DDD4F0816B1C3201201"        ; G1 exe
      ${Switch} $MD5vdfs
        ${Case} "7E224E4D5F361919C9CA153AA141EAEE"      ; G1/GS dll
          StrCpy $Platform "G1"
          ${Break}
      ${EndSwitch}
      ${Break}
    ${Case} "E0144B8B8CC690CD2E416E473D94D0A8"        ; PK 1.08 exe
      ${Switch} $MD5vdfs
        ${Case} "7E224E4D5F361919C9CA153AA141EAEE"      ; G1/GS dll
          StrCpy $Platform "G1_PK"
          ${Break}
        ${Case} "72A644C64F4A99F004C5BF18A5C03F09"      ; SP 1.8 dll
          StrCpy $Platform "G1_SP"
          ${Break}
        ${Case} "851A21C5740D199B634C01AE2DE00F48"      ; Union 1.0k dll
          StrCpy $Platform "G1_Union_10k"
          ${Break}
        ${Case} "40B3BE5689490770DB5C91EF88F46D61"      ; Union 1.0l-beta dll
          StrCpy $Platform "ANY_Union_oldbeta"
          ${Break}
        ${Case} "D4D5A5AB8022E3A8A431624F562AF786"      ; Union 1.0l dll
          StrCpy $Platform "G1_Union_10l"
          ${Break}
      ${EndSwitch}
      ${Break}
    ${Case} "03E7FF0AF0AC2308E3D7226855B7A512"        ; Sequel exe
      ${Switch} $MD5vdfs
        ${Case} "7E224E4D5F361919C9CA153AA141EAEE"      ; G1/GS dll
          StrCpy $Platform "GS"
          ${Break}
        ${Case} "72A644C64F4A99F004C5BF18A5C03F09"      ; SP 1.8 dll
          StrCpy $Platform "GS_SP"
          ${Break}
        ${Case} "851A21C5740D199B634C01AE2DE00F48"      ; Union 1.0k dll
          StrCpy $Platform "GS_Union_10k"
          ${Break}
        ${Case} "40B3BE5689490770DB5C91EF88F46D61"      ; Union 1.0l-beta dll
          StrCpy $Platform "ANY_Union_oldbeta"
          ${Break}
        ${Case} "D4D5A5AB8022E3A8A431624F562AF786"      ; Union 1.0l dll
          StrCpy $Platform "GS_Union_10l"
          ${Break}
      ${EndSwitch}
      ${Break}
    ${Case} "EE2254F93B904DBA6D55FB427A78A7BE"        ; G2 exe
      ${Switch} $MD5vdfs
      ; ${Case}                                         ; G2G-classic dll - fallthrough
        ${Case} "F05834F52F5E668B2485A37C0C5B8EFA"      ; G2E dll
          StrCpy $Platform "G2"
          ${Break}
      ${EndSwitch}
      ${Break}
    ${Case} "BED9A6BB63760BEB6A093AA42A36AAB8"        ; RV 1.30 exe - fallthrough
    ${Case} "95FA7C29B074C54FA98F26BA82DAF86A"        ; RV 1.30 (Union) exe
      ${Switch} $MD5vdfs
      ; ${Case}                                         ; G2G-classic dll - fallthrough
        ${Case} "F05834F52F5E668B2485A37C0C5B8EFA"      ; G2E dll
          StrCpy $Platform "G2_RV"
          ${Break}
        ${Case} "72A644C64F4A99F004C5BF18A5C03F09"      ; SP 1.8 dll
          StrCpy $Platform "G2_SP"
          ${Break}
        ${Case} "851A21C5740D199B634C01AE2DE00F48"      ; Union 1.0k dll
          StrCpy $Platform "G2_Union_10k"
          ${Break}
        ${Case} "40B3BE5689490770DB5C91EF88F46D61"      ; Union 1.0l-beta dll
          StrCpy $Platform "ANY_Union_oldbeta"
          ${Break}
        ${Case} "D4D5A5AB8022E3A8A431624F562AF786"      ; Union 1.0l dll
          StrCpy $Platform "G2_Union_10l"
          ${Break}
      ${EndSwitch}
      ${Break}
    ${Case} "BABAAABAB7B037F3DD0D200FDB207F94"        ; G2A exe
      ${Switch} $MD5vdfs
      ; ${Case}                                         ; G2E-addon dll - fallthrough
        ${Case} "A6C182A15FB91484B4585471A1484EF5"      ; G2G dll
          StrCpy $Platform "G2A"
          ${Break}
      ${EndSwitch}
      ${Break}
    ${Case} "3C436BD199CAAAA64E9736E3CC1C9C32"        ; RV 2.60 exe - fallthrough
    ${Case} "6706198A79022BF704412D6B72DFB45A"        ; RV 2.60 (Union) exe
      ${Switch} $MD5vdfs
      ; ${Case}                                         ; G2E-addon dll - fallthrough
        ${Case} "A6C182A15FB91484B4585471A1484EF5"      ; G2G dll
          StrCpy $Platform "G2A_RV"
          ${Break}
        ${Case} "72A644C64F4A99F004C5BF18A5C03F09"      ; SP 1.8 dll
          StrCpy $Platform "G2A_SP"
          ${Break}
        ${Case} "851A21C5740D199B634C01AE2DE00F48"      ; Union 1.0k dll
          StrCpy $Platform "G2A_Union_10k"
          ${Break}
        ${Case} "40B3BE5689490770DB5C91EF88F46D61"      ; Union 1.0l-beta dll
          StrCpy $Platform "G2A_Union_10l-beta"
          ${Break}
        ${Case} "D4D5A5AB8022E3A8A431624F562AF786"      ; Union 1.0l dll
          StrCpy $Platform "G2A_Union_10l"
          ${Break}
        ${Case} "A5D64E000F49B1AE2B4364B9651426CA"      ; R2 dll
          StrCpy $Platform "G2A_R2"
          ${Break}
      ${EndSwitch}
      ${Break}
  ${EndSwitch}

  ${If} $Platform == "G1_Union_10k"
  ${OrIf} $Platform == "GS_Union_10k"
    MessageBox MB_YESNO|MB_ICONQUESTION "Are you installing GDRPC for Gothic Sequel?$\r$\n$\r$\nYes: Gothic Sequel$\r$\n No: Gothic 1" IDYES decideGS_10k IDNO decideG1_10k
    decideG1_10k:
      StrCpy $Platform "G1_Union_10k"
      Goto decide1Over_10k
    decideGS_10k:
      StrCpy $Platform "GS_Union_10k"
    decide1Over_10k:
  ${EndIf}

  ${If} $Platform == "G1_Union_10l"
  ${OrIf} $Platform == "GS_Union_10l"
    MessageBox MB_YESNO|MB_ICONQUESTION "Are you installing GDRPC for Gothic Sequel?$\r$\n$\r$\nYes: Gothic Sequel$\r$\n No: Gothic 1" IDYES decideGS_10l IDNO decideG1_10l
    decideG1_10l:
      StrCpy $Platform "G1_Union_10l"
      Goto decide1Over_10l
    decideGS_10l:
      StrCpy $Platform "GS_Union_10l"
    decide1Over_10l:
  ${EndIf}

  ${If} $Platform == "G2A_Union_10k"
  ${OrIf} $Platform == "G2A_NB_20xx"
    MessageBox MB_YESNO|MB_ICONQUESTION "Are you installing GDRPC for Gothic 2: New Balance?$\r$\n$\r$\nYes: Gothic 2 - New Balance$\r$\n No: Gothic 2 Gold Edition" IDYES decideG2NB_20xx IDNO decideG2A_10k
    decideG2A_10k:
      StrCpy $Platform "G2A_Union_10k"
      Goto decide2Over_10k
    decideG2NB_20xx:
      StrCpy $Platform "G2A_NB_20xx"
    decide2Over_10k:
  ${EndIf}

  ${If} $Platform == "G2A_Union_10l-beta"
  ${OrIf} $Platform == "G2A_NB_21xx"
    MessageBox MB_YESNO|MB_ICONQUESTION "Are you installing GDRPC for Gothic 2: New Balance?$\r$\n$\r$\nYes: Gothic 2 - New Balance$\r$\n No: (any other game version)" IDYES decideG2NB_21xx IDNO decideANY_oldbeta
    decideG2NB_21xx:
      StrCpy $Platform "G2A_NB_21xx"
    decide2Over_10l-beta:
  ${EndIf}

;  ${If} $Platform == "G2A_Union_10l"
;  ${OrIf} $Platform == "G2A_NB_22xx"
;    MessageBox MB_YESNO|MB_ICONQUESTION "Are you installing GDRPC for Gothic 2: New Balance?$\r$\n$\r$\nYes: Gothic 2 - New Balance$\r$\n No: Gothic 2 Gold Edition" IDYES decideG2NB_22xx IDNO decideG2A_10l
;    decideG2A_10l:
;      StrCpy $Platform "G2A_Union_10l"
;      Goto decide2Over_10l
;    decideG2NB_22xx:
;      StrCpy $Platform "G2A_NB_22xx"
;    decide2Over_10l:
;  ${EndIf}

  ${If} $Platform == "ANY_Union_oldbeta"
    decideANY_oldbeta:
      Abort "Older preview versions of Union releases are not supported. Please update Union to the latest supported release (current: Union 1.0l stable) or any other *stable* release (1.0k+).$\r$\n$\r$\nAborting installation..."
  ${EndIf}

  ${If} $Platform == ""
    DetailPrint ""
    DetailPrint "Error:"
    DetailPrint "Unrecognized combination of Gothic.exe / Gothic2.exe and vdfs32g.dll / vdfs32e.dll."
    IfFileExists $INSTDIR\System\libdiscord-rpc.dll 0 +3
      DetailPrint "(libdiscord-rpc.dll exists, GDRPC or equivalent probably already installed)"
      DetailPrint "(if updating existing installation of GDRPC, uninstall current one first)"
    DetailPrint "Please contact helpo1 using contact info at https://github.com/helpo1/GDRPC/."
    DetailPrint ""
    Abort "Aborting installation..."
  ${EndIf}

FunctionEnd



; Setup (directory validation)

LangString TextVerifyDir ${LANG_ENGLISH} "Choose the installation directory of 'Gothic', 'Gothic Sequel', 'Gothic II' or 'Gothic II - Night of the Raven'."

Var VerifyMessageOnce

Function .onVerifyInstDir

  IfFileExists "$INSTDIR\*.*" "" nope
  IfFileExists "$INSTDIR\System\*.*" "" nope
  IfFileExists "$INSTDIR\Data\*.*" "" nope

  Goto done

  nope:
  ; Show only once
  StrCmp $VerifyMessageOnce "done" +3
  MessageBox MB_OK|MB_ICONINFORMATION $(TextVerifyDir)
  StrCpy $VerifyMessageOnce "done"
  Abort

  done:
FunctionEnd



Function .onInit

  StrCpy $1 ${SEC_INI_EN} ; default: EN .ini
  StrCpy $2 ${SEC_OE_FF} ; default: Ninja FF Output Extender

FunctionEnd

Function .onSelChange

  ${If} ${SectionIsPartiallySelected} ${SEC_INI}
  !insertmacro StartRadioButtons $1
    !insertmacro RadioButton ${SEC_INI_EN}
    !insertmacro RadioButton ${SEC_INI_DE}
    !insertmacro RadioButton ${SEC_INI_PL}
    !insertmacro RadioButton ${SEC_INI_RU}
    !insertmacro RadioButton ${SEC_INI_CZ}
  !insertmacro EndRadioButtons
  ${Else}
  !insertmacro UnselectSection ${SEC_INI_EN}
  !insertmacro UnselectSection ${SEC_INI_DE}
  !insertmacro UnselectSection ${SEC_INI_PL}
  !insertmacro UnselectSection ${SEC_INI_RU}
  !insertmacro UnselectSection ${SEC_INI_CZ}
  ${EndIf}
  
  ${If} ${SectionIsPartiallySelected} ${SEC_OE}
  !insertmacro StartRadioButtons $2
    !insertmacro RadioButton ${SEC_OE_FF}
    !insertmacro RadioButton ${SEC_OE_HD}
  !insertmacro EndRadioButtons
  ${Else}
  !insertmacro UnselectSection ${SEC_OE_FF}
  !insertmacro UnselectSection ${SEC_OE_HD}
  ${EndIf}

FunctionEnd
