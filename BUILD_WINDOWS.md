# Building Meulade_RVSQ for Windows

This guide explains how to create a portable Windows executable (.exe) for the Meulade_RVSQ application.

## Prerequisites

1. **Windows Machine**: You need access to a Windows machine to create a Windows executable
2. **Python 3.8+**: Install from [python.org](https://python.org)
3. **Git** (optional): To clone the repository

## Method 1: Using the Automated Build Script (Recommended)

### On Windows:

1. **Download/Clone the project** to your Windows machine
2. **Open Command Prompt** as Administrator (or PowerShell)
3. **Navigate to the project directory**:
   ```cmd
   cd path\to\Meulade_RVSQ
   ```
4. **Run the build script**:
   ```cmd
   build_windows.bat
   ```

The script will:
- Install all required dependencies
- Download Playwright browsers
- Build the executable using PyInstaller
- Create a portable .exe file in the `dist` folder

### Manual Steps (if the batch script doesn't work):

1. **Install dependencies**:
   ```cmd
   pip install -r requirements.txt
   ```

2. **Install Playwright browsers**:
   ```cmd
   playwright install chromium
   ```

3. **Build the executable**:
   ```cmd
   python build_windows.py
   ```

## Method 2: Cross-compilation from macOS (Limited)

While you're on macOS, creating a Windows executable is challenging due to platform-specific dependencies. However, you can try:

1. **Install Wine** (to emulate Windows environment):
   ```bash
   brew install wine
   ```

2. **Use a Windows Python installation through Wine**:
   ```bash
   # This is complex and may not work reliably
   wine python build_windows.py
   ```

## Method 3: Using Docker (Advanced)

Create a Windows container to build the executable:

1. **Create a Dockerfile for Windows builds**:
   ```dockerfile
   FROM python:3.11-windowsservercore
   COPY . /app
   WORKDIR /app
   RUN pip install -r requirements.txt
   RUN playwright install chromium
   RUN python build_windows.py
   ```

## Output

After successful build, you'll find:
- `dist/Meulade_RVSQ.exe` - The portable executable
- The executable should be ~50-100MB (includes Playwright and Pygame)

## Distribution

The created executable should be portable and work on Windows machines without requiring:
- Python installation
- Additional dependencies
- Manual browser downloads

## Troubleshooting

### Common Issues:

1. **"Python not found"**
   - Install Python from python.org
   - Make sure Python is added to PATH during installation

2. **"playwright install failed"**
   - Run: `pip install playwright` then `playwright install chromium`

3. **Large executable size**
   - This is normal due to including Playwright browser and Pygame
   - You can optimize by excluding unused modules in the spec file

4. **Missing DLL errors on target machines**
   - Install Visual C++ Redistributable on target machines
   - Or use `--collect-all` for more dependencies

### Build on Windows VM/Machine

For best results, use a Windows virtual machine or actual Windows computer:

1. **VirtualBox/VMware**: Create Windows 10/11 VM
2. **AWS/Azure**: Use Windows cloud instance
3. **GitHub Actions**: Use Windows runner for automated builds

## Alternative: GitHub Actions Build

You can set up automated Windows builds using GitHub Actions:

```yaml
name: Build Windows EXE
on: [push]
jobs:
  build:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v2
    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: '3.11'
    - name: Install dependencies
      run: pip install -r requirements.txt
    - name: Install Playwright
      run: playwright install chromium
    - name: Build executable
      run: python build_windows.py
    - name: Upload artifact
      uses: actions/upload-artifact@v2
      with:
        name: Meulade_RVSQ-Windows
        path: dist/
```

This will automatically build your Windows executable whenever you push code to GitHub.
