module.exports = {

  // 应用appid
  appid: 'cy930202',

  // 应用秘钥
  appSecret: 'YR40gZVTz1BCPGhAsCCOwR9Q59Kq14Bf',

  // token在Cookie中存储的天数，默认1天
  cookieExpires: 1,

  // 上传路径
  uploadUrl: {
    img: '/admin/upload/upimg',
    video: '',
    file: ''
  },

  // 配置显示在浏览器标签的title
  title: '后台管理系统',

  /**
   * @type {boolean} true | false
   * @description Whether show the settings right-panel
   */
  showSettings: true,

  /**
   * @type {boolean} true | false
   * @description Whether need tagsView
   */
  tagsView: true,

  /**
   * @type {boolean} true | false
   * @description Whether fix the header
   */
  fixedHeader: false,

  /**
   * @type {boolean} true | false
   * @description Whether show the logo in sidebar
   */
  sidebarLogo: true,

  defaultImage: '@/assets/images/default-img.jpg',
  webSite: 'http://local.api.tp6-element.com',
  apiUrl: 'http://local.api.tp6-element.com/index.php',
  
}
