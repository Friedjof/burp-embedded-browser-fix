# Burp Embedded Browser Fix

This script **fixes** the issue where the default browser in Burp Suite doesn't launch after upgrading to Ubuntu 24.04.

## Problem

After upgrading to Ubuntu 24.04, many users encountered an issue where clicking on the "Open Browser" button in Burp Suite no longer launches the default browser. This issue occurs even after reinstalling the latest version of Burp Suite, and it prevents users from using Burp's embedded browser feature as intended.

This problem is caused by incorrect permissions set on the `chrome-sandbox` binary bundled with Burp Suite. The sandbox binary requires elevated permissions to function correctly, and without these permissions, the browser will not launch when triggered from Burp Suite.

## Usage

### One-liner

You can quickly fix the issue by running the following one-liner, which will clone the repository, give execution permissions to the script, and run it in one go:

```bash
git clone https://github.com/intelligencegroup-io/burp-embedded-browser-fix.git && cd burp-embedded-browser-fix && chmod +x burp-embedded-browser-fix.sh && ./burp-embedded-browser-fix.sh
```

### Step 1: Clone the repository

If you prefer to follow individual steps, first clone the repository to your local machine:

```bash
git clone https://github.com/intelligencegroup-io/burp-embedded-browser-fix.git
```

### Step 2: Give execution permissions

Navigate into the cloned directory and make the script executable:

```bash
cd burp-embedded-browser-fix
chmod +x burp-embedded-browser-fix.sh
```

### Step 3: Run the script

Execute the script with the following command:

```bash
./burp-embedded-browser-fix.sh
```

This will fix the permissions for Burp Suite's embedded browser to launch correctly.

### Step 4: Open Browser

After running the script, click on the "Open Browser" button. The default browser should now launch without any issues.
