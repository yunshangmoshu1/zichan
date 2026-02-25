#!/bin/bash
# 机器人资产管理系统自测脚本

echo "=== 机器人资产管理系统自测 ==="

# 检查Java环境
echo "1. 检查Java环境..."
java -version
if [ $? -ne 0 ]; then
    echo "❌ Java环境未安装或配置不正确"
    exit 1
fi
echo "✅ Java环境正常"

# 检查Maven
echo "2. 检查Maven..."
mvn -v
if [ $? -ne 0 ]; then
    echo "❌ Maven未安装或配置不正确"
    exit 1
fi
echo "✅ Maven环境正常"

# 检查Node.js环境
echo "3. 检查Node.js环境..."
node -v
if [ $? -ne 0 ]; then
    echo "⚠️  Node.js未安装，前端无法运行"
else
    echo "✅ Node.js环境正常"
fi

# 检查项目结构
echo "4. 检查项目结构..."
if [ -f "pom.xml" ]; then
    echo "✅ Maven配置文件存在"
else
    echo "❌ Maven配置文件缺失"
fi

if [ -d "src/main/java" ]; then
    echo "✅ Java源码目录存在"
else
    echo "❌ Java源码目录缺失"
fi

if [ -d "src/main/resources" ]; then
    echo "✅ 资源文件目录存在"
else
    echo "❌ 资源文件目录缺失"
fi

# 编译测试
echo "5. 编译项目..."
mvn clean compile -q
if [ $? -eq 0 ]; then
    echo "✅ 项目编译成功"
else
    echo "❌ 项目编译失败"
fi

# 检查必要文件
echo "6. 检查核心文件..."
CORE_FILES=(
    "src/main/java/com/company/robot/RobotAssetApplication.java"
    "src/main/java/com/company/robot/entity/Asset.java"
    "src/main/java/com/company/robot/service/AssetService.java"
    "src/main/java/com/company/robot/controller/AssetController.java"
    "src/main/resources/application.yml"
)

for file in "${CORE_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file 存在"
    else
        echo "❌ $file 缺失"
    fi
done

echo "=== 自测完成 ==="
echo "项目已准备就绪，可以进行以下操作："
echo "1. 数据库初始化: 执行 sql/init.sql"
echo "2. 后端启动: mvn spring-boot:run"
echo "3. 前端启动: npm install && npm run serve"
echo "4. Docker部署: docker-compose up -d"