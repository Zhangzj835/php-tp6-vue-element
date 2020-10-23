<template>
  <div class="container container-editDashboard">
    <div class="simple-header-container">
      <div class="df-acenter">        
        <div class="header-btn">
          <el-row>
            <el-radio-group v-model="editPreviewShow" @change="selectRadio">
              <el-radio :label="'edit'">编辑</el-radio>
              <el-radio :label="'preview'">预览</el-radio>
            </el-radio-group>
            <el-button class="save-button" type="primary" @click="saveSubmit">保存</el-button>
            <!-- <el-button size="mini" v-if="!publishStatus&&identification" @click="statusChange()">重新发布</el-button> -->
          </el-row>
        </div>
      </div>
    </div>
    <el-row :gutter="3">
      <el-col :span="editPreviewShow=='preview'||!dashboardLayout.length?24:18">
        <div class="container-box">
          <el-card>
            <div slot="header" class="clearfix">
              <!-- <span class="mr-10">+添加组件</span> -->
              <el-tooltip
                v-for="(item,index) in componentsTypes"
                :key="index"
                class="item"
                effect="dark"
                :content="item.name"
                placement="top-start"
              >
                <el-button size="small" type="text" @click="createComponents(item)">
                  <div class="com-icon" :style="'background-image: url('+item.img+');'"></div>
                </el-button>
              </el-tooltip>
            </div>
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
                  v-for="item in dashboardLayout"
                  :x="item.x"
                  :y="item.y"
                  :w="item.w"
                  :h="item.h"
                  :i="item.i"
                  :key="item.i"
                  drag-allow-from=".vue-draggable-handle"
                  drag-ignore-from=".no-drag"
                  @resize="resizeEvent"
                  @move="moveEvent"
                  @resized="resizedEvent"
                  @moved="movedEvent"
                >
                  <div class="content" style="position:relative;" @click="itemClick(item)">
                    <div
                      class="vue-draggable-handle"
                      style="display:inline-block;position:absolute;top:0;left:0;z-index:9999;"
                    >
                      <el-button size="small" type="primary">拖拽</el-button>
                    </div>
                    <div
                      class="no-drag"
                      :class="itemFocusId==item.i?'focus':''"
                      :style="item.type=='text'?'overflow-y: auto;':''"
                    >
                      <div v-if="item.type!='filter'&&item.type!='text'" class="component-title">
                        <el-input v-model="item.title" placeholder="请输入图表标题"></el-input>
                      </div>

                      <!-- 可视化视图 -->
                      <component-item
                        v-loading="item.loading&&item.type!='filter'&&item.type!='text'?item.loading:false"
                        v-show="!item.tableShow"
                        :ref="'item_'+item.i"
                        :componentData="item"
                        @refreshSubmit="refreshSubmit"
                        @itemRefreshSubmit="itemRefreshSubmit"
                      />
                      <!-- 表格视图 -->
                      <el-table
                        border
                        v-if="item.type!='tab'&&item.tableShow"
                        :data="item.metadata"
                        style="width: 100%;"
                        height="100%"
                      >
                        <el-table-column
                          v-for="(iField,idx) in item.tableColumns"
                          :key="idx"
                          :prop="iField.prop"
                          :label="iField.label"
                        >
                          <template slot-scope="scope">
                            <span>{{ scope.row[iField.prop]}}</span>
                          </template>
                        </el-table-column>
                      </el-table>
                      <br />

                      <div                        
                        style="position:absolute;right:10px;top:5px;z-index:9999;"
                      >

                        <el-tooltip v-if="item.queryInput.getDataWay=='sql'" class="item" effect="dark" content="刷新数据" placement="top-start">
                          <svg-icon icon-class="caret-right" @click="clickRefreshItem(item)"/>
                        </el-tooltip>

                        <el-dropdown>
                          <span class="el-dropdown-link">
                            <i class="cp-gesture el-icon-more el-icon--right fs-20"></i>
                          </span>
                          <el-dropdown-menu slot="dropdown" v-if="item.type=='filter'">
                            <el-dropdown-item>
                              <div @click="delItem(item)">删除组件</div>
                            </el-dropdown-item>
                          </el-dropdown-menu>
                          <el-dropdown-menu slot="dropdown" v-else>
                            <el-dropdown-item>
                              <div @click="delItem(item)">删除组件</div>
                            </el-dropdown-item>
                            <el-dropdown-item v-show="item.type!='text'">
                              <div @click="downloadData(item)">导出数据</div>
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
      <el-col :span="6" v-if="editPreviewShow == 'edit'&&dashboardLayout.length">
        <div class="container-box">
          <sidebarConfig
            v-if="focusItem!==null"
            :itemConfig="focusItem"
            @updateSubmit="updateSubmit"
            @componentUpdate="componentUpdate"
          />
        </div>
      </el-col>
    </el-row>
  </div>
</template>
<script>
import router from "@/router";
import sidebarConfig from "./components/sidebarConfig";
import componentItem from "./components/componentItem";
import Pagination from "@/components/pagination";
import DateQuick from "@/components/DateQuickBtn";
import { userTabColumn, operatorSymbol, revenueTabColumn } from "./config";
import {
  getNowDay,
  getFileName,
  getRadioDate,
  linkRelativeRatio  
} from "@/utils";
import VueGridLayout from "vue-grid-layout";
import {
  beehiveQuery,
  beehiveDownload,
  getComResultData,
  saveDashboardMaking,
  getMenuComponents,
  getPageInfo,
  downloadComponentData,
  setDashBoardStatus,
} from "@/api/web";
export default {
  data() {
    return {
      publishStatus: null, //发布状态
      pageInfo: {}, //页面信息
      userInfo: JSON.parse(localStorage.getItem("userInfo")), //用户信息      
      identification: "", //页面ID，编辑的时候用
      editPreviewShow: "edit", //切换编辑模式or预览模式
      dateValue: [],
      focusItem: null,
      componentShow: true,
      itemFocusId: "", //当前获取焦点的组件
      componentsTypes: [
        {
          name: "文本框",
          type: "text",
          img: require("@/assets/images/xp_slices/icon-text.png"),
        },
        {
          name: "表格",
          type: "tab",
          img: require("@/assets/images/xp_slices/icon-tab.png"),
        },
        {
          name: "柱形图",
          type: "bar",
          img: require("@/assets/images/xp_slices/icon-bar.png"),
        },
        {
          name: "折线图",
          type: "line",
          img: require("@/assets/images/xp_slices/icon-line.png"),
        },
        {
          name: "饼图",
          type: "pie",
          img: require("@/assets/images/xp_slices/icon-pie.png"),
        },
        {
          name: "组合图",
          type: "mix",
          img: require("@/assets/images/xp_slices/icon-mix.png"),
        },
        {
          name: "指标看板",
          type: "index",
          img: require("@/assets/images/xp_slices/icon-index.png"),
        },
        {
          name: "漏斗图",
          type: "funnel",
          img: require("@/assets/images/xp_slices/icon-funnel.png"),
        },
        {
          name: "时间查询控件",
          type: "filter",
          img: require("@/assets/images/xp_slices/icon-search.png"),
        },
      ],
      userInfo: JSON.parse(localStorage.getItem("userInfo")),
      timeShow: false,
      queryLoading: false,
      tableShow: false,
      fieldTagsChange: false,
      dateQuick: {
        radioValue: "昨日", //默认时间
        options: ["昨日", "近7天", "本月"], //默认选项
      },
      downloading: false,
      filterFieldsValue: null,
      checkAll: false,
      checkedCities: [],
      isIndeterminate: true,
      loading: false,
      //选中的所需字段
      fieldTags: [],
      //选中过滤条件
      filterTags: [],
      //营收宽表全字段
      revenueTabColumn: [],
      //用户宽表全字段
      userTabColumn: [],
      //操作符
      operatorSymbol: operatorSymbol,

      //所需字段选中值
      fields: ["时间", "用户ID"],
      //过滤条件弹窗 显示/隐藏
      conditionVisible: false,
      //所需字段弹窗 显示/隐藏
      fieldVisible: false,
      //模拟全字段
      tableColumns: [],
      //table显示字段
      tabColumns: [],
      tableData: [],
      form: {
        dataType: "用户",
        dateTime: [],
        timeGranularity: "日",
      },
      paginationData: {
        pageNumber: 1,
        pageSize: 10,
        total: 0,
      },
      //分割线
      sortConfig: {
        sortField: "",
        sort: "",
      },
      dashboardLayout: [],
      //表格变量参数
      variables: []
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
    fieldTags() {
      let fieldTags = this.fieldTags;
      for (let i = 0; i < fieldTags.length; i++) {
        if (fieldTags[i].prop == "dt") {
          this.timeShow = true;
          this.form.timeGranularity = "日";
          break;
        } else {
          this.timeShow = false;
        }
      }

      //字段有改动的时候，tab表格重新渲染
      this.fieldTagsChange = true;
    },
  },
  mounted() {
    window.onbeforeunload = true;
    this.init();
  },
  methods: {
    async init() {
      if (localStorage.getItem("is_reload_page") == 1) {
        localStorage.setItem("is_reload_page", 0);
        window.location.reload();
      }

      let dateTime = await getRadioDate("昨日");
      this.form.dateTime = [dateTime[0], dateTime[1]];

      let query = this.$route.query;
      let params = this.$route.path.split('/');      
      this.identification = params[3] ? params[3] : "";
      this.publishStatus = query.status ? query.status : null;
      if (this.identification) {        
        this.getPageInfo();
      }
    },
    statusChange() {
      try {
        setDashBoardStatus({
          identification: this.identification,
          status: 1,
        }).then((res) => {
          this.$message({
            message: "修改发布状态成功",
            type: "success",
          });
        });
      } catch (error) {}
    },
    getPageInfo() {
      let identification = this.identification;
      try {
        getPageInfo({
          identification,
        }).then((res) => {          
          this.pageInfo = res.data.pageInfo;
          let dashboardLayout = [];
          let data = res.data.components;

          data.map((item) => {
            let layout_info = JSON.parse(item.layout_info);
            let query_input = JSON.parse(item.query_input);
            dashboardLayout.push({
              dashboardId: identification,
              dataFromId: item.component_model,
              h: layout_info.h,
              i: item.id,
              w: layout_info.w,
              x: layout_info.x,
              y: layout_info.y,
              moved: false,
              queryInput: query_input,
              type: item.component_type,
              tableShow: false,
              loading: true,
              title: item.name ? item.name : "默认图表标题",
              text: layout_info.text ? layout_info.text : "",
              dataSource: item.data_source
            });
          });
          this.dashboardLayout = dashboardLayout;
          /*
           * 各组件查询数据
           */
          this.dashboardLayout.map((item) => {
            if (item.type != "filter") {
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
    /*
     * 处理指标看板环比
     */
    indexRatio(item) {
      let ratioItem = JSON.parse(JSON.stringify(item));
      let filters = ratioItem.queryInput.filters;

      filters.map((f_item) => {
        if (f_item.speRequire == "dt") {
          let arrs = f_item.conValue.split(",");
          let date = linkRelativeRatio(arrs[0], arrs[1]);
          f_item.conValue = date;
        }
      });
      console.log("指标看板日期覆盖-------", filters);
    },
    /**
     * 更新组件数据
     * @param  {参数类型} form 组件的配置信息
     * @param  {参数类型} type 组件类型（这里用作编辑的时候，初始化请求组件数据；如果不存在，则是点击组件时不带组件类型type）
     * @param  {参数类型} id 组件id（这里用作编辑的时候，初始化请i去组件数据需要用到；如果不存在，则是点击组件时不带组件ID）
     */
    updateSubmit(form, type, id) {
      console.log('==============update Submit form:', form);

      let itemFocusId = id ? id : this.itemFocusId;
      let dashboardLayout = JSON.parse(JSON.stringify(this.dashboardLayout));
      let componentType = type ? type : this.focusItem.type;
      if (componentType == "text") return;
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
            sortConfig: form.sortConfig ? form.sortConfig : null,
            getDataWay: form.getDataWay ? form.getDataWay : '',
            sqlDatasourceId: form.sqlDatasourceId,
            sqlString: form.sqlString,
            searchItems: form.searchItems
          }),
        }).then((res) => {
          try {
            if (componentType == "tab") {
              let data = res.data.dataRes;
              data.map((item) => {
                for (let i in item) {
                  form.selectMeasure.map((item_2) => {
                    if (i == item_2.fact_column) {
                      item[i] = parseFloat(item[i]).toLocaleString();
                    }
                  });
                }
              });
              res.data.dataRes = data;
            } else {
              let data = res.data.metadata;
              data.map((item) => {
                for (let i in item) {
                  form.selectMeasure.map((item_2) => {
                    if (i == item_2.fact_column) {
                      item[i] = parseFloat(item[i]).toLocaleString();
                    }
                  });
                }
              });
              res.data.metadata = data;
            }
          } catch (error) {}

          dashboardLayout.map((item, index) => {
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
                  sortConfig: form.sortConfig,
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
    delItem(row) {
      this.dashboardLayout.map((item, index) => {
        if (item.i == row.i) {
          this.dashboardLayout.splice(index, 1);
          this.focusItem = null;
          this.itemFocusId = "";
        }
      });
    },
    itemClick(item) {
      if (this.itemFocusId == item.i) return;
      // this.focusItem = null;
      console.log('=======itemClick item:', item);
      this.focusItem = item;
      this.itemFocusId = item.i;
    },

    selectRadio() {
      this.dashboardLayout.map((item) => {
        this.$refs["item_" + item.i][0].parentHandleclick();
      });

      // this.$refs["item_" + i][0].parentHandleclick();
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
      console.log("移动结束了", i, newX, newY);
    },
    createComponents(item) {
      console.log("图表类型", item.type);

      let dashboardLayout = this.dashboardLayout.length
        ? JSON.parse(JSON.stringify(this.dashboardLayout))
        : [];
      let yArrs = dashboardLayout.length
        ? dashboardLayout.sort(this.compare("y"))
        : [];
      let componentId = dashboardLayout.length
        ? dashboardLayout.sort(this.compare("i"))
        : [];
      dashboardLayout.push({
        x: 0,
        y: 0,
        w: 12,
        h: item.type == "filter" ? 2 : item.type == "index" ? 6 : 8,
        i: componentId.length ? componentId[componentId.length - 1].i + 1 : 1,
        type: item.type,
        moved: false,
        dashboardId: "",
        dataFromId: "",
        queryInput: {
          area_measure: [],
          area_dim: [],
          second_dim: [],
          filters: [],
          second_measure: [],
          sortConfig: null,
          getDataWay: '',
          sqlDatasourceId: '',
          sqlString: '',
          searchItems: []
        },
        data: item.type == "tab" ? [] : {},
        tableShow: false,
        title: "默认图表标题",
      });
      console.log("dashboardLayout", dashboardLayout);
      this.dashboardLayout = dashboardLayout;
      // console.log('this.dashboardLayout',this.dashboardLayout)
      this.itemClick(this.dashboardLayout[this.dashboardLayout.length - 1]);
    },
    compare(property) {
      return function (a, b) {
        var value1 = a[property];
        var value2 = b[property];
        return value1 - value2;
      };
    },
    itemRefreshSubmit(params) {
      const sortConfig = params.sortConfig;
      const itemData = params.item;
      const searchItems = params.searchItems;      
      let dashboardLayout = this.dashboardLayout;
      this.focusItem = itemData;
      dashboardLayout.map((item) => {
        if (item.i == itemData.i) {
          item.loading = true;
          this.itemClick(itemData);
          item.queryInput.sortConfig = sortConfig ? sortConfig: item.queryInput.sortConfig;
          item.queryInput.searchItems = searchItems ? searchItems: item.queryInput.searchItems;

          this.updateSubmit({
            filterTags: item.queryInput.filters,
            modelValue: item.dataFromId,
            selectDimension: item.queryInput.area_dim,
            selectSecondDimension: item.queryInput.second_dim,
            selectScondMeasure: item.queryInput.second_measure,
            selectMeasure: item.queryInput.area_measure,
            sortConfig: item.queryInput.sortConfig,
            dataSource:item.dataSource,
            getDataWay: item.queryInput.getDataWay,
            sqlDatasourceId: item.queryInput.sqlDatasourceId,
            sqlString: item.queryInput.sqlString,
            searchItems: item.queryInput.searchItems
          });
        }
      });
    },    
    refreshSubmit(params) {
      let dateValue = params.dateValue
      let dateRadio = params.dateRadio

      let dashboardLayout = JSON.parse(JSON.stringify(this.dashboardLayout));
      dashboardLayout.map((item, index) => {
        if (item.type == "filter") {          
          item.queryInput.dateValue = dateValue;
          item.queryInput.dateRadio = dateRadio;
          this.$set(this.dashboardLayout, index, item);
        } else {
          let date_show = true;
          item.loading = true;
          item.queryInput.filters.map((filters_item) => {
            if (filters_item.speRequire == "dt") {
              date_show = false;
              if (dateRadio) {
                filters_item.addValType = 2;
                filters_item.conValue = dateRadio;
              } else {
                filters_item.conValue = dateValue.join(",");
              }
              
            }
          });
          if (date_show) {
            item.queryInput.filters.push({
              speRequire: "dt",
              operatorSymbol: "",
              addValType: "1",
              conValue: dateValue.join(","),
              operatorSymbolArrs: [],
              type: 1,
              labelZhCn: "日期",
            });
          }
          this.$set(this.dashboardLayout, index, item);
          this.updateSubmit(
            {
              filterTags: item.queryInput.filters,
              modelValue: item.dataFromId,
              selectDimension: item.queryInput.area_dim,
              selectSecondDimension: item.queryInput.second_dim,
              selectMeasure: item.queryInput.area_measure,
              selectScondMeasure: item.queryInput.second_measure,
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
    },
    saveSubmit() {
      console.log("this.dashboardLayout", this.dashboardLayout);
      let dashboardLayout = this.dashboardLayout;
      let query = this.$route.query;
      let identification = this.identification ? this.identification : ""; //有identification就是编辑，否则就是新增仪表板
      let arrs = [];
      let components = [];
      if (!dashboardLayout.length) {
        return this.$message({
          message: "请添加组件",
          type: "warning",
        });
      }
      dashboardLayout.map((item) => {
        if (item.type == "text") {          
          item.text = this.$refs["item_" + item.i][0].newsContext;
        }
        //这里没有选模型且组件类型不为筛选控件的才可以插入
        if (
          item.dataFromId == "" &&
          item.type != "filter" &&
          item.type != "text" && 
          item.queryInput.getDataWay != 'sql'
        )
          return;

        components.push({
          id: item.i,
          report_page_id: identification,
          component_type: item.type,
          component_model: item.dataFromId,
          layout_info: JSON.stringify({
            h: item.h,
            w: item.w,
            x: item.x,
            y: item.y,
            text: item.text,
          }),
          query_input: JSON.stringify(item.queryInput),
          name: item.title,
          data_source:item.dataSource
        });
      });
      let body = {
        id: identification,
        parent_id: query.parent_id,                
        status: 1,
        components: components,
      };
      console.log("components", components);

      // return;
      try {
        saveDashboardMaking(body).then((res) => {
          if (res.code == 10000) {
            if (res.data.page_id) {
              this.identification = res.data.identification;
            }
            let that = this;
            this.$message({
              showClose: true,
              message: "保存成功",
              type: "success",
              async onClose() {
                if (!identification) {
                  // window.location.reload();
                  localStorage.setItem("is_reload_page", 1);
                  that.$router.push(
                    "/visual/dashboardMaking/"+res.data.identification
                  );
                  that.init();
                }
              },
            });
          } else {
            this.$message.error(res.message);
          }
          // window.location.reload();
          // this.router.go(-1);
        });
      } catch (error) {}
    },
    /*
     * 切换视图
     */
    switchView(row) {
      console.log(row)
      //显示表格
      row.tableShow = !row.tableShow;
      //初始化表格字段
      let tableColumns = [];

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
        //模型表格展示
        let concatFields = []; //合并字段        
        concatFields = row.queryInput.area_dim.concat(
          row.queryInput.area_measure
        );
        concatFields.map((item) => {
          tableColumns.push({
            prop: item.fact_column,
            label: item.column,
          });
        });
        
      }
      if(row.type != 'index') this.$refs["item_" + row.i][0].parentHandleclick(); //解决报表管理：新建报表，来回切换视图后，图表异常（所有报表）
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
            sortConfig: item.queryInput.sortConfig,
            getDataWay: item.queryInput.getDataWay,
            sqlDatasourceId: item.queryInput.sqlDatasourceId,
            sqlString: item.queryInput.sqlString,
            searchItems: item.queryInput.searchItems
          }),
        }).then((res) => {
          const link = document.createElement("a");
          let blob = new Blob([res], { type: "application/vnd.ms-excel" });
          link.style.display = "none";
          link.href = URL.createObjectURL(blob);
          link.setAttribute("download", "list.xlsx");
          document.body.appendChild(link);
          link.click();
        });
      } catch (error) {}
    },
    componentUpdate(form) {
      let dashboardLayout = JSON.parse(JSON.stringify(this.dashboardLayout));
      dashboardLayout.map((item, index) => {
        if (item.i == this.itemFocusId) {
          item.loading = true;
          this.$set(this.dashboardLayout, index, item);
        }

      });
      this.updateSubmit(form);
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
// @import './styles/visual.scss';

.container {
  background: #fff;
  padding: 0;
  .component-title {
    width: 200px;
    margin-bottom: 20px;
  }
  .container-box {
    padding: 0;
  }
  .com-icon {
    width: 22px;
    height: 22px;
    background-repeat: no-repeat;
    background-size: contain;
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
.save-button{
  margin-left: 10px;
}
</style>
<style scoped>
.svg-icon{
  width: 1em;
  height: 1em;
}

</style>