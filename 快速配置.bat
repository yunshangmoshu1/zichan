@echo off
chcp 65001 >nul
title 快速环境配置
color 0A

echo ================================
echo   机器人资产管理系统快速配置
echo ================================
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  建议以管理员身份运行此脚本
    echo 右键点击此文件，选择"以管理员身份运行"
    echo.
)

:: 自动检测和配置
echo 正在自动配置环境...

:: 检查并设置环境变量
echo 1. 检查Java环境...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未找到Java，请先安装Java 17+
    echo 下载地址：https://www.oracle.com/java/technologies/downloads/
    pause
    exit /b 1
) else (
    echo ✅ Java环境正常
)

echo 2. 检查Maven...
mvn -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未找到Maven，请先安装Maven
    echo 下载地址：https://maven.apache.org/download.cgi
    pause
    exit /b 1
) else (
    echo ✅ Maven环境正常
)

echo 3. 检查MySQL服务...
sc query mysql >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  MySQL服务未启动，正在尝试启动...
    net start mysql >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ MySQL服务启动成功
    ) else (
        echo ❌ MySQL服务启动失败
        echo 请手动启动MySQL服务后再运行此脚本
        pause
        exit /b 1
    )
) else (
    echo ✅ MySQL服务运行中
)

echo 4. 配置数据库...
set /p mysql_root_pwd=请输入MySQL root密码（直接回车跳过自动配置）：
if defined mysql_root_pwd (
    echo 正在创建数据库...
    mysql -u root -p%mysql_root_pwd% -e "CREATE DATABASE IF NOT EXISTS robot_asset CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ 数据库创建成功
        echo 正在初始化数据...
        mysql -u root -p%mysql_root_pwd% robot_asset < sql\init.sql >nul 2>&1
        if %errorlevel% equ 0 (
            echo ✅ 数据初始化完成
        ) else (
            echo ⚠️  数据初始化可能有问题，请手动执行 sql/init.sql
        )
    ) else (
        echo ❌ 数据库创建失败，请检查密码是否正确
    )
) else (
    echo 跳过自动数据库配置
    echo 请手动执行 sql/init.sql 文件
)

echo 5. 检查前端环境...
node -v >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Node.js环境正常
    if not exist "node_modules" (
        echo 正在安装前端依赖...
        npm install >nul 2>&1
        if %errorlevel% equ 0 (
            echo ✅ 前端依赖安装完成
        ) else (
            echo ❌ 前端依赖安装失败
        )
    ) else (
        echo ✅ 前端依赖已安装
    )
) else (
    echo ⚠️  未找到Node.js，前端功能受限
)

echo.
echo ================================
echo     环境配置完成！
echo ================================
echo.
echo 现在您可以：
echo 1. 双击 test.bat 进行最终测试
echo 2. 运行 mvn spring-boot:run 启动后端
echo 3. 运行 npm run serve 启动前端
echo.
echo 默认登录：admin / admin123
echo.
echo 按任意键退出...
pause >nul