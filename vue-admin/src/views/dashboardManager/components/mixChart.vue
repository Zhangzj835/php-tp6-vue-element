<template>
  <div :id="id" :class="className" :style="{height:height,width:width}" />
</template>

<script>
import echarts from "echarts";
require("echarts/theme/macarons"); // echarts theme
import resize from "@/utils/mixins/resize";

export default {
  mixins: [resize],
  props: {
    axisLabelRotate: {
      type: Number,
      default: 0,
    },
    markLineShow: {
      type: Boolean,
      default: false,
    },
    splitLineShow: {
      type: Boolean,
      default: true,
    },
    //图表边距
    gridLeft: {
      type: String,
      default: "10%",
    },
    gridRight: {
      type: String,
      default: "10%",
    },
    //dataZoom
    dataZoom: {
      type: Boolean,
      default: false,
    },
    //柱体宽度
    barWidth: {
      type: Number,
      default: 12,
    },
    //混合图表配置
    mixChartShow: {
      type: Object,
      default: null,
    },
    //图表类型 line：折线图 bar：柱形图
    typeChart: {
      type: String,
      default: "line",
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
      default: "500px",
    },
    //单位
    strUnit: {
      type: String,
      default: "",
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
      let series = [];
      let yAxis = [];
      let legends = this.dataJson.legends;
      //图表前十条为选中状态
      let selected = {};
      for (let i in legends) {
        if (i < 10) {
          selected[legends[i]] = true;
        } else {
          selected[legends[i]] = false;
        }
      }
  

      let options = {
        color: ["rgb(88,175,255)", "rgb(220,105,170)", "rgb(237,129,45)"],
        tooltip: {
          trigger: "axis",
          axisPointer: {
            type: "cross",
            crossStyle: {
              color: "#999",
            },
          },
        },
        grid: {
          left: this.gridLeft,
          right: this.gridRight,
          borderWidth: 0,
          // top: 100,
          // bottom: this.dataZoom?65:'13%',
          textStyle: {
            color: "#fff",
          },
        },
        legend: {
          show: true,
          selected: selected,
          textStyle: {
            color: "#90979c",
          }
        },
        calculable: true,
        xAxis: {
          show: true,
          type: "category",
          axisLine: {
            lineStyle: {
              color: "#90979c",
            },
          },
          axisLabel: {
            rotate: this.axisLabelRotate,
          },
          data: this.dataJson.xAxis,
          nameGap: 30,
        },
        yAxis: [
          {
            type: "value",
            // axisLabel: {
            // 	color: "#909399"
            // },
            axisLine: {
              lineStyle: {
                color: "#909399",
              },
            },
            axisLine: {
              lineStyle: {
                color: "#909399",
              },
              show: false,
            },
            axisTick: {
              show: false,
            },
            splitArea: {
              show: false,
            },
            splitLine: {
              show: this.splitLineShow,
              lineStyle: {
                type: "dashed",
              },
            },
            splitArea: {
              show: false,
            },
            axisLabel: {
								interval: 0,
								formatter: function(value) {
									return JSON.stringify(parseInt(value)).length > 4 ? parseFloat(value / 10000).toLocaleString() + " 万" :
										value;
								}
							},
          },
          {
            type: "value",
            axisLabel: {
								interval: 0,
								formatter: function(value) {
									return JSON.stringify(parseInt(value)).length > 4 ? parseFloat(value / 10000).toLocaleString() + " 万" :
										value;
								}
							},
            axisLine: {
              lineStyle: {
                color: "#909399",
              },
            },
            axisLine: {
              lineStyle: {
                color: "#909399",
              },
              show: false,
            },
            axisTick: {
              show: false,
            },
            splitArea: {
              show: false,
            },
            splitLine: {
              show: this.splitLineShow,
              lineStyle: {
                type: "dashed",
              },
            },
            splitArea: {
              show: false,
            },
          },
        ],
        dataZoom: [
          {
            type: "inside",
            disabled: !this.dataZoom,
            height: 15,
            xAxisIndex: [0],
            bottom: 15,
            handleIcon:
              "path://M306.1,413c0,2.2-1.8,4-4,4h-59.8c-2.2,0-4-1.8-4-4V200.8c0-2.2,1.8-4,4-4h59.8c2.2,0,4,1.8,4,4V413z",
            handleSize: "110%",
            handleStyle: {
              color: "#d3dee5",
            },
            textStyle: {
              color: "#fff",
            },
            borderColor: "#90979c",
          },
        ],
        series: this.dataJson.data,
      };
      this.chart.setOption(options);
      this.chart.on("click", (params) => {
        this.$emit("chartClick", params);
      });
      this.$_resizeHandler();
    },
  },
};
</script>
