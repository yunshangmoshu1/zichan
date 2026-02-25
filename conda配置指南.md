# 机器人资产管理系统 - Conda环境配置指南

## 🐍 Conda环境配置优势

使用Conda配置虚拟环境的优势：
- ✅ 统一管理所有依赖包
- ✅ 避免版本冲突
- ✅ 一键安装所有必需组件
- ✅ 环境隔离，不影响系统其他项目
- ✅ 跨平台兼容性好

## 🚀 快速开始

### 1. 安装Anaconda/Miniconda
如果还没有安装Conda，请先下载安装：
- **Anaconda**（推荐新手）：https://www.anaconda.com/products/distribution
- **Miniconda**（轻量版）：https://docs.conda.io/en/latest/miniconda.html

### 2. 创建项目环境
```bash
# 克隆项目
git clone <项目地址>
cd robot-asset-management

# 创建conda环境
conda env create -f environment.yml

# 激活环境
conda activate robot-asset
```

### 3. 启动系统
```bash
# 启动后端
mvn spring-boot:run

# 启动前端（新终端窗口）
npm run serve
```

## 📦 environment.yml 文件内容

```yaml
name: robot-asset
channels:
  - conda-forge
  - defaults
dependencies:
  # Java环境
  - openjdk=17
  - maven
  
  # 数据库工具
  - mysql-client
  - mysql-server
  
  # Node.js环境
  - nodejs=16
  - npm
  
  # Python工具（用于脚本）
  - python=3.9
  - pip
  
  # 开发工具
  - curl
  - git
  - vim
  
  # 数据库管理
  - redis
  
  # pip packages
  - pip:
    - mysql-connector-python
    - requests
    - pyyaml
```

## 🛠️ 环境管理命令

```bash
# 查看所有环境
conda env list

# 激活环境
conda activate robot-asset

# 退出环境
conda deactivate

# 删除环境
conda env remove -n robot-asset

# 更新环境配置
conda env update -f environment.yml

# 导出环境配置
conda env export > environment.yml
```

## 🎯 简化版配置脚本

创建一个一键配置脚本：