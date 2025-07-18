# Burp Embedded Browser Fix

This script **fixes** the issue where the default browser in Burp Suite doesn't launch after upgrading to Ubuntu 24.04.

## Problem

After upgrading to Ubuntu 24.04, many users encountered an issue where clicking on the "Open Browser" button in Burp Suite no longer launches the default browser. This issue occurs even after reinstalling the latest version of Burp Suite, and it prevents users from using Burp's embedded browser feature as intended.

This problem is caused by incorrect permissions set on the `chrome-sandbox` binary bundled with Burp Suite. The sandbox binary requires elevated permissions to function correctly, and without these permissions, the browser will not launch when triggered from Burp Suite.

## Usage

### Quick Fix (Remote Execution)

The fastest way to fix the issue is to run the script directly from the repository using one of these commands:

**Using curl:**
```bash
curl -fsSL https://raw.githubusercontent.com/intelligencegroup-io/burp-embedded-browser-fix/refs/heads/main/burp-embedded-browser-fix.sh | bash
```

**Using wget:**
```bash
wget -qO- https://raw.githubusercontent.com/intelligencegroup-io/burp-embedded-browser-fix/refs/heads/main/burp-embedded-browser-fix.sh | bash
```

### Local Installation

#### One-liner

You can quickly fix the issue by running the following one-liner, which will clone the repository, give execution permissions to the script, and run it in one go:

```bash
git clone https://github.com/intelligencegroup-io/burp-embedded-browser-fix.git && cd burp-embedded-browser-fix && chmod +x burp-embedded-browser-fix.sh && ./burp-embedded-browser-fix.sh
```

#### Step-by-step

If you prefer to follow individual steps:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/intelligencegroup-io/burp-embedded-browser-fix.git
   ```

2. **Give execution permissions:**
   ```bash
   cd burp-embedded-browser-fix
   chmod +x burp-embedded-browser-fix.sh
   ```

3. **Run the script:**
   ```bash
   ./burp-embedded-browser-fix.sh
   ```

### Advanced Usage

The script now supports additional options:

**Help:**
```bash
./burp-embedded-browser-fix.sh --help
```

**Custom chrome-sandbox path:**
```bash
./burp-embedded-browser-fix.sh --path /custom/path/to/chrome-sandbox
```

### Verification

After running the script, click on the "Open Browser" button in Burp Suite. The default browser should now launch without any issues.
