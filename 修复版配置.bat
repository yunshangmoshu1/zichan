@echo off
chcp 65001 >nul
title 修复版环境配置工具
color 0E

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║           机器人资产管理系统 - 修复版环境配置                ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

:: 检查是否以管理员身份运行
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  检测到权限不足
    echo 建议右键点击此文件，选择"以管理员身份运行"
    echo.
    echo 是否继续以当前权限运行？(Y/N)
    set /p continue_choice=
    if /i not "%continue_choice%"=="Y" (
        echo 程序退出
        pause
        exit /b 1
    )
    echo 继续运行...
    echo.
)

:: 设置错误处理
set ERROR_COUNT=0
set SUCCESS_COUNT=0

:main_menu
cls
echo 当前时间：%date% %time%
echo.
echo 请选择操作模式：
echo.
echo 1. 🛠️  详细环境检测（推荐）
echo 2. 🚀 快速配置模式
echo 3. 📊 系统状态检查
echo 4. 🆘 问题诊断工具
echo 5. 🚪 退出程序
echo.
set /p user_choice=请输入选项（1-5）：

if "%user_choice%"=="1" goto detailed_check
if "%user_choice%"=="2" goto quick_setup
if "%user_choice%"=="3" goto system_status
if "%user_choice%"=="4" goto diagnostics
if "%user_choice%"=="5" goto exit_program

echo ❌ 无效选择，请重新输入
timeout /t 2 >nul
goto main_menu

:detailed_check
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    详细环境检测                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 正在进行详细环境检测...
echo.

:: 检查Java环境
echo [1/6] Java环境检查...
java -version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Java环境正常
    for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr "version"') do set JAVA_VERSION=%%i
    echo    版本：%JAVA_VERSION%
    set /a SUCCESS_COUNT+=1
) else (
    echo ❌ Java环境异常
    echo    解决方案：
    echo    1. 下载安装Java 17+
    echo    2. 配置JAVA_HOME环境变量
    echo    3. 将Java添加到系统Path
    set /a ERROR_COUNT+=1
)
timeout /t 2 >nul

:: 检查Maven环境
echo.
echo [2/6] Maven环境检查...
mvn -v >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Maven环境正常
    set /a SUCCESS_COUNT+=1
) else (
    echo ❌ Maven环境异常
    echo    解决方案：
    echo    1. 下载安装Maven
    echo    2. 配置MAVEN_HOME环境变量
    echo    3. 将Maven添加到系统Path
    set /a ERROR_COUNT+=1
)
timeout /t 2 >nul

:: 检查Node.js环境
echo.
echo [3/6] Node.js环境检查...
node -v >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Node.js环境正常
    for /f "delims=" %%i in ('node -v') do set NODE_VERSION=%%i
    echo    版本：%NODE_VERSION%
    set /a SUCCESS_COUNT+=1
) else (
    echo ⚠️  Node.js环境缺失（不影响后端运行）
)
timeout /t 2 >nul

:: 检查MySQL服务
echo.
echo [4/6] MySQL服务检查...
sc query mysql >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL服务存在
    sc query mysql | findstr "STATE" | findstr "RUNNING" >nul
    if %errorlevel% equ 0 (
        echo    状态：运行中
        set /a SUCCESS_COUNT+=1
    ) else (
        echo    状态：已停止
        echo    解决方案：在Windows服务中启动MySQL服务
    )
) else (
    echo ❌ MySQL服务未安装
    echo    解决方案：安装MySQL 8.0+
    set /a ERROR_COUNT+=1
)
timeout /t 2 >nul

:: 检查项目文件
echo.
echo [5/6] 项目文件检查...
set REQUIRED_FILES=pom.xml package.json src\main\java\com\company\robot\RobotAssetApplication.java
set FILE_ERROR=0
for %%f in (%REQUIRED_FILES%) do (
    if exist "%%f" (
        echo    ✅ %%f
    ) else (
        echo    ❌ %%f 缺失
        set /a FILE_ERROR+=1
    )
)
if %FILE_ERROR% equ 0 (
    echo ✅ 项目文件完整
    set /a SUCCESS_COUNT+=1
) else (
    echo ❌ 项目文件不完整
    set /a ERROR_COUNT+=1
)
timeout /t 2 >nul

:: 检查端口占用
echo.
echo [6/6] 端口状态检查...
netstat -an | findstr :8080 >nul
if %errorlevel% equ 0 (
    echo ⚠️  端口8080被占用
) else (
    echo ✅ 端口8080可用
)

netstat -an | findstr :3306 >nul
if %errorlevel% equ 0 (
    echo ✅ MySQL端口3306正常
) else (
    echo ⚠️  MySQL端口3306异常
)

echo.
echo === 检测完成 ===
echo 成功项目：%SUCCESS_COUNT% 项
echo 失败项目：%ERROR_COUNT% 项
echo.

if %ERROR_COUNT% equ 0 (
    echo 🎉 环境检测通过！
    echo.
    echo 是否现在开始配置数据库？(Y/N)
    set /p db_setup=
    if /i "%db_setup%"=="Y" goto database_config
) else (
    echo ⚠️  发现 %ERROR_COUNT% 个问题需要解决
    echo 建议先解决上述问题再继续配置
)

echo.
echo 按任意键返回主菜单...
pause >nul
goto main_menu

:quick_setup
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    快速配置模式                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 快速配置模式启动...
echo.

:: 简化的环境检查
echo 检查必要环境...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java环境缺失，无法继续
    pause
    goto main_menu
)

mvn -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Maven环境缺失，无法继续
    pause
    goto main_menu
)

echo ✅ 必要环境检查通过

:: 启动MySQL服务
echo 启动MySQL服务...
net start mysql >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL服务启动成功
) else (
    echo ⚠️  MySQL服务启动失败（可能已在运行）
)

:: 安装前端依赖
echo 安装前端依赖...
if not exist "node_modules" (
    npm install --silent >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ 前端依赖安装完成
    ) else (
        echo ⚠️  前端依赖安装失败
    )
) else (
    echo ✅ 前端依赖已存在
)

echo.
echo 快速配置完成！
echo.
echo 现在您可以：
echo 1. 运行 mvn spring-boot:run 启动后端
echo 2. 运行 npm run serve 启动前端
echo.
echo 按任意键返回主菜单...
pause >nul
goto main_menu

:system_status
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    系统状态检查                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 系统状态检查...
echo.

echo 当前时间：%date% %time%
echo 当前目录：%cd%
echo 用户名：%USERNAME%
echo.

echo === 进程状态 ===
tasklist | findstr "java.exe" >nul
if %errorlevel% equ 0 (
    echo ✅ Java进程运行中
) else (
    echo ❌ Java进程未运行
)

tasklist | findstr "node.exe" >nul
if %errorlevel% equ 0 (
    echo ✅ Node.js进程运行中
) else (
    echo ❌ Node.js进程未运行
)

echo.
echo === 服务状态 ===
sc query mysql | findstr "STATE" | findstr "RUNNING" >nul
if %errorlevel% equ 0 (
    echo ✅ MySQL服务运行中
) else (
    echo ❌ MySQL服务未运行
)

echo.
echo === 端口状态 ===
netstat -an | findstr :8080 >nul
if %errorlevel% equ 0 (
    echo ✅ 端口8080已占用
) else (
    echo ❌ 端口8080未占用
)

netstat -an | findstr :3306 >nul
if %errorlevel% equ 0 (
    echo ✅ MySQL端口3306正常
) else (
    echo ❌ MySQL端口3306异常
)

echo.
echo 按任意键返回主菜单...
pause >nul
goto main_menu

:diagnostics
cls
echo.
echo 正在启动诊断工具...
call 诊断工具.bat
goto main_menu

:database_config
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    数据库配置                                ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 数据库配置向导...
echo.

set /p mysql_pwd=请输入MySQL root密码：
if defined mysql_pwd (
    echo 正在创建数据库...
    mysql -u root -p%mysql_pwd% -e "CREATE DATABASE IF NOT EXISTS robot_asset CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ 数据库创建成功
        echo 正在初始化数据...
        mysql -u root -p%mysql_pwd% robot_asset < sql\init.sql >nul 2>&1
        if %errorlevel% equ 0 (
            echo ✅ 数据初始化完成
        ) else (
            echo ⚠️  数据初始化可能有问题
        )
    ) else (
        echo ❌ 数据库创建失败
    )
) else (
    echo 跳过数据库配置
)

echo.
echo 按任意键返回主菜单...
pause >nul
goto main_menu

:exit_program
cls
echo.
echo 感谢使用机器人资产管理系统配置工具！
echo 祝您使用愉快！
echo.
timeout /t 3 >nul
exit /b