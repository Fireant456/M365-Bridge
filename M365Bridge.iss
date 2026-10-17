; ==============================================================================
; INNO SETUP PRE-COMPILE TASK: AUTOMATIC STANDALONE BINARY BUILDER
; ==============================================================================
; Runs your compile.ps1 script invisibly before the installer compression begins.
; If compilation fails, the Inno Setup build will halt with an error code.

#if Exec("powershell.exe", "-NoProfile -ExecutionPolicy Bypass -File """ + SourcePath + "compile.ps1""", SourcePath, 1, 0) != 0
  #error M365 Bridge Pre-Compile Error: compile.ps1 execution failed. Check your PowerShell script or files.
#endif
; ==============================================================================

[Setup]
AppName=M365 Bridge
AppVersion=1.0.0
AppPublisher=Max Michaels
AppPublisherURL=https://github.com/Fireant456/M365-Bridge
AppSupportURL=https://github.com/Fireant456/M365-Bridge/issues
SetupIconFile=src\m365.ico
DefaultDirName={autopf}\M365Bridge
DefaultGroupName=M365 Bridge
Compression=lzma2
SolidCompression=yes
OutputDir=Output
OutputBaseFilename=M365BridgeInstaller_{#AppVersionStr}
ChangesAssociations=yes
PrivilegesRequired=admin
UninstallDisplayIcon={app}\m365.ico

[Files]
; Core background automation engine
Source: "src\OpenOnline.ps1"; DestDir: "{app}"; Flags: ignoreversion

; Standalone application wrappers
Source: "src\WordWeb.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "src\ExcelWeb.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "src\PowerPointWeb.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "src\VisioWeb.exe"; DestDir: "{app}"; Flags: ignoreversion

; Application Icon
Source: "src\m365.ico"; DestDir: "{app}"; Flags: ignoreversion

[Registry]
; ==============================================================================
; 1. FILE EXTENSION ENHANCED OPENWITH & DEFAULT ICON MAPPINGS
; ==============================================================================

; --- WORD WRAPPER ASSOCIATIONS (.docx, .doc, .docm, .dotx, .dotm) ---
Root: HKLM; Subkey: "Software\Classes\.docx\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Word"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.doc\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Word"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.docm\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Word"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.dotx\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Word"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.dotm\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Word"; Flags: uninsdeletevalue
; FIX: Force legacy extensions to display your wrapper icon by default in File Explorer
Root: HKLM; Subkey: "Software\Classes\.docx\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\WordWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.doc\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\WordWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.docm\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\WordWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.dotx\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\WordWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.dotm\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\WordWeb.exe,0"; Flags: uninsdeletevalue

; --- EXCEL WRAPPER ASSOCIATIONS (.xlsx, .xls, .xlsm, .xltx, .xltm) ---
Root: HKLM; Subkey: "Software\Classes\.xlsx\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Excel"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.xls\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Excel"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.xlsm\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Excel"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.xltx\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Excel"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.xltm\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Excel"; Flags: uninsdeletevalue
; FIX: Force legacy extensions to display your wrapper icon by default in File Explorer
Root: HKLM; Subkey: "Software\Classes\.xlsx\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\ExcelWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.xls\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\ExcelWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.xlsm\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\ExcelWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.xltx\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\ExcelWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.xltm\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\ExcelWeb.exe,0"; Flags: uninsdeletevalue

; --- POWERPOINT WRAPPER ASSOCIATIONS (.pptx, .ppt, .pptm, .potx, .potm) ---
Root: HKLM; Subkey: "Software\Classes\.pptx\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.PowerPoint"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.ppt\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.PowerPoint"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.pptm\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.PowerPoint"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.potx\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.PowerPoint"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.potm\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.PowerPoint"; Flags: uninsdeletevalue
; FIX: Force legacy extensions to display your wrapper icon by default in File Explorer
Root: HKLM; Subkey: "Software\Classes\.pptx\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\PowerPointWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.ppt\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\PowerPointWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.pptm\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\PowerPointWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.potx\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\PowerPointWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.potm\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\PowerPointWeb.exe,0"; Flags: uninsdeletevalue

; --- VISIO WRAPPER ASSOCIATIONS (.vsdx, .vsdm, .vsd, .vdx) ---
Root: HKLM; Subkey: "Software\Classes\.vsdx\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Visio"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.vsdm\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Visio"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.vsd\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Visio"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.vdx\OpenWithProgids"; ValueType: none; ValueName: "M365Bridge.Visio"; Flags: uninsdeletevalue
; FIX: Force Visio extensions to display your wrapper icon by default in File Explorer
Root: HKLM; Subkey: "Software\Classes\.vsdx\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\VisioWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.vsdm\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\VisioWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.vsd\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\VisioWeb.exe,0"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.vdx\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\VisioWeb.exe,0"; Flags: uninsdeletevalue


; ==============================================================================
; 2. CORE APPLICATION PROGID EXECUTION COMMAND TARGETS
; ==============================================================================

Root: HKLM; Subkey: "Software\Classes\M365Bridge.Word"; ValueType: string; ValueName: ""; ValueData: "Word Web"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\M365Bridge.Word\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\WordWeb.exe,0"
Root: HKLM; Subkey: "Software\Classes\M365Bridge.Word\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\WordWeb.exe"" ""%1"""

Root: HKLM; Subkey: "Software\Classes\M365Bridge.Excel"; ValueType: string; ValueName: ""; ValueData: "Excel Web"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\M365Bridge.Excel\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\ExcelWeb.exe,0"
Root: HKLM; Subkey: "Software\Classes\M365Bridge.Excel\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\ExcelWeb.exe"" ""%1"""

Root: HKLM; Subkey: "Software\Classes\M365Bridge.PowerPoint"; ValueType: string; ValueName: ""; ValueData: "PowerPoint Web"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\M365Bridge.PowerPoint\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\PowerPointWeb.exe,0"
Root: HKLM; Subkey: "Software\Classes\M365Bridge.PowerPoint\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\PowerPointWeb.exe"" ""%1"""

Root: HKLM; Subkey: "Software\Classes\M365Bridge.Visio"; ValueType: string; ValueName: ""; ValueData: "Visio Web"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\M365Bridge.Visio\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\VisioWeb.exe,0"
Root: HKLM; Subkey: "Software\Classes\M365Bridge.Visio\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\VisioWeb.exe"" ""%1"""


; ==============================================================================
; 3. NATIVE APPS RECOGNITION (OPEN WITH DIALOG INCLUSION LISTS)
; ==============================================================================

Root: HKLM; Subkey: "Software\Classes\Applications\WordWeb.exe"; ValueType: string; ValueName: "FriendlyAppName"; ValueData: "Word Web"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\Applications\WordWeb.exe\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\WordWeb.exe,0"
Root: HKLM; Subkey: "Software\Classes\Applications\WordWeb.exe\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\WordWeb.exe"" ""%1"""
Root: HKLM; Subkey: "Software\Classes\Applications\WordWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".docx"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\WordWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".doc"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\WordWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".docm"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\WordWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".dotx"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\WordWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".dotm"; ValueData: ""

Root: HKLM; Subkey: "Software\Classes\Applications\ExcelWeb.exe"; ValueType: string; ValueName: "FriendlyAppName"; ValueData: "Excel Web"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\Applications\ExcelWeb.exe\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\ExcelWeb.exe,0"
Root: HKLM; Subkey: "Software\Classes\Applications\ExcelWeb.exe\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\ExcelWeb.exe"" ""%1"""
Root: HKLM; Subkey: "Software\Classes\Applications\ExcelWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".xlsx"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\ExcelWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".xls"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\ExcelWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".xlsm"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\ExcelWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".xltx"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\ExcelWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".xltm"; ValueData: ""

Root: HKLM; Subkey: "Software\Classes\Applications\PowerPointWeb.exe"; ValueType: string; ValueName: "FriendlyAppName"; ValueData: "PowerPoint Web"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\Applications\PowerPointWeb.exe\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\PowerPointWeb.exe,0"
Root: HKLM; Subkey: "Software\Classes\Applications\PowerPointWeb.exe\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\PowerPointWeb.exe"" ""%1"""
Root: HKLM; Subkey: "Software\Classes\Applications\PowerPointWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".pptx"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\PowerPointWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".ppt"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\PowerPointWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".pptm"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\PowerPointWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".potx"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\PowerPointWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".potm"; ValueData: ""

Root: HKLM; Subkey: "Software\Classes\Applications\VisioWeb.exe"; ValueType: string; ValueName: "FriendlyAppName"; ValueData: "Visio Web"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\Applications\VisioWeb.exe\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\VisioWeb.exe,0"
Root: HKLM; Subkey: "Software\Classes\Applications\VisioWeb.exe\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\VisioWeb.exe"" ""%1"""
Root: HKLM; Subkey: "Software\Classes\Applications\VisioWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".vsdx"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\VisioWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".vsdm"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\VisioWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".vsd"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\Applications\VisioWeb.exe\SupportedTypes"; ValueType: string; ValueName: ".vdx"; ValueData: ""

; ==============================================================================
; 4. DEFINE WINDOWS APPLICATION CAPABILITIES MANAGER (DEFAULT APPS ENGINE)
; ==============================================================================

Root: HKLM; Subkey: "Software\M365Bridge\Capabilities"; ValueType: string; ValueName: "ApplicationName"; ValueData: "M365 Bridge"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities"; ValueType: string; ValueName: "ApplicationDescription"; ValueData: "Open Office documents in Microsoft 365 for the web"
; Word Capabilities
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".docx"; ValueData: "M365Bridge.Word"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".doc"; ValueData: "M365Bridge.Word"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".docm"; ValueData: "M365Bridge.Word"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".dotx"; ValueData: "M365Bridge.Word"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".dotm"; ValueData: "M365Bridge.Word"
; Excel Capabilities
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".xlsx"; ValueData: "M365Bridge.Excel"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".xls"; ValueData: "M365Bridge.Excel"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".xlsm"; ValueData: "M365Bridge.Excel"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".xltx"; ValueData: "M365Bridge.Excel"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".xltm"; ValueData: "M365Bridge.Excel"
; PowerPoint Capabilities
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".pptx"; ValueData: "M365Bridge.PowerPoint"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".ppt"; ValueData: "M365Bridge.PowerPoint"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".pptm"; ValueData: "M365Bridge.PowerPoint"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".potx"; ValueData: "M365Bridge.PowerPoint"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".potm"; ValueData: "M365Bridge.PowerPoint"
; Visio Capabilities
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".vsdx"; ValueData: "M365Bridge.Visio"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".vsdm"; ValueData: "M365Bridge.Visio"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".vsd"; ValueData: "M365Bridge.Visio"
Root: HKLM; Subkey: "Software\M365Bridge\Capabilities\FileAssociations"; ValueType: string; ValueName: ".vdx"; ValueData: "M365Bridge.Visio"

Root: HKLM; Subkey: "Software\RegisteredApplications"; ValueType: string; ValueName: "M365 Bridge"; ValueData: "Software\M365Bridge\Capabilities"; Flags: uninsdeletevalue