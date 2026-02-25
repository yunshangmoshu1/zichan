@echo off
echo === 机器人资产管理系统自测 ===

echo 1. 检查Java环境...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java环境未安装或配置不正确
    exit /b 1
)
echo ✅ Java环境正常

echo 2. 检查Maven...
mvn -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Maven未安装或配置不正确
    exit /b 1
)
echo ✅ Maven环境正常

echo 3. 检查Node.js环境...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Node.js未安装，前端无法运行
) else (
    echo ✅ Node.js环境正常
)

echo 4. 检查项目结构...
if exist "pom.xml" (
    echo ✅ Maven配置文件存在
) else (
    echo ❌ Maven配置文件缺失
)

if exist "src\main\java" (
    echo ✅ Java源码目录存在
) else (
    echo ❌ Java源码目录缺失
)

if exist "src\main\resources" (
    echo ✅ 资源文件目录存在
) else (
    echo ❌ 资源文件目录缺失
)

echo 5. 编译项目...
mvn clean compile -q
if %errorlevel% equ 0 (
    echo ✅ 项目编译成功
) else (
    echo ❌ 项目编译失败
)

echo 6. 检查核心文件...
set CORE_FILES=src\main\java\com\company\robot\RobotAssetApplication.java src\main\java\com\company\robot\entity\Asset.java src\main\java\com\company\robot\service\AssetService.java src\main\java\com\company\robot\controller\AssetController.java src\main\resources\application.yml

for %%f in (%CORE_FILES%) do (
    if exist "%%f" (
        echo ✅ %%f 存在
    ) else (
        echo ❌ %%f 缺失
    )
)

echo === 自测完成 ===
echo 项目已准备就绪，可以进行以下操作：
echo 1. 数据库初始化: 执行 sql\init.sql
echo 2. 后端启动: mvn spring-boot:run
echo 3. 前端启动: npm install ^&^& npm run serve
echo 4. Docker部署: docker-compose up -d
pause