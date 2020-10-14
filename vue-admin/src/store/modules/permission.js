import { constantRoutes } from '@/router'

// import AppMain from '@/layout/components/AppMain.vue'; 
// import dashboardView from '@/views/dashboardManager/dashboardView'; //仪表板视图页面
// import dashboardManager from '@/views/dashboardManager/dashboardList';//报表管理页面
// import dashboardOperation from '@/views/dashboardManager/dashboardMaking';//仪表板操作页面

const state = {
  routes: [],
  addRoutes: []
}

const mutations = {
  SET_ROUTES: (state, routes) => {
    state.addRoutes = routes
    state.routes = constantRoutes.concat(routes)
  }
}

const actions = {
  generateRoutes({ commit }, data) {
    return new Promise(resolve => {
      const accessedRouters = data
      accessedRouters.map(function(item) {
        //一级菜单组件默认layout，数据库中组件字段无需配置
        item.component = (resolve) => require(['./../../layout'], resolve)
        if(item.children){
          item.children.map(function(child) {
            //二级菜单下如果无子菜单，数据库组件字段值=view下文件夹名称+'/'+vue文件名称，如果有三级菜单，二级菜单组件默认layout，数据库中组件字段无需配置
            const child_component = child.component
            if (child_component == 'AppMain') { 
              child.component = (resolve) => require(['./../../layout/components/AppMain'], resolve)
            }else if(child_component){
              child.component = (resolve) => require([`./../../views/${child_component}`], resolve)
            }else{
              child.component = (resolve) => require(['./../../layout'], resolve)
            }
            if(child.children){
              //最多三级级菜单，数据库组件字段值=view下一级文件夹名称+'/'+二级文件夹名称+'/'+vue文件名称
              child.children.map(function(children) {
                const children_component = children.component
                children.component = (resolve) => require([`./../../views/${children_component}`], resolve)
              })
            }  
          })
        }
      })

      // //分析报表模块目录生成
			// let dashboardViewArrs = JSON.parse(JSON.stringify(dashManagerMenuTree));
			// dashboardViewArrs.map(item=>{
			// 	//修改parentId为分析报表一级目录ID
			// 	item.parentId = 240;
			// 	item.component = AppMain;
			// 	item.children.map(item2=>{
			// 		item2.component = dashboardView;
			// 	})
			// })
			// let dashManagerMenuList = JSON.parse(JSON.stringify(dashManagerMenuTree));
			// //报表管理模块生成目录
			// dashManagerMenuList.map(item=>{
			// 	item.component = dashboardManager;	
			// 	item.children = [];
			// })
			// //星盘插入生成自定义页面 
			// arrs.map(item => {
			// 	if (item.id == 223) {
			// 		item.children.map(item_2 => {
			// 			if (item_2.id == 224) {
			// 				console.log('获取是否有仪表板制作权限',item_2.children)
			// 				if(!item_2.children.length){
			// 					//没有仪表板权限的用户手动插入仪表板制作页面，避免报错
			// 					dashManagerMenuList.push({
			// 						id: 225,
			// 						parentId: 224,
			// 						children: [],
			// 						path: 'dashboardMaking',
			// 						name: 'DashboardMaking',
			// 						component: dashboardOperation,
			// 						meta: {
			// 							title: '仪表板制作'
			// 						},
			// 						hidden: true
			// 					});
			// 				}
							
			// 				item_2.children = dashManagerMenuList;
			// 			}
			// 			if (item_2.id == 240) {
			// 				item_2.children = item_2.children.concat(dashboardViewArrs)
			// 			}
			// 		})
			// 	}
			// })
      // //不知道干哈的
			// try {
			// 	for (var j = 0; j < arrs.length; j++) {
			// 		if (arrs[j].children.length && arrs[j].id !== 144) {
			// 			if (!arrs[j].children[0].children.length) {							
			// 				arrs[j].children[0].path = 'index';
			// 			} else {							
			// 				arrs[j].children[0].children[0].path = 'index';
			// 			}
			// 			break;
			// 		} else if (arrs.length == 1 && arrs[j].id == 144) {
			// 			if (arrs[j].children.length == 2) {							
			// 				arrs[j].children[1].children[0].path = 'index';
			// 			} else {							
			// 				arrs[j].children[0].children[0].path = 'index';
			// 			}
			// 		}
			// 	}
			// } catch (error) {}


      accessedRouters.push({ path: '*', redirect: '/404', hidden: true })
      commit('SET_ROUTES', accessedRouters)
      resolve(accessedRouters)
    })
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
