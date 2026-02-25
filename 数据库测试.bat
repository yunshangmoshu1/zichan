@echo off
chcp 65001 >nul
title 数据库功能测试工具
color 0D

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║              数据库功能完整性测试                            ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

set DB_HOST=localhost
set DB_PORT=3306
set DB_NAME=robot_asset
set DB_USER=root
set DB_PASSWORD=
set DB_TEST_LOG=db_test_%date:~0,4%%date:~5,2%%date:~8,2%.log

echo 数据库测试报告 - %date% %time% > "%DB_TEST_LOG%"
echo 测试数据库：%DB_NAME% >> "%DB_TEST_LOG%"
echo ================================= >> "%DB_TEST_LOG%"

:: 获取数据库密码
set /p DB_PASSWORD=请输入MySQL root密码：

:: 1. 数据库连接测试
echo [1/7] 数据库连接测试
echo 数据库连接测试 >> "%DB_TEST_LOG%"

mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% -e "SELECT 1;" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 数据库连接成功
    echo ✅ 数据库连接成功 >> "%DB_TEST_LOG%"
) else (
    echo ❌ 数据库连接失败
    echo ❌ 数据库连接失败 >> "%DB_TEST_LOG%"
    goto :test_summary
)

:: 2. 数据库存在性检查
echo [2/7] 数据库存在性检查
echo 数据库存在性检查 >> "%DB_TEST_LOG%"

mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% -e "SHOW DATABASES LIKE '%DB_NAME%';" | findstr "%DB_NAME%" >nul
if %errorlevel% equ 0 (
    echo ✅ 数据库 %DB_NAME% 存在
    echo ✅ 数据库 %DB_NAME% 存在 >> "%DB_TEST_LOG%"
) else (
    echo ❌ 数据库 %DB_NAME% 不存在
    echo ❌ 数据库 %DB_NAME% 不存在 >> "%DB_TEST_LOG%"
)

:: 3. 核心表结构检查
echo [3/7] 核心表结构检查
echo 核心表结构检查 >> "%DB_TEST_LOG%"

set CORE_TABLES=robot_asset sys_user sys_role sys_permission sys_department
set TABLE_COUNT=0
set MISSING_TABLES=

for %%t in (%CORE_TABLES%) do (
    mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SHOW TABLES LIKE '%%t';" | findstr "%%t" >nul
    if %errorlevel% equ 0 (
        echo   ✅ 表 %%t 存在
        echo   ✅ 表 %%t 存在 >> "%DB_TEST_LOG%"
        set /a TABLE_COUNT+=1
    ) else (
        echo   ❌ 表 %%t 缺失
        echo   ❌ 表 %%t 缺失 >> "%DB_TEST_LOG%"
        set MISSING_TABLES=%MISSING_TABLES%,%%t
    )
)

echo 共找到 %TABLE_COUNT% 个核心表
echo 共找到 %TABLE_COUNT% 个核心表 >> "%DB_TEST_LOG%"

:: 4. 数据完整性检查
echo [4/7] 数据完整性检查
echo 数据完整性检查 >> "%DB_TEST_LOG%"

:: 检查用户数据
mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT COUNT(*) as user_count FROM sys_user;" > temp_result.txt 2>nul
for /f "skip=1" %%i in (temp_result.txt) do set USER_COUNT=%%i
del temp_result.txt >nul 2>&1

if defined USER_COUNT (
    echo   ✅ 用户表记录数：%USER_COUNT%
    echo   ✅ 用户表记录数：%USER_COUNT% >> "%DB_TEST_LOG%"
) else (
    echo   ⚠️  无法获取用户表记录数
    echo   ⚠️  无法获取用户表记录数 >> "%DB_TEST_LOG%"
)

:: 检查资产数据
mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT COUNT(*) as asset_count FROM robot_asset;" > temp_result.txt 2>nul
for /f "skip=1" %%i in (temp_result.txt) do set ASSET_COUNT=%%i
del temp_result.txt >nul 2>&1

if defined ASSET_COUNT (
    echo   ✅ 资产表记录数：%ASSET_COUNT%
    echo   ✅ 资产表记录数：%ASSET_COUNT% >> "%DB_TEST_LOG%"
) else (
    echo   ⚠️  无法获取资产表记录数
    echo   ⚠️  无法获取资产表记录数 >> "%DB_TEST_LOG%"
)

:: 5. 索引检查
echo [5/7] 数据库索引检查
echo 数据库索引检查 >> "%DB_TEST_LOG%"

mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SHOW INDEX FROM robot_asset;" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ 资产表索引正常
    echo   ✅ 资产表索引正常 >> "%DB_TEST_LOG%"
) else (
    echo   ⚠️  资产表索引检查异常
    echo   ⚠️  资产表索引检查异常 >> "%DB_TEST_LOG%"
)

:: 6. 外键约束检查
echo [6/7] 外键约束检查
echo 外键约束检查 >> "%DB_TEST_LOG%"

mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT COUNT(*) as fk_count FROM information_schema.KEY_COLUMN_USAGE WHERE REFERENCED_TABLE_SCHEMA='%DB_NAME%' AND REFERENCED_TABLE_NAME IS NOT NULL;" > temp_result.txt 2>nul
for /f "skip=1" %%i in (temp_result.txt) do set FK_COUNT=%%i
del temp_result.txt >nul 2>&1

if defined FK_COUNT (
    echo   ✅ 外键约束数量：%FK_COUNT%
    echo   ✅ 外键约束数量：%FK_COUNT% >> "%DB_TEST_LOG%"
) else (
    echo   ⚠️  外键约束检查异常
    echo   ⚠️  外键约束检查异常 >> "%DB_TEST_LOG%"
)

:: 7. 性能参数检查
echo [7/7] 数据库性能参数检查
echo 数据库性能参数检查 >> "%DB_TEST_LOG%"

mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size';" > temp_result.txt 2>nul
type temp_result.txt
type temp_result.txt >> "%DB_TEST_LOG%"
del temp_result.txt >nul 2>&1

:test_summary
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    数据库测试完成                            ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 详细测试结果已保存到：%DB_TEST_LOG%
echo.
echo 按任意键查看测试摘要...
pause >nul

:: 显示测试摘要
echo.
echo === 数据库测试摘要 ===
type "%DB_TEST_LOG%" | findstr /C:"✅" /C:"❌" /C:"⚠️"
echo.
echo 完整日志：%DB_TEST_LOG%

echo.
echo 按任意键退出...
pause >nul
exit /b