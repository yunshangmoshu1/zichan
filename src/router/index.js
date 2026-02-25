import { createRouter, createWebHistory } from 'vue-router'
import Layout from '@/components/Layout/Main.vue'

export const constantRoutes = [
  {
    path: '/login',
    component: () => import('@/views/Login.vue'),
    hidden: true
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Dashboard.vue'),
        meta: { title: '首页', icon: 'dashboard' }
      }
    ]
  }
]

export const asyncRoutes = [
  {
    path: '/asset',
    component: Layout,
    meta: { title: '资产管理', icon: 'goods' },
    children: [
      {
        path: 'list',
        name: 'AssetList',
        component: () => import('@/views/asset/AssetList.vue'),
        meta: { title: '资产台账', icon: 'list' }
      },
      {
        path: 'add',
        name: 'AssetAdd',
        component: () => import('@/views/asset/AssetAdd.vue'),
        meta: { title: '新增资产', icon: 'plus' }
      }
    ]
  },
  {
    path: '/stock',
    component: Layout,
    meta: { title: '库存管理', icon: 'tickets' },
    children: [
      {
        path: 'in',
        name: 'StockIn',
        component: () => import('@/views/stock/StockIn.vue'),
        meta: { title: '入库管理', icon: 'upload' }
      },
      {
        path: 'out',
        name: 'StockOut',
        component: () => import('@/views/stock/StockOut.vue'),
        meta: { title: '出库管理', icon: 'download' }
      },
      {
        path: 'transfer',
        name: 'Transfer',
        component: () => import('@/views/stock/Transfer.vue'),
        meta: { title: '调拨管理', icon: 'refresh' }
      }
    ]
  },
  {
    path: '/maintenance',
    component: Layout,
    meta: { title: '维护管理', icon: 'tools' },
    children: [
      {
        path: 'repair',
        name: 'Repair',
        component: () => import('@/views/maintenance/Repair.vue'),
        meta: { title: '维修管理', icon: 'brush' }
      },
      {
        path: 'maintenance',
        name: 'Maintenance',
        component: () => import('@/views/maintenance/Maintenance.vue'),
        meta: { title: '保养管理', icon: 'monitor' }
      }
    ]
  },
  {
    path: '/system',
    component: Layout,
    meta: { title: '系统管理', icon: 'setting' },
    children: [
      {
        path: 'user',
        name: 'User',
        component: () => import('@/views/system/User.vue'),
        meta: { title: '用户管理', icon: 'user' }
      },
      {
        path: 'role',
        name: 'Role',
        component: () => import('@/views/system/Role.vue'),
        meta: { title: '角色管理', icon: 'role' }
      },
      {
        path: 'log',
        name: 'Log',
        component: () => import('@/views/system/Log.vue'),
        meta: { title: '操作日志', icon: 'document' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes: constantRoutes
})

export default router