package com.company.robot.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.company.robot.entity.Asset;
import com.company.robot.vo.AssetVO;
import org.apache.ibatis.annotations.Param;

/**
 * 资产Mapper接口
 */
public interface AssetMapper extends BaseMapper<Asset> {
    
    /**
     * 分页查询资产列表
     */
    IPage<AssetVO> selectAssetPage(Page<AssetVO> page, @Param("keyword") String keyword, 
                                   @Param("robotType") String robotType, @Param("status") String status);
    
    /**
     * 根据资产编号查询
     */
    AssetVO selectByAssetNo(@Param("assetNo") String assetNo);
}