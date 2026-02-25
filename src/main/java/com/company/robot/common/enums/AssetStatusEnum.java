package com.company.robot.common.enums;

import lombok.Getter;

/**
 * 资产状态枚举
 */
@Getter
public enum AssetStatusEnum {
    
    IN_STOCK("IN_STOCK", "在库"),
    USED("USED", "已领用"),
    REPAIRING("REPAIRING", "维修中"),
    SCRAPPED("SCRAPPED", "已报废"),
    TRANSFERRED("TRANSFERRED", "已调拨");
    
    private final String code;
    private final String desc;
    
    AssetStatusEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }
    
    public static AssetStatusEnum getByCode(String code) {
        for (AssetStatusEnum status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        return null;
    }
}