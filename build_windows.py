#!/usr/bin/env python3
"""
Build script for creating a portable Windows .exe file
"""

import PyInstaller.__main__
import os
import sys
from pathlib import Path
import shutil
import traceback

def build_windows_exe():
    """Build a portable Windows executable using PyInstaller"""
    
    print("Building portable Windows executable...")
    print(f"Working directory: {os.getcwd()}")
    print(f"Python version: {sys.version}")
    
    # Check if main script exists
    if not os.path.exists('meulade.py'):
        print("ERROR: meulade.py not found!")
        print("Available Python files:")
        for file in os.listdir('.'):
            if file.endswith('.py'):
                print(f"  - {file}")
        return False
    
    # Clean previous builds
    if os.path.exists('dist'):
        print("Cleaning old dist directory...")
        shutil.rmtree('dist')
    if os.path.exists('build'):
        print("Cleaning old build directory...")
        shutil.rmtree('build')
    
    # Check for data files
    data_files = []
    if os.path.exists('config.json'):
        data_files.append('--add-data=config.json;.')
        print("Found config.json")
    else:
        print("WARNING: config.json not found - continuing without it")
        
    if os.path.exists('images'):
        data_files.append('--add-data=images;images')
        print("Found images directory")
    else:
        print("WARNING: images directory not found")
    
    # PyInstaller command for Windows executable
    command = [
        'meulade.py',  # Main entry point
        '--onefile',   # Create a single executable file
        '--windowed',  # Hide console window (GUI app)
        '--name=Meulade_RVSQ',
        '--clean',
        '--noconfirm',
    ]
    
    # Add data files if they exist
    command.extend(data_files)
    
    # Add the rest of the options
    command.extend([
        # Hidden imports for dependencies
        '--hidden-import=pygame',
        '--hidden-import=pygame.mixer',
        '--hidden-import=pygame.font',
        '--hidden-import=playwright',
        '--hidden-import=playwright.sync_api',
        '--hidden-import=playwright.async_api',
        '--hidden-import=playwright._impl._api_types',
        '--hidden-import=playwright._impl.sync_api',
        '--hidden-import=playwright._impl.async_api',
        '--hidden-import=gui',
        '--hidden-import=browser',
        '--hidden-import=languages',
        '--hidden-import=logger',
        
        # Collect all playwright and pygame files
        '--collect-all=playwright',
        '--collect-all=pygame',
        
        # Exclude unnecessary modules to reduce size
        '--exclude-module=tkinter',
        '--exclude-module=matplotlib',
        '--exclude-module=numpy',
        '--exclude-module=scipy',
        '--exclude-module=IPython',
        '--exclude-module=jupyter',
        
        # Optimization
        '--strip',
        '--optimize=2',
    ])
    
    # Add icon if ICO format is available
    if os.path.exists('images/logo_small.ico'):
        command.append('--icon=images/logo_small.ico')
        print("Using icon: images/logo_small.ico")
    else:
        print("No ICO icon found - continuing without icon (PNG format not supported on Windows)")
    
    try:
        print("\nRunning PyInstaller...")
        print("Command:")
        print(" ".join(command))
        print("\n" + "="*60)
        
        # Run PyInstaller
        result = PyInstaller.__main__.run(command)
        
        print("\n" + "="*60)
        print("PyInstaller execution completed!")
        print("="*60)
        
        # Check if dist directory exists
        if not os.path.exists('dist'):
            print("ERROR: dist directory was not created!")
            print("Available directories:")
            for item in os.listdir('.'):
                if os.path.isdir(item):
                    print(f"  {item}")
            return False
        
        # List contents of dist directory
        print("Contents of dist directory:")
        dist_items = os.listdir('dist')
        if not dist_items:
            print("  (empty)")
            return False
            
        for item in dist_items:
            item_path = os.path.join('dist', item)
            if os.path.isfile(item_path):
                size = os.path.getsize(item_path) / (1024 * 1024)
                print(f"  {item} ({size:.1f} MB)")
            else:
                print(f"  {item}")
        
        exe_path = Path('dist/Meulade_RVSQ.exe')
        if exe_path.exists():
            size_mb = exe_path.stat().st_size / (1024 * 1024)
            print(f"\nSUCCESS: Executable created!")
            print(f"Location: {exe_path}")
            print(f"File size: {size_mb:.1f} MB")
            print("\nDistribution instructions:")
            print("1. Download the executable from GitHub Actions artifacts")
            print("2. The .exe should work on Windows machines without Python")
            print("3. Includes Playwright browser and all dependencies")
            return True
        else:
            print("ERROR: Meulade_RVSQ.exe not found in dist folder!")
            return False
            
    except Exception as e:
        print(f"Build failed with error: {e}")
        print("\nFull traceback:")
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = build_windows_exe()
    if not success:
        print("\nBuild failed!")
        sys.exit(1)
    else:
        print("\nBuild completed successfully!")
