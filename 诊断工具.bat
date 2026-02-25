@echo off
chcp 65001 >nul
title 环境配置诊断工具
color 0C

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║              环境配置问题诊断工具                            ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 正在诊断环境配置问题...
echo.

:: 1. 检查基本命令
echo [诊断1] 检查基本系统命令...
echo 测试echo命令...
echo ✅ Echo命令正常
echo.

echo 测试chcp命令...
chcp 65001 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ CHCP命令正常
) else (
    echo ❌ CHCP命令异常
)
echo.

:: 2. 检查环境变量
echo [诊断2] 检查系统环境变量...
echo 当前工作目录：%cd%
echo 系统盘符：%SystemDrive%
echo 用户名：%USERNAME%
echo.

:: 3. 逐项检查可能的问题点
echo [诊断3] 逐一测试关键命令...

echo 测试java命令...
java -version >nul 2>&1
set JAVA_RESULT=%errorlevel%
echo Java命令返回码：%JAVA_RESULT%

echo 测试mvn命令...
mvn -v >nul 2>&1
set MVN_RESULT=%errorlevel%
echo Maven命令返回码：%MVN_RESULT%

echo 测试node命令...
node -v >nul 2>&1
set NODE_RESULT=%errorlevel%
echo Node命令返回码：%NODE_RESULT%

echo 测试sc命令...
sc query mysql >nul 2>&1
set SC_RESULT=%errorlevel%
echo SC命令返回码：%SC_RESULT%
echo.

:: 4. 详细错误分析
echo [诊断4] 错误原因分析...
echo.

if %JAVA_RESULT% neq 0 (
    echo ⚠️  Java环境问题：
    echo    - Java可能未安装
    echo    - Java路径未添加到系统环境变量
    echo    - 权限不足
    echo.
)

if %MVN_RESULT% neq 0 (
    echo ⚠️  Maven环境问题：
    echo    - Maven可能未安装
    echo    - MAVEN_HOME环境变量未设置
    echo    - Path中缺少Maven路径
    echo.
)

if %NODE_RESULT% neq 0 (
    echo ⚠️  Node.js环境问题：
    echo    - Node.js可能未安装
    echo    - Node.js路径未添加到系统环境变量
    echo.
)

if %SC_RESULT% neq 0 (
    echo ⚠️  服务管理问题：
    echo    - 可能没有管理员权限
    echo    - MySQL服务未安装
    echo.
)

:: 5. 提供解决方案
echo [诊断5] 解决方案建议...
echo.

echo 🔧 推荐解决方案：
echo 1. 以管理员身份运行配置工具
echo 2. 确保已安装所需软件（Java、Maven、Node.js、MySQL）
echo 3. 检查系统环境变量配置
echo 4. 使用应急配置工具作为替代方案
echo.

echo 🚀 快速修复选项：
echo 1. 运行应急配置.bat（简化版）
echo 2. 运行conda配置.bat（虚拟环境方案）
echo 3. 手动检查环境变量
echo.

:: 6. 生成诊断报告
set DIAGNOSTIC_REPORT=diagnostic_report_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt
echo 诊断报告 - %date% %time% > "%DIAGNOSTIC_REPORT%"
echo ================================= >> "%DIAGNOSTIC_REPORT%"
echo Java返回码：%JAVA_RESULT% >> "%DIAGNOSTIC_REPORT%"
echo Maven返回码：%MVN_RESULT% >> "%DIAGNOSTIC_REPORT%"
echo Node返回码：%NODE_RESULT% >> "%DIAGNOSTIC_REPORT%"
echo SC返回码：%SC_RESULT% >> "%DIAGNOSTIC_REPORT%"
echo 工作目录：%cd% >> "%DIAGNOSTIC_REPORT%"

echo.
echo 详细诊断报告已保存到：%DIAGNOSTIC_REPORT%
echo.

echo 按任意键查看详细报告内容...
pause >nul
echo.
echo === 诊断报告内容 ===
type "%DIAGNOSTIC_REPORT%"
echo.
echo ===================

echo.
echo 🎯 建议操作：
echo 1. 右键点击配置工具 → "以管理员身份运行"
echo 2. 或者使用应急配置.bat
echo 3. 或者使用conda配置.bat
echo.

echo 按任意键退出...
pause >nul
exit /b