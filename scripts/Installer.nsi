!include "Sections.nsh"
!include "CustomFunctions.nsh"

!define PRODUCT_NAME "MySimpleNotePad"
!define PRODUCT_VERSION "0.9.0"
;!define PRODUCT_NAME_VERSION "${PRODUCT_NAME} ${PRODUCT_VERSION}"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}Installer.exe"
InstallDir "c:\${PRODUCT_NAME}"
ShowInstDetails show
ShowUnInstDetails show
LoadLanguageFile "Korean.nlf"
Icon "Installer.ico"
UninstallIcon "Uninstaller.ico"
XPStyle on
LicenseData "License.rtf"

!define MSG_UNINATALL_COMPLETED "$(^Name)는(은) 완전히 제거되었습니다."
!define MSG_DO_U_WANT_UNINTALL "$(^Name)을(를) 제거하시겠습니까?"
!define SECTION_INSTALL_MAIN "$(^Name) 기본설치"
!define SECTION_PROGRAMGROUP_LINK_CREATE "프로그램그룹에 바로가기생성"
!define SECTION_DESKTOP_LINK_CREATE "데스크톱에 바로가기생성"
!define SECTION_REGISTER_AS_STARTUP "시작프로그램에 등록"
!define SECTION_REGISTER_AT_ADD_REMOVE_PROGRAMS "추가/삭제 프로그램에 등록"
!define SECTION_INSTALL_REMOTECALL "원격지원 설치"
!define TIME_INSTALLER_SPLASH "3000"
!define TIME_UNINSTALLER_SPLASH "3000"
!define EXCUTABLE "wordpad.exe"

Page license
Page components
Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles



Section "닷넷프레임워크 4.0 설치" SEC_ID_DOTNET40_INSTALL
;	MessageBox MB_OK "닷넷프레임워크 4.0 설치"
	SectionIn RO

	IfFileExists "$WINDIR\Microsoft.NET\Framework\v4.0.30319" Dotnet40Installed 0
;		File /oname="$TEMP\dotNetFx40_Full_x86_x64.exe" "dotNetFx40_Full_x86_x64.exe"
;		File /oname="$TEMP\NDP40-KB2468871-v2-x86.exe" "NDP40-KB2468871-v2-x86.exe"

		DetailPrint "닷넷프레임워크 4.0 다운로드중 ..."
		NSISdl::download "http://ec2-52-78-167-96.ap-northeast-2.compute.amazonaws.com/coconut/dotNetFx40_Full_x86_x64.exe" "$TEMP\dotNetFx40_Full_x86_x64.exe"
		DetailPrint "닷넷프레임워크 4.0 다운로드완료 !!!"
		DetailPrint "닷넷프레임워크 4.0 설치중 ..."
		ExecWait "$TEMP\dotNetFx40_Full_x86_x64.exe /q"
;		ExecWait "$TEMP\dotNetFx40_Full_x86_x64.exe"
		DetailPrint "닷넷프레임워크 4.0 설치완료 !!!"

		DetailPrint "NDP40-KB2468871-v2 다운로드중 ..."
		NSISdl::download "http://ec2-52-78-167-96.ap-northeast-2.compute.amazonaws.com/coconut/NDP40-KB2468871-v2-x86.exe" "$TEMP\NDP40-KB2468871-v2-x86.exe"
		DetailPrint "NDP40-KB2468871-v2 다운로드완료 !!!"
		DetailPrint "NDP40-KB2468871-v2 설치중 ..."
		ExecWait "$TEMP\NDP40-KB2468871-v2-x86.exe /q"
;		ExecWait "$TEMP\NDP40-KB2468871-v2-x86.exe"
		DetailPrint "NDP40-KB2468871-v2 설치완료 !!!"
	Dotnet40Installed:
	
SectionEnd

Section "vcredist 2010 설치"
	SectionIn RO

	DetailPrint "vcredist 2010 다운로드중 ..."
	NSISdl::download "http://ec2-52-78-167-96.ap-northeast-2.compute.amazonaws.com/coconut/vcredist_x86-vs2010.exe" "$TEMP\vcredist_x86-vs2010.exe"
	DetailPrint "vcredist 2010 다운로드완료 !!!"
	DetailPrint "vcredist 2010 설치중 ..."
	ExecWait "$TEMP\vcredist_x86-vs2010.exe /q"
;	ExecWait "$TEMP\${VCREDIST_X86_VS2010}"
	DetailPrint "vcredist 2010 설치완료 !!!"

SectionEnd

Section "${SECTION_INSTALL_MAIN}"
	SectionIn RO
	SetOutPath "$INSTDIR"
	SetOverwrite on

	File /a /r "..\deploy\*"
  
	WriteUninstaller "$INSTDIR\uninst.exe"
SectionEnd
	
Section "${SECTION_PROGRAMGROUP_LINK_CREATE}"
	SectionIn RO
	CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
	CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXCUTABLE}"
	CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section "${SECTION_DESKTOP_LINK_CREATE}"
	CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXCUTABLE}"
SectionEnd

;Section "${SECTION_REGISTER_AS_STARTUP}"
;	SectionIn RO
;	CreateShortCut "$SMSTARTUP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXCUTABLE}"
;SectionEnd

Section "${SECTION_REGISTER_AT_ADD_REMOVE_PROGRAMS}"
	SectionIn RO
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
		"DisplayIcon" "$INSTDIR\${EXCUTABLE}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
		"DisplayName" "${PRODUCT_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
		"DisplayVersion" "${PRODUCT_VERSION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
		"Publisher" "(주)MySimpleNotePad"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
		"UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
		"URLInfoAbout" "http://www.mysimplenotepad.com"
SectionEnd

;Section "${SECTION_INSTALL_REMOTECALL}"
;	SectionIn RO
;	File /oname=$TEMP\${REMOTECALL_INSTALLER} ${REMOTECALL_INSTALLER}
;	DetailPrint "원격지원 설치중..."
;	ExecWait "$TEMP\${REMOTECALL_INSTALLER} /q"
;SectionEnd



Section Uninstall
	RMDir /r "$INSTDIR"

	RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"
	Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
	Delete "$SMSTARTUP\${PRODUCT_NAME}.lnk"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

	/* 
	* SetAutoClose true
	*/
SectionEnd



Function .onInit
	MessageBox MB_OK "onInit"

	InitPluginsDir
;	File /oname=$PLUGINSDIR\splash.bmp "InstallerSplash.bmp"
;	File /oname=$PLUGINSDIR\splash.wav "InstallerSplash.wav"
;	splash::show ${TIME_INSTALLER_SPLASH} $PLUGINSDIR\splash
	
	IfFileExists "$WINDIR\Microsoft.NET\Framework\v4.0.30319" 0 Dotnet40NotInstalled
		SectionSetText ${SEC_ID_DOTNET40_INSTALL} ""
	Dotnet40NotInstalled:

FunctionEnd

Function .onInstSuccess
	Exec $INSTDIR\${EXCUTABLE}
FunctionEnd
  

  
Function un.onUninstSuccess
	HideWindow
	MessageBox MB_ICONINFORMATION|MB_OK "${MSG_UNINATALL_COMPLETED}"
FunctionEnd

Function un.onInit
	InitPluginsDir
;	File /oname=$PLUGINSDIR\splash.bmp "UninstallerSplash.bmp"
;	File /oname=$PLUGINSDIR\splash.wav "UninstallerSplash.wav"
;	splash::show ${TIME_UNINSTALLER_SPLASH} $PLUGINSDIR\splash
	
	MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "${MSG_DO_U_WANT_UNINTALL}" IDYES +2
	Abort
FunctionEnd