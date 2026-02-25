package com.company.robot.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 机器人资产实体类
 */
@Data
@TableName("robot_asset")
public class Asset {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String assetNo;
    
    private String assetName;
    
    private String robotType;
    
    private String brand;
    
    private String model;
    
    private String serialNo;
    
    private LocalDate purchaseDate;
    
    private BigDecimal purchasePrice;
    
    private String supplier;
    
    private LocalDate warrantyEndDate;
    
    private Long departmentId;
    
    private String storageLocation;
    
    private String currentStatus;
    
    private String responsiblePerson;
    
    private String qrCodeUrl;
    
    private String attachments;
    
    private String description;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    @TableLogic
    private Integer deleted;
}