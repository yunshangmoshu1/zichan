package com.company.robot.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.company.robot.common.annotation.LogAnnotation;
import com.company.robot.entity.Asset;
import com.company.robot.service.AssetService;
import com.company.robot.vo.AssetVO;
import com.company.robot.vo.ResponseVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * 资产管理控制器
 */
@RestController
@RequestMapping("/api/assets")
@Api(tags = "资产管理")
public class AssetController {
    
    @Autowired
    private AssetService assetService;
    
    @GetMapping("/page")
    @ApiOperation("分页查询资产列表")
    public ResponseVO<IPage<AssetVO>> getAssetPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String robotType,
            @RequestParam(required = false) String status) {
        
        IPage<AssetVO> page = assetService.getAssetPage(pageNum, pageSize, keyword, robotType, status);
        return ResponseVO.success(page);
    }
    
    @GetMapping("/{id}")
    @ApiOperation("根据ID查询资产详情")
    public ResponseVO<AssetVO> getAssetById(@PathVariable Long id) {
        AssetVO asset = assetService.getById(id);
        return ResponseVO.success(asset);
    }
    
    @PostMapping
    @ApiOperation("添加资产")
    @LogAnnotation(module = "资产管理", operation = "添加资产")
    public ResponseVO<Boolean> addAsset(@Valid @RequestBody Asset asset) {
        boolean result = assetService.addAsset(asset);
        return ResponseVO.success(result);
    }
    
    @PutMapping
    @ApiOperation("更新资产")
    @LogAnnotation(module = "资产管理", operation = "更新资产")
    public ResponseVO<Boolean> updateAsset(@Valid @RequestBody Asset asset) {
        boolean result = assetService.updateAsset(asset);
        return ResponseVO.success(result);
    }
    
    @DeleteMapping("/{id}")
    @ApiOperation("删除资产")
    @LogAnnotation(module = "资产管理", operation = "删除资产")
    public ResponseVO<Boolean> deleteAsset(@PathVariable Long id) {
        boolean result = assetService.deleteAsset(id);
        return ResponseVO.success(result);
    }
    
    @GetMapping("/no/{assetNo}")
    @ApiOperation("根据资产编号查询")
    public ResponseVO<AssetVO> getAssetByNo(@PathVariable String assetNo) {
        AssetVO asset = assetService.getAssetByNo(assetNo);
        return ResponseVO.success(asset);
    }
}