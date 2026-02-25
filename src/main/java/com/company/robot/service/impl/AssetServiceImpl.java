package com.company.robot.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.company.robot.common.enums.AssetStatusEnum;
import com.company.robot.entity.Asset;
import com.company.robot.mapper.AssetMapper;
import com.company.robot.service.AssetService;
import com.company.robot.vo.AssetVO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * 资产服务实现类
 */
@Service
@Transactional
public class AssetServiceImpl extends ServiceImpl<AssetMapper, Asset> implements AssetService {
    
    @Value("${system.asset-no-prefix:RA}")
    private String assetNoPrefix;
    
    @Override
    public IPage<AssetVO> getAssetPage(Integer pageNum, Integer pageSize, String keyword, 
                                      String robotType, String status) {
        Page<AssetVO> page = new Page<>(pageNum, pageSize);
        return baseMapper.selectAssetPage(page, keyword, robotType, status);
    }
    
    @Override
    public boolean addAsset(Asset asset) {
        // 生成资产编号
        if (asset.getAssetNo() == null || asset.getAssetNo().isEmpty()) {
            asset.setAssetNo(generateAssetNo());
        }
        
        // 设置默认状态
        if (asset.getCurrentStatus() == null) {
            asset.setCurrentStatus(AssetStatusEnum.IN_STOCK.getCode());
        }
        
        // 设置购入日期默认值
        if (asset.getPurchaseDate() == null) {
            asset.setPurchaseDate(LocalDate.now());
        }
        
        return save(asset);
    }
    
    @Override
    public boolean updateAsset(Asset asset) {
        return updateById(asset);
    }
    
    @Override
    public boolean deleteAsset(Long id) {
        return removeById(id);
    }
    
    @Override
    public AssetVO getAssetByNo(String assetNo) {
        return baseMapper.selectByAssetNo(assetNo);
    }
    
    @Override
    public String generateAssetNo() {
        // 生成资产编号：前缀 + 年月日 + 4位序号
        String dateStr = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String prefix = assetNoPrefix + dateStr;
        
        // 查询当天最大序号
        LambdaQueryWrapper<Asset> wrapper = new LambdaQueryWrapper<>();
        wrapper.likeRight(Asset::getAssetNo, prefix);
        wrapper.orderByDesc(Asset::getAssetNo);
        wrapper.last("LIMIT 1");
        
        Asset latestAsset = getOne(wrapper);
        int nextSeq = 1;
        
        if (latestAsset != null && latestAsset.getAssetNo() != null) {
            String latestNo = latestAsset.getAssetNo();
            String seqStr = latestNo.substring(prefix.length());
            try {
                nextSeq = Integer.parseInt(seqStr) + 1;
            } catch (NumberFormatException e) {
                nextSeq = 1;
            }
        }
        
        return String.format("%s%04d", prefix, nextSeq);
    }
}