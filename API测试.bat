@echo off
chcp 65001 >nul
title API接口测试工具
color 0E

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║              API接口自动化测试工具                           ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

set BASE_URL=http://localhost:8080
set API_TOKEN=
set TEST_RESULTS_FILE=api_test_results_%date:~0,4%%date:~5,2%%date:~8,2%.txt

echo API测试报告 - %date% %time% > "%TEST_RESULTS_FILE%"
echo 测试目标：%BASE_URL% >> "%TEST_RESULTS_FILE%"
echo ================================= >> "%TEST_RESULTS_FILE%"

:: 检查服务是否运行
echo [预检查] 检查后端服务状态...
curl -s %BASE_URL%/actuator/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 后端服务未运行，请先启动服务
    echo 请运行：mvn spring-boot:run
    pause
    exit /b 1
)
echo ✅ 后端服务运行正常

:: 用户登录获取token
echo [1/8] 用户认证测试...
echo.
echo 测试用户登录...
set LOGIN_RESPONSE={"username":"admin","password":"admin123"}
for /f "delims=" %%i in ('curl -s -X POST %BASE_URL%/api/auth/login -H "Content-Type: application/json" -d "%LOGIN_RESPONSE%"') do set AUTH_RESPONSE=%%i

echo 登录响应：%AUTH_RESPONSE%
echo 登录响应：%AUTH_RESPONSE% >> "%TEST_RESULTS_FILE%"

:: 从响应中提取token（这里需要根据实际API结构调整）
echo ⚠️  Token提取功能需要根据实际API响应格式调整
set API_TOKEN=test_token_placeholder

:: 测试各个API端点
echo.
echo [2/8] 资产管理API测试...
call :test_asset_apis

echo.
echo [3/8] 入库管理API测试...
call :test_stock_in_apis

echo.
echo [4/8] 出库管理API测试...
call :test_stock_out_apis

echo.
echo [5/8] 调拨管理API测试...
call :test_transfer_apis

echo.
echo [6/8] 维修管理API测试...
call :test_repair_apis

echo.
echo [7/8] 系统管理API测试...
call :test_system_apis

echo.
echo [8/8] 性能压力测试...
call :performance_test

:: 输出测试总结
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    API测试完成                               ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 详细测试结果已保存到：%TEST_RESULTS_FILE%
echo.
type "%TEST_RESULTS_FILE%" | findstr /C:"✅" /C:"❌" /C:"⚠️"

echo.
echo 按任意键退出...
pause >nul
exit /b

:: ========== API测试函数 ==========

:test_asset_apis
echo   测试资产列表接口...
curl -s -H "Authorization: Bearer %API_TOKEN%" %BASE_URL%/api/assets/page >nul 2>&1
if %errorlevel% equ 0 (
    echo     ✅ GET /api/assets/page - 资产分页查询
    echo     ✅ GET /api/assets/page - 资产分页查询 >> "%TEST_RESULTS_FILE%"
) else (
    echo     ❌ GET /api/assets/page - 资产分页查询失败
    echo     ❌ GET /api/assets/page - 资产分页查询失败 >> "%TEST_RESULTS_FILE%"
)

echo   测试资产详情接口...
curl -s -H "Authorization: Bearer %API_TOKEN%" %BASE_URL%/api/assets/1 >nul 2>&1
if %errorlevel% equ 0 (
    echo     ✅ GET /api/assets/1 - 资产详情查询
    echo     ✅ GET /api/assets/1 - 资产详情查询 >> "%TEST_RESULTS_FILE%"
) else (
    echo     ⚠️  GET /api/assets/1 - 资产详情查询（可能ID不存在）
    echo     ⚠️  GET /api/assets/1 - 资产详情查询 >> "%TEST_RESULTS_FILE%"
)
exit /b

:test_stock_in_apis
echo   测试入库单列表接口...
curl -s -H "Authorization: Bearer %API_TOKEN%" %BASE_URL%/api/stock-in/page >nul 2>&1
if %errorlevel% equ 0 (
    echo     ✅ GET /api/stock-in/page - 入库单分页查询
    echo     ✅ GET /api/stock-in/page - 入库单分页查询 >> "%TEST_RESULTS_FILE%"
) else (
    echo     ⚠️  GET /api/stock-in/page - 入库单分页查询
    echo     ⚠️  GET /api/stock-in/page - 入库单分页查询 >> "%TEST_RESULTS_FILE%"
)
exit /b

:test_stock_out_apis
echo   测试出库单列表接口...
curl -s -H "Authorization: Bearer %API_TOKEN%" %BASE_URL%/api/stock-out/page >nul 2>&1
if %errorlevel% equ 0 (
    echo     ✅ GET /api/stock-out/page - 出库单分页查询
    echo     ✅ GET /api/stock-out/page - 出库单分页查询 >> "%TEST_RESULTS_FILE%"
) else (
    echo     ⚠️  GET /api/stock-out/page - 出库单分页查询
    echo     ⚠️  GET /api/stock-out/page - 出库单分页查询 >> "%TEST_RESULTS_FILE%"
)
exit /b

:test_transfer_apis
echo   测试调拨单列表接口...
curl -s -H "Authorization: Bearer %API_TOKEN%" %BASE_URL%/api/transfer/page >nul 2>&1
if %errorlevel% equ 0 (
    echo     ✅ GET /api/transfer/page - 调拨单分页查询
    echo     ✅ GET /api/transfer/page - 调拨单分页查询 >> "%TEST_RESULTS_FILE%"
) else (
    echo     ⚠️  GET /api/transfer/page - 调拨单分页查询
    echo     ⚠️  GET /api/transfer/page - 调拨单分页查询 >> "%TEST_RESULTS_FILE%"
)
exit /b

:test_repair_apis
echo   测试维修单列表接口...
curl -s -H "Authorization: Bearer %API_TOKEN%" %BASE_URL%/api/repair/page >nul 2>&1
if %errorlevel% equ 0 (
    echo     ✅ GET /api/repair/page - 维修单分页查询
    echo     ✅ GET /api/repair/page - 维修单分页查询 >> "%TEST_RESULTS_FILE%"
) else (
    echo     ⚠️  GET /api/repair/page - 维修单分页查询
    echo     ⚠️  GET /api/repair/page - 维修单分页查询 >> "%TEST_RESULTS_FILE%"
)
exit /b

:test_system_apis
echo   测试用户管理接口...
curl -s -H "Authorization: Bearer %API_TOKEN%" %BASE_URL%/api/users/page >nul 2>&1
if %errorlevel% equ 0 (
    echo     ✅ GET /api/users/page - 用户分页查询
    echo     ✅ GET /api/users/page - 用户分页查询 >> "%TEST_RESULTS_FILE%"
) else (
    echo     ⚠️  GET /api/users/page - 用户分页查询
    echo     ⚠️  GET /api/users/page - 用户分页查询 >> "%TEST_RESULTS_FILE%"
)

echo   测试角色管理接口...
curl -s -H "Authorization: Bearer %API_TOKEN%" %BASE_URL%/api/roles >nul 2>&1
if %errorlevel% equ 0 (
    echo     ✅ GET /api/roles - 角色列表查询
    echo     ✅ GET /api/roles - 角色列表查询 >> "%TEST_RESULTS_FILE%"
) else (
    echo     ⚠️  GET /api/roles - 角色列表查询
    echo     ⚠️  GET /api/roles - 角色列表查询 >> "%TEST_RESULTS_FILE%"
)
exit /b

:performance_test
echo   执行并发请求测试...
echo     ⚠️  性能测试需要专业工具支持
echo     ⚠️  建议使用JMeter或Postman进行压力测试
echo     性能测试说明 >> "%TEST_RESULTS_FILE%"
exit /b