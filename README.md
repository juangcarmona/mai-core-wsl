
# MAI-Core-WSL

**MAI-Core-WSL** is a set of scripts to quickly configure an AI development environment on a fresh installation of **Windows Subsystem for Linux (WSL)**. This project builds upon the excellent work of [ODA (On Device AI)](https://github.com/mitkox/oda) by Mitko Vasilev, extending its principles to streamline WSL setup specifically for AI development.

---

### **Features**
- **ZSH with Oh My Zsh**: Modern shell environment for productivity.
- **CUDA Setup**: GPU support for accelerated AI workloads.
- **Python Virtual Environment**: Prepares a local `venv` for dependencies.
- **llama.cpp Installation**: Compiles and sets up `llama.cpp` for inference.
- **Utilities**: Installs essential tools like Docker and Git.

---

### **Requirements**
- **WSL Installed**: You must have WSL installed on your Windows machine. If you need to install WSL on a non-system drive (e.g., `D:\`), refer to the guide in [WSL_DRIVE.md](./WSL_DRIVE.md).
- **Ubuntu**: A fresh installation of Ubuntu within WSL.

---
## Before You Start

To ensure a smooth start, follow these essential steps for setting up your development environment:

### Configure Git
1. Set your name and email for Git:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
2. Verify the configuration:
   ```bash
   git config --global --list
   ```

### Generate and Add SSH Key
1. Generate a new SSH key:
   ```bash
   ssh-keygen -t ed25519 -C "your.email@example.com"
   ```
   - Save the key in the default location (`~/.ssh/id_ed25519`).
   - Use a passphrase for added security.

2. Start the SSH agent:
   ```bash
   eval "$(ssh-agent -s)"
   ```

3. Add the SSH key to the agent:
   ```bash
   ssh-add ~/.ssh/id_ed25519
   ```

4. Copy the SSH key to your clipboard:
   ```bash
   cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
   ```
   *(If `xclip` is not installed, you can manually copy the output of the command.)*

5. Add the SSH key to your GitHub account:
   - Go to [GitHub SSH Settings](https://github.com/settings/keys).
   - Click **New SSH Key**.
   - Paste your key and save.

6. Test the connection:
   ```bash
   ssh -T git@github.com
   ```

   You should see a success message.

---

### **Installation**

1. **Step 1: Clone the Repository**:
   Open your terminal in WSL and run:
   ```bash
   git clone https://github.com/your-username/mai-core-wsl.git
   cd mai-core-wsl
   ```

2. **Step 2: Install ZSH**:
   Run the following command to install ZSH:   
   ```bash
   bash ./scripts/install_zsh.sh
   ```

   You will see an installation screen like this:

   After installation, close your terminal and open a new one to ensure ZSH is set as the default shell.

3. ** Step 3: Run the Main Installation Script**:
   Once ZSH is your default shell, navigate back to the mai-core-wsl directory and execute:   
   ```bash
   bash ./scripts/install.sh
   ```
   You will see a confirmation screen like this:e ~/.zshrc
   

---

### **Folder Structure**
- `.venv/`: Virtual environment created during the setup.
- `.temp/`: Temporary files used during installation.
- `scripts/`: All installation and configuration scripts.
- `WSL_DRIVE.md`: Guide for installing WSL on a non-system drive.

---

### **Contributing**
Contributions are welcome! Feel free to open issues or submit pull requests to improve the setup.

---

### **Credits**
This project is inspired by [ODA (On Device AI)](https://github.com/mitkox/oda) by Mitko Vasilev. It simplifies and customizes the setup process for WSL users focused on AI development.

---

### **License**
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.


---

MAI is more than a set of scripts; it’s a philosophy of independence and innovation. Let’s build something incredible together.

---
