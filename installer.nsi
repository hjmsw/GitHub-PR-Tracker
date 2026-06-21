Name "PR Tracker"
OutFile "PRTracker.exe"

InstallDir "$PROGRAMFILES64\PRTracker"

Page directory
Page instfiles

Section

    SetOutPath "$INSTDIR"
    File /r "bin\*.*"

    WriteUninstaller "$INSTDIR\Uninstall.exe"

    CreateDirectory "$SMPROGRAMS\PRTracker"
    CreateShortcut "$SMPROGRAMS\PRTracker\PRTracker.lnk" "$INSTDIR\PRTracker.exe"
    CreateShortcut "$SMPROGRAMS\PRTracker\Uninstall.lnk" "$INSTDIR\Uninstall.exe"

SectionEnd

Section "Uninstall"

    Delete "$DESKTOP\PRTracker.lnk"

    RMDir /r "$INSTDIR"

SectionEnd