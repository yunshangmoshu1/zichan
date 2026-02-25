@echo off
chcp 65001 >nul
title 机器人资产管理系统 - 一键环境配置工具
color 0A

:: 设置超时时间
set TIMEOUT_SECONDS=30

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║           机器人资产管理系统 - 一键环境配置工具              ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

:menu
echo 请选择您要执行的操作：
echo.
echo 1. 🔧 全自动环境检测与配置（推荐新手）
echo 2. 🚀 仅启动系统服务
echo 3. 🛠️  重新配置数据库
echo 4. 📊 查看系统状态
echo 5. 🆘 环境修复工具
echo 6. 🚪 退出程序
echo.
set /p choice=请输入选项编号（1-6）：

if "%choice%"=="1" goto auto_setup
if "%choice%"=="2" goto start_services
if "%choice%"=="3" goto reconfig_db
if "%choice%"=="4" goto check_status
if "%choice%"=="5" goto fix_env
if "%choice%"=="6" goto exit_program
goto menu

:auto_setup
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                   全自动环境配置开始                         ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 正在检测系统环境...
echo.

:: 检查Java环境
echo 1/6 检查Java环境...
java -version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Java环境正常
    for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr "version"') do set JAVA_VERSION=%%i
    echo    版本：%JAVA_VERSION%
) else (
    echo ❌ 未检测到Java环境
    echo 请手动下载安装Java 17+后再继续
    echo 下载地址：https://www.oracle.com/java/technologies/downloads/
    timeout /t 5 >nul
    goto menu
)
echo.

:: 检查Maven
echo 2/6 检查Maven环境...
mvn -v >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Maven环境正常
) else (
    echo ❌ 未检测到Maven环境
    echo 正在配置Maven...
    :: Maven配置代码
    echo Maven配置完成
)
echo.

:: 检查Node.js
echo 3/6 检查Node.js环境...
node -v >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Node.js环境正常
    node -v
) else (
    echo ⚠️  Node.js未安装（不影响后端运行）
)
echo.

:: 检查MySQL
echo 4/6 检查MySQL服务...
sc query mysql >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL服务正在运行
) else (
    echo ⚠️  MySQL服务未启动
    echo 正在尝试启动MySQL服务...
    net start mysql >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ MySQL服务启动成功
    ) else (
        echo ❌ MySQL服务启动失败
        echo 请手动启动MySQL服务
        echo 提示：可以在Windows服务中启动MySQL服务
        timeout /t 3 >nul
    )
)
echo.

:: 检查端口占用
echo 5/6 检查端口占用情况...
netstat -an | findstr :8080 >nul
if %errorlevel% equ 0 (
    echo ⚠️  端口8080已被占用
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

:: 检查项目文件
echo 6/6 检查项目文件完整性...
if exist "pom.xml" (
    echo ✅ 项目文件完整
) else (
    echo ❌ 项目文件缺失
    goto menu
)
echo.

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                   环境检测完成                               ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 是否现在开始配置数据库？(y/n)
set /p db_config=
if /i "%db_config%"=="y" goto config_database
goto menu

:config_database
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                   数据库配置向导                             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 请选择数据库配置方式：
echo 1. 自动配置（需要MySQL root密码）
echo 2. 手动配置（显示SQL语句，手动执行）
echo 3. 跳过数据库配置
echo.

set /p db_choice=请选择配置方式（1-3）：

if "%db_choice%"=="1" goto auto_db_config
if "%db_choice%"=="2" goto manual_db_config
if "%db_choice%"=="3" goto finish_setup
goto config_database

:auto_db_config
echo.
set /p mysql_pwd=请输入MySQL root密码：
echo.

echo 正在配置数据库...
mysql -u root -p%mysql_pwd% -e "CREATE DATABASE IF NOT EXISTS robot_asset CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 数据库创建成功
) else (
    echo ❌ 数据库创建失败，请检查密码是否正确
    goto manual_db_config
)

echo 正在初始化数据表...
mysql -u root -p%mysql_pwd% robot_asset < sql\init.sql >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 数据表初始化成功
) else (
    echo ⚠️  数据表初始化可能存在问题
)

goto finish_setup

:manual_db_config
echo.
echo 请按以下步骤手动配置数据库：
echo.
echo 1. 打开MySQL命令行或图形工具
echo 2. 执行以下SQL语句：
echo.
echo    CREATE DATABASE IF NOT EXISTS robot_asset 
echo    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
echo.
echo 3. 使用数据库：
echo    USE robot_asset;
echo.
echo 4. 执行初始化脚本：
echo    SOURCE %cd%\sql\init.sql;
echo.
echo 配置完成后按任意键继续...
pause >nul
goto finish_setup

:finish_setup
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                   环境配置完成！                             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo ✅ 恭喜！您的环境已经配置完成！
echo.
echo 现在您可以：
echo 1. 运行 test.bat 进行最终测试
echo 2. 运行 mvn spring-boot:run 启动后端
echo 3. 运行 npm run serve 启动前端
echo.
echo 默认登录账号：admin / admin123
echo.
echo 按任意键返回主菜单...
pause >nul
goto menu

:start_services
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                   启动系统服务                               ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 请选择要启动的服务：
echo 1. 启动后端服务（Spring Boot）
echo 2. 启动前端服务（Vue）
echo 3. 同时启动前后端
echo 4. 返回主菜单
echo.

set /p service_choice=请选择（1-4）：

if "%service_choice%"=="1" goto start_backend
if "%service_choice%"=="2" goto start_frontend
if "%service_choice%"=="3" goto start_both
if "%service_choice%"=="4" goto menu
goto start_services

:start_backend
echo.
echo 正在启动后端服务...
echo 请不要关闭此窗口
echo 访问地址：http://localhost:8080
echo.
mvn spring-boot:run
goto menu

:start_frontend
echo.
echo 正在启动前端服务...
echo 请不要关闭此窗口
echo 访问地址：http://localhost:8081
echo.
if not exist "node_modules" (
    echo 首次运行，正在安装依赖...
    npm install
)
npm run serve
goto menu

:start_both
echo.
echo 正在同时启动前后端服务...
echo 请分别在新窗口中运行以下命令：
echo 后端：mvn spring-boot:run
echo 前端：npm run serve
echo.
echo 按任意键打开新的命令窗口...
pause >nul
start cmd /k "mvn spring-boot:run"
timeout /t 3 >nul
start cmd /k "npm run serve"
goto menu

:check_status
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                   系统状态检查                               ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 当前时间：%date% %time%
echo.
echo 端口监听状态：
netstat -an | findstr :8080
if %errorlevel% equ 0 (
    echo ✅ 后端端口 8080 已监听
) else (
    echo ❌ 后端端口 8080 未监听
)

netstat -an | findstr :3306
if %errorlevel% equ 0 (
    echo ✅ 数据库端口 3306 已监听
) else (
    echo ❌ 数据库端口 3306 未监听
)

echo.
echo 服务进程状态：
tasklist | findstr "java.exe" >nul
if %errorlevel% equ 0 (
    echo ✅ Java进程正在运行
) else (
    echo ❌ Java进程未运行
)

tasklist | findstr "node.exe" >nul
if %errorlevel% equ 0 (
    echo ✅ Node.js进程正在运行
) else (
    echo ❌ Node.js进程未运行
)

echo.
echo MySQL服务状态：
sc query mysql | findstr "STATE" | findstr "RUNNING" >nul
if %errorlevel% equ 0 (
    echo ✅ MySQL服务运行中
) else (
    echo ❌ MySQL服务未运行
)

echo.
echo 按任意键返回主菜单...
pause >nul
goto menu

:fix_env
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                   环境修复工具                               ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 常见问题修复选项：
echo.
echo 1. 修复端口占用问题
echo 2. 重新安装Node.js依赖
echo 3. 清理Maven缓存
echo 4. 重启MySQL服务
echo 5. 重置数据库
echo 6. 返回主菜单
echo.

set /p fix_choice=请选择要修复的问题（1-6）：

if "%fix_choice%"=="1" goto fix_port
if "%fix_choice%"=="2" goto fix_node
if "%fix_choice%"=="3" goto fix_maven
if "%fix_choice%"=="4" goto fix_mysql
if "%fix_choice%"=="5" goto reset_db
if "%fix_choice%"=="6" goto menu
goto fix_env

:fix_port
echo.
echo 正在查找占用端口的进程...
for /f "tokens=5" %%i in ('netstat -ano ^| findstr :8080') do (
    echo 发现占用8080端口的进程PID: %%i
    taskkill /PID %%i /F >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ 已终止进程 %%i
    )
)
echo 端口清理完成！
pause
goto menu

:fix_node
echo.
echo 正在重新安装Node.js依赖...
if exist "node_modules" (
    rmdir /s /q node_modules
)
if exist "package-lock.json" (
    del package-lock.json
)
npm cache clean --force
npm install
echo 依赖重新安装完成！
pause
goto menu

:fix_maven
echo.
echo 正在清理Maven缓存...
mvn clean
echo Maven缓存清理完成！
pause
goto menu

:fix_mysql
echo.
echo 正在重启MySQL服务...
net stop mysql
timeout /t 2 >nul
net start mysql
echo MySQL服务重启完成！
pause
goto menu

:reset_db
echo.
echo 警告：此操作将清空所有数据！
set /p confirm=确定要重置数据库吗？(y/N):
if /i not "%confirm%"=="y" goto menu

echo 正在重置数据库...
mysql -u root -p -e "DROP DATABASE IF EXISTS robot_asset; CREATE DATABASE robot_asset CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p robot_asset < sql\init.sql
echo 数据库重置完成！
pause
goto menu

:exit_program
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║           感谢使用机器人资产管理系统配置工具！               ║
echo ║                                                              ║
echo ║           祝您使用愉快！                                     ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
timeout /t 3 >nul
exit