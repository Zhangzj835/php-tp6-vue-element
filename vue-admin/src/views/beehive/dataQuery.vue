<template>
  <div class="container chooseSystem">
    <div class="container-box mb-20">
      <el-form ref="form" label-position="left" label-width="110px">
        <el-form-item label="查询数据类型：">
          <el-radio-group v-model="form.dataType" @change="changeDataType">
            <el-radio v-model="form.dataType" label="用户">用户</el-radio>
            <el-radio v-model="form.dataType" label="营收">营收</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="时间筛选：">
          <div class="df-acenter">
            <el-date-picker
              v-model="form.dateTime"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              value-format="yyyy-MM-dd"
              @change="changeDateTime"
            ></el-date-picker>
            <div class="ml-20">
              <!-- 时间快捷导航 -->
              <date-quick
                @changeRadio="changeRadio"
                :defaultValue="dateQuick.radioValue"
                :defaultOptions="dateQuick.options"
              />
            </div>
          </div>
        </el-form-item>

        <el-form-item label="所需字段：">
          <el-tag
            :key="idx"
            v-for="(tag,idx) in fieldTags"
            closable
            :disable-transitions="false"
            @close="delfieldTag(idx)"
          >{{tag.label}}</el-tag>
          <el-button class="button-new-tag" size="small" @click="requiredFields">+ 添加</el-button>
        </el-form-item>
        <el-form-item label="时间粒度：" v-if="timeShow">
          <el-radio-group @change="selectRadio" v-model="form.timeGranularity">
            <el-radio label="日">日</el-radio>
            <el-radio label="周">周</el-radio>
            <el-radio label="月">月</el-radio>
            <el-radio label="年">年</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="过滤条件：">
          <el-tag
            :key="idx"
            v-for="(tag,idx) in filterTags"
            closable
            :disable-transitions="false"
            v-if="tag.labelZhCn!=''"
            @close="delfilterTag(idx)"
          >{{tag.labelZhCn+' '+tag.operatorSymbol+' '+tag.conValue}}</el-tag>
          <el-button class="button-new-tag" size="small" @click="conditionalFilter">+ 添加</el-button>
        </el-form-item>
      </el-form>
    </div>
    
    <div class="container-box">
      <div class="mb-10">
        <el-button type="primary" size="small" @click="queryData" :loading="queryLoading">查询</el-button>
        <el-button type="primary" size="small" @click="download" :loading="downloading">
          <i class="el-icon-download"></i>下载
        </el-button>
      </div>
      <div
        style="color:red;"
        class="mb-10"
      >*{{form.dataType}}主题下载和展示仅显示top {{form.dataType=='用户'?'1000':'10000'}}条</div>
      <el-table
        v-if="tableShow"
        @sort-change="sortChange"
        :default-sort="{prop: sortConfig.sortField, order: sortConfig.sort=='desc'?'descending':'ascending'}"
        border
        :data="tableData"
        style="width: 100%"
        v-loading="loading"
      >
        <el-table-column
          v-for="(item,index) in tabColumns"
          :key="index"
          :prop="item.prop"
          :label="item.label"
          min-width="150px"
          :sortable="'custom'"
        >
          <template slot-scope="scope">
            <span
              v-if="item.prop == 'user_type'"
            >{{scope.row[item.prop]==1?'vip':scope.row[item.prop]==2?'运营专员':scope.row[item.prop]==3?'运营经理':'未知'}}</span>
            <!-- <span
              v-else-if="item.prop == 'is_plus'"
            >{{scope.row[item.prop]==1?'是':'否'}}</span>-->
            <span
              v-else-if="item.prop == 'order_status_id'"
            >{{scope.row[item.prop]==1?'订单付款':scope.row[item.prop]==2?'订单成功':scope.row[item.prop]==3?'订单结算':scope.row[item.prop]==4?'订单失效':'未知'}}</span>
            <span v-else>{{scope.row[item.prop]}}</span>
          </template>
        </el-table-column>
      </el-table>
      <!-- 分页组件 -->
      <pagination :paginationData="paginationData" @handleCurrentChange="handleCurrentChange" />
    </div>
    <el-dialog
      title="所需字段"
      :visible.sync="fieldVisible"
      width="800px"
      :before-close="fieldHandleClose"
    >
      <div>
        <div>
          <el-tooltip class="item" effect="dark" content="Top Left 提示文字" placement="top-start">
            <el-button icon="el-icon-info" type="text">提示</el-button>
            <div slot="content">
              <div v-if="form.dataType == '营收'">
                <div>1、字段勾选时：维度字段和指标字段都至少选一个；</div>
                <div>2、所选指标字段会根据所选维度字段进行分组求和；</div>
                <div>3、维度字段+指标字段都可作为过滤字段；</div>
              </div>
              <div v-else>
                <div>1、字段勾选时：用户ID、用户手机号码、邀请码、用户类型、标签分组、班级标签，必选一个；若只选择”用户类型“、“标签分组”、“班级标签”其中维度字段，则至少还需要选择1个指标字段；</div>
                <div>2、选择字段仅包含维度字段和指标字段，按维度对指标进行求和；</div>
                <div>3、属性字段+维度字段+指标字段，均可作为过滤字段；</div>
                <div>4、当选择属性和指标的时候，加上“用户ID”字段提高查询速度</div>
              </div>
            </div>
          </el-tooltip>
        </div>

        <el-checkbox
          :indeterminate="isIndeterminate"
          v-model="checkAll"
          @change="handleCheckAllChange"
        >全选</el-checkbox>
        <div style="margin: 15px 0;"></div>
        <el-checkbox-group v-model="fields" @change="handleCheckedCitiesChange">
          <div>
            <div class="mt-20 mb-10">维度：</div>
            <div>
              <el-checkbox
                v-for="(item,index) in tableColumns"
                :key="index"
                :label="item.label"
                v-if="item.cField=='dimension'||item.prop=='dt'"
              >
                <span>{{item.label}}</span>
              </el-checkbox>
            </div>
            <div class="mt-20 mb-10" v-if="form.dataType=='用户'">属性：</div>
            <div>
              <el-checkbox
                v-for="(item,index) in tableColumns"
                :key="index"
                :label="item.label"
                v-if="item.cField=='property'&&item.prop!=='dt'"
              >
                <span>{{item.label}}</span>
              </el-checkbox>
            </div>
            <div class="mt-20 mb-10">指标：</div>
            <div>
              <el-checkbox
                v-for="(item,index) in tableColumns"
                :key="index"
                :label="item.label"
                v-if="item.cField=='index'"
              >
                <span>{{item.label}}</span>
              </el-checkbox>
            </div>
          </div>
        </el-checkbox-group>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="fieldVisible = false">取 消</el-button>
        <el-button type="primary" @click="fieldOnSubmit">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog
      title="过滤条件"
      :visible.sync="conditionVisible"
      width="900px"
      :before-close="conditionOnSubmit"
    >
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
          >
            <template slot-scope="scope">
              <div v-if="item.prop == 'speRequire'">
                <el-select
                  filterable
                  v-model="scope.row[item.prop]"
                  placeholder="请选择字段"
                  @change="selectSpeRequire"
                >
                  <el-option
                    v-for="(item,index) in tableColumns"
                    :key="index"
                    :label="item.label"
                    :value="item.prop"
                    v-if="item.prop!='dt'"
                  ></el-option>
                </el-select>
              </div>
              <div v-else-if="item.prop == 'operatorSymbol'">
                <el-select v-model="scope.row[item.prop]" placeholder="请选择操作符">
                  <el-option
                    v-for="(item,index) in scope.row['operatorSymbolArrs']"
                    :key="index"
                    :label="item.label"
                    :value="item.value"
                  ></el-option>
                </el-select>
              </div>
              <div v-else-if="item.prop == 'addValType'">
                <el-select v-model="scope.row[item.prop]" placeholder="请选择添加筛选值的方式">
                  <el-option label="输入" value="1"></el-option>
                  <el-option v-if="scope.row['operatorSymbol']=='IN'" label="导入" value="2"></el-option>
                </el-select>
              </div>
              <div v-else-if="item.prop == 'conValue'">
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
                  <input
                    style="display:none"
                    :class="'input-file'+scope.row['speRequire']"
                    type="file"
                    @change="exportData"
                    accept=".csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel"
                  />
                  <el-button
                    type="primary"
                    size="small"
                    @click="btnClick(scope.row,'input-file'+scope.row['speRequire'])"
                  >导入excel</el-button>
                  <div class="mt-5">
                    <el-input type="textarea" v-model="scope.row[item.prop]" placeholder="请输入内容"></el-input>
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
      <span slot="footer" class="dialog-footer">
        <el-button @click="conditionVisible = false">取 消</el-button>
        <el-button type="primary" @click="conditionOnSubmit">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
import XLSX from "xlsx";
import axios from "axios";
import { apiUrl4 } from "@/settings";
import { getNowDay, getFileName, getRadioDate } from "@/utils";
import { beehiveQuery, beehiveDownload } from "@/api/web";
import Pagination from "@/components/pagination";
import { userTabColumn, operatorSymbol, revenueTabColumn } from "./config";
import DateQuick from "@/components/DateQuickBtn";
export default {
  data() {
    return {
      userInfo: JSON.parse(localStorage.getItem("userInfo")),
      timeShow: false,
      queryLoading: false,
      tableShow: true,
      fieldTagsChange: false,
      dateQuick: {
        radioValue: "昨日", //默认时间
        options: ["昨日", "近7天", "本月"] //默认选项
      },
      downloading: false,
      filterFieldsValue: null,
      checkAll: false,
      checkedCities: [],
      isIndeterminate: true,
      //indeterminate 属性用以表示 checkbox 的不确定状态，一般用于实现全选的效果
      // isIndeterminate: true,
      //所需字段选择时全选按钮
      // checkAll:true,
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
      //过滤条件列表
      filterTableData: [
        {
          speRequire: "",
          operatorSymbol: "",
          addValType: "1",
          conValue: "",
          operatorSymbolArrs: [],
          type: ""
        }
      ],
      //过滤条件列表字段
      filtertabColumn: [
        {
          prop: "speRequire",
          label: "指定条件"
        },
        {
          prop: "operatorSymbol",
          label: "操作符"
        },
        {
          prop: "addValType",
          label: "添加筛选值的方式"
        },
        {
          prop: "conValue",
          label: "筛选值"
        }
      ],
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
        timeGranularity: "日"
      },
      paginationData: {
        pageNumber: 1,
        pageSize: 10,
        total: 0
      },
      //分割线
      sortConfig: {
        sortField: "",
        sort: ""
      }
    };
  },
  watch: {
    fieldTags() {
      console.log(this.fieldTags);
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
    "form.dataType"() {
      this.cutDataType();
    }
  },
  mounted() {
    this.init();
  },
  methods: {
    async init() {
      let dateTime = await getRadioDate("昨日");
      this.form.dateTime = [dateTime[0], dateTime[1]];
      this.cutDataType();
    },
    changeDateTime() {
      this.dateQuick.radioValue = "";
    },
    queryData() {
      this.sortConfig.sortField = "";
      this.sortConfig.sort = "";
      this.tableShow = false;
      this.onSubmit();
    },
    selectRadio() {
      // this.sortConfig.sortField = '';
      // this.sortConfig.sort = '';
      console.log(this.form.timeGranularity);
    },
    sortChange(res) {
      if (res.prop == null) return;
      this.sortConfig.sortField = res.prop;
      res.order == "ascending"
        ? (this.sortConfig.sort = "asc")
        : (this.sortConfig.sort = "desc");
      this.onSubmit();
    },
    changeRadio(radioValue) {
      this.dateQuick.radioValue = radioValue;
      let dateTime = getRadioDate(radioValue);
      this.form.dateTime = [dateTime[0], dateTime[1]];
    },
    exportData(event) {
      let userId = "";
      if (!event.target.files.length) {
        return;
      }
      const that = this;
      // 拿取文件对象
      var f = event.target.files[0];
      // 用FileReader来读取
      var reader = new FileReader();
      // 重写FileReader上的readAsBinaryString方法
      FileReader.prototype.readAsBinaryString = f => {
        var binary = "";
        var wb; // 读取完成的数据
        var outdata; // 你需要的数据
        var reader = new FileReader();
        let filterFieldsValue = this.filterFieldsValue;
        reader.onload = e => {
          // 读取成Uint8Array，再转换为Unicode编码（Unicode占两个字节）
          var bytes = new Uint8Array(reader.result);
          var length = bytes.byteLength;
          for (var i = 0; i < length; i++) {
            binary += String.fromCharCode(bytes[i]);
          }
          // 接下来就是xlsx了，具体可看api
          wb = XLSX.read(binary, {
            type: "binary"
          });
          outdata = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
          // 自定义方法向父组件传递数据
          for (var i = 0; i < outdata.length; i++) {
            if (outdata[i][filterFieldsValue.label]) {
              if (i == outdata.length - 1) {
                userId += "'" + outdata[i][filterFieldsValue.label] + "'";
                this.filterTableData.map(item => {
                  if (item.label == filterFieldsValue.label) {
                    item.conValue = userId;
                  }
                });
                return;
              }
              userId += "'" + outdata[i][filterFieldsValue.label] + "',";
            }
          }
        };
        reader.readAsArrayBuffer(f);
      };
      reader.readAsBinaryString(f);
    },
    btnClick(row, className) {
      this.fieldTags.map(item => {
        if (item.prop == row.speRequire) {
          row.label = item.label;
        }
      });
      this.filterFieldsValue = row;
      console.log(className);
      document.querySelector("." + className).click();
    },

    /*
     * 下载表格数据
     */
    download() {
      if (!this.tableData.length) {
        return this.$message({
          message: "暂无查询数据",
          type: "warning"
        });
      }

      if (this.downloading) return; //防止重复点击
      let params = {
        form: this.form,
        fields: this.fieldTags,
        filters: this.filterTags,
        sortConfig: this.sortConfig
      };
      try {
        this.downloading = true;
        beehiveDownload(params).then(res => {
          this.downloading = false;
          const link = document.createElement("a");
          let blob = new Blob([res], { type: "application/vnd.ms-excel" });
          link.style.display = "none";
          link.href = URL.createObjectURL(blob);
          link.setAttribute("download", "beenhive.xlsx");
          document.body.appendChild(link);
          link.click();
        });
      } catch (error) {}
    },
    /*
     * 所需字段全选按钮触发
     */
    handleCheckAllChange(val) {
      let arrs = [];
      this.tableColumns.map(item => {
        arrs.push(item.label);
      });
      this.fields = val ? arrs : [];
      this.isIndeterminate = false;
    },
    handleCheckedCitiesChange(value) {
      let checkedCount = value.length;
      this.checkAll = checkedCount === this.tableColumns.length;
      this.isIndeterminate =
        checkedCount > 0 && checkedCount < this.tableColumns.length;
    },
    /*
     * 查询列表
     */
    onSubmit() {
      if (this.queryLoading) return; //防止重复点击
      if (!this.fieldTags.length) {
        return this.$message({
          message: "请选择要查询的字段",
          type: "warning"
        });
      }
      //所选字段为空时显示所有字段，反之显示所选字段
      if (this.fieldTags.length) {
        this.tabColumns = JSON.parse(JSON.stringify(this.fieldTags));
      } else {
        this.tabColumns = this.tableColumns;
      }
      let granularity = this.form.timeGranularity;
      //选择了周/月/年后，时间字段删除
      if (granularity == "周" || granularity == "月" || granularity == "年") {
        this.tabColumns.map((item, index) => {
          console.log(item);
          if (item.prop == "dt") {
            this.tabColumns.splice(index, 1);
          }
        });
      }
      if (this.form.timeGranularity == "周") {
        this.tabColumns.unshift({
          label: "周",
          prop: "p_week"
        });
      } else if (this.form.timeGranularity == "月") {
        this.tabColumns.unshift({
          label: "月",
          prop: "p_month"
        });
      } else if (this.form.timeGranularity == "年") {
        this.tabColumns.unshift({
          label: "年",
          prop: "p_year"
        });
      }
      //字段有改动，重新渲染表格
      if (this.fieldTagsChange) {
        this.tableShow = false;
        this.fieldTagsChange = false;
        this.sortConfig = {
          sort: "",
          sortField: ""
        };
      }
      // return;
      let params = {
        form: this.form,
        fields: this.fieldTags,
        filters: this.filterTags,
        size: this.paginationData.pageSize,
        page: this.paginationData.pageNumber,
        sortConfig: this.sortConfig,
        userInfo:{
          id:this.userInfo.id,
          name:this.userInfo.name
        }
      };
      try {
        this.queryLoading = true;
        this.loading = true;
        beehiveQuery(params).then(res => {
          this.tableShow = true;
          this.queryLoading = false;
          this.loading = false;
          this.tableData = res.data.list;
          this.paginationData.total = res.data.total;
          console.log(JSON.stringify(this.tableData));
          // this.sortConfig = {
          //   sort:'',
          //   sortField:''
          // }
        });
      } catch (error) {}
      console.log(params);
    },
    /*
     * 添加指定字段的时候不允许重复选择
     */
    selectSpeRequire(row) {
      console.log(row);
      console.log(this.filterTableData);
      console.log(this.fieldTags);
      let filterTableData = this.filterTableData;
      let operatorSymbol = [];
      //遍历过滤条件，根据字段类型赋值可选操作符

      this.filterTableData.map((item, index) => {
        this.tableColumns.map(item2 => {
          if (item.speRequire == item2.prop) {
            item.operatorSymbolArrs = item2.operatorSymbolArrs;
            item.rely = item2.rely;
          }
        });
      });
    },

    /*
     * 切换查询数据主题
     */
    changeDataType() {
      this.sortConfig = {
        sortField: "",
        sort: ""
      };
      this.timeShow = false;
      this.tabColumns = [];
      this.tableData = [];
      this.checkAll = false;
      this.fieldTags = [];
      this.filterTags = [];
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
    /*
     * 删除过滤条件（已确定）
     */
    delfilterTag(idx) {
      this.filterTags.splice(idx, 1);
    },
    /*
     * 删除所需字段（已确定）
     */
    delfieldTag(idx) {
      let has_dimension = false;
      let has_index = false;
      let fieldTags = JSON.parse(JSON.stringify(this.fieldTags));
      fieldTags.splice(idx, 1);
      // fieldTags.map(item=>{
      //   if(item.cField=='dimension'&&!has_dimension){
      //       has_dimension = true
      //   }
      //   if(item.cField=='index'&&!has_index){
      //       has_index = true
      //   }
      // })
      this.form.timeGranularity = "日";
      this.fieldTags = fieldTags;
    },
    conditionOnSubmit() {
      if (!this.filterTableData.length) {
        this.filterTags = [];
      } else {
        this.filterTags = JSON.parse(JSON.stringify(this.filterTableData));
      }
      console.log("过滤条件", this.filterTags);
      let arrs = [];
      this.filterTags.map((item, index) => {
        if (item.conValue !== "") {
          this.tableColumns.map(item2 => {
            if (item.speRequire == item2.prop) {
              item.labelZhCn = item2.label;
              item.type = item2.type;
              item.rely = item2.rely;
              arrs.push(item);
            }
          });
        }
      });
      this.filterTags = arrs;
      console.log("this.filterTags", this.filterTags);
      console.log("this.tableColumn", this.tableColumn);
      this.conditionVisible = false;
    },
    ruleFields(arrs) {
      let userRequired = [
        "dt",
        "user_id",
        "phone",
        "invite_code",
        "user_type",
        "class_type_name",
        "class_label_name",
        "team_name"
      ];
      let userVisible = false;
      let userDimension = false;
      let userIndex = false;
      arrs.map(item => {
        if (!userIndex) {
          if (item.cField == "index") userIndex = true;
        }
        if (!userDimension && !userVisible) {
          if (item.cField == "dimension") userDimension = true;
        }
        if (!userVisible) {
          if (userRequired.indexOf(item.prop) != -1) userVisible = true;
        }
      });
      console.log(this.form.dataType);
      if (this.form.dataType == "营收") {
        if (!(userDimension && userIndex)) {
          this.$message({
            message: "维度字段和指标字段都至少选一个；",
            type: "warning"
          });
          return false;
        }
        return true;
      }
      if (userDimension == true && userIndex == false) {
        this.$message({
          message:
            "若只选择”用户类型“、“标签分组”、“班级标签”、“团队名称”其中维度字段，则至少还需要选择1个指标字段；",
          type: "warning"
        });
        return false;
      }
      if (userVisible == false) {
        this.$message({
          message:
            "时间、用户ID、用户手机号码、邀请码、用户类型、标签分组、班级标签、团队名称，必选一个",
          type: "warning"
        });
        return false;
      }

      return true;
    },
    async fieldOnSubmit() {
      let columns = [];
      this.form.dataType == "用户"
        ? (columns = userTabColumn)
        : (columns = revenueTabColumn);
      let arrs = [];
      columns.map(item => {
        if (this.fields.indexOf(item.label) !== -1) {
          arrs.push(item);
        }
      });
      //校验字段选择情况
      console.log(arrs);
      const res = await this.ruleFields(arrs);
      if (!res) return;
      this.form.timeGranularity = "日";
      this.fieldTags = arrs;
      console.log(this.fieldTags);
      // console.log(this.)
      this.fieldVisible = false;
    },
    cutDataType() {
      this.tableColumns =
        this.form.dataType == "用户" ? userTabColumn : revenueTabColumn;

      // this.tabColumns = this.tableColumns;
    },
    /*
     * 插入一行筛选条件
     */
    addFilter() {
      this.filterTableData.push({
        speRequire: "",
        operatorSymbol: "",
        addValType: "1",
        conValue: "",
        operatorSymbolArrs: [],
        rely: ""
      });
    },
    /*
     * 切换分页
     */
    handleCurrentChange(val) {
      console.log("触发");
      this.paginationData.pageNumber = val;
      this.onSubmit();
    },
    /*
     * 关闭条件查询弹窗
     */
    conditionHandleClose() {
      this.conditionVisible = false;
    },
    /*
     * 关闭所需字段弹窗
     */
    fieldHandleClose() {
      this.fieldVisible = false;
    },
    requiredFields() {
      let arrs = [];
      this.fieldTags.map(item => {
        arrs.push(item.label);
      });
      this.fields = arrs;
      this.fieldVisible = true;
    },
    conditionalFilter() {
      //遍历过滤条件，根据字段类型赋值可选操作符
      this.tableColumns.map(item => {
        if (item.dataType == "varchar") {
          item.operatorSymbolArrs = [
            {
              description: "等于",
              value: "="
            },
            {
              description: "不等于",
              value: "!="
            },
            {
              description: "在集合中",
              value: "IN"
            },
            {
              description: "模糊匹配",
              value: "LIKE"
            }
          ];
        } else if (
          item.dataType == "integer" ||
          item.dataType == "decimal" ||
          item.dataType == "bigint"
        ) {
          item.operatorSymbolArrs = [
            {
              description: "等于",
              value: "="
            },
            {
              description: "不等于",
              value: "!="
            },
            {
              description: "大于",
              value: ">"
            },
            {
              description: "小于",
              value: "<"
            },
            {
              description: "小于等于",
              value: "<="
            },
            {
              description: "大于等于",
              value: ">="
            },
            {
              description: "在集合中",
              value: "IN"
            }
          ];
        }
      });
      console.log(this.tableColumns);
      //重新赋值已选过滤条件
      if (!this.filterTags.length) {
        this.filterTableData = [
          {
            speRequire: "",
            operatorSymbol: "",
            addValType: "1",
            conValue: ""
          }
        ];
      } else {
        this.filterTableData = this.filterTags;
      }
      // this.selectSpeRequire();
      this.conditionVisible = true;
    }
  },
  components: {
    Pagination,
    DateQuick
  }
};
</script>
<style lang="scss" scoped>
.container {
  .el-checkbox {
    width: 200px;
    margin-bottom: 5px;
  }
  .box-card {
    .text {
      white-space: pre-wrap;
    }
  }

  .box-card:first-child {
    margin-bottom: 20px;
  }
}
</style>
