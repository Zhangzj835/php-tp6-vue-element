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
				radioValue: "",
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
				
			},
			
			/*
			 * 修改快捷时间
			 */
			changeRadio() {
				this.$emit("changeRadio", this.radioValue);			  
			}
		},
		components: {}
	};
</script>
<style lang="scss" scoped>
</style>
