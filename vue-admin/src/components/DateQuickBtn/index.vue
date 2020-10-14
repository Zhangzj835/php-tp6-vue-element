<template>
	<div>
		<el-radio-group v-model="radioValue" @change="changeRadio">
			<el-radio-button v-for="(item,index) in options" :key="index" :label="item"></el-radio-button>
		</el-radio-group>
	</div>
</template>
<script>
	import { debounce } from '@/utils'
	export default {
		props: {
			defaultValue: {
				type: String,
				default: ''
			},
			defaultOptions: {
				type: Array ,
				default: ()=>[]
			}			
		},
		data() {
			return {
				show:false,
				radioValue: "近30天",
				options:['今日', '昨日', '本周', '本月','近7天', '近30天']
			};
		},
		watch: {
			defaultValue() {
				console.log("触发")
				this.radioValue = this.defaultValue;
			}
		},
		mounted() {
			if (this.defaultValue) {
				this.radioValue = this.defaultValue;
			}
			if (this.defaultOptions.length != 0) {
				this.options = this.defaultOptions;
			}
			this.init();
		},
		methods: {
			init() {
				// console.log('this.propOptions.length',this.propOptions.length)
				// if(this.propOptions.length){
				// 	this.options = this.propOptions;
				// }
				console.log('this.$route',this.$route)
				if (this.$route.params.btnDate && this.$route.name == 'CategorySalesRatio') {
					this.radioValue = this.$route.params.btnDate;
				}
				if (this.$route.name == 'BuriedSiteDetail') {
					this.radioValue = '今日';
					this.options = ['今日', '昨日','前三天'];
				} else if (this.$route.name == 'CategorySalesRatio' || this.$route.name == 'FlowTransform') {
					this.radioValue = '昨日';
				} else if( this.$route.name == 'DailyKanban'){
					this.radioValue = this.$route.name == 'DailyKanban'?'昨日':'今日';
					this.options = ['今日', '昨日', '近7天', '近30天'];
				}else if(this.$route.name == 'Index'){
					this.radioValue = '本月';
				}else if(this.$route.name == 'ComList'){
					this.radioValue = '今日';
				}else if(this.$route.name == 'PullNewData'){
					this.options = ['昨日', '本周', '本月','近7天', '近30天'];
				}
			},
			
			/*
			 * 修改快捷时间
			 */
			changeRadio() {
				this.$emit("changeRadio", this.radioValue);
			  // debounce(() => {
			  //   this.$emit("changeRadio", this.radioValue);
			  // }, 1000)()
			}
		},
		components: {}
	};
</script>
<style lang="scss" scoped>
</style>
