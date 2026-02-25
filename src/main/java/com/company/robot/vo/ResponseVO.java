package com.company.robot.vo;

import lombok.Data;

/**
 * 统一响应结果封装
 */
@Data
public class ResponseVO<T> {
    
    private Integer code;
    private String message;
    private T data;
    
    public ResponseVO() {}
    
    public ResponseVO(Integer code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }
    
    public static <T> ResponseVO<T> success() {
        return new ResponseVO<>(200, "操作成功", null);
    }
    
    public static <T> ResponseVO<T> success(T data) {
        return new ResponseVO<>(200, "操作成功", data);
    }
    
    public static <T> ResponseVO<T> success(String message, T data) {
        return new ResponseVO<>(200, message, data);
    }
    
    public static <T> ResponseVO<T> error(String message) {
        return new ResponseVO<>(500, message, null);
    }
    
    public static <T> ResponseVO<T> error(Integer code, String message) {
        return new ResponseVO<>(code, message, null);
    }
}