﻿# SHiT9-TA-Tools
 
## How It Works
This tool modifies the Windows registry to redirect Roblox Player launches to a different executable, effectively "breaking" normal Roblox startup for unsuspecting users.

## Usage

### Setup the Prank
1. **Open Registry Editor**
   - Press `Win + R`, type `regedit`, hit Enter
   - Accept the admin prompt

2. **Navigate to the Target**
   ```
   HKEY_CLASSES_ROOT\roblox_player\shell\open\command
   ```

3. **Execute the Troll**
   - Find the default value
   - Change the path from `RobloxPlayer.exe` to `roblox.exe` (or your chosen redirect)
   - Save and close

4. **Watch the Confusion**
   - When someone tries to launch Roblox, it won't work as expected
   - Enjoy the mild frustration (responsibly)

# Reverting the Prank
To undo the changes, simply restore the original RobloxPlayer.exe path in the same registry location.
<br>
**Important**: Once someone clicks on Roblox and the redirect happens, you cannot cancel it mid-execution. GLHF!!
