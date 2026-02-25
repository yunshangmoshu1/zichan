# Robot Asset Management System - Beginner's Guide

## 🎯 Getting Started for Complete Beginners

This guide will teach you how to use this system step by step, as simple as teaching children to play with building blocks!

---

## 📋 Step 1: Preparation (Like Grocery Shopping and Cooking)

### 🛒 Software to Download and Install:

**1. Download Java Environment**
- Visit official website: https://www.oracle.com/java/technologies/downloads/
- Select **Java 17** version
- Click download, click "Next" all the way to install

**2. Download MySQL Database**
- Visit official website: https://dev.mysql.com/downloads/mysql/
- Select version suitable for your computer system
- Remember the password set during installation (e.g., 123456)

**3. Download Node.js (Required for frontend)**
- Visit official website: https://nodejs.org/en/
- Download LTS version
- Double-click installer, keep clicking "Next"

**4. Download Code Editor (Recommended)**
- Visit official website: https://code.visualstudio.com/
- Download Visual Studio Code
- Complete installation

> 💡 **Pro Tip**: All software above can be downloaded for free, just like downloading games!

---

## 🚀 Step 2: Install System (Like Assembling Toys)

### 📦 Method 1: Simplest One-click Installation

**1. Download Project Files**
```
Download the entire project folder to your computer
For example, place in: D:\My Projects\robot-system\
```

**2. Open Command Prompt**
```
Press Win+R, type cmd, press Enter
```

**3. Enter Project Directory**
```cmd
cd D:\My Projects\robot-system
```

**4. One-click Startup**
```cmd
# Double-click to run this file
test.bat
```

If green "✅" signs appear, the environment is ready!

---

## 🛠️ Step 3: Configure Database (Like Setting Game Save)

### 🎮 Graphical Operation Method:

**1. Open MySQL Workbench**
- Find MySQL Workbench in Start menu
- Click to open

**2. Connect to Database**
- Click "+" to create new connection
- Connection Name: Give it a name like "My Asset System"
- Username: root
- Password: Password you set during installation
- Click "Test Connection" to test connection

**3. Execute Initialization Script**
- After successful connection, click "File" → "Open SQL Script" in top menu
- Select `sql/init.sql` in project folder
- Click lightning icon ⚡ to run all code

> ✅ No red errors means success!

---

## ▶️ Step 4: Start System (Like Turning on TV)

### 🖥️ Start Backend Service:

**1. Open Command Prompt**
```cmd
cd D:\My Projects\robot-system
```

**2. Start Backend**
```cmd
mvn spring-boot:run
```

Success message looks like:
```
Started RobotAssetApplication in 5.234 seconds
Robot Asset Management System started successfully!
```

### 🌐 Start Frontend Interface:

**1. Open New Command Prompt Window**
```cmd
cd D:\My Projects\robot-system
```

**2. Install Frontend Dependencies**
```cmd
npm install
```

**3. Start Frontend**
```cmd
npm run serve
```

Success message looks like:
```
Local: http://localhost:8080/
```

---

## 🎮 Step 5: Start Using (As Simple as Playing Games)

### 🔓 Login System:
1. Open browser (Chrome, Edge both work)
2. Enter address: http://localhost:8080
3. Username: admin
4. Password: admin123
5. Click Login

### 🏠 Main Interface Introduction:
- Left side is function menu
- Top is title bar
- Middle is operation area

### 📦 Add First Asset:
1. Click left menu "Asset Management" → "Asset Ledger"
2. Click top right "Add Asset" button
3. Fill in basic information:
   - Asset Name: e.g., "Six-axis Robotic Arm"
   - Robot Type: Select "Industrial Robot"
   - Brand: e.g., "ABB"
   - Model: e.g., "IRB6700"
4. Click "Save" button

### 🔍 View Asset List:
- Search assets by typing name in search box
- Click "View" in table to see detailed information
- Click "Edit" to modify information

---

## 🆘 Common Problem Solutions (Don't Panic When Problems Occur)

### ❌ Problem 1: "'java' is not recognized as an internal or external command"
**Solution:**
1. Reinstall Java
2. Configure environment variables:
   - Right-click "This PC" → "Properties" → "Advanced system settings"
   - Click "Environment Variables"
   - In System Variables find Path, add Java installation path

### ❌ Problem 2: Cannot connect to MySQL
**Solution:**
1. Confirm MySQL service is started
2. Check if username/password is correct
3. Firewall may be blocking connection

### ❌ Problem 3: Webpage won't open
**Solution:**
1. Confirm backend service started successfully
2. Check if port is occupied
3. Try refreshing browser page

### ❌ Problem 4: npm install very slow
**Solution:**
```cmd
# Use domestic mirror source
npm config set registry https://registry.npmmirror.com
npm install
```

---

## 🎯 Advanced Operation Guide

### 📱 Mobile Access:
System supports mobile and tablet access, enter in mobile browser:
```
http://your-computer-ip:8080
```

### 🖨️ Print Asset Labels:
1. Click "Generate QR Code" in asset details page
2. Right-click QR code image and select "Print"
3. Stick on physical assets for easy management

### 📊 View Statistical Data:
1. Click "Data Statistics" menu
2. Can see various charts and reports
3. Supports Excel file export

---

## 🛡️ Security Reminders

### 🔐 Change Default Password:
1. After logging in, click avatar in top right
2. Select "Personal Settings"
3. Change login password
4. At least 8 characters, including letters and numbers

### 📂 Regular Data Backup:
1. Backup database weekly
2. Export important data timely
3. Store backup files properly

---

## 📞 Get Help

If you encounter unsolvable problems:
1. Check system log files
2. Contact technical support
3. Ask questions in community forums

---

## 🌟 Success Secrets for Beginners

✅ **Remember these points to get started easily:**
- Don't be afraid of making mistakes, practice makes perfect
- Look at error messages first when problems occur
- Make good use of search engines to find answers
- Practice more times to become proficient

🎉 **Congratulations! You're now a little expert of the asset management system!**