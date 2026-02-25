@echo off
chcp 65001 >nul
title 应急环境配置工具
color 0C

echo ================================
echo   应急环境配置工具
echo   （解决卡死问题专用）
echo ================================
echo.

:: 立即检查基本环境
echo 正在快速检测环境...

echo 1. 检查Java...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java未安装或配置错误
    echo 请先安装Java 17+
    echo 下载地址：https://www.oracle.com/java/technologies/downloads/
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ Java正常

echo 2. 检查Maven...
mvn -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Maven未安装或配置错误
    echo 请先安装Maven
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ Maven正常

echo 3. 检查MySQL服务...
sc query mysql >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  MySQL服务未安装或未启动
    echo 请手动启动MySQL服务
    timeout /t 3 >nul
) else (
    echo ✅ MySQL服务正常
)

echo.
echo 环境检测完成！

:: 提供简单选项
echo.
echo 请选择要执行的操作：
echo 1. 启动后端服务
echo 2. 启动前端服务  
echo 3. 配置数据库
echo 4. 退出
echo.

set /p choice=请输入选项（1-4）：

if "%choice%"=="1" (
    echo 正在启动后端服务...
    echo 请勿关闭此窗口
    echo 访问地址：http://localhost:8080
    echo.
    mvn spring-boot:run
) else if "%choice%"=="2" (
    echo 正在启动前端服务...
    echo 请勿关闭此窗口
    echo 访问地址：http://localhost:8081
    echo.
    if not exist "node_modules" (
        echo 首次运行，正在安装依赖...
        npm install
    )
    npm run serve
) else if "%choice%"=="3" (
    echo 配置数据库...
    set /p pwd=请输入MySQL root密码：
    if defined pwd (
        mysql -u root -p%pwd% -e "CREATE DATABASE IF NOT EXISTS robot_asset CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
        mysql -u root -p%pwd% robot_asset < sql\init.sql
        echo 数据库配置完成
    ) else (
        echo 跳过数据库配置
    )
    timeout /t 3 >nul
) else (
    echo 程序退出
)

echo.
echo 按任意键结束...
pause >nul