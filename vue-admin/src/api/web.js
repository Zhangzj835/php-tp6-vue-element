import request from '@/utils/request'
import { apiUrl, apiUrl2, apiUrl3, apiUrl4 } from '@/settings'
import { reportRequest } from '@/utils/sdk.js' // 埋点上报
const test = 'http://10.0.1.140:7001';

/*
* 整体看板
*/
//数据统计
export function dataStatistics(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/kanban/dataStatistics',
        method: 'get',
        params
    })
}
//GMV趋势图
export function gmvTrend(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/kanban/gmvTrend',
        method: 'get',
        params
    })
}
//客单价/下单人数
export function orderUserList(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/kanban/orderUserList',
        method: 'get',
        params
    })
}
//获取用户流失率
export function getUserRunAway(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/kanban/userRunAway',
        method: 'get',
        params
    })
}
/*
* 会员数据大屏
*/
//新增用户趋势
export function newUserTrend(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/memberDataV/newUserTrend',
        method: 'get',
        params
    })
}
//新用户转化漏斗
export function newUserFunnel(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/memberDataV/newUserFunnel',
        method: 'get',
        params
    })
}
//用户拉新/升级
export function userNewUpgrade(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/memberDataV/userNewUpgrade',
        method: 'get',
        params
    })
}
//运营专员plus 拉新
export function operatorPlusNew(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/memberDataV/operatorPlusNew',
        method: 'get',
        params
    })
}
//运营专员铂金 拉新
export function operatorPlatinumNew(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/memberDataV/operatorPlatinumNew',
        method: 'get',
        params
    })
}
//运营专员plus 升级
export function operatorPlusUpgrade(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/memberDataV/operatorPlusUpgrade',
        method: 'get',
        params
    })
}
//运营专员铂金 升级
export function operatorPlatinumUpgrade(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/memberDataV/operatorPlatinumUpgrade',
        method: 'get',
        params
    })
}
//运营专员plus、钻石、黄金排行top100下载
export function comCenterDataDownload(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/comCenterDataV/download',
        method: 'get',
        params,
        responseType: 'blob'
    })
}
//运营专员黄金 升级
export function operatorGoldUpgrade(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/memberDataV/operatorGoldUpgrade',
        method: 'get',
        params
    })
}
//运营专员黄金 拉新
export function operatorGoldNew(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/memberDataV/operatorGoldNew',
        method: 'get',
        params
    })
}
/*
* 蜂巢数据请求
*/
//查询结果
export function beehiveQuery(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/beehive/query',
        method: 'post',
        data:params
    })
}
//数据下载
export function beehiveDownload(params) {
    reportRequest({
        pageId:'蜂巢数据下载',
        type:3,
        restPath:"/bi/order/Order/download",
        params:params,
    })
    return request({
        url: apiUrl4 + '/bi-node-service/beehive/download',
        method: 'post',
        data:params,
        responseType: 'blob'
    })
}

/*
* 会员资产
*/
//角色统计
export function roleStatistical(params) {
    return request({
        url: apiUrl4 + '/gmi/user/userAssets/roleStatistical',
        method: 'get',
        params
    })
}
//会员统计
export function memberStatistics(params) {
    return request({
        url: apiUrl4 + '/gmi/user/userAssets/memberStatistics',
        method: 'get',
        params
    })
}
/*
* 指挥中心 大屏
*/
//运营专员plusGMV排行
export function operatorPlusRank(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/comCenterDataV/operatorPlusRank',
        method: 'get',
        params
    })
}
//运营专员钻石 GMV排行
export function operatorDiamondPlusRank(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/comCenterDataV/operatorDiamondPlusRank',
        method: 'get',
        params
    })
}
//运营专员plus班级 拉新榜单
export function operatorTeamPlusRank(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/comCenterDataV/operatorTeamPlusRank',
        method: 'get',
        params
    })
}
//今日统计
export function todayStatistics(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/comCenterDataV/todayStatistics',
        method: 'get',
        params
    })
}
//gmv趋势
export function dsGmvTrend(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/comCenterDataV/gmvTrend',
        method: 'get',
        params
    })
}
//招商商品
export function businessItem(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/comCenterDataV/businessItem',
        method: 'get',
        params
    })
}
//搜索榜单
export function dsSearchRank(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/comCenterDataV/searchRank',
        method: 'get',
        params
    })
}
//预热榜单
export function warmUpItem(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/comCenterDataV/warmUpItem',
        method: 'get',
        params
    })
}
//品类排行
export function dsCategoryRank(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/comCenterDataV/categoryRank',
        method: 'get',
        params
    })
}
/*
* 平台分析
*/
//斗斗蜂-爆款排行
export function wxHotRankNode(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/wxHotRank',
        method: 'get',
        params
    })
}
//斗斗蜂-爆款排行-下载
export function wxHotRankDownloadNode(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/wxHotRank/download',
        method: 'get',
        params,
        responseType: 'blob'
    })
}
/*
* 配置接口
*/
//渠道
export function getSourse(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/getSourse',
        method: 'get',
        params
    })
}
//一级品类
export function getFirstCategory(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/category/getFirstCategory',
        method: 'get',
        params
    })
}
//获取预售榜单列表
export function getPresellRank(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/presellRank',
        method: 'get',
        params
    })
}
//预售榜单列表下载
export function presellRankDownload(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/presellRank/download',
        method: 'get',
        params,
        responseType: 'blob'
    })
}
//获取搜索榜单列表
export function searchRankRank(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/searchRank',
        method: 'get',
        params
    })
}
//搜索列表下载
export function searchRankDownload(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/searchRank/download',
        method: 'get',
        params,
        responseType: 'blob'
    })
}
//商品榜单
export function getGoodsRank(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/goodsRank',
        method: 'get',
        params
    })
}
//商品榜单-下载
export function goodsRankDownload(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/goodsRank/download',
        method: 'get',
        params,
        responseType: 'blob'
    })
}

//热词榜单
export function getHotWordRank(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/hotWordRank',
        method: 'get',
        params
    })
}
//热词榜单-近30天趋势
export function getHotWordTrend(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/hotWordRank/trend',
        method: 'get',
        params
    })
}
//热词榜单-下载
export function hotWordListDownload(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/goods/ranking/hotWordRank/download',
        method: 'get',
        params,
        responseType: 'blob'
    })
}

/*
* 整体看板
*/
//日活
export function dauTrend(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/kanban/dauTrend',
        method: 'get',
        params
    })
}
//获取新用户数/新授权用户数/首单用户数/上级运营专员黄金数
export function newUserIndex(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/kanban/newUserIndex',
        method: 'get',
        params
    })
}
/*
* 报表访问记录
*/
export function beenhiveQueryLog(params) {
    return request({
        url: apiUrl4 + '/pageShowPerm/beenhiveQueryLog',
        method: 'get',
        params
    })
}
/*
* 用户排行
*/
//用户佣金排行
export function getCommissonRank(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/user/userRank/userCommissionRank',
        method: 'get',
        params
    })
}
//用户佣金排行下载
export function commissonRankDownload(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/user/userRank/userCommissionRank/download',
        method: 'get',
        params,
        responseType: 'blob'
    })
}
/*
* 星盘接口
*/
//获取当前用户的报表的页面结构
export function dashManagerMenuTree(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/menuTree',
        method: 'get',
        params
    })
}
//获取数据模型列表
export function getDataModels(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/getDataModels',
        method: 'get',
        params
    })
}
//获取数据源列表
export function getDataSources(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/getDataSources',
        method: 'get',
        params
    })
}
//获取数据模型维度和指标表
export function getDataModelColumn(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/getDataModelColumn',
        method: 'get',
        params
    })
}
//获取组件数据
export function getComResultData(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/getComResultData',
        method: 'post',
        data:params
    })
}
//新建文件夹接口
export function createFolderMenu(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/createMenu',
        method: 'post',
        params
    })
}
//获取指定文件夹下面的子菜单
export function getMenuChildren(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/getMenuChildren',
        method: 'get',
        params
    })
}
//修改发布状态
export function setDashBoardStatus(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/setDashBoardStatus',
        method: 'post',
        params
    })
}

//保存仪表板制作 
export function saveDashboardMaking(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/saveDashboardMaking',
        method: 'post',
        data:params
    })
}

//获取页面的所有组件 
export function getMenuComponents(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/getMenuComponents',
        method: 'get',
        params
    })
}

//删除仪表板
export function delDashboard(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/delDashboard',
        method: 'post',
        data:params
    })
}

//获取仪表板页面信息
export function getPageInfo(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/getPageInfo',
        method: 'get',
        params
    })
}

//获取维度关联表字段
export function getDimRelation(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/getDimRelation',
        method: 'get',
        params
    })
}
//下载组件数据
export function downloadComponentData(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/downloadComponentData',
        method: 'post',
        data:params,
        responseType: 'blob'
    })
}

//修改文件夹名称
export function updateFolderName(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/updateFolderName',
        method: 'post',
        data:params
    })
}


//删除文件夹
export function deleteFolder(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/deleteFolder',
        method: 'post',
        data:params
    })
}

//修改报表所属文件夹
export function updatePageToFolder(params) {
    return request({
        url: apiUrl4 + '/bi-node-service/visual/dashManager/updatePageToFolder',
        method: 'post',
        data:params
    })
}