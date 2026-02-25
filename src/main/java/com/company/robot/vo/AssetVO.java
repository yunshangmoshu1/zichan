package com.company.robot.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 资产VO类
 */
@Data
public class AssetVO {
    
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
    
    private String departmentName;
    
    private String storageLocation;
    
    private String currentStatus;
    
    private String responsiblePerson;
    
    private String qrCodeUrl;
    
    private String attachments;
    
    private String description;
    
    private LocalDateTime createTime;
    
    private LocalDateTime updateTime;
}