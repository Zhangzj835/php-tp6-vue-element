<template>
  <div class="wrap">
    <div>
      <div class="mb-10">
        <el-button type="primary" icon="el-icon-plus" @click="addFilter">添加过滤条件</el-button>
      </div>
      <el-table :data="filterTableData" style="width: 100%">
        <el-table-column
          v-for="(item,index) in filtertabColumn"
          :prop="item.prop"
          :label="item.label"
          :key="index"
          :width="item.prop=='conValue'?250:'auto'"
        >
          <template slot-scope="scope">
            <div v-if="item.prop == 'speRequire'">
              <el-select
                filterable
                v-model="scope.row[item.prop]"
                placeholder="请选择字段"
                @change="selectSpeRequire(scope.$index,scope.row)"
              >
                <el-option
                  v-for="(item,index) in tableColumns"
                  :key="index"
                  :label="item.column"
                  :value="item.fact_column"
                ></el-option>
              </el-select>
            </div>
            <div v-else-if="item.prop == 'operatorSymbol'">
              <el-select
                :disabled="scope.row['speRequire']=='dt'?true:false"
                v-model="scope.row[item.prop]"
                placeholder="请选择操作符"
                @change="selectOperatorSymbol(scope.$index,scope.row)"
              >
                <el-option
                  v-for="(item,index) in scope.row['operatorSymbolArrs']"
                  :key="index"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
            </div>
            <div v-else-if="item.prop == 'addValType'">
              <el-select                
                v-model="scope.row[item.prop]"
                placeholder="请选择添加筛选值的方式"
              >
                <el-option label="输入" value="1"></el-option>
                <el-option v-if="scope.row['operatorSymbol']!=='LIKE'" label="下拉框" value="2"></el-option>
              </el-select>
            </div>
            <div v-else-if="item.prop == 'conValue'">
              <div v-if="scope.row['speRequire']=='dt'">
                <div v-if="scope.row['addValType']==1">
                  <date-picker :dateValue="dateValue" @changeDate="changeDate" />
                </div>
                <div v-else>
                  <el-select
                    collapse-tags
                    filterable                    
                    v-model="scope.row[item.prop]"
                    placeholder="请选择添加筛选值"
                  >
                    <el-option
                      v-for="(item,index) in scope.row['dimOptions']"
                      :key="index"
                      :value="item.value"
                    ></el-option>
                  </el-select>
                </div>
              </div>
              <div v-else>
                <div v-if="scope.row['addValType']==1">
                  <el-input
                    :type="scope.row['operatorSymbol']=='IN'?'textarea':'text'"
                    v-model="scope.row[item.prop]"
                    placeholder="请输入内容"
                  ></el-input>
                  <div
                    class="default-color"
                    v-if="scope.row['operatorSymbol']=='IN'"
                  >*批量查询输入值以逗号隔开（例如：'xx','xxx','xxxx'）</div>
                </div>
                <div v-else-if="scope.row['addValType']==2">
                  <el-select
                    collapse-tags
                    filterable
                    :multiple="scope.row['operatorSymbol']=='IN'?true:false"
                    v-model="scope.row[item.prop]"
                    placeholder="请选择添加筛选值"
                  >
                    <el-option
                      v-for="(item,index) in scope.row['dimOptions']"
                      :key="index"
                      :value="item.value"
                    ></el-option>
                  </el-select>
                </div>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column fixed="right" label="操作" width="80">
          <template slot-scope="scope">
            <el-button type="primary" size="small" @click="delfilTabDataItem(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>
<script>
import {
  userTabColumn,
  operatorSymbol,
  revenueTabColumn,
} from "../../beehive/config";
import DatePicker from "@/components/DateTimePicker";
import { getDimRelation } from "@/api/web";
export default {
  props: {
    dataModelsColumn: {
      type: Array,
      default: [],
    },
    filterArss: {
      type: Array,
      default: [],
    },
  },
  data() {
    return {
      //时间选择控件绑定值
      dateValue:[],
      //模拟全字段
      tableColumns: [],
      //过滤条件列表
      filterTableData: [
        {
          speRequire: "",
          operatorSymbol: "",
          addValType: "1",
          conValue: "",
          operatorSymbolArrs: [],
          dimOptions: [],
          type: "",
          
        },
      ],
      //过滤条件列表字段
      filtertabColumn: [
        {
          prop: "speRequire",
          label: "指定条件",
        },
        {
          prop: "operatorSymbol",
          label: "操作符",
        },
        {
          prop: "addValType",
          label: "添加筛选值的方式",
        },
        {
          prop: "conValue",
          label: "筛选值",
        },
      ],
    };
  },
  mounted() {
    this.init();
  },
  watch: {
    dataModelsColumn() {
      console.log(this.dataModelsColumn);
    },
    filterArss() {
      this.filterTableData = this.filterArss;
    },
  },
  methods: {
    init() {
      this.filterTableData = JSON.parse(JSON.stringify(this.filterArss)) ;
      this.tableColumns = this.dataModelsColumn;
      this.filterTableData.map(item=>{
        if(item.speRequire == 'dt'){
          this.dateValue = item.conValue.split(',')
        }
      })
      console.log("过滤条件", this.filterTableData);
    },
    /*
     * 选择操作符后，要把添加筛选值的方式和筛选值初始化
     */
    selectOperatorSymbol(idx, row) {
      this.filterTableData[idx].addValType = "1";
      this.filterTableData[idx].conValue = null;
    },
    /*
     * 插入一行筛选条件
     */
    addFilter() {
      this.filterTableData.push({
        speRequire: "",
        operatorSymbol: "",
        addValType: "1",
        conValue: null,
        operatorSymbolArrs: [],
        rely: "",
      });
    },
    /*
     * 插入维度关联表字段,用作下拉框选择值用
     */
    setDimOptions(idx, row, type) {
      let dataModelsColumn = this.dataModelsColumn;
      let dim_id = "";
      let dim_field = "";
      dataModelsColumn.map((item) => {
        if (item.fact_column == row.speRequire) {
          dim_id = item.dim_relation;
          dim_field = item.dim_relation_field;
        }
      });
      if (dim_id == null) {
        this.filterTableData[idx].dimOptions = [];
        return;
      }
      try {
        getDimRelation({
          dim_id,
          dim_field,
        }).then((res) => {
          let data = res.data;
          data.map((item) => {
            for (var key in item) {
              var newKey = "value";
              if (newKey) {
                item[newKey] = item[key];
                delete item[key];
              }
            }
          });
          let itemObj = this.filterTableData[idx];
          itemObj.dimOptions = data;
          this.$set(this.filterTableData, idx, itemObj);
          
          
        });
      } catch (error) {}
    },
    /*
     * 添加指定字段的时候不允许重复选择
     */
    selectSpeRequire(idx, row) {
      let selectFieldType = 0;
      this.tableColumns.map((item) => {
        if (item.fact_column == row.speRequire) {
          selectFieldType = item.type;
        }
      });

      let filterTableData = this.filterTableData;
      let operatorSymbol = [];

      //重新选择了字段后，都清空已选值
      this.filterTableData[idx].conValue = null;

      //插入维度关联表字段,用作下拉框选择值用
      this.setDimOptions(idx, row, selectFieldType);

      //遍历过滤条件，根据字段类型赋值可选操作符
      this.filterTableData[idx].operatorSymbolArrs =
        selectFieldType == 1
          ? [
              {
                description: "等于",
                value: "=",
              },
              {
                description: "不等于",
                value: "!=",
              },
              {
                description: "在集合中",
                value: "IN",
              },
              {
                description: "模糊匹配",
                value: "LIKE",
              },
            ]
          : [
              {
                description: "等于",
                value: "=",
              },
              {
                description: "不等于",
                value: "!=",
              },
              {
                description: "大于",
                value: ">",
              },
              {
                description: "小于",
                value: "<",
              },
              {
                description: "小于等于",
                value: "<=",
              },
              {
                description: "大于等于",
                value: ">=",
              },
              {
                description: "在集合中",
                value: "IN",
              },
            ];
    },
    /*
     * 删除弹窗过滤条件（未确定）
     */
    delfilTabDataItem(row) {
      let filterTableData = this.filterTableData;
      filterTableData.map((item, index) => {
        if (item.speRequire == row.speRequire) {
          this.filterTableData.splice(index, 1);
        }
      });
    },
    changeDate(dateValue) {
      this.filterTableData.map(item=>{
        if(item.speRequire == 'dt'){
          item.conValue = dateValue.join(',')
        }
      })
    },
    btnClick(row, className) {
      this.fieldTags.map((item) => {
        if (item.prop == row.speRequire) {
          row.label = item.label;
        }
      });
      this.filterFieldsValue = row;
      document.querySelector("." + className).click();
    },
  },
  components: {
    DatePicker
  },
};
</script>
<style lang="scss" scoped>
.wrap {
  height: 100%;
}
</style>