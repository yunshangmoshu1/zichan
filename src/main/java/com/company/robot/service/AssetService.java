package com.company.robot.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.company.robot.entity.Asset;
import com.company.robot.vo.AssetVO;

/**
 * 资产服务接口
 */
public interface AssetService extends IService<Asset> {
    
    /**
     * 分页查询资产列表
     */
    IPage<AssetVO> getAssetPage(Integer pageNum, Integer pageSize, String keyword, 
                               String robotType, String status);
    
    /**
     * 添加资产
     */
    boolean addAsset(Asset asset);
    
    /**
     * 更新资产
     */
    boolean updateAsset(Asset asset);
    
    /**
     * 删除资产
     */
    boolean deleteAsset(Long id);
    
    /**
     * 根据资产编号查询
     */
    AssetVO getAssetByNo(String assetNo);
    
    /**
     * 生成资产编号
     */
    String generateAssetNo();
}