<template>
  <div
    class="row wrap"
    v-loading="modelColumnLoading"
    v-if="itemConfig.type!='filter'&&itemConfig.type!='text'"
  >
    <div class="header mb-10">{{sidebarTitle}}</div>
    <el-button type="primary" @click="updateSubmit" class="update-btn">更新</el-button>

    <div class="header-setting-type">
        <el-button :type="(form.getDataWay != 'sql')?'primary':'plain'" size="small" @click="selectGetWay('')">选择模型</el-button>
        <el-button :type="(form.getDataWay == 'sql')?'primary':'plain'" size="small" @click="selectGetWay('sql')">输入SQL</el-button>
    </div>

    <!-- sql配置 -->
    <div v-if="form.getDataWay == 'sql'">
      <div class="mb-10">
        <el-form label-width="80px">
          <el-form-item label="数据源">
            <el-select placeholder="请选择数据源" v-model="form.sqlDatasourceId">
              <el-option
                v-for="(item, index) in dataSourceArr"
                :key="index"
                :label="item.source_name"
                :value="item.id"
              ></el-option>
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <div>        
          <!-- web编辑器 -->
          <code-mirror ref="mycode" :value="form.sqlString" />
      </div>
      
      <!--温馨提示-->
      <div>
        <br/>
        &nbsp;&nbsp;温馨提示
        <el-button type="text" @click="dialogVisibleTip = true">（点击查看）</el-button><br/>
        <el-dialog
          title="提示"
          :visible.sync="dialogVisibleTip"
          width="60%">
          <span>
            <ol>
            <li>配置可变参数的格式为：${XXX}</li>            
            <li>输入框提示配置 <span style="color:orange">placeholder</span>：
              <div>如：${今日||placeholder=格式为：xxxx-xx-xx}</div>
            </li>
            <li>默认值配置 <span style="color:orange">default</span>：
              <div>如：${姓名||default=张三}</div>
              <div>延伸：((phone='${手机号码||default=' or phone!='}') and (nickname='${昵称||default=' or nickname != '}'))  可实现多条件组合查询，空值不作为查询条件</div>
            </li>
            <li>随页面时间控件查询 <span style="color:orange">filterDate</span>：
              <div>${开始日期||filterDate=start}</div>
              <div>${结束日期||filterDate=end}</div>
            </li>
            <li>是否展示组件查询 <span style="color:orange">show</span>：
              <div>不显示：${开始日期||show=false}</div>
              <div>默认显示：${结束日期||show=true}</div>
            </li>
            <li>下拉框配置 <span style="color:orange">inputType</span> <span style="color:orange">inputOptions</span>：
              <div>需 inputType=select 和 inputOptions 两个关键字组合配置</div>
              <div>如：${渠道||inputType=select||inputOptions=京东,淘宝}</div>
            </li>
            <li>特殊可变参数有：
              <div>${今日}:系统自动替换为当天日期,格式为：20201002</div>
              <div>${昨日}:系统自动替换为昨天日期,格式为：20201001</div>
            </li>
            <li>查询优先级排序为：
              <div>图表中的筛选条件 > 页面中筛选条件 > sql内的default默认值 > 特殊可变参数 </div>
            </li>
          </ol>
          </span>
          <span slot="footer" class="dialog-footer">            
            <el-button type="primary" @click="dialogVisibleTip = false">确 定</el-button>
          </span>
        </el-dialog>

        <div v-if="itemConfig.type == 'tab'">          
          
        </div>
        <div v-else-if="itemConfig.type == 'line' || itemConfig.type == 'bar'">          
          <ol>
            <li>折线图或柱状图：结果集的第一列为维度，其余列为指标</li>            
          </ol>
        </div>
        <div v-else-if="itemConfig.type == 'mix'">          
          <ol>
            <li>组合图：结果集的第一列为维度，第二列为折线图，第三列为柱形图</li>            
            <li>若结果集只有两列，则不展示柱形图</li>            
            <li>若结果集超过三列，则不展示其余列</li>            
          </ol>
        </div>
        <div v-else-if="itemConfig.type == 'pie'">          
          <ol>
            <li>饼状图：结果集的第一列为名称，第二列为值</li>          
          </ol>
        </div>
        <div v-else-if="itemConfig.type == 'index'">          
          <ol>
            <li>指标看板：结果集的第一列为指标看板的标题，第二列为数值</li>          
            <li>指标看板：<div style="color:orange;display:inline-block">暂不支持环比的计算</div></li>          
          </ol>
        </div>
        <div v-else-if="itemConfig.type == 'funnel'">          
          <ol>
            <li>漏斗图：结果集的第一列为维度，第二列为指标值</li>                      
          </ol>
        </div>

      </div>
    </div>
    <!-- 拖拽配置 -->
    <div v-else>
      <div class="mb-10">
        <el-form label-width="80px">
          <el-form-item label="数据模型">
            <el-select placeholder="请选择" v-model="form.modelValue" @change="selectModel">
              <el-option
                v-for="item in dataModels"
                :key="item.id"
                :label="item.caption"
                :value="item.fac_table"
              ></el-option>
            </el-select>
          </el-form-item>
        </el-form>
      </div>    
      <div class="sidebar-content">
        <el-row>
          <!-- 配置 -->
          <el-col :span="12">
            <!-- 配置指标 -->
            <div class="grid-content bg-purple">
              <div class="title">
                {{itemConfig.type=='bar'||itemConfig.type=='line'?'值轴':itemConfig.type=='pie'?'扇区角度':itemConfig.type=='mix'?'主值轴':itemConfig.type=='index'?'看板指标':itemConfig.type=='funnel'?'漏斗层宽':''}}{{itemConfig.type=='tab'?'':'/'}}指标
                <span
                  v-if="itemConfig.type!='tab'"
                >（{{form.selectMeasure.length}}/{{fieldLimits}}）</span>
              </div>
              <draggable
                class="dragArea list-group"
                :options="daOptions"
                :list="form.selectMeasure"
                group="measure"
                @change="measureChange"
              >
                <div class="list-group-item" v-for="item in form.selectMeasure" :key="item.column">
                  <el-tooltip effect="dark" :content="item.column" placement="left-start">
                  <div class="title-field">{{ item.column }}</div>
                  </el-tooltip>

                  <span class="field-operation">
                    <el-tooltip class="item" effect="dark" content="排序" placement="top-start">
                      <span class="el-table">
                        <span :class="item.sort">
                          <span class="caret-wrapper">
                            <i class="sort-caret ascending" @click="sortChange(item,'ascending')"></i>
                            <i class="sort-caret descending" @click="sortChange(item,'descending')"></i>
                          </span>
                        </span>
                      </span>
                    </el-tooltip>
                    <el-tooltip class="item" effect="dark" content="删除" placement="top-start">
                      <i class="el-icon-delete" @click="delField(item)"></i>
                    </el-tooltip>
                  </span>
                </div>
              </draggable>
            </div>
            <!-- 配置副值轴/指标 -->
            <div v-if="itemConfig.type == 'mix'" class="grid-content bg-purple">
              <div class="title">副值轴/指标 （{{form.selectScondMeasure.length}}/{{fieldLimits}}）</div>
              <draggable
                class="dragArea list-group"
                :options="daOptions"
                :list="form.selectScondMeasure"
                group="measure"
                @change="secondMeasureChange"
              >
                <div
                  class="list-group-item"
                  v-for="item in form.selectScondMeasure"
                  :key="item.column"
                >
                <el-tooltip effect="dark" :content="item.column" placement="left-start">
                  <div class="title-field">{{ item.column }}</div>
                </el-tooltip>

                  <span class="field-operation">
                    <el-tooltip class="item" effect="dark" content="排序" placement="top-start">
                      <span class="el-table">
                        <span :class="item.sort">
                          <span class="caret-wrapper">
                            <i class="sort-caret ascending" @click="sortChange(item,'ascending')"></i>
                            <i class="sort-caret descending" @click="sortChange(item,'descending')"></i>
                          </span>
                        </span>
                      </span>
                    </el-tooltip>
                    <el-tooltip class="item" effect="dark" content="删除" placement="top-start">
                      <i class="el-icon-delete" @click="delSecondMeasureField(item)"></i>
                    </el-tooltip>
                  </span>
                </div>
              </draggable>
            </div>
            <!-- 配置维度 -->
            <div class="grid-content bg-purple" >
              <div class="title">
                {{itemConfig.type=='bar'||itemConfig.type=='line'||itemConfig.type=='mix'?'类别轴':itemConfig.type=='pie'?'扇区标签':itemConfig.type=='index'?'看板标签':itemConfig.type=='funnel'?'漏斗分层':''}}{{itemConfig.type=='tab'?'':'/'}}维度
                <span
                  v-if="itemConfig.type!='tab'"
                >（{{form.selectDimension.length}}/1）</span>
              </div>
              <draggable
                :options="daOptions"
                class="dragArea list-group"
                :list="form.selectDimension"
                group="dimension"
                @change="dimensionChange"
              >
                <div
                  class="list-group-item"
                  v-for="(element,index) in form.selectDimension"
                  :key="element.column"
                >
                <el-tooltip effect="dark" :content="element.column" placement="left-start">
                  <div class="title-field">{{ element.column }}</div>
                </el-tooltip>

                  <span class="field-operation">
                    <el-tooltip class="item" effect="dark" content="排序" placement="top-start">
                      <span class="el-table">
                        <span :class="element.sort">
                          <span class="caret-wrapper">
                            <i class="sort-caret ascending" @click="sortChange(element,'ascending')"></i>
                            <i
                              class="sort-caret descending"
                              @click="sortChange(element,'descending')"
                            ></i>
                          </span>
                        </span>
                      </span>
                    </el-tooltip>
                    <el-tooltip class="item" effect="dark" content="删除" placement="top-start">
                      <i class="el-icon-delete" @click="form.selectDimension.splice(index,1)"></i>
                    </el-tooltip>
                  </span>
                  <!-- <span class="field-operation">
                    <i class="el-icon-delete" @click="form.selectDimension.splice(0,1)"></i>
                  </span>-->
                </div>
              </draggable>
            </div>
            <!-- 配置颜色维度 -->
            <div class="grid-content bg-purple" v-if="itemConfig.type == 'bar' || itemConfig.type == 'line'">
              <div class="title">
                颜色/维度
                <span
                  v-if="itemConfig.type!='tab'"
                >（{{form.selectSecondDimension.length}}/1）</span>
              </div>
              <draggable
                :options="daOptions"
                class="dragArea list-group"
                :list="form.selectSecondDimension"
                group="dimension"
                @change="secondDimensionChange"
              >
                <div
                  class="list-group-item"
                  v-for="(element,index) in form.selectSecondDimension"
                  :key="element.column"
                >
                <el-tooltip effect="dark" :content="element.column" placement="left-start">
                  <div class="title-field">{{ element.column }}</div>
                </el-tooltip>

                  <span class="field-operation">
                    <el-tooltip class="item" effect="dark" content="排序" placement="top-start">
                      <span class="el-table">
                        <span :class="element.sort">
                          <span class="caret-wrapper">
                            <i class="sort-caret ascending" @click="sortChange(element,'ascending')"></i>
                            <i
                              class="sort-caret descending"
                              @click="sortChange(element,'descending')"
                            ></i>
                          </span>
                        </span>
                      </span>
                    </el-tooltip>
                    <el-tooltip class="item" effect="dark" content="删除" placement="top-start">
                      <i class="el-icon-delete" @click="form.selectSecondDimension.splice(index,1)"></i>
                    </el-tooltip>
                  </span>
                </div>
              </draggable>
            </div>
            <!-- 配置过滤条件 -->
            <div class="grid-content bg-purple">
              <div class="title">过滤条件</div>

              <div class="list-group-item" v-for="(item,index) in form.filterTags" :key="index">
                <el-tooltip effect="dark" :content="item.labelZhCn+' '+item.operatorSymbol+' '+item.conValue" placement="left-start">
                  <div class="title-field">{{item.labelZhCn+' '+item.operatorSymbol+' '+item.conValue}} </div>
                </el-tooltip>

                <span class="field-operation">
                  <el-tooltip class="item" effect="dark" content="删除" placement="top-start">
                    <i class="el-icon-delete" @click="delFilterTags(index)"></i>
                  </el-tooltip>
                </span>
              </div>

              <el-button
                :style="form.filterTags.length?'':'margin-top:10px;'"
                class="button-new-tag mt-10"
                size="small"
                @click="openFilterDialog"
              >
                <i class="el-icon-plus"></i>
              </el-button>
            </div>
          </el-col>

          <!-- 模型指标维度 -->
          <el-col :span="12" class="rg-field">
            <div class="grid-content bg-purple">
              <div class="title">指标</div>
              <draggable
                class="dragArea list-group"
                :list="measure"
                :options="daOptions"
                :group="{ name: 'measure', pull: 'clone', put: false }"
              >
                <div class="list-group-item" v-for="element in measure" :key="element.column">
                  <el-tooltip effect="dark" :content="element.column" placement="left-start">
                  <div class="title-field">{{ element.column }}</div>
                  </el-tooltip>
                </div>
              </draggable>
            </div>
            <div class="grid-content bg-purple pb-40">
              <div class="title">维度</div>
              <draggable
                class="dragArea list-group"
                :list="dimension"
                :options="daOptions"
                :group="{ name: 'dimension', pull: 'clone', put: false }"
              >
                <div class="list-group-item" v-for="element in dimension" :key="element.column">
                  <el-tooltip effect="dark" :content="element.column" placement="left-start">
                  <div class="title-field">{{ element.column }}</div>
                  </el-tooltip>
                </div>
              </draggable>
            </div>
          </el-col>
        </el-row>
      </div>

      <!-- 过滤条件弹框 -->
      <el-dialog
        title="过滤条件"
        :visible.sync="conditionVisible"
        width="900px"
        :before-close="conditionOnSubmit"
      >
        <div v-if="conditionVisible">
          <componentFilter
            ref="componentFilter"
            :dataModelsColumn="dataModelsColumn"
            :filterArss="filterTableData"
          />
        </div>
        <span slot="footer" class="dialog-footer">
          <el-button @click="conditionVisible = false">取 消</el-button>
          <el-button type="primary" @click="conditionOnSubmit">确 定</el-button>
        </span>
      </el-dialog>
    </div>

  </div>

</template>

<script>
import { getRadioDate, getNowDay, getVariablesByStr } from "@/utils";
import { getDataModels, getDataModelColumn, getDataSources } from "@/api/web";
import componentFilter from "./componentFilter";
import CodeMirror from "./codemirror";
import draggable from "vuedraggable";
let idGlobal = 8;
export default {
  name: "custom-clone",
  props: {
    itemConfig: {
      type: Object,
      default: null,
    },
  },
  components: {
    draggable,
    componentFilter,
    CodeMirror,
  },
  data() {
    return {            
      sortClass: "",
      filterTableData: [], //已选过滤条件
      modelColumnLoading: false,
      form: {
        filterTags: [],
        modelValue: "",
        selectDimension: [],
        selectSecondDimension: [],
        selectMeasure: [],
        selectScondMeasure: [],
        getDataWay: '',  //获取数据方式 1:模型拖拽配置 2:sql获取
        sqlDatasourceId: '',
        sqlString: ''
      },
      daOptions: {
        sort: true,
      },
      modelValue: "",
      //选中过滤条件
      filterTags: [],
      //过滤条件弹窗 显示/隐藏
      conditionVisible: false,
      animation: 200,
      group: "description",
      disabled: false,
      dataModels: [],
      dataModelsColumn: [],
      dimension: [],
      measure: [],
      selectDimension: [],
      selectMeasure: [],
      dataSourceArr: [],  //数据源
      dialogVisibleTip: false
    };
  },
  watch: {
    itemConfig() {
      this.configInit();
    },
  },
  mounted() {
    this.init();
  },
  computed: {
    fieldLimits() {
      let limit = 0;
      let type = this.itemConfig.type;
      limit = type == "bar" || type == "line" || type == "mix" ? 5 :type=='funnel'?10: 1;
      return limit;
    },
    sidebarTitle() {
      let title = ``;
      let type = this.itemConfig.type;
      title =
        type == "bar"
          ? "柱形图"
          : type == "pie"
          ? "饼图"
          : type == "mix"
          ? "混合图形"
          : type == "index"
          ? "指标看板"
          : type == "line"
          ? "折线图"
          : type == "funnel"
          ? "漏斗图"
          : type == "tab"
          ? "表格"
          : "";
      return title;
    },
  },
  methods: {
    init() {
      this.getDataModels(); //获取数据模型
      this.getDataSources(); //获取数据源
    },
    sortChange(item, sortType) {
      console.log(item, sortType);
      if (item.sort == sortType) {
        item.sort = "";
        return;
      }
      item.sort = sortType;
    },
    configInit() {
      let itemConfig = this.itemConfig;           
      this.form = {
        filterTags: itemConfig.queryInput.filters,
        modelValue: itemConfig.dataFromId,
        selectDimension: itemConfig.queryInput.area_dim,
        selectSecondDimension: itemConfig.queryInput.second_dim ? itemConfig.queryInput.second_dim: [],
        selectMeasure: itemConfig.queryInput.area_measure,
        selectScondMeasure: itemConfig.queryInput.second_measure,
        getDataWay: itemConfig.queryInput.getDataWay ? itemConfig.queryInput.getDataWay: '',  //获取数据方式 '':模型拖拽配置 'sql':sql获取
        sqlDatasourceId: itemConfig.queryInput.sqlDatasourceId,
        sqlString: itemConfig.queryInput.sqlString ? itemConfig.queryInput.sqlString: '',
        searchItems: itemConfig.queryInput.searchItems ? itemConfig.queryInput.searchItems: [],
      }; 
      if (this.form.getDataWay == 'sql') {        
        let that = this;
        setTimeout(function(){                    
          that.$refs.mycode.refreshValue(that.form.sqlString);
        }, 200)
        
        
      }
      

      let model_id = 0;

      this.dataModels.map((item) => {
        if (item.fac_table == itemConfig.dataFromId) {
          model_id = item.id;
        }
      });
      this.getDataModelColumn(model_id);
    },
    
    delFilterTags(idx) {
      this.form.filterTags.splice(idx, 1);
      this.filterTableData.splice(idx, 1);
    },
    dimensionChange(item) {
      if (this.itemConfig.type == "tab") return;
      if (this.form.selectDimension.length > 1) {
        this.$message({
          message: "已超过可添加字段数量",
          type: "warning",
        });
        this.form.selectDimension.splice(1, 1);
      }
    },
    secondDimensionChange(item) {
      if (this.itemConfig.type == "tab") return;
      if (this.form.selectSecondDimension.length > 1) {
        this.$message({
          message: "已超过可添加字段数量",
          type: "warning",
        });        
        this.form.selectSecondDimension.splice(1, 1);
      }
      //判断指标是否大于1（指标数只能为1）
      if (this.form.selectMeasure.length > 1) {
        this.$message({
          message: "颜色维度已有项，指标只能有一项",
          type: "warning",
        });        
        this.form.selectSecondDimension.splice(0, 1);
      }
      //判断维度是否已经存在
      let dimArr = []
      for (let i in this.form.selectDimension) {
        dimArr.push(this.form.selectDimension[i].column);
      }      
      for (let i in this.form.selectSecondDimension) {
        if (dimArr.indexOf(this.form.selectSecondDimension[0].column) >= 0) {
          this.$message({
            message: "已存在该维度",
            type: "warning",
          });        
          this.form.selectSecondDimension.splice(0, 1);
        }
      }
    },
    secondMeasureChange(item) {
      if (this.form.selectScondMeasure.length > this.fieldLimits) {
        this.$message({
          message: "已超过可添加字段数量",
          type: "warning",
        });
        this.form.selectScondMeasure.map((itemMeasure, index) => {
          if (itemMeasure.fact_column == item.added.element.fact_column) {
            this.form.selectScondMeasure.splice(index, 1);
          }
        });
      }
    },
    measureChange(item) {
      let selectMeasure = this.form.selectMeasure;
      //impala不支持一个查询中多个聚合函数使用distinct
      let len = 0;
      console.log('selectMeasure',selectMeasure)
      selectMeasure.map((item,index)=>{
        if(item.deduplication_count){
          if(len>=1){
            this.form.selectMeasure.splice(index, 1);
            return this.$message({
              message: '暂不支持一个查询中的多个聚合函数使用去重计数',
              type: 'warning'
            });
          }
          len+=1;
        }
      })
      //表格不设限制
      if (this.itemConfig.type == "tab") return;
      //字段数限制
      if (this.form.selectMeasure.length > this.fieldLimits) {
        this.$message({
          message: "已超过可添加字段数量",
          type: "warning",
        });
        this.form.selectMeasure.map((itemMeasure, index) => {
          if (itemMeasure.fact_column == item.added.element.fact_column) {
            this.form.selectMeasure.splice(index, 1);
          }
        });
      }
      
    },
    selectModel() {
      console.log("this.form.filterTags", this.form.filterTags);
      console.log("filterTableData", this.filterTableData); //this.filterTableData = this.form.filterTags;
      let model_id = 0;
      this.dataModels.map((item) => {
        if (item.fac_table == this.form.modelValue) {
          model_id = item.id;
        }
      });
      this.getDataModelColumn(model_id);
      //切换数据模型后，指标/维度/过滤条件都要清空
      this.form.selectScondMeasure = [];
      this.form.selectDimension = [];
      this.form.selectSecondDimension = [];
      this.form.selectMeasure = [];
      this.form.filterTags = [];
    },
    getDataModelColumn(model_id) {
      
      try {
        this.modelColumnLoading = true;
        getDataModelColumn({
          model_id,
        }).then((res) => {
          this.modelColumnLoading = false;
          let data = res.data.list;
          this.dataModelsColumn = data;
          let measure = [];
          let dimension = [];
          data.map((item) => {
            if (item.type == 1) {
              dimension.push(item);
            } else if (item.type == 2) {
              measure.push(item);
            }
          });
          this.measure = measure;
          this.dimension = dimension;
          let flag = false;
          let filterTags = this.form.filterTags;
          const dtDimOptions = [
                    {value:'今日'},
                    {value:'昨日'},
                    {value:'近两日(含今日)'},
                    {value:'近3天'},
                    {value:'近7天'},
                    {value:'近10天'},
                    {value:'近14天'},
                    {value:'近30天'},
                    {value:'本周'},
                    {value:'本月'},
                    {value:'上一周'},
                    {value:'上一个月'}
                ]
          filterTags.map(item=>{
            if(item.speRequire == 'dt'){
              flag = true;
              item.dimOptions = dtDimOptions
            }
          })
          if(flag) return;
          //获取最近30天
          let dateValue = getRadioDate("近30天").join(','); //"2020-08-01 00:00:00,2020-08-25 23:59:59";
          
          dimension.map(item=>{
            if(item.fact_column == 'dt'){
              this.form.filterTags = [
                {
                  speRequire: "dt",
                  operatorSymbol: "",
                  addValType: "1", 
                  conValue: dateValue,
                  operatorSymbolArrs: [],
                  rely: "",
                  dimOptions: dtDimOptions,
                  labelZhCn: item.column,
                  type: 1,
                },
              ];
            }
          })
        });
      } catch (error) {}
    },
    getDataModels() {
      try {
        getDataModels().then((res) => {
          if (res.code == 10000) {
            this.dataModels = res.data.list;
            this.configInit();
          }
        });
      } catch (error) {}
    },
    
    /**
     * 获取数据源
     */
    getDataSources() {
        try {
        getDataSources().then((res) => {
          if (res.code == 10000) {
            this.dataSourceArr = res.data.list;            
          }
        });
      } catch (error) {}
    },

    /*
     * 过滤数据
     */
    async rinseTabData(filterTableData) {
      filterTableData.map((item) => {
        if (item.operatorSymbol == "IN") {
          let conValue = ``;
          let len = item.conValue.length;
          item.conValue.map((item2, index) => {
            conValue += `'${item2}'${len - 1 == index ? "" : ","}`;
          });
          item.conValue = conValue;
        }
      });
      return filterTableData;
    },
    async conditionOnSubmit() {
      let filterTableData = this.$refs.componentFilter.filterTableData;
      for (let i = 0; i < filterTableData.length; i++) {
        if (
          filterTableData[i].speRequire != "dt" &&
          (filterTableData[i].operatorSymbol == "" ||
            filterTableData[i].conValue == null)
        ) {
          return this.$message({
            message: "操作符/筛选值不能为空",
            type: "warning",
          });
        }
      }

      //过滤数据
      // filterTableData = await this.rinseTabData(filterTableData);
      this.filterTableData = filterTableData; //已选过滤条件保存起来
      let filterTags = [];
      if (!filterTableData.length) {
        filterTags = [];
      } else {
        filterTags = JSON.parse(JSON.stringify(filterTableData));
      }
      let dataModelsColumn = this.dataModelsColumn;
      let arrs = [];
      filterTags.map((item, index) => {
        dataModelsColumn.map((item2) => {
          if (item.speRequire == item2.fact_column) {
            item.labelZhCn = item2.column;
            item.type = item2.type;
            arrs.push(item);
          }
        });
      });
      console.log("arrs", arrs);
      this.form.filterTags = arrs;
      this.conditionVisible = false;
    },
    openFilterDialog() {
      console.log("filterTableData", this.filterTableData);
      console.log("this.form.filterTags", this.form.filterTags);
      this.conditionVisible = true;
      this.filterTableData = this.form.filterTags;
    },
    delSecondMeasureField(item) {
      let selectMeasure = this.form.selectScondMeasure;
      selectMeasure.map((cell, index) => {
        if (item.id == cell.id) {
          selectMeasure.splice(index, 1);
        }
      });
    },
    delField(item) {
      console.log(item);
      let selectMeasure = this.form.selectMeasure;
      selectMeasure.map((cell, index) => {
        if (item.id == cell.id) {
          selectMeasure.splice(index, 1);
        }
      });
    },
    log(evt) {},
    indexChange() {},
    cloneDog({ id }) {
      return {
        id: idGlobal++,
        name: `cat ${id}`,
      };
    },
    updateSubmit() {
      this.form.sqlString = (this.$refs.mycode && this.$refs.mycode.code) ? this.$refs.mycode.code : this.form.sqlString;
      console.log('dataModels',this.dataModels)
      console.log('form',this.form)

      //参数校验
      if (this.form.getDataWay == 'sql') {
        if (!this.form.sqlDatasourceId) {
          return this.$message.error("请选择数据源");
        }
        if (!this.form.sqlString) {
          return this.$message.error("请输入sql查询语句");
        }
      } else {
        if (
          !this.form.selectMeasure.length ||
          (!this.form.selectDimension.length && this.itemConfig.type !== "index" && this.itemConfig.type !== "funnel")
        ) {
          return this.$message.error("缺少维度或指标项");
        }
      }
      
      //漏斗图当指标字段超过1个，删除已选维度字段
      if(this.itemConfig.type=='funnel'&&this.form.selectMeasure.length>1){
        if(this.form.selectDimension.length){
          this.$message({
            message: '漏斗图组件指标/指标字段超过1个，不支持加上维度查询',
            type: 'warning'
          });
        }
        this.form.selectDimension = [];
      }
      let arrs = [];
      let flag = true;
      this.form.selectMeasure.map((item) => {
        if (arrs.indexOf(item.fact_column) !== -1) {
          flag = false;
        }
        arrs.push(item.fact_column);
      });
      if (!flag) return this.$message.error("存在重复字段");
      this.dataModels.map(item=>{
        if(item.fac_table == this.form.modelValue){
          this.form.dataSource = item.data_source;
        }
      })

      //配置搜索条件
      if (this.form.getDataWay == 'sql') {           
        const matchArr = getVariablesByStr(this.form.sqlString);          
        let oldSearchItems = this.form.searchItems ? this.form.searchItems: [];          
        let newSearchItems = [];
        matchArr.map(item=> {
          let arr = {};
          arr.label = item.label;
          arr.value = '';        
          arr.inputType = item.inputType;  
          for (let i in oldSearchItems) {
            if (oldSearchItems[i].label == item.label) {
              arr.value = oldSearchItems[i].value;
            }
          }          
          newSearchItems.push(arr);
        });
        this.form.searchItems = newSearchItems;                                     
      }

      this.$emit("componentUpdate", this.form);
    },

    /**
     * 改变配置类型
     */
    selectGetWay(type) {            
      this.form.getDataWay = type;
    }

  },
};
</script>
<style  lang="scss"  scoped>
.row {
  height: calc(100vh - 140px);
  border-left: 1px solid #f2f2f2;
  position: relative;
  .button-new-tag {
    margin: 0 10px 10px;
  }

  .update-btn {
    width: 100%;
    position: absolute;
    bottom: 0;
    border-radius: 0;
    z-index: 10;
  }
  .grid-content {
    border-bottom: 1px solid #f2f2f2;
    border-left: 1px solid #f2f2f2;
  }
  .header {
    text-align: center;
    line-height: 43px;
    border-bottom: 1px solid #ebeef5;
    background: rgb(236, 235, 242);
  }
  .header-setting-type{
    text-align: center;
    padding-bottom: 5px;
    margin-bottom: 5px;
    border-bottom: 1px dotted gray;
  }
  .sidebar-content {
    // padding: 0px 13px;
    .title {
      text-align: center;
      padding: 10px 0;
      background: rgb(236, 235, 244);
    }
  }
  .list-group-item {
    position: relative;
    display: block;
    padding: 0;
    background-color: #fff;
    border: 1px solid rgba(0, 0, 0, 0.125);
    cursor: move;
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    margin: 4px;
    height: 28px;
    line-height: 28px;
    padding: 0 10px;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    word-break: break-all;
    .title-field {
      display: inline-block;
      /* width: 100%; */
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    .el-table::before {
      height: 0;
    }
    .field-operation {
      text-align: right;
      flex: 1;
      .el-icon-delete {
        cursor: pointer;
        &:hover {
          color: #24a0ff;
        }
      }
    }
  }
  .list-group {
    max-height: 83px;
    overflow: hidden;
    overflow-y: auto;
    min-height: 60px;
  }
  .rg-field {
    height: calc(100vh - 284px);
    overflow: hidden;
    .grid-content {
      height: 50%;
    }
    .pb-40{
      padding-bottom: 40px;
    }
    .list-group {
      overflow: hidden;
      overflow-y: auto;
      height: 86%;
      max-height: 86%;
      min-height: 86%;
    }
  }
}
</style>