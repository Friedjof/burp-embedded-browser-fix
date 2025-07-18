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
    echo -e "${BLUE}  Burp Suite Embedded Browser Fix${NC}"
    echo -e "${BLUE}=================================================${NC}\n"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -p, --path PATH     Specify custom path to chrome-sandbox binary"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Auto-search for chrome-sandbox"
    echo "  $0 -p /path/to/chrome-sandbox        # Use specific path"
    echo ""
    echo "Remote execution:"
    echo "  curl -fsSL https://raw.githubusercontent.com/intelligencegroup-io/burp-embedded-browser-fix/refs/heads/main/burp-embedded-browser-fix.sh | bash"
    echo "  wget -qO- https://raw.githubusercontent.com/intelligencegroup-io/burp-embedded-browser-fix/refs/heads/main/burp-embedded-browser-fix.sh | bash"
}

# Parse command line arguments
CUSTOM_PATH=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--path)
            CUSTOM_PATH="$2"
            shift 2
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
print_info "This script will set the correct permissions for the Burp Suite embedded browser's sandbox."

# Determine sandbox path
if [ -n "$CUSTOM_PATH" ]; then
    print_info "Using custom path: $CUSTOM_PATH"
    sandbox_path="$CUSTOM_PATH"
    
    # Verify custom path exists
    if [ ! -f "$sandbox_path" ]; then
        print_error "Custom path does not exist: $sandbox_path"
        exit 1
    fi
    
    # Verify it's actually chrome-sandbox
    if [[ ! "$sandbox_path" == *"chrome-sandbox"* ]]; then
        print_warning "File name doesn't contain 'chrome-sandbox'. Proceeding anyway..."
    fi
else
    print_info "Searching for chrome-sandbox in the home directory..."
    
    # Show search progress
    echo -n "Scanning directories... "
    sandbox_path=$(find ~ -type f -name "chrome-sandbox" 2>/dev/null | head -1)
    echo "done"
    
    # Check if the file was found
    if [ -z "$sandbox_path" ]; then
        print_error "chrome-sandbox not found in home directory."
        print_info "Please ensure Burp Suite is installed, or specify a custom path using -p option."
        echo ""
        show_usage
        exit 1
    fi
    
    print_success "Found chrome-sandbox at: $sandbox_path"
fi

# Verify file permissions before changes
print_info "Current permissions:"
ls -l "$sandbox_path"

# Check if running as root (not recommended but handle it)
if [ "$EUID" -eq 0 ]; then
    print_warning "Running as root. This is not recommended for security reasons."
fi

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
    print_error "sudo is not available. Please run as root or install sudo."
    exit 1
fi

# Change ownership and permissions
print_info "Setting root ownership and SUID permissions..."
echo -n "Applying changes... "

if sudo chown root:root "$sandbox_path" && sudo chmod 4755 "$sandbox_path"; then
    echo "done"
    print_success "Permissions updated successfully!"
else
    echo "failed"
    print_error "Failed to update permissions. Please check sudo access."
    exit 1
fi

# Verify the changes
print_info "Updated permissions:"
ls -l "$sandbox_path"

# Final success message
print_success "Burp Suite embedded browser fix completed successfully!"
print_info "You can now use the embedded browser in Burp Suite without issues."

echo ""
