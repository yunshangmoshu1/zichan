-- 机器人资产管理系统数据库初始化脚本

-- 创建数据库
CREATE DATABASE IF NOT EXISTS robot_asset CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE robot_asset;

-- 部门表
CREATE TABLE IF NOT EXISTS sys_department (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '部门ID',
    dept_name VARCHAR(50) NOT NULL COMMENT '部门名称',
    dept_code VARCHAR(50) NOT NULL UNIQUE COMMENT '部门编码',
    parent_id BIGINT DEFAULT 0 COMMENT '父级部门ID',
    leader VARCHAR(50) COMMENT '负责人',
    phone VARCHAR(20) COMMENT '联系电话',
    email VARCHAR(100) COMMENT '邮箱',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    sort_order INT DEFAULT 0 COMMENT '排序',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除'
) COMMENT '部门表';

-- 用户表
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) COMMENT '真实姓名',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    department_id BIGINT COMMENT '所属部门ID',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    avatar VARCHAR(200) COMMENT '头像URL',
    last_login_time DATETIME COMMENT '最后登录时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除'
) COMMENT '用户表';

-- 角色表
CREATE TABLE IF NOT EXISTS sys_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '角色ID',
    role_name VARCHAR(50) NOT NULL UNIQUE COMMENT '角色名称',
    role_code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
    description VARCHAR(200) COMMENT '角色描述',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除'
) COMMENT '角色表';

-- 权限表
CREATE TABLE IF NOT EXISTS sys_permission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '权限ID',
    permission_name VARCHAR(50) NOT NULL COMMENT '权限名称',
    permission_code VARCHAR(100) NOT NULL UNIQUE COMMENT '权限编码',
    menu_path VARCHAR(200) COMMENT '菜单路径',
    component_path VARCHAR(200) COMMENT '组件路径',
    icon VARCHAR(50) COMMENT '图标',
    parent_id BIGINT DEFAULT 0 COMMENT '父级权限ID',
    sort_order INT DEFAULT 0 COMMENT '排序',
    type TINYINT DEFAULT 1 COMMENT '类型：1-菜单，2-按钮',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除'
) COMMENT '权限表';

-- 用户角色关联表
CREATE TABLE IF NOT EXISTS sys_user_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_user_role (user_id, role_id)
) COMMENT '用户角色关联表';

-- 角色权限关联表
CREATE TABLE IF NOT EXISTS sys_role_permission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    role_id BIGINT NOT NULL COMMENT '角色ID',
    permission_id BIGINT NOT NULL COMMENT '权限ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_role_permission (role_id, permission_id)
) COMMENT '角色权限关联表';

-- 机器人资产表
CREATE TABLE IF NOT EXISTS robot_asset (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '资产ID',
    asset_no VARCHAR(50) NOT NULL UNIQUE COMMENT '资产编号',
    asset_name VARCHAR(100) NOT NULL COMMENT '资产名称',
    robot_type VARCHAR(50) COMMENT '机器人类型',
    brand VARCHAR(50) COMMENT '品牌',
    model VARCHAR(50) COMMENT '型号',
    serial_no VARCHAR(100) COMMENT '序列号',
    purchase_date DATE COMMENT '购入日期',
    purchase_price DECIMAL(15,2) COMMENT '购入价格',
    supplier VARCHAR(100) COMMENT '供应商',
    warranty_end_date DATE COMMENT '保修到期日',
    department_id BIGINT COMMENT '所属部门ID',
    storage_location VARCHAR(100) COMMENT '存放位置',
    current_status VARCHAR(20) DEFAULT 'IN_STOCK' COMMENT '当前状态：IN_STOCK-在库，USED-已领用，REPAIRING-维修中，SCRAPPED-已报废，TRANSFERRED-已调拨',
    responsible_person VARCHAR(50) COMMENT '责任人',
    qr_code_url VARCHAR(200) COMMENT '二维码URL',
    attachments JSON COMMENT '附件信息',
    description TEXT COMMENT '描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    INDEX idx_asset_no (asset_no),
    INDEX idx_robot_type (robot_type),
    INDEX idx_current_status (current_status),
    INDEX idx_department_id (department_id)
) COMMENT '机器人资产表';

-- 操作日志表
CREATE TABLE IF NOT EXISTS operation_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    module VARCHAR(50) COMMENT '操作模块',
    operation VARCHAR(50) COMMENT '操作类型',
    method VARCHAR(200) COMMENT '请求方法',
    url VARCHAR(500) COMMENT '请求URL',
    ip VARCHAR(50) COMMENT 'IP地址',
    user_agent VARCHAR(500) COMMENT '用户代理',
    user_id BIGINT COMMENT '操作用户ID',
    username VARCHAR(50) COMMENT '操作用户名',
    params TEXT COMMENT '请求参数',
    result TEXT COMMENT '响应结果',
    time_cost INT COMMENT '耗时(ms)',
    status TINYINT COMMENT '操作状态：1-成功，0-失败',
    error_msg TEXT COMMENT '错误信息',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间'
) COMMENT '操作日志表';

-- 数据字典表
CREATE TABLE IF NOT EXISTS data_dictionary (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '字典ID',
    dict_type VARCHAR(50) NOT NULL COMMENT '字典类型',
    dict_label VARCHAR(100) NOT NULL COMMENT '字典标签',
    dict_value VARCHAR(100) NOT NULL COMMENT '字典值',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    UNIQUE KEY uk_dict_type_value (dict_type, dict_value)
) COMMENT '数据字典表';

-- 初始化数据
-- 插入默认部门
INSERT IGNORE INTO sys_department (dept_name, dept_code, leader) VALUES 
('研发部', 'RD001', '张三'),
('生产部', 'PR001', '李四'),
('质量部', 'QA001', '王五'),
('采购部', 'PU001', '赵六');

-- 插入默认角色
INSERT IGNORE INTO sys_role (role_name, role_code, description) VALUES 
('超级管理员', 'ADMIN', '系统超级管理员'),
('资产管理员', 'ASSET_MANAGER', '资产管理专员'),
('部门主管', 'DEPARTMENT_MANAGER', '部门主管'),
('普通用户', 'USER', '普通用户');

-- 插入默认权限
INSERT IGNORE INTO sys_permission (permission_name, permission_code, menu_path, component_path, icon, parent_id, type) VALUES 
('系统管理', 'sys:manage', '/system', 'Layout', 'setting', 0, 1),
('用户管理', 'sys:user:list', '/system/user', '/system/user/index', 'user', 1, 1),
('角色管理', 'sys:role:list', '/system/role', '/system/role/index', 'role', 1, 1),
('资产管理', 'asset:manage', '/asset', 'Layout', 'goods', 0, 1),
('资产台账', 'asset:list', '/asset/list', '/asset/list/index', 'list', 4, 1),
('入库管理', 'stock:in:list', '/asset/in', '/asset/in/index', 'upload', 4, 1),
('出库管理', 'stock:out:list', '/asset/out', '/asset/out/index', 'download', 4, 1);

-- 插入默认用户（密码：admin123，实际应该加密存储）
INSERT IGNORE INTO sys_user (username, password, real_name, email, phone, department_id) VALUES 
('admin', '$2a$10$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', '管理员', 'admin@example.com', '13800138000', 1);

-- 插入用户角色关系
INSERT IGNORE INTO sys_user_role (user_id, role_id) VALUES (1, 1);

-- 插入数据字典
INSERT IGNORE INTO data_dictionary (dict_type, dict_label, dict_value, sort_order) VALUES 
('robot_type', '工业机器人', 'INDUSTRIAL_ROBOT', 1),
('robot_type', '协作机器人', 'COLLABORATIVE_ROBOT', 2),
('robot_type', 'AGV', 'AGV', 3),
('robot_type', '服务机器人', 'SERVICE_ROBOT', 4),
('asset_status', '在库', 'IN_STOCK', 1),
('asset_status', '已领用', 'USED', 2),
('asset_status', '维修中', 'REPAIRING', 3),
('asset_status', '已报废', 'SCRAPPED', 4),
('asset_status', '已调拨', 'TRANSFERRED', 5);

-- 插入测试资产数据
INSERT IGNORE INTO robot_asset (asset_no, asset_name, robot_type, brand, model, serial_no, purchase_date, purchase_price, supplier, warranty_end_date, department_id, storage_location, current_status) VALUES 
('RA202312010001', '六轴工业机器人', 'INDUSTRIAL_ROBOT', 'ABB', 'IRB6700', 'ABB6700-001', '2023-12-01', 150000.00, 'ABB中国', '2026-12-01', 2, 'A区-01', 'IN_STOCK'),
('RA202312010002', '协作机器人', 'COLLABORATIVE_ROBOT', 'UR', 'UR10e', 'UR10e-001', '2023-12-01', 80000.00, '优傲机器人', '2026-12-01', 2, 'A区-02', 'USED'),
('RA202312010003', 'AGV搬运机器人', 'AGV', '新松', 'SR-AGV100', 'SR100-001', '2023-12-01', 120000.00, '新松机器人', '2026-12-01', 2, 'B区-01', 'IN_STOCK');