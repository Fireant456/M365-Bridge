# M365 Bridge

M365 Bridge is an open-source, lightweight Windows application wrapped powershell script. It allows users to seamlessly open local Microsoft Office documents (Word, Excel, PowerPoint, and Visio) that are synced inside OneDrive or SharePoint document libraries directly within their respective native Microsoft 365 Web apps.

If a file is synced, it natively invokes the cloud "View Online" web canvas. If the file is unsynced or local-only, the background engine catches it and provides a clean, native alert dialog.

## Features

- **Native App Wrappers:** Completely standalone C# background execution wrappers (`WordWeb.exe`, `ExcelWeb.exe`, etc.) embedded with matching application branding icons.
- **Zero-Footprint Compilation:** Uses PowerShell's built-in .NET CodeDom compiler provider engine to dynamically build binaries in memory—no explicit local installation or hardcoded paths to `csc.exe` required.
- **Deep Windows Integration:** Registers across 19 standard, legacy, and macro-enabled extensions (`.docx`, `.docm`, `.doc`, `.xlsx`, `.xlsm`, `.xls`, `.pptx`, `.pptm`, `.ppt`, `.vsdx`, etc.).
- **Windows Default Apps Aware:** Fully registers with the Windows Application Capabilities manager so users or administrators can manage defaults natively via Windows Settings.

## Installation and Requirements

You can easily get up and running with this simple solution by heading over the [GitHub Releases page](https://github.com/Fireant456/M365-Bridge/releases). Download the latest `M365BridgeInstaller_x.x.x.exe` file and run it on any system you want to install it on.

The only requirement is that you have OneDrive setup and any file you want to open with the bridge is synced in a OneDrive folder. Windows 10 and newer comes with OneDrive so it should be as simple as making sure you are logged in and your files are in the designated folder (typically `C:\users\{username}\OneDrive\`) or your backed up folders that are also being synced to OneDrive (configurable in the OneDrive Settings).

## Project Structure

```text
M365-Bridge/
├── src/
│   ├── OpenOnline.ps1        # Core background automation/routing engine
│   ├── excel.ico             # Microsoft Excel Icon
│   ├── powerpoint.ico        # Microsoft PowerPoint Icon
│   ├── visio.ico             # Microsoft Visio Icon
│   ├── word.ico              # Microsoft Word Icon
│   └── m365.ico              # Microsoft 365 Icon for Installer/Uninstaller
├── compile.ps1               # Automated in-memory C# compilation provider
└── M365Bridge.iss                 # Inno Setup compilation script
```

## Compilation and Packaging

The automated build pipeline is fully unified through Inno Setup. You do not need to run the compilation script manually.

1. Open `setup.iss` inside the **Inno Setup Compiler IDE**.
2. Click **Compile** (or press `Ctrl + F9`).
3. The Inno Preprocessor will silently invoke `compile.ps1` to build `WordWeb.exe`, `ExcelWeb.exe`, `PowerPointWeb.exe`, and `VisioWeb.exe` directly inside `/src` before compressing the final installer assets into `Output\M365BridgeInstaller.exe`.

---

## Enterprise Deployment & Silent Installation

M365 Bridge is designed to be fully compatible with enterprise endpoint management systems and RMM/MDM platforms (such as **Action1**, **Microsoft Intune**, **PDQ Deploy**, or **NinjaOne**).

Because the installer is compiled via Inno Setup, it executes system-wide out of the box and requires local administrative privileges to establish file association registry structures.

### Command-Line Arguments

To deploy the package completely invisibly without user interaction, use the following silent switches:

```cmd
M365BridgeInstaller.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
```

| Switch | Description |
| :--- | :--- |
| `/VERYSILENT` | Runs the installer completely in the background without displaying a wizard interface or progress windows. |
| `/SUPPRESSMSGBOXES` | Automatically answers default actions (e.g., "Yes" or "OK") to all internal setup prompt dialogs. |
| `/NORESTART` | Prevents the target computer from rebooting if an association change requests an OS lock cycle. |

---

## Changing File Defaults Natively

If your target machines have deep-seated native office assignments, Windows 10 and 11 may initially place legacy extensions into an unassigned state due to User Choice Hash protection rules. 

End users or system administrators can globally default file structures cleanly by opening:
**Settings** -> **Apps** -> **Default Apps** -> Search for **M365 Bridge** -> Map associations across desired extensions.

Alternitively users can select the Word Web, Excel Web, PowerPoint Web, or Visio Web at the first open of the respective file types.

## Looking for a solution on Mac OS?

This solution was in part inspired by https://github.com/bewithdhanu/office-online-bridge-macos. If you are not on Windows and looking for a MacOS compatible solution, this was the only other solution I personally could find.

## License

This project is licensed under the **GNU General Public License v3 (GPLv3)**. See the `LICENSE` file for more details. Build toolchains and external compilation scripts conform to open linking exceptions.
