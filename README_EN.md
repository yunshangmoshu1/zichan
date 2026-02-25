# Robot Asset Management System

> 🎯 **Beginner Guide**: If you're new to this system, please read [beginner_guide.md](beginner_guide.md) first, which contains detailed tutorials with illustrations!

## Project Overview

Robot Asset Management System is a complete enterprise-level asset management solution specifically designed for managing various types of robot equipment throughout their lifecycle. The system adopts a modern technical architecture, providing full-process management functions from asset procurement, warehousing, requisition, transfer, maintenance to retirement.

## Technical Architecture

### Backend Technology Stack
- **Spring Boot 3** - Core framework
- **MyBatis-Plus** - ORM framework
- **Spring Security + JWT** - Authentication and authorization
- **MySQL 8.0** - Main database
- **Redis** - Cache and session storage
- **Maven** - Project build tool

### Frontend Technology Stack
- **Vue 3** - Frontend framework
- **Element Plus** - UI component library
- **Pinia** - State management
- **Vue Router** - Routing management
- **Axios** - HTTP client
- **ECharts** - Data visualization

### Deployment Technology
- **Docker** - Containerized deployment
- **Nginx** - Reverse proxy and load balancing
- **Docker Compose** - Multi-container orchestration

## Key Features

### 📦 Asset Ledger Management
- Robot information CRUD operations
- Support for multiple robot types (Industrial robots, Collaborative robots, AGV, Service robots, etc.)
- Asset status tracking (In-stock, In-use, Under repair, Scrapped, Transferred)
- Batch import/export functionality
- QR code/barcode generation

### 📥 Warehousing Management
- Multiple inbound types (New purchase, Return, Repair return, Transfer inbound)
- Inbound order management and approval workflow
- Automatic asset status updates

### 📤 Outbound Management
- Multiple outbound types (Requisition, Transfer outbound, Repair outbound, Scrap outbound)
- Outbound approval workflow
- Responsible person and department management

### 🔄 Transfer Management
- Cross-department/cross-warehouse transfers
- Dual-party confirmation workflow
- Transfer history records

### 🔧 Maintenance Management
- Repair work orders
- Regular maintenance schedules
- Fault records and repair history

### 🗑️ Scrap Management
- Scrap applications and approvals
- Residual value assessment
- Scrap asset status management

### 📊 Data Statistics and Dashboard
- Asset overview dashboard
- Inbound/outbound trend analysis
- Department asset distribution statistics
- Warning and alert functions

## How to Use

### 🛠️ Environment Preparation

#### System Requirements
- **Operating System**: Windows 10+/Linux/macOS
- **Java Environment**: JDK 17 or higher
- **Frontend Environment**: Node.js 16+ and npm 8+
- **Database**: MySQL 8.0+
- **Cache Service**: Redis 6.0+ (optional)
- **Containerization**: Docker & Docker Compose (recommended for production)

### 🚀 Quick Deployment

#### Method 1: Local Development Deployment

**1. Clone project and enter directory**
```bash
git clone <project_url>
cd robot-asset-management
```

**2. Database initialization**
```bash
# Login to MySQL
mysql -u root -p

# Execute initialization script
source sql/init.sql
```
Or directly execute `sql/init.sql` file in MySQL client

**3. Configure backend environment**
```bash
# Modify database connection configuration
vim src/main/resources/application.yml

# Main configuration items:
# spring.datasource.url: jdbc:mysql://localhost:3306/robot_asset
# spring.datasource.username: root
# spring.datasource.password: your_password
```

**4. Start backend service**
```bash
# Compile project
mvn clean package

# Run application
mvn spring-boot:run

# Or run jar package directly
java -jar target/robot-asset-management-1.0.0.jar
```

**5. Start frontend service**
```bash
# Install dependencies
npm install

# Start development server
npm run serve
```

**6. Access system**
- Backend API: http://localhost:8080
- Frontend interface: http://localhost:8081
- API documentation: http://localhost:8080/swagger-ui.html

#### Method 2: Docker One-click Deployment

**1. Ensure Docker environment**
```bash
docker --version
docker-compose --version
```

**2. One-click deployment**
```bash
# Build and start all services
docker-compose up -d

# View service status
docker-compose ps

# View real-time logs
docker-compose logs -f
```

**3. System access**
- Web interface: http://localhost
- Backend API: http://localhost:8080
- Database: localhost:3306
- Redis: localhost:6379

### 🛠️ Environment Configuration Tools

We provide multiple environment configuration solutions:

| Solution Type | Tool Name | Target Users | Features | Recommendation |
|---------------|-----------|--------------|----------|----------------|
| **Traditional** | [one_click_setup.bat](one_click_setup.bat) | Complete beginners | Graphical menu, full guidance | ⭐⭐⭐⭐⭐ |
| **Traditional** | [quick_setup.bat](quick_setup.bat) | Users with basic knowledge | Command line automation | ⭐⭐⭐⭐ |
| **Traditional** | [test.bat](test.bat) | Technical personnel | Pure detection tool | ⭐⭐⭐ |
| **Virtual Env** | [conda_setup.bat](conda_setup.bat) | Developers | Conda virtual environment management | ⭐⭐⭐⭐⭐ |
| **Enhanced** | [enhanced_setup.bat](enhanced_setup.bat) | Enhanced error handling version | Improved error handling | ⭐⭐⭐⭐ |
| **Emergency** | [emergency_setup.bat](emergency_setup.bat) | Simplified configuration tool | Minimalist approach | ⭐⭐⭐ |
| **Stable** | [anti_freeze_setup.bat](anti_freeze_setup.bat) | Stability enhancement version | Enhanced stability | ⭐⭐⭐⭐ |
| **Diagnostic** | [diagnostic_tool.bat](diagnostic_tool.bat) | Precise diagnostic tool | Accurate problem diagnosis | ⭐⭐⭐⭐ |

### 🚀 Fastest Startup
Double-click `test.bat` in the project root directory to automatically detect environment!

## API Documentation
The system integrates Swagger API documentation, accessible after startup at: http://localhost:8080/swagger-ui.html

## Default Account
- **Username**: admin
- **Password**: admin123
- **Role**: Super Administrator

> ⚠️ **Security Reminder**: Please change the default password in production environments!

## Project Structure
```
robot-asset-management/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/company/robot/
│   │   │       ├── RobotAssetApplication.java
│   │   │       ├── config/          # Configuration classes
│   │   │       ├── controller/      # Controller layer
│   │   │       ├── service/         # Service layer
│   │   │       ├── mapper/          # Data access layer
│   │   │       ├── entity/          # Entity classes
│   │   │       ├── vo/              # View objects
│   │   │       └── common/          # Common components
│   │   └── resources/
│   │       ├── application.yml      # Configuration file
│   │       └── mapper/              # MyBatis mapping files
├── frontend/                        # Frontend project
├── docker-compose.yml              # Docker orchestration file
├── Dockerfile                      # Backend Dockerfile
└── frontend.Dockerfile             # Frontend Dockerfile
```

## License
MIT License