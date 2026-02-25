package com.company.robot;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.company.robot.mapper")
public class RobotAssetApplication {

    public static void main(String[] args) {
        SpringApplication.run(RobotAssetApplication.class, args);
        System.out.println("机器人资产管理系统启动成功！");
    }
}