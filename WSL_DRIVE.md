### **Installing WSL on a Drive Other Than C**

If you want to install and run WSL on a drive that is not your main system drive (e.g., D:\), you can follow the steps below. This allows you to keep your system drive clean and allocate more space for your Linux distributions.

---

#### **Steps to Install WSL on a Non-System Drive**

1. **Create a Directory for WSL**
   ```powershell
   PS C:\> d:
   PS D:\> New-Item WSL -Type Directory
   PS D:\> Set-Location .\WSL
   ```

2. **Download the Ubuntu Appx Package**
   Download the WSL distribution you want to install. For example, for Ubuntu 22.04:
   ```powershell
   PS D:\WSL> curl.exe -L -o Linux.appx https://aka.ms/wslubuntu2204
   ```

3. **Convert the `.appx` File to a `.zip` File**
   Rename the downloaded `.appx` file to `.zip` to extract its contents:
   ```powershell
   PS D:\WSL> Copy-Item .\Linux.appx .\Linux.zip
   ```

4. **Extract the `.zip` File**
   Unzip the file to extract the necessary installation files:
   ```powershell
   PS D:\WSL> Expand-Archive .\Linux.zip
   PS D:\WSL> Set-Location .\Ubuntu2204
   ```

5. **Optional: Rename Files or Folders**
   If needed, rename the folder or files to organize them better. For example:
   ```powershell
   PS D:\WSL\Ubuntu2204> Rename-Item .\ext4.vhdx .\Ubuntu_22.04_ext4.vhdx
   ```

6. **Unregister the Current Installation (if necessary)**
   If you already have the distribution installed, unregister it to start fresh:
   ```powershell
   wsl --unregister Ubuntu
   ```

7. **Run the `.exe` to Install the Distribution**
   Execute the `.exe` file in the extracted folder to reinstall the distribution on the new drive:
   ```powershell
   PS D:\WSL\Ubuntu2204> .\ubuntu.exe
   ```

8. **Verify Installation**
   After installation, confirm that the distribution is now running from the new drive:
   ```powershell
   wsl --list --verbose
   ```

   The distribution should appear as installed and registered.

---

#### **Notes**
- The `.vhdx` file in the folder is your Linux distribution's virtual hard disk (e.g., `ext4.vhdx`). It contains all the files for your distribution.
- Make sure to back up the `.vhdx` file if you want to preserve your distribution before any major changes.

This method ensures that WSL and its associated files reside on your desired drive, keeping your system drive free of large files.

