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
<style lang="scss" scoped>
</style>
