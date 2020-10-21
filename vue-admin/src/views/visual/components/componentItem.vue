<template>
  <div ref="componentItem" class="wrap" :style="type=='tab'?'overflow-y: auto;':type=='filter'?'height:100%;':'height: calc(100% - 30px);'" >
    <!-- 组件内查询条件 -->
    <div ref="searchForm" >
      <el-form    
        v-if="getDataWay == 'sql'"     
        :inline="true" 
        class="form-search"         
        v-model="searchItems">    
        <span v-for="(item, index) in searchItems" :key="index">    
        <el-form-item v-if="item.show != 'false'" :label="item.label">
          <el-select 
            v-if="item.inputType == 'select'"
            v-model="item.value"
            clearable 
            :placeholder="item.placeholder">
            <el-option v-for="(v, i) in item.inputOptions" :key="i" :label="v" :value="v"></el-option>
          </el-select>
          <el-input                       
            v-else
            v-model="item.value" 
            label-width='80px' 
            :placeholder="item.placeholder"
            @input="onInput()" >
          </el-input>
        </el-form-item>
        </span>
      </el-form>
    </div>

    <!-- 指标看板 -->
    <div
      v-if="type=='index'"
      class="index-wrap"
    >
      <el-row :gutter="15">
        <el-col
          :span="(pieFunnelData.data.length>4)?6:24/pieFunnelData.data.length"
          v-for="(item,index) in pieFunnelData.data"
          :key="index"
        >
          <el-card >
            <div>
              <div class="title">{{item.name}}</div>
              <div class="number">
                <span style="font-size:12px;">{{ item.label ? item.label : measureField}}：</span>
                <count-to
                  :start-val="0"
                  :end-val="item.value||0"
                  :decimals="0"
                  :duration="2600"
                  class="card-panel-num"
                />
                <div class="fs-12 mt-5" v-if="item.ratio&&item.ratio!='NaN'">环比：{{item.ratio}}%</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
    <!-- 文本框 -->
    <div v-else-if="type=='text'" style="height:100%;">
      <Tinymce ref="editor" v-model="newsContext" :height="'100%'" />
    </div>
    <!-- 表格看板 -->
    <div v-else-if="type=='tab'" style="height: calc(100% - 60px);">
      <el-table
        @sort-change="sortChange"
        v-if="tableShow"
        border
        :data="tableData.slice(0,500)"         
        :max-height="tableHeight"       
      >
        <el-table-column
          v-for="(item,index) in tabColumns"
          :key="index"
          :prop="item.prop"
          :label="item.label"
          min-width="150px"
          sortable="custom"
          show-overflow-tooltip
        >
          <template slot-scope="scope">
            <span>{{ scope.row[item.prop]}}</span>  
          </template>
        </el-table-column>
      </el-table>
      <!-- 分页组件 -->
      <pagination 
        v-if="isPagination == true" 
        :paginationData="paginationData" 
        @handleCurrentChange="handleCurrentChange" />
    </div>
    <!-- 饼图/漏斗图看板 -->
    <div v-else-if="type=='pie'||type=='funnel'" style="height:100%;">
      <pieFunelChart
        :id="'componentsItem_'+id"
        :dataJson="pieFunnelData"
        :legendShow="false"
        :typeChart="type"
        ref="chartChild"
      />
    </div>
    <!-- 时间查询控件 -->
    <div v-else-if="type=='filter'" class="df-acenter">
      <el-form :label-position="'left'" label-width="85px" :inline="true">
        <el-form-item label="查询时间：">
          <date-picker :dateValue="dateValue" @changeDate="changeDate" />
        </el-form-item>
        <el-form-item class="dateRadio">
              <!-- 时间快捷导航 -->
              <date-quick
                @changeRadio="changeDateQuick"
                :defaultValue="dateRadio"
                :defaultOptions="dateRadioOptions"
              />
        </el-form-item>
      </el-form>
    </div>
    <!-- 其它图表看板 -->
    <div v-else style="height:100%;">
      <mixChart
        :id="'componentsItem_'+id"
        height="100%"
        width="100%"
        :dataJson="lbmixDataJson"
        :dataZoom="true"
        :typeChart="type"
        :mixChartShow="type=='mix'?mixChartShow:null"
        ref="chartChild"
      />
    </div>
  </div>
</template>
<script>
import Tinymce from "@/components/Tinymce";
import CountTo from "vue-count-to";
import pieFunelChart from "./pieFunelChart";
import mixChart from "./mixChart";
import DatePicker from "./dateTimePicker";
import DateQuick from "./dateQuickBtn";
import { getVariablesByStr, getNewRadioDate } from "@/utils";
import Pagination from "@/components/pagination";
export default {
  props: {
    componentData: {
      type: Object,
      default: {},
    },
  },
  data() {
    return {
      newsContext:'',
      //加载loading
      loading:true,
      //文本框的值
      editorValue: "",
      //暂时仅指标看板作标题使用
      measureField: "",
      //所选的时间范围值
      dateValue: [],
      tabColumns: [],
      tableData: [],
      tableShow: true,
      sortConfig: {
        sortField: "",
        sort: "",
      },
      //组件ID
      id: "",
      //组件类型
      type: "",
      //饼图/漏斗图数据
      pieFunnelData: {
        data: [],
        xAxis: [],
      },
      // 折线图/柱形图/组合图数据
      lbmixDataJson: {
        data: [],
        xAxis: [],
        legends: [],
      },
      mixChartShow: {
        type: "bar",
        show: true,
      },
      //筛选条件
      getDataWay: '',
      searchItems: [],
      //日期筛选
      dateRadio: "",
      dateRadioOptions: ["今日", "昨日", "近两日(含今日)", "近3天", "近7天", "近30天"],
      //表格分页
      isPagination: false,
      paginationData: {
        pageNumber: 1,
        pageSize: 5,
        total: 0
      },
      isHasSearch: false,
      tableHeight: 300,
      //是否展示图表label
      isShowChartLabel: false,
    };
  },
  mounted() {    
    console.log('组件数据更新',this.componentData)
    this.type = this.componentData.type;
    this.id = this.componentData.i;
    if(this.type == 'text'){
      this.newsContext = this.componentData.text;
    } else if (this.type == 'filter') {
      this.dateRadio = this.componentData.queryInput.dateRadio      
      this.dateValue = getNewRadioDate(this.dateRadio).length > 0? getNewRadioDate(this.dateRadio): (this.componentData.queryInput.dateValue ? this.componentData.queryInput.dateValue: [])
    }
  },
  watch: {
    componentData() {
      let type = this.type;
      let componentData = this.componentData;
      let { area_measure, area_dim, getDataWay, sqlString, searchItems } = componentData.queryInput;
      let { data } = componentData;      
      
      //变量参数配置
      this.getDataWay = getDataWay
      if (getDataWay == 'sql') {           
        const matchArr = getVariablesByStr(sqlString);          
        searchItems = searchItems ? searchItems: [];          
        let newSearchItems = [];
        console.log('====matchArr:', matchArr);
        matchArr.map(item=> {                    
            //配置数据筛选
            let arr = item;            
            arr.value = '';        
            for (let i in searchItems) {
              if (searchItems[i].label == item.label) {
                arr.value = searchItems[i].value ? searchItems[i].value: ( arr.inputValue ? arr.inputValue: '');              
              }
            }          
            //配置分页
            if (item.label == '分页') {              
              this.isPagination = true;
              this.paginationData.pageSize = item.pageSize ? parseInt(item.pageSize): 5;  
              this.paginationData.pageNumber = arr.value ? parseInt(arr.value): 1;  
            }
            //是否显示筛选条件
            item.show != 'false'?this.isHasSearch = true:'';
            //是否展示图表label
            this.isShowChartLabel = (item.isShowChartLabel == 'true')? true:false;
            //赋值筛选条件
            newSearchItems.push(arr);          
          
        });        
        this.searchItems = newSearchItems;                              
      }

      if (type == "line" || type == "bar" || type == "mix") {
        //配置折线图柱状图指标        
        if (this.isShowChartLabel && typeof(data) != 'undefined' && typeof(data.data[0]) != 'undefined' && typeof(data.data[0]['label']) == 'undefined') {
          data.data.map(item=>{
            item['label'] = {
              normal: {
                  show: true,
                  position: 'top',
                  formatter: function (params) {
                    return parseFloat(params.value).toLocaleString();
                  }
              }
            }
          })
        }        

        this.lbmixDataJson = data
          ? data
          : {
              data: [],
              xAxis: [],
              legends: [],
            };
      } else if (type == "pie" || type == "funnel" || type == "index") {        
        if (getDataWay == 'sql') {          
          this.measureField = ''
        } else {
          this.measureField = this.componentData.queryInput.area_measure[0].column; //只为指标看板标题用
        }
        this.pieFunnelData = data
          ? data
          : {
              data: [],
              xAxis: [],
            };
      } else if (type == "tab") {
        if (getDataWay == 'sql') {                         
          //sql查询
          let tableColumn = [];
          if (data.list) {
            for (let key in data.list[0]) {
              let arr = {};
              arr.fact_column = key;
              arr.column = key;
              tableColumn.push(arr);
            }
          }                   
          this.paginationData.total = parseInt(data.total) ? parseInt(data.total):0;          
          this.setTabConfig(tableColumn, [] ,data.list? data.list: []);
        } else {
          //模型查询
          this.setTabConfig(area_measure, area_dim ,data.list? data.list: []);
        }
        
      } else if(type == "text"){
        console.log('componentData',componentData)
        this.newsContext = componentData.text;
      }
      
      this.setTableHeight();
    },
  },
  methods: {
    getEditor(){
      console.log(this.newsContext)
    },
    changeDate(dateValue, dateRadio='') {
      this.dateValue = dateValue;
      this.dateRadio = dateRadio;
      let params = {
        dateValue: dateValue,
        dateRadio: dateRadio
      }
      this.$emit("refreshSubmit", params);
    },
    searchSubmit() {      
      let params = {
        item: this.componentData,
        searchItems: this.searchItems,
        sortConfig: this.sortConfig
      }                  
      this.$emit("itemRefreshSubmit", params);
    },
    onInput(){
      this.$forceUpdate();
    },
    parentHandleclick(e) {
      if (this.$refs.chartChild) {
        this.$refs.chartChild.$_resizeHandler();
        this.$refs.chartChild.$_initResizeEvent();
        this.$refs.chartChild.$_initSidebarResizeEvent();
      }
      //配置表格高度
      this.setTableHeight();
    },
    sortChange(res) {
      if (res.prop == null) return;
      this.sortConfig.sortField = res.prop;
      res.order == "ascending"
        ? (this.sortConfig.sort = "asc")
        : (this.sortConfig.sort = "desc");
      //触发排序更新数据操作      
      this.searchSubmit();      
    },
    setTabConfig(area_measure, area_dim) {
      let tableColumn = [];
      let fields = [];      
      fields = area_dim.concat(area_measure);
      fields.map((item) => {
        tableColumn.push({
          label: item.column,
          prop: item.fact_column,
        });
      });
      this.tabColumns = tableColumn;
      this.tableData = this.componentData.data.list ? this.componentData.data.list: [];
    },

    /**
     * 切换时间
     */
    async changeDateQuick(dateRadio) {      
      let dateValue = await getNewRadioDate(dateRadio);      
      this.changeDate(dateValue, dateRadio);      
    },


    /*
     * 切换分页
     */
    handleCurrentChange(val) {      
      this.paginationData.pageNumber = val;
      this.searchItems.map(item => {
        if (item.label == '分页') {
          item.value = val
        }
      })
      this.searchSubmit();
    },

    /**
     * 配置表格高度值
     */
    setTableHeight() {
      let tableHeight = this.$refs.componentItem.offsetHeight;                 
      this.tableHeight = this.isHasSearch ? tableHeight-62: tableHeight-2;
    }

  },
  components: {
    mixChart,
    pieFunelChart,
    DatePicker,
    DateQuick,
    CountTo,
    Tinymce,
    Pagination
  },
};
</script>
<style lang="scss" scoped>
.wrap {
  height: calc(100% - 30px);
  
  .index-wrap {
    overflow: hidden;
    overflow-y: auto;
    height: 100%;
    .el-card{
      background: #f7f9fa;
    }
    .el-card__body {
      .title {
        font-size: 15px;
        margin-bottom: 10px;
      }
      .number {
        font-size: 24px;
      }
    }
    .el-col-6 {
      margin-bottom: 15px;
    }
  }
  .df-acenter {
    height: 100%;
    display: flex;
    align-items: center;
  }
  .form-search{
    padding-bottom: 10px;
  }
}
</style>