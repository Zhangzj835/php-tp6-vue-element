<template>
  <div>
    <el-date-picker
      :clearable="false"
      v-model="value"
      type="datetimerange"
      :picker-options="pickerOptions"
      range-separator="至" 
      start-placeholder="开始日期"
      end-placeholder="结束日期"
      align="right"
      @change="changeDate"
      value-format="yyyy-MM-dd HH:mm:ss"
      :default-time="['00:00:00','23:59:59']"
    ></el-date-picker>
  </div>
</template>
<script>
import { getDay, getOneMonth, getRadioDate } from "@/utils";
export default {
  props: {
    dateValue: {
      type: Array,
      default: []
    }
  },
  data() {
    return {
      value: "",
      //日期时间选择器扩展
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() > new Date(new Date(new Date().toLocaleDateString()).getTime()+24*60*60*1000-1);
        },
        shortcuts: [
          {
            text: '今日',
            onClick(picker) {
              let start = getDay(0) + ' 00:00:00';
              let end = getDay(0) + ' 23:59:59';
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '昨日',
            onClick(picker) {
              let start = getDay(-1) + ' 00:00:00';
              let end = getDay(-1) + ' 23:59:59';
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '近两日(含今日)',
            onClick(picker) {
              let start = getDay(-1) + ' 00:00:00';
              let end = getDay(0) + ' 23:59:59';
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '近3天',
            onClick(picker) {
              let start = getDay(-3) + ' 00:00:00';
              let end = getDay(-1) + ' 23:59:59';
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '近7天',
            onClick(picker) {
              let start = getDay(-7) + ' 00:00:00';
              let end = getDay(-1) + ' 23:59:59';
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '近14天',
            onClick(picker) {
              let start = getDay(-14) + ' 00:00:00';
              let end = getDay(-1) + ' 23:59:59';
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '近30天',
            onClick(picker) {
              let start = getDay(-30) + ' 00:00:00';
              let end = getDay(-1) + ' 23:59:59';
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '近180天',
            onClick(picker) {
              let start = getDay(-180) + ' 00:00:00';
              let end = getDay(-1) + ' 23:59:59';
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '本周',
            onClick(picker) {
              let dateArr = getRadioDate('本周');
              picker.$emit('pick', [dateArr[0], dateArr[1]]);
            }
          }, {
            text: '本月',
            onClick(picker) {
              let dateArr = getRadioDate('本月');
              picker.$emit('pick', [dateArr[0], dateArr[1]]);
            }
          }, {
            text: '上一周',
            onClick(picker) {
              let dateArr = getRadioDate('上一周');
              picker.$emit('pick', [dateArr[0], dateArr[1]]);
            }
          }, {
            text: '上一个月',
            onClick(picker) {
              let dateArr = getRadioDate('上一个月');
              picker.$emit('pick', [dateArr[0], dateArr[1]]);
            }
          }
        ],

        onPick: ({ maxDate, minDate }) => {
          this.pickerMinDate = minDate.getTime();
          if (maxDate) {
            this.pickerMinDate = "";
          }
        }
      }
    };
  },
  watch: {
    dateValue() {
      this.value = this.dateValue;
    }
  },
  mounted() {
    this.init();
  },
  methods: {
    /*
     * 初始化
     */
    async init() {
      this.value = this.dateValue;
      
    },
    /*
     * 修改时间
     */
    changeDate() {
      this.$emit("changeDate", this.value);
    }
  },
  components: {}
};
</script>
<style lang="scss">
.el-picker-panel__shortcut{
  padding-left: 8px;
}
.el-range-editor.el-input__inner {
  width: 210px;
}
</style>
