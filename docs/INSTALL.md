# Install Pacific Coast Highway on Windows

> **Community beta · provided as is.** PCH is in active development. Expect bugs and changes between releases. Back up your personal save and use Sandbox with Standard racers for a first Drive.

The beta uses your own compatible FH2 installation and Azimuth. Start original FH2 once in Azimuth to create a save. The source game folder contains `Mount\forza_durango_release_final.exe`. The runtime folder contains `azimuth.exe` and the existing save. FHCM prepares a separate library and copies both originals. Close Azimuth before setup or switching builds. Allow space for the copied game and runtime, the downloaded parts, the joined ZIP, and the installed map.

## Get the map ZIP

From the [PCH releases page](https://github.com/fhcustommaps/pch-public-preview/releases), download all seven numbered ZIP parts, `FHCM-PCH-Review72-beta1-california.parts.json`, and `Join-PchCaliforniaDownload.ps1` from the California Plates release. Put them in one folder. In PowerShell, run the join script from that folder.

```powershell
.\Join-PchCaliforniaDownload.ps1
```

If PowerShell blocks the downloaded script under RemoteSigned, verify it against the [repository copy](../tools/Join-PchCaliforniaDownload.ps1) before running `Unblock-File -LiteralPath .\Join-PchCaliforniaDownload.ps1` for that file.

The script checks all seven downloads and the reassembled ZIP. Use the resulting `FHCM-PCH-Review72-beta1-california.zip` intact. If you already have the complete ZIP, verify `Get-FileHash -Algorithm SHA256 -LiteralPath .\FHCM-PCH-Review72-beta1-california.zip` against the release checksum and skip joining.

## With FHCM Launcher

1. Download the Windows x64 installer from the [FHCM Launcher releases](https://github.com/fhcustommaps/fhcm-launcher-public-preview/releases), verify its SHA-256, and run it.
2. In **Create FHCM Library**, select the owned game and Azimuth folders, optional installed Storm Island content, and a new library destination.
3. Open **Import ZIP**, select the joined PCH ZIP, then select **Pacific Coast Highway**.
4. For a first Drive, select **Sandbox**, **Standard**, and **Medium** traffic. Keep the ZIP and a backup of your original save until the install is verified.

## Without the desktop launcher

The standalone Map Tool is also an as-is community preview. Download and verify **FHCM Map Tool for Windows x64** from the [FHCM Launcher releases](https://github.com/fhcustommaps/fhcm-launcher-public-preview/releases). Extract that tool ZIP to a folder of its own and open PowerShell there. Replace the example paths with yours.

```powershell
.\fhcm-map.exe setup 'D:\FHCM Library' 'D:\Owned FH2\Game' 'D:\Azimuth'
.\fhcm-map.exe import 'D:\FHCM Library' 'D:\Downloads\FHCM-PCH-Review72-beta1-california.zip'
.\fhcm-map.exe drive 'D:\FHCM Library' medium standard
```

Put a fourth path after the Azimuth folder on the `setup` command if you have installed Storm Island content. Run `setup` once per new library. The map tool uses Sandbox for Drive and starts Azimuth directly. Use `prepare` in place of `drive` to stage the map and set the spawn in the copied library without opening the game.

| Selection | Options |
| --- | --- |
| Traffic | `off`, `light`, `medium`, `heavy` |
| Racers | `standard` starts at estate parking and supports distance challenges. `tour` starts at the lower lot with ten Experimental Tour racers and disables challenges. |

## Known beta issues

Experimental Tour still needs moving catch-up and off-lane regroup fixes. Use Standard for a first playthrough. See the [known issues](KNOWN-ISSUES.md).
