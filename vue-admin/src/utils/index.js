/**
 * Created by PanJiaChen on 16/11/18.
 */

/**
 * Parse the time to string
 * @param {(Object|string|number)} time
 * @param {string} cFormat
 * @returns {string | null}
 */
export function parseTime(time, cFormat) {
  if (arguments.length === 0 || !time) {
    return ''
  }
  const format = cFormat || '{y}-{m}-{d} {h}:{i}:{s}'
  let date
  if (typeof time === 'object') {
    date = time
  } else {
    if ((typeof time === 'string') && (/^[0-9]+$/.test(time))) {
      time = parseInt(time)
    }
    if ((typeof time === 'number') && (time.toString().length === 10)) {
      time = time * 1000
    }
    date = new Date(time)
  }
  const formatObj = {
    y: date.getFullYear(),
    m: date.getMonth() + 1,
    d: date.getDate(),
    h: date.getHours(),
    i: date.getMinutes(),
    s: date.getSeconds(),
    a: date.getDay()
  }
  const time_str = format.replace(/{([ymdhisa])+}/g, (result, key) => {
    const value = formatObj[key]
    // Note: getDay() returns 0 on Sunday
    if (key === 'a') { return ['日', '一', '二', '三', '四', '五', '六'][value ] }
    return value.toString().padStart(2, '0')
  })
  return time_str
}

/**
 * @param {number} time
 * @param {string} option
 * @returns {string}
 */
export function formatTime(time, option) {
  if (('' + time).length === 10) {
    time = parseInt(time) * 1000
  } else {
    time = +time
  }
  const d = new Date(time)
  const now = Date.now()

  const diff = (now - d) / 1000

  if (diff < 30) {
    return '刚刚'
  } else if (diff < 3600) {
    // less 1 hour
    return Math.ceil(diff / 60) + '分钟前'
  } else if (diff < 3600 * 24) {
    return Math.ceil(diff / 3600) + '小时前'
  } else if (diff < 3600 * 24 * 2) {
    return '1天前'
  }
  if (option) {
    return parseTime(time, option)
  } else {
    return (
      d.getMonth() +
      1 +
      '月' +
      d.getDate() +
      '日' +
      d.getHours() +
      '时' +
      d.getMinutes() +
      '分'
    )
  }
}

/**
 * @param {string} url
 * @returns {Object}
 */
export function getQueryObject(url) {
  url = url == null ? window.location.href : url
  const search = url.substring(url.lastIndexOf('?') + 1)
  const obj = {}
  const reg = /([^?&=]+)=([^?&=]*)/g
  search.replace(reg, (rs, $1, $2) => {
    const name = decodeURIComponent($1)
    let val = decodeURIComponent($2)
    val = String(val)
    obj[name] = val
    return rs
  })
  return obj
}

/**
 * @param {string} input value
 * @returns {number} output value
 */
export function byteLength(str) {
  // returns the byte length of an utf8 string
  let s = str.length
  for (var i = str.length - 1; i >= 0; i--) {
    const code = str.charCodeAt(i)
    if (code > 0x7f && code <= 0x7ff) s++
    else if (code > 0x7ff && code <= 0xffff) s += 2
    if (code >= 0xDC00 && code <= 0xDFFF) i--
  }
  return s
}

/**
 * @param {Array} actual
 * @returns {Array}
 */
export function cleanArray(actual) {
  const newArray = []
  for (let i = 0; i < actual.length; i++) {
    if (actual[i]) {
      newArray.push(actual[i])
    }
  }
  return newArray
}

/**
 * @param {Object} json
 * @returns {Array}
 */
export function param(json) {
  if (!json) return ''
  return cleanArray(
    Object.keys(json).map(key => {
      if (json[key] === undefined) return ''
      return encodeURIComponent(key) + '=' + encodeURIComponent(json[key])
    })
  ).join('&')
}

/**
 * @param {string} url
 * @returns {Object}
 */
export function param2Obj(url) {
  const search = url.split('?')[1]
  if (!search) {
    return {}
  }
  return JSON.parse(
    '{"' +
      decodeURIComponent(search)
        .replace(/"/g, '\\"')
        .replace(/&/g, '","')
        .replace(/=/g, '":"')
        .replace(/\+/g, ' ') +
      '"}'
  )
}

/**
 * @param {string} val
 * @returns {string}
 */
export function html2Text(val) {
  const div = document.createElement('div')
  div.innerHTML = val
  return div.textContent || div.innerText
}

/**
 * Merges two objects, giving the last one precedence
 * @param {Object} target
 * @param {(Object|Array)} source
 * @returns {Object}
 */
export function objectMerge(target, source) {
  if (typeof target !== 'object') {
    target = {}
  }
  if (Array.isArray(source)) {
    return source.slice()
  }
  Object.keys(source).forEach(property => {
    const sourceProperty = source[property]
    if (typeof sourceProperty === 'object') {
      target[property] = objectMerge(target[property], sourceProperty)
    } else {
      target[property] = sourceProperty
    }
  })
  return target
}

/**
 * @param {HTMLElement} element
 * @param {string} className
 */
export function toggleClass(element, className) {
  if (!element || !className) {
    return
  }
  let classString = element.className
  const nameIndex = classString.indexOf(className)
  if (nameIndex === -1) {
    classString += '' + className
  } else {
    classString =
      classString.substr(0, nameIndex) +
      classString.substr(nameIndex + className.length)
  }
  element.className = classString
}

/**
 * @param {string} type
 * @returns {Date}
 */
export function getTime(type) {
  if (type === 'start') {
    return new Date().getTime() - 3600 * 1000 * 24 * 90
  } else {
    return new Date(new Date().toDateString())
  }
}

/**
 * @param {Function} func
 * @param {number} wait
 * @param {boolean} immediate
 * @return {*}
 */
export function debounce(func, wait, immediate) {
  let timeout, args, context, timestamp, result

  const later = function() {
    // 据上一次触发时间间隔
    const last = +new Date() - timestamp

    // 上次被包装函数被调用时间间隔 last 小于设定时间间隔 wait
    if (last < wait && last > 0) {
      timeout = setTimeout(later, wait - last)
    } else {
      timeout = null
      // 如果设定为immediate===true，因为开始边界已经调用过了此处无需调用
      if (!immediate) {
        result = func.apply(context, args)
        if (!timeout) context = args = null
      }
    }
  }

  return function(...args) {
    context = this
    timestamp = +new Date()
    const callNow = immediate && !timeout
    // 如果延时不存在，重新设定延时
    if (!timeout) timeout = setTimeout(later, wait)
    if (callNow) {
      result = func.apply(context, args)
      context = args = null
    }

    return result
  }
}

/**
 * This is just a simple version of deep copy
 * Has a lot of edge cases bug
 * If you want to use a perfect deep copy, use lodash's _.cloneDeep
 * @param {Object} source
 * @returns {Object}
 */
export function deepClone(source) {
  if (!source && typeof source !== 'object') {
    throw new Error('error arguments', 'deepClone')
  }
  const targetObj = source.constructor === Array ? [] : {}
  Object.keys(source).forEach(keys => {
    if (source[keys] && typeof source[keys] === 'object') {
      targetObj[keys] = deepClone(source[keys])
    } else {
      targetObj[keys] = source[keys]
    }
  })
  return targetObj
}

/**
 * @param {Array} arr
 * @returns {Array}
 */
export function uniqueArr(arr) {
  return Array.from(new Set(arr))
}

/**
 * @returns {string}
 */
export function createUniqueString() {
  const timestamp = +new Date() + ''
  const randomNum = parseInt((1 + Math.random()) * 65536) + ''
  return (+(randomNum + timestamp)).toString(32)
}

/**
 * Check if an element has a class
 * @param {HTMLElement} elm
 * @param {string} cls
 * @returns {boolean}
 */
export function hasClass(ele, cls) {
  return !!ele.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'))
}

/**
 * Add class to element
 * @param {HTMLElement} elm
 * @param {string} cls
 */
export function addClass(ele, cls) {
  if (!hasClass(ele, cls)) ele.className += ' ' + cls
}

/**
 * Remove class from element
 * @param {HTMLElement} elm
 * @param {string} cls
 */
export function removeClass(ele, cls) {
  if (hasClass(ele, cls)) {
    const reg = new RegExp('(\\s|^)' + cls + '(\\s|$)')
    ele.className = ele.className.replace(reg, ' ')
  }
}

export function formatImgToArr(imgStr) {
  let imgarr = []
  const img = []
  if (imgStr === '') {
    return []
  }
  imgarr = imgStr.split(',')
  for (let i = 0; i < imgarr.length; i++) {
    img.push(imgarr[i])
  }
  return img
}

export function getArrByKey(arr, key) {
  const arrNew = []
  for (let i = 0; i < arr.length; i++) {
    if (arr[i].hasOwnProperty(key)) {
      arrNew.push(arr[i][key])
    }
  }
  return arrNew
}

/**
 * 获取最近7天
 * @param {day} 获取多少天
 */
export function getDay(day) {
	var today = new Date();

	var targetday_milliseconds = today.getTime() + 1000 * 60 * 60 * 24 * day;

	today.setTime(targetday_milliseconds); //注意，这行是关键代码

	var tYear = today.getFullYear();
	var tMonth = today.getMonth();
	var tDate = today.getDate();
	tMonth = doHandleMonth(tMonth + 1);
	tDate = doHandleMonth(tDate);
	return tYear + "-" + tMonth + "-" + tDate;
}

function doHandleMonth(month) {
	var m = month;
	if (month.toString().length == 1) {
		m = "0" + month;
	}
	return m;
}
/**
 * 获取近30天
 * 
 */
export function getOneMonth() {
	let day = new Date();
	var year = day.getFullYear();
	var month = day.getMonth();
	if (month == 0) {
		month = 12;
		year = year - 1;
	}
	if (month < 10) {
		month = "0" + month;
	}
	var firstDay = year + "-" + month + "-" + "01"; //上个月的第一天
	var myDate = new Date(year, month, 0);
	var lastDay = year + "-" + month + "-" + myDate.getDate(); //上个月的最后一天

	return [firstDay + " 00:00:00", lastDay + " 23:59:59"];
}

/**
 * 快捷筛选时间区间逻辑处理
 */
export function getTime2(n) {
	var now = new Date();
	var year = now.getFullYear();
	//因为月份是从0开始的,所以获取这个月的月份数要加1才行
	var month = now.getMonth() + 1;
	var date = now.getDate();
	var day = now.getDay();
	console.log(date);
	//判断是否为周日,如果不是的话,就让今天的day-1(例如星期二就是2-1)
	if (day !== 0) {
		n = n + (day - 1);
	} else {
		n = n + day;
	}
	if (day) {
		//这个判断是为了解决跨年的问题
		if (month > 1) {
			month = month;
		}
		//这个判断是为了解决跨年的问题,月份是从0开始的
		else {
			year = year - 1;
			month = 12;
		}
	}
	now.setDate(now.getDate() - n);
	year = now.getFullYear();
	month = now.getMonth() + 1;
	date = now.getDate();
	console.log(n);
	let s = year + "-" + (month < 10 ? ('0' + month) : month) + "-" + (date < 10 ? ('0' + date) : date);
	return s;
}
var now = new Date(); //当前日期
var nowYear = now.getYear(); //当前年
var nowMonth = now.getMonth(); //当前月
//格式化日期：yyyy-MM-dd
function formatDate(date) {
	var myyear = date.getFullYear();
	var mymonth = date.getMonth() + 1;
	var myweekday = date.getDate();
	if (mymonth < 10) {
		mymonth = "0" + mymonth;
	}
	if (myweekday < 10) {
		myweekday = "0" + myweekday;
	}
	return (mymonth + "-" + myweekday);
}
//获得某月的天数
function getMonthDays(myMonth) {
	var monthStartDate = new Date(nowYear, myMonth, 1);
	var monthEndDate = new Date(nowYear, myMonth + 1, 1);
	var days = (monthEndDate - monthStartDate) / (1000 * 60 * 60 * 24);
	return days;
}
//获得本月的开始日期
export function getMonthStartDate() {
	var monthStartDate = new Date(nowYear, nowMonth, 1);
	return formatDate(monthStartDate);
}
//获得本月的结束日期
export function getMonthEndDate() {
	var monthEndDate = new Date(nowYear, nowMonth, getMonthDays(nowMonth));
	return formatDate(monthEndDate);
}

export function getRadioDate(radio) {
	console.log('radio', radio)
	let day = new Date();
	let s = "";
	const end = new Date();
	const start = new Date();
	let value1 = [];
	if (radio == "今日") {
		value1 = [getDay(0) + " 00:00:00", getDay(0) + " 23:59:59"];
	} else if (radio == "昨日") {
		value1 = [getDay(-1) + " 00:00:00", getDay(-1) + " 23:59:59"];
	} else if (radio == "本周") {
		value1 = SearchDate(3);
	} else if (radio == "上一周") {
		value1 = [getTime2(7) + " 00:00:00", getTime2(1) + " 23:59:59"];
		
	} else if (radio == "近3天" || radio == "近3日") {
		value1 = [getDay(-3) + " 00:00:00", getDay(-1) + " 23:59:59"];		
	} else if (radio == "近7日") {
		value1 = [getDay(-7) + " 00:00:00", getDay(-1) + " 23:59:59"];		
	} else if (radio == "近7天" || radio == "最近7天" ) {
		value1 = [getDay(-6) + " 00:00:00", getDay(0) + " 23:59:59"];
	} else if (radio == "上一个月") {
		var year = day.getFullYear();
		var month = day.getMonth();
		if (month == 0) {
			month = 12;
			year = year - 1;
		}
		if (month < 10) {
			month = "0" + month;
		}
		var firstDay = year + "-" + month + "-" + "01"; //上个月的第一天
		var myDate = new Date(year, month, 0);
		var lastDay = year + "-" + month + "-" + myDate.getDate(); //上个月的最后一天
		value1 = [firstDay + " 00:00:00", lastDay + " 23:59:59"];
	} else if (radio == "近30天" || radio == "最近30天") {
		value1 = [getDay(-29) + " 00:00:00", getDay(0) + " 23:59:59"];
	} else if (radio == "本月") {
		var year = day.getFullYear();
		value1 = [year + '-' + getMonthStartDate() + " 00:00:00", getDay(0) + " 23:59:59"];
	} else if (radio == "前三天") {
		value1 = [getDay(-2) + " 00:00:00", getDay(0) + " 23:59:59"];
	} else if (radio == "最近60天") {
		value1 = [getDay(-59) + " 00:00:00", getDay(0) + " 23:59:59"];
	} else if (radio == "最近90天") {
		value1 = [getDay(-89) + " 00:00:00", getDay(0) + " 23:59:59"];
	}
	return value1;
}


export function getNewRadioDate(radio) {
	console.log('radio', radio)
	let day = new Date();
	let res = [];
	if (radio == "今日") {
		res = [getDay(0) + " 00:00:00", getDay(0) + " 23:59:59"];
	} else if (radio == "昨日") {
		res = [getDay(-1) + " 00:00:00", getDay(-1) + " 23:59:59"];
	} else if (radio == "近两日(含今日)" || radio == "近两日") {
		res = [getDay(-1) + " 00:00:00", getDay(0) + " 23:59:59"];			
	} else if (radio == "近3天") {
		res = [getDay(-3) + " 00:00:00", getDay(-1) + " 23:59:59"];			
	} else if (radio == "近7天") {
		res = [getDay(-7) + " 00:00:00", getDay(-1) + " 23:59:59"];			
	} else if (radio == "近14天") {
		res = [getDay(-14) + " 00:00:00", getDay(-1) + " 23:59:59"];		
	} else if (radio == "近15天") {
		res = [getDay(-15) + " 00:00:00", getDay(-1) + " 23:59:59"];		
	} else if (radio == "近30天") {
		res = [getDay(-30) + " 00:00:00", getDay(-1) + " 23:59:59"];		
	} else if (radio == "近60天") {
		res = [getDay(-60) + " 00:00:00", getDay(-1) + " 23:59:59"];		
	} else if (radio == "近90天") {
		res = [getDay(-90) + " 00:00:00", getDay(-1) + " 23:59:59"];		
	} else if (radio == "近180天") {
		res = [getDay(-180) + " 00:00:00", getDay(-1) + " 23:59:59"];		
	} else if (radio == "本周") {
		res = SearchDate(3);
	} else if (radio == "本月") {
		var year = day.getFullYear();
		res = [year + '-' + getMonthStartDate() + " 00:00:00", getDay(0) + " 23:59:59"];
	} else if (radio == "上一周") {
		res = [getTime2(7) + " 00:00:00", getTime2(1) + " 23:59:59"];
	} else if (radio == "上一个月") {
		var year = day.getFullYear();
		var month = day.getMonth();
		if (month == 0) {
			month = 12;
			year = year - 1;
		}
		if (month < 10) {
			month = "0" + month;
		}
		var firstDay = year + "-" + month + "-" + "01"; //上个月的第一天
		var myDate = new Date(year, month, 0);
		var lastDay = year + "-" + month + "-" + myDate.getDate(); //上个月的最后一天
		res = [firstDay + " 00:00:00", lastDay + " 23:59:59"];
	} 
	return res;
}

/**
 * 时间截取
 */
export function subArray(arrs) {
	let times = [];
	arrs.map((item) => {
		times.push(item.length == 10 ? item.substring(5) : item.length == 19 ? item.substring(11, 16) : item);
	})
	return times;
}
//显示日期在页面上  yyy-MM-dd
export function getNowDay() {
	var date = new Date();
	//年
	var year = date.getFullYear();
	//月
	var month = date.getMonth() + 1;

	//日
	var day = date.getDate();
	//时
	var hh = date.getHours();
	//分
	var mm = date.getMinutes();
	//秒
	var ss = date.getSeconds();
	if (month < 10) {
		month = "0" + month;
	}
	if (day < 10) {
		day = "0" + day;
	}
	if (hh < 10) {
		hh = "0" + hh;
	}
	var rq = year + "-" + month + "-" + day + " " + hh + ":" + mm + ":" + ss;
	return rq;
}


export const getFileName = (name) => { // 获取到文件名
	let pos = name.lastIndexOf('\/'); // 查找最后一个/的位置
	return name.substring(pos + 1); // 截取最后一个/位置到字符长度，也就是截取文件名
};

function SearchDate(a) {
	var myDate = new Date();
	var year = myDate.getFullYear();
	var month = myDate.getMonth() + 1; //获取当前月份(0-11,0代表1月，所以要加1);
	var premonth = myDate.getMonth(); //上月
	var day = myDate.getDate(); //获取当前日（1-31）
	if (month < 10) {
		month = "0" + month;
	}
	if (premonth < 10) {
		premonth = "0" + premonth;
	}
	if (day >= 0 && day <= 9) {
		day = "0" + day;
	}

	if (a == 3) {
		var now = new Date;
		let day1 = now.getDay();
		day1 == 0 ? day1 = 7 : day1 = day1;
		var week = "1234567";
		var first = 0 - week.indexOf(day1);
		var last = 6 - week.indexOf(day1);
		return [GetDateStr(first) + " 00:00:00", GetDateStr(last) + " 23:59:59"]
	} //本周

	if (a == 5) {
		var now = new Date;
		var day1 = now.getDay();
		var week = "1234567";
		var first = 0 - week.indexOf(day1) - 14;
		var last = 6 - week.indexOf(day1) - 14; //这里计算的是从周一到周日为一周，大家可以根据需求做相应改变
		return [GetDateStr(first) + " 00:00:00", GetDateStr(last) + " 23:59:59"]
	} //上周 

}

function GetDateStr(AddDayCount) {
	var dd = new Date();
	dd.setDate(dd.getDate() + AddDayCount); //获取AddDayCount天后的日期
	var y = dd.getFullYear();
	var m = dd.getMonth() + 1; //获取当前月份的日期
	var d = dd.getDate();
	if (m < 10) {
		m = "0" + m;
	}
	if (d >= 0 && d <= 9) {
		d = "0" + d;
	}
	return y + "-" + m + "-" + d;
}
export function getMonths() {
	var dataArr = [];
	var data = new Date();
	var year = data.getFullYear();
	data.setMonth(data.getMonth() + 1, 1); //获取到当前月份,设置月份
	for (var i = 0; i < 12; i++) {
		data.setMonth(data.getMonth() - 1); //每次循环一次 月份值减1
		var m = data.getMonth() + 1;
		m = m < 10 ? "0" + m : m;
		dataArr.push(data.getFullYear() + "-" + m);
	}
	return dataArr;
}
/**
* 获取环比时间段
*/
export function linkRelativeRatio(start, end) {
	let a = new Date(start + ' 00:00:00');
	let b = new Date(end + ' 00:00:00');
	let arr1 = new Date(a - (b - a) - 1).toLocaleDateString().split('-');
	let arr2 = new Date(b - (b - a) - 1).toLocaleDateString().split('-');
	let startArrs = arr1[0].split('/');
	let endArrs = arr2[0].split('/');
	if (startArrs[1] < 10) {
		startArrs[1] = '0' + startArrs[1]
	}
	if (startArrs[2] < 10) {
		startArrs[2] = '0' + startArrs[2]
	}
	if (endArrs[1] < 10) {
		endArrs[1] = '0' + endArrs[1]
	}
	if (endArrs[2] < 10) {
		endArrs[2] = '0' + endArrs[2]
	}
	return [startArrs[0] + '-' + startArrs[1] + '-' + startArrs[2], endArrs[0] + '-' + endArrs[1] + '-' + endArrs[2]];
}

/**
 * 检测字符串是否含有特殊符号
 */
export function checkStrSpecialChar(str) {
	let reg = new RegExp('[:;/|,*?"><]');
	let isInclude = str.match(reg);
	if (isInclude || str.indexOf('\\') !== -1) {
		return ':;/|,*?"><';
	} else {
		return true;
	}
}

export function objectArraySort(keyName) {
	return function (objectN, objectM) {
		var valueN = objectN[keyName]
		var valueM = objectM[keyName]
		if (valueN < valueM) return 1
		else if (valueN > valueM) return -1
		else return 0
	}
}

/**
 * 从sql中匹配出变量
 */
export function getVariablesByStr(str) {		
	let reg = /\$\{([^\}]+)\}/gi
	let matchRes = str.match(reg)
	let variables = []
	let labels = []
	if (matchRes) {		
		matchRes.map(item=> {
			item = item.replace('${', '')
			item = item.replace('}', '')
			let arr = item.split('||')
			if (labels.indexOf(arr[0]) < 0) {
				let obj = {}
				obj.label = arr[0]
				obj.variable = item
				for (let i in arr) {
					if (i != 0) {
						let key = arr[i].split('=')
						obj[key[0]] = key[1]
						if ( key[0] == 'inputOptions') {
							let options = key[1].split(',')
							obj[key[0]] = options
						}
					}
				}
				labels.push(obj.label)
				variables.push(obj)
			}
		})
	}		
	return  variables;
}

export const pickerOptions = [
  {
    text: '今天',
    onClick(picker) {
      const end = new Date()
      const start = new Date(new Date().toDateString())
      end.setTime(start.getTime())
      picker.$emit('pick', [start, end])
    }
  },
  {
    text: '最近一周',
    onClick(picker) {
      const end = new Date(new Date().toDateString())
      const start = new Date()
      start.setTime(end.getTime() - 3600 * 1000 * 24 * 7)
      picker.$emit('pick', [start, end])
    }
  },
  {
    text: '最近一个月',
    onClick(picker) {
      const end = new Date(new Date().toDateString())
      const start = new Date()
      start.setTime(start.getTime() - 3600 * 1000 * 24 * 30)
      picker.$emit('pick', [start, end])
    }
  },
  {
    text: '最近三个月',
    onClick(picker) {
      const end = new Date(new Date().toDateString())
      const start = new Date()
      start.setTime(start.getTime() - 3600 * 1000 * 24 * 90)
      picker.$emit('pick', [start, end])
    }
  }
]
