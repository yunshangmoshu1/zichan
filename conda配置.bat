@echo off
chcp 65001 >nul
title Conda环境配置工具
color 0A

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║           机器人资产管理系统 - Conda环境配置                 ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

:: 检查Conda是否安装
echo 检查Conda环境...
conda --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到Conda环境
    echo.
    echo 请先安装Anaconda或Miniconda：
    echo 🌐 Anaconda下载：https://www.anaconda.com/products/distribution
    echo 🌐 Miniconda下载：https://docs.conda.io/en/latest/miniconda.html
    echo.
    echo 安装完成后请重新运行此脚本
    pause
    exit /b 1
) else (
    echo ✅ Conda环境已安装
    for /f "delims=" %%i in ('conda --version') do set CONDA_VERSION=%%i
    echo    版本：%CONDA_VERSION%
)

echo.
echo 开始配置项目环境...

:: 检查environment.yml文件
if not exist "environment.yml" (
    echo ❌ 找不到environment.yml配置文件
    echo 请确保在项目根目录下运行此脚本
    pause
    exit /b 1
)

:: 创建或更新环境
echo.
echo [1/4] 创建/更新Conda环境...
echo 正在创建robot-asset环境，这可能需要几分钟时间...
conda env create -f environment.yml
if %errorlevel% neq 0 (
    echo ⚠️  环境创建失败，尝试更新现有环境...
    conda env update -f environment.yml
    if %errorlevel% neq 0 (
        echo ❌ 环境配置失败
        pause
        exit /b 1
    )
)

echo ✅ Conda环境配置完成

:: 激活环境并验证
echo.
echo [2/4] 验证环境配置...
call conda activate robot-asset

:: 检查关键组件
echo 检查Java环境...
java -version >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Java环境正常
) else (
    echo   ❌ Java环境异常
)

echo 检查Maven环境...
mvn -v >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Maven环境正常
) else (
    echo   ❌ Maven环境异常
)

echo 检查Node.js环境...
node -v >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Node.js环境正常
) else (
    echo   ❌ Node.js环境异常
)

:: 安装前端依赖
echo.
echo [3/4] 安装前端依赖...
if not exist "node_modules" (
    echo 正在安装Node.js依赖包...
    npm install --registry https://registry.npmmirror.com
    if %errorlevel% equ 0 (
        echo ✅ 前端依赖安装完成
    ) else (
        echo ⚠️  前端依赖安装可能有问题
    )
) else (
    echo ✅ 前端依赖已安装
)

:: 数据库初始化提示
echo.
echo [4/4] 数据库配置提示...
echo.
echo 请手动完成以下数据库配置：
echo 1. 启动MySQL服务
echo 2. 创建数据库：CREATE DATABASE robot_asset CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
echo 3. 执行初始化脚本：sql/init.sql
echo.
echo 或者运行：数据库测试.bat 来自动配置

:: 完成提示
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    环境配置完成！                            ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 现在您可以：
echo 1. 激活环境：conda activate robot-asset
echo 2. 启动后端：mvn spring-boot:run
echo 3. 启动前端：npm run serve
echo 4. 运行自检：全面自检.bat
echo.
echo 默认登录账号：admin / admin123
echo.
echo 按任意键退出...
pause >nul