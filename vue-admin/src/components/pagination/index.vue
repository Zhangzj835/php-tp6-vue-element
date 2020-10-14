<template>
  <div>
    <!-- 分页组件 -->
    <el-pagination
      @current-change="handleCurrentChange"
      :current-page.sync="result.pageNumber"
      :page-size="result.pageSize"
      layout="total, prev, pager, next"
      :total="result.total"
    ></el-pagination>
  </div>
</template>
<script>
export default {
    props:{
        paginationData:{
            type:Object,
            default:{
                pageNumber:1,
                pageSize:10,
                total:0
            }
        }
    },
  data() {
    return {
        result:{
            pageNumber:1,
            pageSize:10,
            total:0
        }
    };
  },
  watch:{
      paginationData (){
          this.result.total = this.paginationData.total;
      }
  },
  mounted() {
       this.result = this.paginationData;
  },
  methods: {
      handleCurrentChange(val){
          console.log(val)
          this.$emit('handleCurrentChange',this.result.pageNumber);
      }
  },
  components: {}
};
</script>
<style lang="scss" scoped>
</style>
