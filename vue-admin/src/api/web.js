import request from '@/utils/request'
import { webSite } from '@/settings'

/*
* 星盘接口
*/
//获取当前用户的报表的页面结构
export function dashManagerMenuTree(params) {
    return request({
        url: '/admin/visual/dashManager/menuTree',
        method: 'get',
        params
    })
}
//获取数据模型列表
export function getDataModels(params) {
    return request({
        url: '/admin/visual/dashManager/getDataModels',
        method: 'get',
        params
    })
}
//获取数据源列表
export function getDataSources(params) {
    return request({
        url: '/admin/visual/dashManager/getDataSources',
        method: 'get',
        params
    })
}
//获取数据模型维度和指标表
export function getDataModelColumn(params) {
    return request({
        url: '/admin/visual/dashManager/getDataModelColumn',
        method: 'get',
        params
    })
}
//获取组件数据
export function getComResultData(params) {
    return request({
        url: '/admin/visual/dashManager/getComResultData',
        method: 'post',
        data:params
    })
}
//新建文件夹接口
export function createFolderMenu(params) {
    return request({
        url: '/admin/visual/dashManager/createMenu',
        method: 'post',
        params
    })
}
//获取指定文件夹下面的子菜单
export function getMenuChildren(params) {
    return request({
        url: '/admin/visual/dashManager/getMenuChildren',
        method: 'get',
        params
    })
}
//修改发布状态
export function setDashBoardStatus(params) {
    return request({
        url: '/admin/visual/dashManager/setDashBoardStatus',
        method: 'post',
        params
    })
}

//保存仪表板制作 
export function saveDashboardMaking(params) {
    return request({
        url: '/admin/visual/dashManager/saveDashboardMaking',
        method: 'post',
        data:params
    })
}

//获取页面的所有组件 
export function getMenuComponents(params) {
    return request({
        url: '/admin/visual/dashManager/getMenuComponents',
        method: 'get',
        params
    })
}

//删除仪表板
export function delDashboard(params) {
    return request({
        url: '/admin/visual/dashManager/delDashboard',
        method: 'post',
        data:params
    })
}

//获取仪表板页面信息
export function getPageInfo(params) {
    return request({
        url: '/admin/visual/getPageInfo',
        method: 'get',
        params
    })
}

//获取维度关联表字段
export function getDimRelation(params) {
    return request({
        url: '/admin/visual/dashManager/getDimRelation',
        method: 'get',
        params
    })
}
//下载组件数据
export function downloadComponentData(params) {
    return request({
        url: '/admin/visual/dashManager/downloadComponentData',
        method: 'post',
        data:params,
        responseType: 'blob'
    })
}

//修改文件夹名称
export function updateFolderName(params) {
    return request({
        url: '/admin/visual/dashManager/updateFolderName',
        method: 'post',
        data:params
    })
}


//删除文件夹
export function deleteFolder(params) {
    return request({
        url: '/admin/visual/dashManager/deleteFolder',
        method: 'post',
        data:params
    })
}

//修改报表所属文件夹
export function updatePageToFolder(params) {
    return request({
        url: '/admin/visual/dashManager/updatePageToFolder',
        method: 'post',
        data:params
    })
}