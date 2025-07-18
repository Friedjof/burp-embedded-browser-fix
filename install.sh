#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}=================================================${NC}"
    echo -e "${BLUE}  Burp Suite Embedded Browser Fix - Installer${NC}"
    echo -e "${BLUE}=================================================${NC}\n"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -y, --yes           Skip confirmation prompt and install automatically"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "This installer will:"
    echo "  1. Copy the fix script to ~/.local/bin/fix-burp"
    echo "  2. Make it executable and available system-wide"
    echo "  3. Add ~/.local/bin to PATH if not already present"
}

# Parse command line arguments
SKIP_CONFIRMATION=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -y|--yes)
            SKIP_CONFIRMATION=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

print_header

# Script URLs
MAIN_SCRIPT_URL="https://raw.githubusercontent.com/intelligencegroup-io/burp-embedded-browser-fix/refs/heads/main/burp-embedded-browser-fix.sh"
TEMP_SCRIPT="/tmp/burp-embedded-browser-fix.sh"

# Check if curl or wget is available
if command -v curl &> /dev/null; then
    DOWNLOAD_CMD="curl -fsSL"
elif command -v wget &> /dev/null; then
    DOWNLOAD_CMD="wget -qO-"
else
    print_error "Neither curl nor wget is available. Please install one of them."
    exit 1
fi

print_info "Downloading main script from repository..."
echo -n "Fetching latest version... "

# Download the main script
if [[ "$DOWNLOAD_CMD" == "curl -fsSL" ]]; then
    curl -fsSL "$MAIN_SCRIPT_URL" > "$TEMP_SCRIPT"
else
    wget -qO- "$MAIN_SCRIPT_URL" > "$TEMP_SCRIPT"
fi

if [ $? -ne 0 ] || [ ! -s "$TEMP_SCRIPT" ]; then
    echo "failed"
    print_error "Failed to download main script from $MAIN_SCRIPT_URL"
    print_info "Please check your internet connection and try again."
    exit 1
fi

echo "done"
print_success "Successfully downloaded main script"

MAIN_SCRIPT="$TEMP_SCRIPT"

# Define installation paths
INSTALL_DIR="$HOME/.local/bin"
INSTALL_PATH="$INSTALL_DIR/fix-burp"

# Show installation details
print_info "Installation details:"
echo "  Source: Remote repository (latest version)"
echo "  Target: $INSTALL_PATH"
echo "  Command: fix-burp"
echo ""

# Check if already installed
if [ -f "$INSTALL_PATH" ]; then
    print_warning "fix-burp is already installed at $INSTALL_PATH"
    if [ "$SKIP_CONFIRMATION" = false ]; then
        echo -n "Do you want to overwrite it? [Y/n]: "
        read -r response
        if [[ "$response" =~ ^[Nn]$ ]]; then
            print_info "Installation cancelled."
            exit 0
        fi
    else
        print_info "Overwriting existing installation..."
    fi
fi

# Confirmation prompt
if [ "$SKIP_CONFIRMATION" = false ]; then
    echo -n "Do you want to install fix-burp? [Y/n]: "
    read -r response
    if [[ "$response" =~ ^[Nn]$ ]]; then
        print_info "Installation cancelled."
        exit 0
    fi
fi

print_info "Starting installation..."

# Create ~/.local/bin if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    print_info "Creating directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
    if [ $? -ne 0 ]; then
        print_error "Failed to create directory: $INSTALL_DIR"
        exit 1
    fi
fi

# Copy the script
print_info "Copying script to $INSTALL_PATH"
cp "$MAIN_SCRIPT" "$INSTALL_PATH"
if [ $? -ne 0 ]; then
    print_error "Failed to copy script to $INSTALL_PATH"
    exit 1
fi

# Make it executable
print_info "Making script executable"
chmod +x "$INSTALL_PATH"
if [ $? -ne 0 ]; then
    print_error "Failed to make script executable"
    exit 1
fi

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    print_warning "~/.local/bin is not in your PATH"
    print_info "Adding ~/.local/bin to PATH in ~/.bashrc"
    
    # Add to ~/.bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        echo '' >> "$HOME/.bashrc"
        echo '# Added by Burp Suite Embedded Browser Fix installer' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        print_success "Added ~/.local/bin to PATH in ~/.bashrc"
        print_info "Please run 'source ~/.bashrc' or restart your terminal to apply changes"
    else
        print_warning "~/.bashrc not found. Please manually add ~/.local/bin to your PATH"
        print_info "Add this line to your shell configuration file:"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
else
    print_success "~/.local/bin is already in your PATH"
fi

# Clean up temporary file
rm -f "$TEMP_SCRIPT"

print_success "Installation completed successfully!"
print_info "You can now run 'fix-burp' from anywhere to fix Burp Suite's embedded browser"

echo ""
print_info "Usage examples:"
echo "  fix-burp                           # Auto-search for chrome-sandbox"
echo "  fix-burp -p /path/to/chrome-sandbox  # Use custom path"
echo "  fix-burp --help                   # Show help"

echo ""
print_info "To test the installation, try running:"
echo "  fix-burp --help"

# Test if the command is available
if command -v fix-burp &> /dev/null; then
    print_success "fix-burp command is available and ready to use!"
else
    print_warning "fix-burp command is not immediately available"
    print_info "You may need to restart your terminal or run 'source ~/.bashrc'"
fi

echo ""