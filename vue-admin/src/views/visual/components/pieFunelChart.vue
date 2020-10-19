<template>
  <div :id="id" :class="className" :style="{height:height,width:width}" />
</template>

<script>
import echarts from "echarts";
require("echarts/theme/macarons"); // echarts theme
import resize from "@/utils/mixins/resize";
import {
  objectArraySort
} from "@/utils";
export default {
  mixins: [resize],
  props: {
    typeChart: {
      type: String,
      default: "pie",
    },
    legendShow: {
      type: Boolean,
      default: true,
    },
    seriesRadius: {
      type: String,
      default: "65%",
    },
    //图表初始化数据
    dataJson: {
      type: Object,
      default: {
        data: [],
        legends: [],
        xAxis: [],
      },
    },
    //图表类名
    className: {
      type: String,
      default: "chart",
    },
    //图表ID
    id: {
      type: String,
      default: "chart",
    },
    //图表宽度
    width: {
      type: String,
      default: "100%",
    },
    //图表高度
    height: {
      type: String,
      default: "100%",
    },
  },
  data() {
    return {
      chart: null,
      sidebarElm: null,
    };
  },
  mounted() {
    this.initChart();
  },
  watch: {
    dataJson() {
      this.clearData();
      this.initChart();
    },
  },
  methods: {
    clearData() {
      if (!this.chart) {
        return;
      }
      this.chart.dispose();
      this.chart = null;
    },
    initChart() {
      this.chart = echarts.init(document.getElementById(this.id), "macarons");
      let typeChart = this.typeChart; //获取图表类型
      let data = this.dataJson.data;
      if(typeChart=='funnel'){
        data = data.sort(objectArraySort('value'));
      }
      
      let options = {
        color: ["rgb(88,175,255)", "rgb(237,129,45)", "rgb(165,165,165)"],
        tooltip: {
          confine: true,
          trigger: "item",
          formatter: (value) => {
            if(typeChart=='funnel'){
              return (
                value.name +
                "：" +
                parseFloat(value.value).toLocaleString() +
                " (" +
                `${value.dataIndex==0? 100 : ((data[value.dataIndex].value / data[value.dataIndex-1].value) * 100).toFixed(2)}` +
                "%)"
              );
            }
            return (
              value.name +
              "：" +
              parseFloat(value.value).toLocaleString() +
              " (" +
              value.percent +
              "%)"
            );
          },
        },
        legend: {
          show: true,
          left: "center"
        },
        series: [
          {
            type: typeChart,
            radius: this.seriesRadius,
            center: ["50%", "50%"],
            radius: [0, "45%"],
            selectedMode: "single",
            data: this.dataJson.data,
            itemStyle: {
              emphasis: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
      };
      this.chart.setOption(options);
      this.$_resizeHandler();
    },
  },
};
</script>
