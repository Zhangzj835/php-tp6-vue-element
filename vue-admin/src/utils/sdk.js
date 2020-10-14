import request from '@/utils/request'
import { apiReport } from '@/settings'
import axios from 'axios'

/*
* 埋点上报请求
*/
export function reportRequest(query) {
  let userInfo = JSON.parse(localStorage.getItem('userInfo'));
  let data = {
    time: (new Date()).getTime(),
    user: userInfo.name||'',//用户名
    user_address: userInfo.email||'',//登陆账号
    router: '',//路由地址/api请求地址
    pageId: '',//页面id
    type: '', //类型， 页面请求1， api请求2
    params: '', //请求参数json格式
    restPath: '', //api请求地址
  }
  data = Object.assign(data, query);
  // return;
  axios({
    method: 'post',
    url: apiReport,
    data:JSON.stringify(data)
  })
    .then((response) => {
      console.log(response);
    })
    .catch((error) => {
      console.log(error);
    });
  // return request({
  //   url: apiReport,
  //   method: 'post',
  //   data:JSON.stringify(data)
  // })
}
