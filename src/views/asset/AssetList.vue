<template>
  <div class="asset-list">
    <el-card>
      <!-- 查询条件 -->
      <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="80px">
        <el-form-item label="关键词">
          <el-input
            v-model="queryParams.keyword"
            placeholder="请输入资产名称或编号"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="机器人类型">
          <el-select v-model="queryParams.robotType" placeholder="请选择" clearable style="width: 150px">
            <el-option label="工业机器人" value="INDUSTRIAL_ROBOT" />
            <el-option label="协作机器人" value="COLLABORATIVE_ROBOT" />
            <el-option label="AGV" value="AGV" />
            <el-option label="服务机器人" value="SERVICE_ROBOT" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryParams.status" placeholder="请选择" clearable style="width: 120px">
            <el-option label="在库" value="IN_STOCK" />
            <el-option label="已领用" value="USED" />
            <el-option label="维修中" value="REPAIRING" />
            <el-option label="已报废" value="SCRAPPED" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 工具栏 -->
      <div class="toolbar">
        <el-button type="primary" icon="Plus" @click="handleAdd">新增资产</el-button>
        <el-button type="success" icon="Upload" @click="handleImport">导入</el-button>
        <el-button type="warning" icon="Download" @click="handleExport">导出</el-button>
        <el-button type="danger" icon="Delete" @click="handleBatchDelete" :disabled="multipleSelection.length === 0">
          批量删除
        </el-button>
      </div>

      <!-- 表格 -->
      <el-table
        v-loading="loading"
        :data="assetList"
        @selection-change="handleSelectionChange"
        border
        style="width: 100%; margin-top: 20px"
      >
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="资产编号" prop="assetNo" width="120" />
        <el-table-column label="资产名称" prop="assetName" min-width="150" />
        <el-table-column label="机器人类型" prop="robotType" width="120">
          <template #default="scope">
            {{ formatRobotType(scope.row.robotType) }}
          </template>
        </el-table-column>
        <el-table-column label="品牌" prop="brand" width="100" />
        <el-table-column label="型号" prop="model" width="120" />
        <el-table-column label="序列号" prop="serialNo" width="150" />
        <el-table-column label="购入日期" prop="purchaseDate" width="120" />
        <el-table-column label="所属部门" prop="departmentName" width="120" />
        <el-table-column label="状态" prop="currentStatus" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.currentStatus)">
              {{ formatStatus(scope.row.currentStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button size="small" type="primary" link @click="handleView(scope.row)">查看</el-button>
            <el-button size="small" type="primary" link @click="handleEdit(scope.row)">编辑</el-button>
            <el-button size="small" type="danger" link @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />

      <!-- 资产详情对话框 -->
      <el-dialog v-model="detailVisible" title="资产详情" width="600px">
        <asset-detail :asset="currentAsset" />
      </el-dialog>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessageBox, ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'
import AssetDetail from '@/components/Asset/AssetDetail.vue'
import Pagination from '@/components/Common/Pagination.vue'
import { getAssetPage, deleteAsset } from '@/api/asset'

const router = useRouter()

// 数据定义
const loading = ref(false)
const detailVisible = ref(false)
const assetList = ref([])
const total = ref(0)
const multipleSelection = ref([])
const currentAsset = ref({})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  keyword: '',
  robotType: '',
  status: ''
})

// 获取列表数据
const getList = async () => {
  loading.value = true
  try {
    const response = await getAssetPage(queryParams)
    assetList.value = response.data.records
    total.value = response.data.total
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

// 查询
const handleQuery = () => {
  queryParams.pageNum = 1
  getList()
}

// 重置查询
const resetQuery = () => {
  queryParams.keyword = ''
  queryParams.robotType = ''
  queryParams.status = ''
  handleQuery()
}

// 新增
const handleAdd = () => {
  router.push('/asset/add')
}

// 查看详情
const handleView = (row) => {
  currentAsset.value = row
  detailVisible.value = true
}

// 编辑
const handleEdit = (row) => {
  router.push(`/asset/edit/${row.id}`)
}

// 删除
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该资产吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await deleteAsset(row.id)
    ElMessage.success('删除成功')
    getList()
  } catch (error) {
    if (error !== 'cancel') {
      console.error(error)
    }
  }
}

// 批量删除
const handleBatchDelete = async () => {
  try {
    await ElMessageBox.confirm(`确定要删除选中的${multipleSelection.value.length}条记录吗？`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    const ids = multipleSelection.value.map(item => item.id)
    // 调用批量删除接口
    ElMessage.success('批量删除成功')
    getList()
  } catch (error) {
    if (error !== 'cancel') {
      console.error(error)
    }
  }
}

// 导入
const handleImport = () => {
  // 实现导入功能
}

// 导出
const handleExport = () => {
  // 实现导出功能
}

// 多选处理
const handleSelectionChange = (selection) => {
  multipleSelection.value = selection
}

// 格式化机器人类型
const formatRobotType = (type) => {
  const typeMap = {
    'INDUSTRIAL_ROBOT': '工业机器人',
    'COLLABORATIVE_ROBOT': '协作机器人',
    'AGV': 'AGV',
    'SERVICE_ROBOT': '服务机器人'
  }
  return typeMap[type] || type
}

// 格式化状态
const formatStatus = (status) => {
  const statusMap = {
    'IN_STOCK': '在库',
    'USED': '已领用',
    'REPAIRING': '维修中',
    'SCRAPPED': '已报废',
    'TRANSFERRED': '已调拨'
  }
  return statusMap[status] || status
}

// 获取状态标签类型
const getStatusType = (status) => {
  const typeMap = {
    'IN_STOCK': 'success',
    'USED': 'primary',
    'REPAIRING': 'warning',
    'SCRAPPED': 'danger',
    'TRANSFERRED': 'info'
  }
  return typeMap[status] || 'info'
}

onMounted(() => {
  getList()
})
</script>

<style scoped>
.toolbar {
  margin: 20px 0;
}

.asset-list {
  padding: 20px;
}
</style>