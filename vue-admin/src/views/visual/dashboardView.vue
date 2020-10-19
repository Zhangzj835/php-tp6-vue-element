<template>
  <div class="container container-dashboardView" v-if="loading">
    <el-row :gutter="3">
      <el-col :span="24">
        <div class="container-box">
          <el-card class="box-card" style="padding:0;">
            <div style="background:rgb(235,234,239);">
              <grid-layout
                :layout="dashboardLayout"
                :col-num="12"
                :row-height="30"
                :is-draggable="true"
                :is-resizable="true"
                :vertical-compact="true"
                :use-css-transforms="true"
                @layout-created="layoutCreatedEvent"
                @layout-before-mount="layoutBeforeMountEvent"
                @layout-mounted="layoutMountedEvent"
                @layout-ready="layoutReadyEvent"
                @layout-updated="layoutUpdatedEvent"
              >
                <grid-item
                  v-for="(item,index) in dashboardLayout"
                  :x="item.x"
                  :y="item.y"
                  :w="item.w"
                  :h="item.h"
                  :i="item.i"
                  :key="index"
                  drag-allow-from=".vue-draggable-handle"
                  drag-ignore-from=".no-drag"
                  @resize="resizeEvent"
                  @move="moveEvent"
                  @resized="resizedEvent"
                  @moved="movedEvent"
                >
                  <div class="content" style="position:relative;">
                    <div class="no-drag" >
                      
                      <div v-if="item.type!='filter'&&item.type!='text'" class="chart-wrapper-title">
                        {{item.title?item.title:'默认图表标题'}}
                      </div>
                      <div v-if="item.type == 'text'" class="" v-html="item.text">
                        {{item.text}}
                      </div> 
                      <!-- 可视化视图 -->
                      <component-item
                        v-if="item.type!='text'"
                        v-loading="item.loading&&item.type!='filter'&&item.type!='text'?item.loading:false"
                        v-show="!item.tableShow"
                        :ref="'item_'+item.i"
                        :componentData="item"
                        @refreshSubmit="refreshSubmit"
                        @itemRefreshSubmit="itemRefreshSubmit"
                      />
                      <!-- 表格视图 -->
                      <el-table border v-if="item.type!='tab'&&item.tableShow" :data="item.metadata" style="width: 100%;" height="100%">
                        <el-table-column v-for="(iField,idx) in item.tableColumns" :key="idx" :prop="iField.prop" :label="iField.label" >
                          <template slot-scope="scope">
                            <span>{{scope.row[iField.prop]}}</span>  
                          </template>
                        </el-table-column>
                      </el-table>
                      <br />

                      <div v-if="item.type!='filter'&&item.type!='text'" style="position:absolute;right:10px;top:5px;z-index:9999;">
                        <el-tooltip v-if="item.queryInput.getDataWay=='sql' && (item.queryInput.searchItems.length > 0 )" class="item" effect="dark" content="刷新数据" placement="top-start">
                          <svg-icon icon-class="caret-right" @click="clickRefreshItem(item)"/>
                        </el-tooltip>

                        <el-dropdown>
                          <span class="el-dropdown-link">
                            <i class="cp-gesture el-icon-more el-icon--right fs-20"></i>
                          </span>
                          <el-dropdown-menu slot="dropdown">
                            <el-dropdown-item >
                              <div @click="downloadData(item)" v-if="downloadVisible">
                                导出数据
                              </div> 
                            </el-dropdown-item>
                            <el-dropdown-item v-show="item.type!='tab'&&item.type!='text'">
                              <div @click="switchView(item)">切换视图</div>
                            </el-dropdown-item>
                          </el-dropdown-menu>
                        </el-dropdown>
                      </div>
                    </div>
                  </div>
                </grid-item>
              </grid-layout>
            </div>
          </el-card>
        </div>
      </el-col>
    </el-row>
  </div>
</template>
<script>
import sidebarConfig from "./components/sidebarConfig";
import componentItem from "./components/componentItem";
import Pagination from "@/components/pagination";
import DateQuick from "@/components/DateQuickBtn";
import { userTabColumn, operatorSymbol, revenueTabColumn } from "./config";
import { getNowDay, getFileName, getRadioDate } from "@/utils";
import VueGridLayout from "vue-grid-layout";
import {
  beehiveQuery,
  beehiveDownload,
  getComResultData,
  saveDashboardMaking,
  getMenuComponents,
  getMenuChildren,
  downloadComponentData,
} from "@/api/web";
export default {
  data() {
    return {
      downloadVisible:false,//下载权限显示控制
      loading: false,
      userInfo: JSON.parse(localStorage.getItem("userInfo")), //用户信息
      pageName: "", //报表名称
      menu_id: 0, //页面ID，编辑的时候用
      editPreviewShow: "edit", //切换编辑模式or预览模式
      dateValue: [],
      focusItem: null,
      componentShow: true,
      itemFocusId: "", //当前获取焦点的组件
      dashboardLayout: [],
    };
  },
  components: {
    GridLayout: VueGridLayout.GridLayout,
    GridItem: VueGridLayout.GridItem,
    Pagination,
    DateQuick,
    componentItem,
    sidebarConfig,
  },
  watch: {
    $route() {
      this.loading = false;
      this.init();
    },
  },
  mounted() {
    this.init();
  },
  methods: {
    async init() {
      let menu_id = this.$route.name;
      this.menu_id = menu_id ? menu_id : 0;
      this.getMenuChildren();
      this.downloadPermission();
    },
    /*
     * 下载权限控制
     */
    downloadPermission(){
      let buttonsPermission = JSON.parse(localStorage.getItem('buttonsPermission'));
      let pageId = this.$route.name;
      buttonsPermission.map(item=>{
        console.log(item.parentId)
        if(item.parentId == pageId){
          this.downloadVisible = true;
        }
      })
    },
    /*
     * 切换视图
     */
    switchView(row) {
      console.log(row)
      row.tableShow = !row.tableShow;      
      let tableColumns = [];//表格字段
      if (row.queryInput.getDataWay == 'sql') {
        //sql表格展示
        if (typeof(row.metadata[0]) != 'undefined') {
          for (let key in row.metadata[0]) {
            let arr = {}
            arr.label = key
            arr.prop = key
            tableColumns.push(arr)
          }
        }
      } else {
        let concatFields = [];//合并字段
        concatFields = row.queryInput.area_dim.concat(row.queryInput.area_measure);
        if (row.queryInput.second_dim) {
          concatFields = concatFields.concat(row.queryInput.second_dim);
        }       
        concatFields.map(item=>{
          tableColumns.push({
            prop:item.fact_column,
            label:item.column,
          })
        })
      }
      if(row.type != 'index') this.$refs["item_" + row.i][0].parentHandleclick();//解决报表管理：新建报表，来回切换视图后，图表异常（所有报表）
      row.tableColumns = tableColumns;
    },
    /*
     * 导出数据
     */
    downloadData(item) {
      
      try {
        downloadComponentData({
          componentType: item.type,
          dataFromId: item.dataFromId,
          dataSource:item.dataSource,
          queryInput: JSON.stringify({
            area_measure: item.queryInput.area_measure,
            area_dim: item.queryInput.area_dim,
            second_dim: item.queryInput.second_dim,
            filters: item.queryInput.filters,
            second_measure: item.queryInput.second_measure,
            sortConfig:item.queryInput.sortConfig,
            getDataWay: item.queryInput.getDataWay,
            sqlDatasourceId: item.queryInput.sqlDatasourceId,
            sqlString: item.queryInput.sqlString,
            searchItems: item.queryInput.searchItems
          }),
        }).then(res=>{
            const link = document.createElement("a");
            let blob = new Blob([res], { type: "application/vnd.ms-excel" });
            link.style.display = "none";
            link.href = URL.createObjectURL(blob);
            link.setAttribute("download", "list.xlsx");
            document.body.appendChild(link);
            link.click();
        })
      } catch (error) {
        
      }
    },
    delItem(row) {
      this.dashboardLayout.map((item, index) => {
        if (item.i == row.i) {
          this.dashboardLayout.splice(index, 1);
        }
      });
    },
    getMenuChildren() {
      try {
        getMenuChildren({
          rpt_menu_id: this.menu_id,
        }).then((res) => {
          if (res.data.length) {
            this.getMenuComponents(res.data[0].id);
          }
        });
      } catch (error) {}
    },
    getMenuComponents(menu_id) {
      try {
        getMenuComponents({
          menu_id,
        }).then((res) => {
          this.loading = true;
          let dashboardLayout = [];
          let data = res.data;

          data.map((item) => {
            let layout_info = JSON.parse(item.layout_info);
            let query_input = JSON.parse(item.query_input);
            dashboardLayout.push({
              dashboardId: menu_id,
              dataFromId: item.component_model,
              h: layout_info.h,
              i: item.id,
              w: layout_info.w,
              x: layout_info.x,
              y: layout_info.y,
              moved: false,
              queryInput: query_input,
              type: item.component_type,
              tableShow:false,
              loading:true,
              title:item.name,
              text:layout_info.text,
              dataSource: item.data_source
            });
          });
          this.dashboardLayout = dashboardLayout;
          /*
           * 各组件查询数据
           */
          this.dashboardLayout.map((item) => {
            if (item.type != "filter"&&item.type != "text") {
              this.updateSubmit(
                {
                  modelValue: item.dataFromId,
                  selectDimension: item.queryInput.area_dim,
                  selectSecondDimension: item.queryInput.second_dim,
                  filterTags: item.queryInput.filters,
                  selectScondMeasure: item.queryInput.second_measure,
                  selectMeasure: item.queryInput.area_measure,
                  dataSource:item.dataSource,
                  getDataWay: item.queryInput.getDataWay,
                  sqlDatasourceId: item.queryInput.sqlDatasourceId,
                  sqlString: item.queryInput.sqlString,
                  searchItems: item.queryInput.searchItems
                },
                item.type,
                item.i
              );
            }
          });
        });
      } catch (error) {}
    },

    layoutCreatedEvent(newLayout) {
      console.log("Created layout: ", newLayout);
    },
    layoutBeforeMountEvent(newLayout) {
      console.log("beforeMount layout: ", newLayout);
    },
    layoutMountedEvent(newLayout) {
      console.log("Mounted layout: ", newLayout);
    },
    layoutReadyEvent(newLayout) {
      console.log("Ready layout: ", newLayout);
    },
    layoutUpdatedEvent(newLayout) {
      console.log("Updated layout: ", this.dashboardLayout);
    },
    resizeEvent(i, newH, newW, newHPx, newWPx) {
      console.log("ref=item_", i);
      console.log("大小正在改变", i, newH, newW, newHPx, newWPx);
      console.log(this.$refs);
      this.$refs["item_" + i][0].parentHandleclick();
    },
    moveEvent(i, newX, newY) {
      console.log("正在移动", i, newX, newY);
    },
    resizedEvent(i, newH, newW, newHPx, newWPx) {
      console.log("大小改变完了", i, newH, newW, newHPx, newWPx);
    },
    movedEvent(i, newX, newY) {
      console.log("移动结束了 ", i, newX, newY);
    },
    itemClick(item) {   
      if (this.itemFocusId == item.i) return;
      // this.focusItem = null;
      this.focusItem = item;
      this.itemFocusId = item.i;
    },
    itemRefreshSubmit(params){
      const sortConfig = params.sortConfig;
      const itemData = params.item;
      const searchItems = params.searchItems;  
      let dashboardLayout = this.dashboardLayout;
      this.focusItem = itemData;
      dashboardLayout.map(item=>{
        if(item.i == itemData.i){
          item.loading = true;
          this.itemClick(itemData);
          item.queryInput.sortConfig = sortConfig ? sortConfig: item.queryInput.sortConfig;
          item.queryInput.searchItems = searchItems ? searchItems: item.queryInput.searchItems;

          this.updateSubmit({
            filterTags: item.queryInput.filters,
            modelValue: item.dataFromId,
            selectDimension: item.queryInput.area_dim,
            selectSecondDimension: item.queryInput.second_dim,
            selectMeasure: item.queryInput.area_measure,
            selectScondMeasure: item.queryInput.second_measure,
            sortConfig:sortConfig,
            dataSource:item.dataSource,
            getDataWay: item.queryInput.getDataWay,
            sqlDatasourceId: item.queryInput.sqlDatasourceId,
            sqlString: item.queryInput.sqlString,
            searchItems: item.queryInput.searchItems
          });
        }
      })
    },
    refreshSubmit(params){
      const dateValue = params.dateValue;
      const dateRadio = params.dateRadio;

      let dashboardLayout = JSON.parse(JSON.stringify(this.dashboardLayout));
      dashboardLayout.map((item,index)=>{
        if(item.type!='filter'&&item.type!='text'){
          let date_show = true;
          item.queryInput.filters.map(filters_item=>{
            if(filters_item.speRequire == 'dt'){
              date_show = false;
              filters_item.conValue = dateValue.join(',');
            }
          })
          if(date_show){
            item.queryInput.filters.push({
              "speRequire": "dt",
              "operatorSymbol": "",
              "addValType": "1",
              "conValue": dateValue.join(','),
              "operatorSymbolArrs": [],
              "type": 1,
              "labelZhCn": "日期"
            })
          }
          item.loading = true; 
          this.$set(this.dashboardLayout, index, item);
          this.updateSubmit({
            filterTags: item.queryInput.filters,
            modelValue: item.dataFromId,
            selectDimension: item.queryInput.area_dim,
            selectSecondDimension: item.queryInput.second_dim,
            selectMeasure: item.queryInput.area_measure,
            selectScondMeasure:item.queryInput.second_measure,
            dataSource:item.dataSource,
            getDataWay: item.queryInput.getDataWay,
            sqlDatasourceId: item.queryInput.sqlDatasourceId,
            sqlString: item.queryInput.sqlString,
            searchItems: item.queryInput.searchItems
          },
          item.type,
          item.i);
        }
      })
    },
    /**
     * 更新组件数据
     * @param  {参数类型} form 组件的配置信息
     * @param  {参数类型} type 组件类型（这里用作编辑的时候，初始化请求组件数据；如果不存在，则是点击组件时不带组件类型type）
     * @param  {参数类型} id 组件id（这里用作编辑的时候，初始化请i去组件数据需要用到；如果不存在，则是点击组件时不带组件ID）
     */
    updateSubmit(form, type, id) {
      let componentType = type ? type : this.focusItem.type;
      if(componentType=='text') return;
      try {
        getComResultData({
          componentType: componentType,
          dataFromId: form.modelValue,
          dataSource:form.dataSource,
          queryInput: JSON.stringify({
            area_measure: form.selectMeasure,
            area_dim: form.selectDimension,
            second_dim: form.selectSecondDimension,
            filters: form.filterTags,
            second_measure: form.selectScondMeasure,
            sortConfig:form.sortConfig?form.sortConfig:null,
            getDataWay: form.getDataWay,
            sqlDatasourceId: form.sqlDatasourceId,
            sqlString: form.sqlString,
            searchItems: form.searchItems
          }),
        }).then((res) => {
          let itemFocusId = id ? id : this.itemFocusId;
          let dashboardLayout = JSON.parse(
            JSON.stringify(this.dashboardLayout)
          );
          try {
            if(componentType == 'tab'){
              let data = res.data.dataRes;
              data.map(item=>{
                for(let i in item){
                  form.selectMeasure.map(item_2=>{
                    if(i == item_2.fact_column){
                      item[i] = parseFloat(item[i]).toLocaleString()
                    }
                  })
                }
              })
              res.data.dataRes = data;
            }else{
              let data = res.data.metadata;
              data.map(item=>{
                for(let i in item){
                  form.selectMeasure.map(item_2=>{
                    if(i == item_2.fact_column){
                      item[i] = parseFloat(item[i]).toLocaleString()
                    }
                  })
                }
              })
              res.data.metadata = data;
            }
          } catch (error) {
            
          }
          
          dashboardLayout.map((item,index) => {
            if (item.i == itemFocusId) {
              item.loading = false;
              item.data = res.data.dataRes;
              item.metadata = res.data.metadata;
              item.dataSource = form.dataSource;
              (item.dataFromId = form.modelValue),
                (item.queryInput = {
                  second_measure: form.selectScondMeasure,
                  area_measure: form.selectMeasure,
                  area_dim: form.selectDimension,
                  second_dim: form.selectSecondDimension,
                  filters: form.filterTags,
                  sortConfig:form.sortConfig,
                  getDataWay: form.getDataWay,
                  sqlDatasourceId: form.sqlDatasourceId,
                  sqlString: form.sqlString,
                  searchItems: form.searchItems
                });
                //单个组件更新数据不触发其他组件重绘
                this.$set(this.dashboardLayout, index, item);
            }
          });
        });
      } catch (error) {
        this.$message.error(error);
      }
    },

    /**
     * 点击刷新组件数据
     */
    clickRefreshItem(item){      
      this.$refs['item_'+item.i][0].searchSubmit();
    }

  },
};
</script>
<style lang="scss" scoped>
.container {
  background: #fff;
  padding: 0;
  .component-title{
    width: 200px;
    margin: 20px 0 0 20px;
  }
  .container-box {
    padding: 0;
  }

  .el-card {
    border: 0;
  }
  .simple-header-container {
    // height: 50px;
    border: 1px solid #ebeef5;
    padding: 10px;
    width: 100%;
    .header-btn {
      flex: 1;
      text-align: right;
    }
  }
}
.vue-grid-item {
  .content {
    .no-drag {
      height: 100%;
    }
    .no-drag.focus {
      border: 2px solid #66b1ff;
      // box-sizing: border-box;
    }
    position: relative;
    height: 100%;
    padding: 20px;
    overflow: hidden;
  }
}
</style>