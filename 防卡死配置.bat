@echo off
chcp 65001 >nul
title 机器人资产管理系统 - 防卡死环境配置工具
color 0A

:: 设置超时和重试参数
set MAX_RETRIES=3
set TIMEOUT_SECONDS=15
set CURRENT_RETRY=0

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║        机器人资产管理系统 - 防卡死环境配置工具               ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

:main_menu
echo 请选择操作模式：
echo.
echo 1. 🚀 快速检测模式（推荐）
echo 2. 🛠️  完整配置模式
echo 3. 📊 系统状态检查
echo 4. 🆘 紧急修复模式
echo 5. 🚪 退出程序
echo.
set /p user_choice=请输入选项（1-5）：

if "%user_choice%"=="1" goto quick_check
if "%user_choice%"=="2" goto full_setup
if "%user_choice%"=="3" goto system_check
if "%user_choice%"=="4" goto emergency_fix
if "%user_choice%"=="5" goto exit_program
echo ❌ 无效选择，请重新输入
timeout /t 2 >nul
cls
goto main_menu

:quick_check
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                     快速环境检测                             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

call :check_java
call :check_maven
call :check_mysql_service
call :check_ports

echo.
echo 检测完成！
echo.
echo 按任意键返回主菜单...
pause >nul
goto main_menu

:full_setup
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                     完整环境配置                             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 正在进行环境配置...
echo.

:: 检查必要环境
call :check_required_env
if errorlevel 1 (
    echo ❌ 必要环境缺失，无法继续配置
    echo 请先安装缺失的软件后再试
    timeout /t 5 >nul
    goto main_menu
)

:: 启动MySQL服务
call :start_mysql_service

:: 配置数据库
call :setup_database

:: 安装前端依赖
call :install_frontend_deps

echo.
echo ✅ 环境配置完成！
echo.
echo 现在您可以：
echo 1. 运行 test.bat 进行最终测试
echo 2. 运行 mvn spring-boot:run 启动后端
echo 3. 运行 npm run serve 启动前端
echo.
echo 默认登录：admin / admin123
echo.
echo 按任意键返回主菜单...
pause >nul
goto main_menu

:system_check
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                     系统状态检查                             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 当前时间：%date% %time%
echo.

echo === 端口状态 ===
netstat -an | findstr :8080 >nul
if %errorlevel% equ 0 (
    echo ✅ 端口 8080 已占用
) else (
    echo ❌ 端口 8080 未占用
)

netstat -an | findstr :3306 >nul
if %errorlevel% equ 0 (
    echo ✅ 端口 3306 已占用
) else (
    echo ❌ 端口 3306 未占用
)

echo.
echo === 服务进程 ===
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
echo === MySQL服务 ===
sc query mysql | findstr "STATE" | findstr "RUNNING" >nul
if %errorlevel% equ 0 (
    echo ✅ MySQL服务运行中
) else (
    echo ❌ MySQL服务未运行
)

echo.
echo 按任意键返回主菜单...
pause >nul
goto main_menu

:emergency_fix
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                     紧急修复模式                             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 请选择要修复的问题：
echo 1. 修复端口占用
echo 2. 重新安装依赖
echo 3. 重启MySQL服务
echo 4. 清理缓存文件
echo 5. 返回主菜单
echo.

set /p fix_choice=请选择（1-5）：

if "%fix_choice%"=="1" call :fix_port_conflict
if "%fix_choice%"=="2" call :reinstall_dependencies
if "%fix_choice%"=="3" call :restart_mysql
if "%fix_choice%"=="4" call :clean_cache
if "%fix_choice%"=="5" goto main_menu

echo 修复完成！
timeout /t 2 >nul
goto emergency_fix

:exit_program
cls
echo.
echo 感谢使用机器人资产管理系统配置工具！
echo 祝您使用愉快！
echo.
timeout /t 3 >nul
exit

:: ========== 函数定义 ==========

:check_java
echo 检查Java环境...
timeout /t 1 >nul
java -version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Java环境正常
    for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr "version"') do set JAVA_VERSION=%%i
    echo    版本：%JAVA_VERSION%
) else (
    echo ❌ Java环境缺失
    echo    请安装Java 17或更高版本
)
exit /b

:check_maven
echo 检查Maven环境...
timeout /t 1 >nul
mvn -v >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Maven环境正常
) else (
    echo ❌ Maven环境缺失
    echo    请安装Apache Maven
)
exit /b

:check_mysql_service
echo 检查MySQL服务...
timeout /t 1 >nul
sc query mysql >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL服务存在
    sc query mysql | findstr "STATE" | findstr "RUNNING" >nul
    if %errorlevel% equ 0 (
        echo    状态：运行中
    ) else (
        echo    状态：已停止
    )
) else (
    echo ❌ MySQL服务未安装
)
exit /b

:check_ports
echo 检查端口占用...
timeout /t 1 >nul
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
exit /b

:check_required_env
:: 检查必要环境
call :check_java
call :check_maven
call :check_mysql_service

:: 如果任何一项检查失败，返回错误
java -version >nul 2>&1
if %errorlevel% neq 0 exit /b 1

mvn -v >nul 2>&1
if %errorlevel% neq 0 exit /b 1

sc query mysql >nul 2>&1
if %errorlevel% neq 0 exit /b 1

exit /b 0

:start_mysql_service
echo 启动MySQL服务...
net start mysql >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL服务启动成功
) else (
    echo ⚠️  MySQL服务启动失败
    echo    请手动启动MySQL服务后再继续
)
timeout /t 2 >nul
exit /b

:setup_database
echo 配置数据库...
set /p mysql_pwd=请输入MySQL root密码（直接回车跳过）：
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
    echo 跳过数据库自动配置
    echo 请手动执行 sql/init.sql 文件
)
timeout /t 2 >nul
exit /b

:install_frontend_deps
echo 检查前端环境...
node -v >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Node.js环境正常
    if not exist "node_modules" (
        echo 正在安装前端依赖...
        npm install --silent >nul 2>&1
        if %errorlevel% equ 0 (
            echo ✅ 前端依赖安装完成
        ) else (
            echo ❌ 前端依赖安装失败
        )
    ) else (
        echo ✅ 前端依赖已安装
    )
) else (
    echo ⚠️  Node.js未安装，跳过前端配置
)
timeout /t 2 >nul
exit /b

:fix_port_conflict
echo 正在清理端口占用...
for /f "tokens=5" %%i in ('netstat -ano ^| findstr :8080') do (
    echo 终止占用8080端口的进程 %%i
    taskkill /PID %%i /F >nul 2>&1
)
echo 端口清理完成
timeout /t 2 >nul
exit /b

:reinstall_dependencies
echo 重新安装依赖...
if exist "node_modules" (
    echo 清理现有依赖...
    rmdir /s /q node_modules >nul 2>&1
)
if exist "package-lock.json" (
    del package-lock.json >nul 2>&1
)
npm cache clean --force >nul 2>&1
npm install --silent >nul 2>&1
echo 依赖重新安装完成
timeout /t 2 >nul
exit /b

:restart_mysql
echo 重启MySQL服务...
net stop mysql >nul 2>&1
timeout /t 3 >nul
net start mysql >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL服务重启成功
) else (
    echo ❌ MySQL服务重启失败
)
timeout /t 2 >nul
exit /b

:clean_cache
echo 清理缓存文件...
mvn clean >nul 2>&1
if exist "target" (
    rmdir /s /q target >nul 2>&1
)
echo 缓存清理完成
timeout /t 2 >nul
exit /b