/*
Navicat MySQL Data Transfer

Source Server         : 本地
Source Server Version : 50726
Source Host           : 127.0.0.1:3306
Source Database       : tp6_element

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2020-10-25 00:55:23
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `test_course`
-- ----------------------------
DROP TABLE IF EXISTS `test_course`;
CREATE TABLE `test_course` (
  `CID` int(11) NOT NULL AUTO_INCREMENT,
  `Cname` varchar(10) DEFAULT NULL,
  `TID` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`CID`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of test_course
-- ----------------------------
INSERT INTO `test_course` VALUES ('1', '语文', '02');
INSERT INTO `test_course` VALUES ('2', '数学', '01');
INSERT INTO `test_course` VALUES ('3', '英语', '03');

-- ----------------------------
-- Table structure for `test_sc`
-- ----------------------------
DROP TABLE IF EXISTS `test_sc`;
CREATE TABLE `test_sc` (
  `SID` int(11) NOT NULL AUTO_INCREMENT,
  `CID` varchar(10) DEFAULT NULL,
  `score` decimal(18,1) DEFAULT NULL,
  PRIMARY KEY (`SID`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of test_sc
-- ----------------------------
INSERT INTO `test_sc` VALUES ('1', '01', '80.0');
INSERT INTO `test_sc` VALUES ('2', '02', '90.0');
INSERT INTO `test_sc` VALUES ('3', '03', '99.0');
INSERT INTO `test_sc` VALUES ('4', '01', '70.0');
INSERT INTO `test_sc` VALUES ('5', '02', '60.0');
INSERT INTO `test_sc` VALUES ('6', '03', '80.0');
INSERT INTO `test_sc` VALUES ('7', '01', '80.0');
INSERT INTO `test_sc` VALUES ('8', '02', '80.0');
INSERT INTO `test_sc` VALUES ('9', '03', '80.0');
INSERT INTO `test_sc` VALUES ('10', '01', '50.0');
INSERT INTO `test_sc` VALUES ('11', '02', '30.0');
INSERT INTO `test_sc` VALUES ('12', '03', '20.0');
INSERT INTO `test_sc` VALUES ('13', '01', '76.0');
INSERT INTO `test_sc` VALUES ('14', '02', '87.0');
INSERT INTO `test_sc` VALUES ('15', '01', '31.0');
INSERT INTO `test_sc` VALUES ('16', '03', '34.0');
INSERT INTO `test_sc` VALUES ('17', '02', '89.0');

-- ----------------------------
-- Table structure for `test_student`
-- ----------------------------
DROP TABLE IF EXISTS `test_student`;
CREATE TABLE `test_student` (
  `SID` int(10) NOT NULL AUTO_INCREMENT,
  `Sname` varchar(10) DEFAULT NULL,
  `Sage` datetime DEFAULT NULL,
  `Ssex` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`SID`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of test_student
-- ----------------------------
INSERT INTO `test_student` VALUES ('1', '赵雷', '1990-01-01 00:00:00', '男');
INSERT INTO `test_student` VALUES ('2', '钱电', '1990-12-21 00:00:00', '男');
INSERT INTO `test_student` VALUES ('3', '孙风', '1990-05-20 00:00:00', '男');
INSERT INTO `test_student` VALUES ('4', '李云', '1990-08-06 00:00:00', '男');
INSERT INTO `test_student` VALUES ('5', '周梅', '1991-12-01 00:00:00', '女');
INSERT INTO `test_student` VALUES ('6', '吴兰', '1992-03-01 00:00:00', '女');
INSERT INTO `test_student` VALUES ('7', '郑竹', '1989-07-01 00:00:00', '女');
INSERT INTO `test_student` VALUES ('8', '王菊', '1990-01-20 00:00:00', '女');
INSERT INTO `test_student` VALUES ('9', '老张', '2020-10-24 23:31:53', '男');

-- ----------------------------
-- Table structure for `test_teacher`
-- ----------------------------
DROP TABLE IF EXISTS `test_teacher`;
CREATE TABLE `test_teacher` (
  `tID` int(10) NOT NULL AUTO_INCREMENT,
  `tname` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`tID`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of test_teacher
-- ----------------------------
INSERT INTO `test_teacher` VALUES ('1', '张三');
INSERT INTO `test_teacher` VALUES ('2', '李四');
INSERT INTO `test_teacher` VALUES ('3', '王五');

-- ----------------------------
-- Table structure for `test_users`
-- ----------------------------
DROP TABLE IF EXISTS `test_users`;
CREATE TABLE `test_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of test_users
-- ----------------------------
INSERT INTO `test_users` VALUES ('1', '张三', '14', null, null);
INSERT INTO `test_users` VALUES ('2', '李四', '15', null, null);
INSERT INTO `test_users` VALUES ('3', '王五', '16', null, null);

-- ----------------------------
-- Table structure for `tp_admin`
-- ----------------------------
DROP TABLE IF EXISTS `tp_admin`;
CREATE TABLE `tp_admin` (
  `id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `username` char(16) NOT NULL DEFAULT '' COMMENT '用户名',
  `password` char(32) NOT NULL DEFAULT '' COMMENT '密码',
  `email` char(32) NOT NULL COMMENT '用户邮箱',
  `realname` varchar(50) NOT NULL DEFAULT '' COMMENT '姓名',
  `phone` char(15) NOT NULL DEFAULT '' COMMENT '用户手机',
  `img` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `reg_ip` varchar(20) NOT NULL DEFAULT '' COMMENT '注册IP',
  `login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `login_ip` varchar(20) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '用户状态  0 禁用，1正常',
  `group_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '权限组',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `delete_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='管理员用户表';

-- ----------------------------
-- Records of tp_admin
-- ----------------------------
INSERT INTO `tp_admin` VALUES ('1', 'admini', 'd93a5def7511da3d0f2d171d9c344e91', '', '', '', 'http://local.api.tp6-element.com/storage\\images/20201025\\ff0107753195c62f9cebf08541460188.jpg', '127.0.0.1', '1603544004', '39.149.12.184', '1603558241', '1', '1', '1540975213', '0');
INSERT INTO `tp_admin` VALUES ('2', 'admina', '00b091d5bbbcbea4a371242e61d644a3', '123@163.com', '王五一', '15237156573', 'https://hardphp.oss-cn-beijing.aliyuncs.com/vedios/20191220/044a612bd5f0874e669e0755f51ca93e.jpg', '127.0.0.1', '1540975213', '123.149.208.76', '1579146396', '1', '1', '1540975213', '0');
INSERT INTO `tp_admin` VALUES ('60', 'test', '', '', '', '', 'https://hardphp.oss-cn-beijing.aliyuncs.com/vedios/20191220/044a612bd5f0874e669e0755f51ca93e.jpg', '127.0.0.1', '1540975213', '0', '1579104327', '1', '2', '1540975213', '0');
INSERT INTO `tp_admin` VALUES ('5831189944471553', '123123', '794484e50babce6d890d24bdbcd3a63b', '123@123.com', '1231', '15237156573', 'https://hardphp.oss-cn-beijing.aliyuncs.com\\images/20200115\\1ed50a8ff67bedbe1d4794705868a234.jpg', '127.0.0.1', '0', '', '1579104339', '1', '2', '1579103200', '1579104339');
INSERT INTO `tp_admin` VALUES ('6014628748464129', '3ewr23', '42fa3e555eecf2754a3da41c5e86af35', '', '', '', 'https://hardphp.oss-cn-beijing.aliyuncs.com\\images/20200115\\1ed50a8ff67bedbe1d4794705868a234.jpg', '127.0.0.1', '0', '', '1579149556', '1', '2', '1579146935', '0');
INSERT INTO `tp_admin` VALUES ('6026749121007617', '2324dfsdf', '80713128888be539a72c80820ea92649', '', 'sdf', '', 'https://hardphp.oss-cn-beijing.aliyuncs.com\\images/20200115\\1ed50a8ff67bedbe1d4794705868a234.jpg', '127.0.0.1', '0', '', '1582174917', '0', '2', '1579149824', '1582174917');
INSERT INTO `tp_admin` VALUES ('99233156061859841', 'laozhang', 'd93a5def7511da3d0f2d171d9c344e91', '123465@qq.com', '老张', '13572022222', '', '127.0.0.1', '0', '', '1601371964', '1', '1', '1601371964', '0');

-- ----------------------------
-- Table structure for `tp_app`
-- ----------------------------
DROP TABLE IF EXISTS `tp_app`;
CREATE TABLE `tp_app` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `appid` char(18) NOT NULL DEFAULT '' COMMENT '应用id',
  `app_salt` char(32) NOT NULL DEFAULT '' COMMENT '应用签名盐值',
  `title` varchar(150) NOT NULL DEFAULT '' COMMENT '名称',
  `description` varchar(255) NOT NULL COMMENT '备注',
  `reg_ip` varchar(20) NOT NULL DEFAULT '' COMMENT '注册IP',
  `login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `login_ip` varchar(20) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '用户状态  0 禁用，1正常',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `appid` (`appid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='app应用表';

-- ----------------------------
-- Records of tp_app
-- ----------------------------
INSERT INTO `tp_app` VALUES ('1', 'cy930202', 'YR40gZVTz1BCPGhAsCCOwR9Q59Kq14Bf', '管理员端', '', '127.0.0.1', '1521305444', '123.149.208.76', '1514962598', '1', '0');

-- ----------------------------
-- Table structure for `tp_article`
-- ----------------------------
DROP TABLE IF EXISTS `tp_article`;
CREATE TABLE `tp_article` (
  `id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `title` varchar(150) NOT NULL DEFAULT '' COMMENT '标题',
  `content` text NOT NULL COMMENT 'seo描述',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态  0 禁用，1正常',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `sorts` int(3) NOT NULL DEFAULT '100' COMMENT '排序',
  `cate_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '分类id',
  `column_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '所属栏目',
  `img` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章表';

-- ----------------------------
-- Records of tp_article
-- ----------------------------
INSERT INTO `tp_article` VALUES ('1', 'ty9fd2848a039ab554', '管理员端', '1582518981', '1', '1514962598', '100', '18716532003704833', '7264324116680705', 'https://hardphp.oss-cn-beijing.aliyuncs.com\\images/20200221\\c2a62a8dbba7ae828c5837291e170a4c.jpg');

-- ----------------------------
-- Table structure for `tp_article_categery`
-- ----------------------------
DROP TABLE IF EXISTS `tp_article_categery`;
CREATE TABLE `tp_article_categery` (
  `id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `name` varchar(150) NOT NULL DEFAULT '' COMMENT '栏目名称',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态  0 禁用，1正常',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `sorts` int(3) NOT NULL DEFAULT '100' COMMENT '排序',
  `column_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '所属栏目',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章分类表';

-- ----------------------------
-- Records of tp_article_categery
-- ----------------------------
INSERT INTO `tp_article_categery` VALUES ('18716532003704835', '老张', '', '1582175304', '1', '1582175305', '100', '7264576798330881');

-- ----------------------------
-- Table structure for `tp_article_column`
-- ----------------------------
DROP TABLE IF EXISTS `tp_article_column`;
CREATE TABLE `tp_article_column` (
  `id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `name` varchar(150) NOT NULL DEFAULT '' COMMENT '栏目名称',
  `seo_title` varchar(150) NOT NULL DEFAULT '' COMMENT 'seo关键词',
  `seo_dec` varchar(255) NOT NULL DEFAULT '' COMMENT 'seo描述',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态  0 禁用，1正常',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `sorts` int(3) NOT NULL DEFAULT '100' COMMENT '排序',
  `pid` bigint(20) NOT NULL DEFAULT '0' COMMENT '父id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章栏目表';

-- ----------------------------
-- Records of tp_article_column
-- ----------------------------
INSERT INTO `tp_article_column` VALUES ('1', '编程语言', 'ec32286d0718118861afdbf6e401ee81', '管理员端', '1579444850', '1', '1514962598', '100', '0');
INSERT INTO `tp_article_column` VALUES ('7264107703177217', '数据库', '1', '1', '1579445065', '1', '1579444834', '100', '0');
INSERT INTO `tp_article_column` VALUES ('7264249676173313', '开发框架', '', '', '1579444868', '1', '1579444868', '100', '0');
INSERT INTO `tp_article_column` VALUES ('7264324116680705', '开发工具', '', '', '1579444885', '1', '1579444885', '100', '0');
INSERT INTO `tp_article_column` VALUES ('7264576798330881', '应用实例', '', '', '1579444946', '1', '1579444946', '100', '0');
INSERT INTO `tp_article_column` VALUES ('7264664253763585', 'php', '', '', '1579445040', '1', '1579444966', '100', '1');
INSERT INTO `tp_article_column` VALUES ('7264796114292737', 'golang', '', '', '1579444998', '1', '1579444998', '100', '1');
INSERT INTO `tp_article_column` VALUES ('7264844751441921', 'python1', '', '', '1601447415', '1', '1579445009', '100', '0');
INSERT INTO `tp_article_column` VALUES ('99550127827587073', 'nodejs', '', '', '1601447536', '1', '1601447536', '100', '0');

-- ----------------------------
-- Table structure for `tp_auth_group`
-- ----------------------------
DROP TABLE IF EXISTS `tp_auth_group`;
CREATE TABLE `tp_auth_group` (
  `id` bigint(20) unsigned NOT NULL,
  `title` char(100) DEFAULT '' COMMENT '用户组中文名称',
  `status` tinyint(1) DEFAULT '1' COMMENT '为1正常，为0禁用',
  `rules` text COMMENT '用户组拥有的规则id， 多个规则","隔开',
  `update_time` int(10) unsigned DEFAULT '0' COMMENT '更新时间',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户组表';

-- ----------------------------
-- Records of tp_auth_group
-- ----------------------------
INSERT INTO `tp_auth_group` VALUES ('1', '超级管理员', '1', '106870968609280001,108069046720794625,106871821529387009,99478116518465537,99496946921771009,102373122036076545,44,7246645603471361,7247512280895489,7247267136409601,7247034964905985,39,40,1,38,7,2', '1603478619', '1544881719');
INSERT INTO `tp_auth_group` VALUES ('2', '普通管理员', '1', '1,2', '1542787522', '1542787522');
INSERT INTO `tp_auth_group` VALUES ('6119919951417345', 'teste', '1', '43,44', '1579172038', '1579172038');

-- ----------------------------
-- Table structure for `tp_auth_rule`
-- ----------------------------
DROP TABLE IF EXISTS `tp_auth_rule`;
CREATE TABLE `tp_auth_rule` (
  `id` bigint(20) unsigned NOT NULL,
  `name` char(80) NOT NULL DEFAULT '' COMMENT '规则唯一标识',
  `title` varchar(20) NOT NULL DEFAULT '' COMMENT '规则中文名称',
  `type` tinyint(1) DEFAULT '1' COMMENT '为1正常，为0禁用',
  `status` tinyint(1) DEFAULT '1' COMMENT '1 正常，0=禁用',
  `condition` char(100) DEFAULT '' COMMENT '规则表达式，为空表示存在就验证',
  `pid` bigint(20) DEFAULT '0' COMMENT '上级菜单',
  `sorts` mediumint(8) DEFAULT '0' COMMENT '升序',
  `icon` varchar(50) DEFAULT '',
  `update_time` int(10) unsigned DEFAULT '0' COMMENT '更新时间',
  `path` varchar(255) DEFAULT '' COMMENT '路经',
  `component` varchar(255) DEFAULT '' COMMENT '组件',
  `hidden` tinyint(1) DEFAULT '0' COMMENT '左侧菜单 0==显示,1隐藏',
  `no_cache` tinyint(1) DEFAULT '0' COMMENT '1=不缓存，0=缓存',
  `always_show` tinyint(1) DEFAULT '0' COMMENT '1= 总显示,0=否 依据子菜单个数',
  `redirect` varchar(255) DEFAULT '',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='规则表';

-- ----------------------------
-- Records of tp_auth_rule
-- ----------------------------
INSERT INTO `tp_auth_rule` VALUES ('1', 'manage', '系统管理', '1', '1', '', '0', '-1', 'component', '1601433238', '/manage', 'layout', '0', '0', '1', '', '0');
INSERT INTO `tp_auth_rule` VALUES ('2', 'manage/admin', '管理员列表', '1', '1', '', '1', '10', 'user', '1541666364', 'admin', 'manage/admin', '0', '0', '0', '', '0');
INSERT INTO `tp_auth_rule` VALUES ('7', 'manage/rules', '权限列表', '1', '1', '', '1', '10', 'lock', '1542353476', 'rules', 'manage/rules', '0', '0', '0', '', '0');
INSERT INTO `tp_auth_rule` VALUES ('38', 'manage/roles', '角色列表', '1', '1', '', '1', '10', 'list', '1542602805', 'roles', 'manage/roles', '0', '0', '0', '', '0');
INSERT INTO `tp_auth_rule` VALUES ('39', 'log', '日志管理', '1', '1', '', '0', '-2', 'education', '1601446075', '/log', 'layout', '0', '0', '1', '', '0');
INSERT INTO `tp_auth_rule` VALUES ('40', 'log/log', '登陆日志', '1', '1', '', '39', '10', 'list', '1579435976', 'log', 'log/log', '0', '0', '0', '', '0');
INSERT INTO `tp_auth_rule` VALUES ('44', 'iconsIndex', '图标列表', '1', '1', '', '99478116518465537', '10', 'list', '1602123122', 'icons/index', 'icons/index', '0', '0', '0', '', '0');
INSERT INTO `tp_auth_rule` VALUES ('7246645603471361', 'article', '文章管理', '1', '1', '', '0', '10', 'documentation', '1579440670', '/article', 'layout', '0', '0', '1', '', '1579440670');
INSERT INTO `tp_auth_rule` VALUES ('7247034964905985', 'article/categery', '分类列表', '1', '1', '', '7246645603471361', '10', 'list', '1579440763', 'categery', 'article/categery', '0', '0', '0', '', '1579440763');
INSERT INTO `tp_auth_rule` VALUES ('7247267136409601', 'article/column', '栏目列表', '1', '1', '', '7246645603471361', '10', 'list', '1579440819', 'column', 'article/column', '0', '0', '0', '', '1579440819');
INSERT INTO `tp_auth_rule` VALUES ('7247512280895489', 'article/blog', '文章列表', '1', '1', '', '7246645603471361', '10', 'list', '1579440877', 'blog', 'article/blog', '0', '0', '0', '', '1579440877');
INSERT INTO `tp_auth_rule` VALUES ('99478116518465537', 'test', '示例目录', '1', '1', '', '0', '10', 'example', '1601437051', '/test', 'layout', '0', '1', '1', 'noredirect', '1601430367');
INSERT INTO `tp_auth_rule` VALUES ('99496946921771009', 'testIndex', '测试页面1', '1', '1', '', '99478116518465537', '10', 'list', '1602485082', 'index', 'AppMain', '0', '1', '1', '', '1601434856');
INSERT INTO `tp_auth_rule` VALUES ('102373122036076545', 'testDemo', '测试目录2', '1', '1', '', '99496946921771009', '10', 'list', '1602484766', 'demo', 'test/demo', '0', '1', '0', '', '1602120590');
INSERT INTO `tp_auth_rule` VALUES ('106870968609280001', 'visual', '可视化', '1', '1', '', '0', '11', 'star', '1603192960', '/visual', 'layout', '0', '1', '1', '', '1603192960');
INSERT INTO `tp_auth_rule` VALUES ('106871821529387009', 'dashboardViewDev', '报表查阅', '1', '1', '', '106870968609280001', '10', 'list', '1603553973', 'dashboardView/dev', 'visual/dashboardView', '0', '1', '0', '', '1603193163');
INSERT INTO `tp_auth_rule` VALUES ('108069046720794625', 'dashboardMakingDev', '报表配置', '1', '1', '', '106870968609280001', '10', 'list', '1603553876', 'dashboardMaking/dev', 'visual/dashboardMaking', '0', '1', '0', '', '1603478604');

-- ----------------------------
-- Table structure for `tp_failed_jobs`
-- ----------------------------
DROP TABLE IF EXISTS `tp_failed_jobs`;
CREATE TABLE `tp_failed_jobs` (
  `id` bigint(20) NOT NULL,
  `type` tinyint(1) DEFAULT '1' COMMENT '1=小程序，2=短信',
  `data` text COMMENT '数据',
  `create_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='队列失败任务记录';

-- ----------------------------
-- Records of tp_failed_jobs
-- ----------------------------

-- ----------------------------
-- Table structure for `tp_image_hash`
-- ----------------------------
DROP TABLE IF EXISTS `tp_image_hash`;
CREATE TABLE `tp_image_hash` (
  `id` bigint(20) unsigned NOT NULL,
  `image` varchar(255) DEFAULT '' COMMENT '图片',
  `hash` varchar(50) DEFAULT '' COMMENT '图片hash',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tp_image_hash
-- ----------------------------
INSERT INTO `tp_image_hash` VALUES ('5819117802229761', 'https://hardphp.oss-cn-beijing.aliyuncs.com\\images/20200115\\1ed50a8ff67bedbe1d4794705868a234.jpg', 'd3ab533b8b10e4f3daeee85dde4179df68cfcc4d', '1579100321', '1579100321');
INSERT INTO `tp_image_hash` VALUES ('19177852159266817', 'https://hardphp.oss-cn-beijing.aliyuncs.com\\images/20200221\\c2a62a8dbba7ae828c5837291e170a4c.jpg', 'b3857f39fb233da316eae01bbbedc67561519cdb', '1582285292', '1582285292');
INSERT INTO `tp_image_hash` VALUES ('99553128025821185', '\\images/20200930\\fe230d9fda46c0cba7f8c8c5c5aec6cb.png', 'ee07718f2797b50dc1cf3411bbae53b28832f53b', '1601448251', '1601448251');
INSERT INTO `tp_image_hash` VALUES ('99555995839238145', '\\images/20200930\\3fddd3004ac536f4a9ab0e603641d7d9.jpg', 'd203a6f652a42ec1466ed88dedf958c1b157569b', '1601448935', '1601448935');
INSERT INTO `tp_image_hash` VALUES ('99559277055840257', '/storage/images/20200930\\d08e7e820934ba3f05b021b7f2d27fb1.png', '761b7f993778b860fef087aa68d74e2ddcc85143', '1601449717', '1601449717');
INSERT INTO `tp_image_hash` VALUES ('99562276272607233', '/storage/images/20200930\\84663c741d1bf14e0fb5bbedadef1a12.png', '9624fc90c3f525cd60cde2eb5dbcabd391f572a6', '1601450432', '1601450432');
INSERT INTO `tp_image_hash` VALUES ('99573133643747329', '/storage\\images/20200930\\2c4e88de5775bbb9e1b2198baf873d7b.png', '7a59b37af8b065f3f683685a78777b858490e829', '1601453021', '1601453021');
INSERT INTO `tp_image_hash` VALUES ('101678079319085057', '/storage\\images/20201006\\79fc79a61eae214b82a40afb902a2828.jpg', 'd52cfdb7c735f860f11ab50696d439e45ff2c7ad', '1601954879', '1601954879');
INSERT INTO `tp_image_hash` VALUES ('108403056865054721', '/storage\\images/20201025\\ff0107753195c62f9cebf08541460188.jpg', 'a8f4c7dfb0c728d4881408d7c1c3c1bccffad06d', '1603558238', '1603558238');

-- ----------------------------
-- Table structure for `tp_login_log`
-- ----------------------------
DROP TABLE IF EXISTS `tp_login_log`;
CREATE TABLE `tp_login_log` (
  `id` bigint(20) unsigned NOT NULL COMMENT 'ID',
  `uid` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `username` char(16) NOT NULL COMMENT '用户名',
  `login_ip` varchar(20) NOT NULL DEFAULT '0' COMMENT '最后登录IP',
  `login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  `roles` varchar(50) NOT NULL DEFAULT '' COMMENT '角色',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='管理员登录';

-- ----------------------------
-- Records of tp_login_log
-- ----------------------------
INSERT INTO `tp_login_log` VALUES ('502', '1', 'admin', '115.60.16.49', '1569570610', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('503', '1', 'admin', '115.60.16.49', '1569570926', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('504', '1', 'admin', '115.60.16.49', '1569571106', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('505', '1', 'admin', '115.60.16.49', '1569571198', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('506', '1', 'admin', '115.60.16.49', '1569572567', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('507', '1', 'admin', '115.60.16.49', '1569572862', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('508', '1', 'admin', '115.60.16.49', '1569577336', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('509', '1', 'admin', '115.60.16.49', '1569577374', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('510', '1', 'admin', '115.60.16.49', '1569579992', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('511', '1', 'admin', '115.60.16.49', '1569580000', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('512', '1', 'admin', '115.60.16.49', '1569580041', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('513', '1', 'admin', '115.60.16.49', '1569580343', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('514', '1', 'admin', '115.60.16.49', '1569580809', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('515', '1', 'admin', '115.60.16.49', '1569580949', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('516', '1', 'admin', '115.60.16.49', '1569581081', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('517', '1', 'admin', '115.60.16.49', '1569581087', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('518', '1', 'admin', '115.60.16.49', '1569581136', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('519', '1', 'admin', '115.60.16.49', '1569581209', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('520', '1', 'admin', '115.60.16.49', '1569581628', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('521', '1', 'admin', '115.60.16.49', '1569581657', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('522', '1', 'admin', '115.60.16.49', '1569581699', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('523', '1', 'admin', '115.60.16.49', '1569581722', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('524', '1', 'admin', '115.60.16.49', '1569583325', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('525', '1', 'admin', '115.60.19.188', '1569634122', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('526', '1', 'admin', '115.60.19.188', '1569639797', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('527', '1', 'admin', '115.60.19.188', '1569639873', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('528', '1', 'admin', '115.60.19.188', '1569640203', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('529', '1', 'admin', '115.60.19.188', '1569640213', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('530', '1', 'admin', '115.60.19.188', '1569642217', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('531', '1', 'admin', '39.149.247.160', '1574342514', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('532', '1', 'admin', '39.149.247.160', '1574468895', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('533', '1', 'admin', '223.88.30.142', '1574846370', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('534', '1', 'admin', '223.88.30.142', '1574848961', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('535', '1', 'admin', '223.88.30.142', '1574849547', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('536', '1', 'admin', '223.88.30.142', '1574849754', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('537', '1', 'admin', '223.88.30.142', '1574850555', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('538', '1', 'admin', '223.88.30.142', '1574850985', '超级管理员', '0', '0');
INSERT INTO `tp_login_log` VALUES ('97657171734564865', '1', 'admini', '127.0.0.1', '1600996220', '超级管理员', '1600996220', '1600996220');
INSERT INTO `tp_login_log` VALUES ('97663612704919552', '1', 'admini', '127.0.0.1', '1600997755', '超级管理员', '1600997755', '1600997755');
INSERT INTO `tp_login_log` VALUES ('98758649312317441', '1', 'admini', '127.0.0.1', '1601258832', '超级管理员', '1601258832', '1601258832');
INSERT INTO `tp_login_log` VALUES ('98898688457445377', '1', 'admini', '127.0.0.1', '1601292220', '超级管理员', '1601292220', '1601292220');
INSERT INTO `tp_login_log` VALUES ('99147137136332801', '1', 'admini', '127.0.0.1', '1601351455', '超级管理员', '1601351455', '1601351455');
INSERT INTO `tp_login_log` VALUES ('99149051244711937', '1', 'admini', '127.0.0.1', '1601351911', '超级管理员', '1601351911', '1601351911');
INSERT INTO `tp_login_log` VALUES ('99478257572909057', '1', 'admini', '127.0.0.1', '1601430400', '超级管理员', '1601430400', '1601430400');
INSERT INTO `tp_login_log` VALUES ('99479561888206849', '1', 'admini', '127.0.0.1', '1601430711', '超级管理员', '1601430711', '1601430711');
INSERT INTO `tp_login_log` VALUES ('99488873876426753', '1', 'admini', '127.0.0.1', '1601432931', '超级管理员', '1601432931', '1601432931');
INSERT INTO `tp_login_log` VALUES ('99489219700985857', '1', 'admini', '127.0.0.1', '1601433014', '超级管理员', '1601433014', '1601433014');
INSERT INTO `tp_login_log` VALUES ('99572052670943233', '1', 'admini', '127.0.0.1', '1601452763', '超级管理员', '1601452763', '1601452763');
INSERT INTO `tp_login_log` VALUES ('99572154995183617', '1', 'admini', '127.0.0.1', '1601452787', '超级管理员', '1601452787', '1601452787');
INSERT INTO `tp_login_log` VALUES ('99609201302704129', '1', 'admini', '127.0.0.1', '1601461620', '超级管理员', '1601461620', '1601461620');
INSERT INTO `tp_login_log` VALUES ('99615483560595457', '1', 'admini', '127.0.0.1', '1601463118', '超级管理员', '1601463118', '1601463118');
INSERT INTO `tp_login_log` VALUES ('99616120520183809', '1', 'admini', '127.0.0.1', '1601463269', '超级管理员', '1601463269', '1601463269');
INSERT INTO `tp_login_log` VALUES ('99616227110031360', '1', 'admini', '127.0.0.1', '1601463295', '超级管理员', '1601463295', '1601463295');
INSERT INTO `tp_login_log` VALUES ('101647788881874945', '1', 'admini', '127.0.0.1', '1601947657', '超级管理员', '1601947657', '1601947657');
INSERT INTO `tp_login_log` VALUES ('101663289213325313', '1', 'admini', '127.0.0.1', '1601951352', '超级管理员', '1601951352', '1601951352');
INSERT INTO `tp_login_log` VALUES ('101665422465699841', '1', 'admini', '127.0.0.1', '1601951861', '超级管理员', '1601951861', '1601951861');
INSERT INTO `tp_login_log` VALUES ('102019449112104961', '1', 'admini', '192.168.11.1', '1602036268', '超级管理员', '1602036268', '1602036268');
INSERT INTO `tp_login_log` VALUES ('102372721727508481', '1', 'admini', '127.0.0.1', '1602120494', '超级管理员', '1602120494', '1602120494');
INSERT INTO `tp_login_log` VALUES ('102388123815776257', '1', 'admini', '127.0.0.1', '1602124166', '超级管理员', '1602124166', '1602124166');
INSERT INTO `tp_login_log` VALUES ('102388182879965185', '1', 'admini', '127.0.0.1', '1602124181', '超级管理员', '1602124181', '1602124181');
INSERT INTO `tp_login_log` VALUES ('102388541732032512', '1', 'admini', '127.0.0.1', '1602124266', '超级管理员', '1602124266', '1602124266');
INSERT INTO `tp_login_log` VALUES ('102388944364244993', '1', 'admini', '127.0.0.1', '1602124362', '超级管理员', '1602124362', '1602124362');
INSERT INTO `tp_login_log` VALUES ('102389463065432065', '1', 'admini', '127.0.0.1', '1602124486', '超级管理员', '1602124486', '1602124486');
INSERT INTO `tp_login_log` VALUES ('102404893612052481', '1', 'admini', '127.0.0.1', '1602128165', '超级管理员', '1602128165', '1602128165');
INSERT INTO `tp_login_log` VALUES ('102406863852802049', '1', 'admini', '127.0.0.1', '1602128634', '超级管理员', '1602128634', '1602128634');
INSERT INTO `tp_login_log` VALUES ('102406908983513089', '1', 'admini', '127.0.0.1', '1602128645', '超级管理员', '1602128645', '1602128645');
INSERT INTO `tp_login_log` VALUES ('102407096254992385', '1', 'admini', '127.0.0.1', '1602128690', '超级管理员', '1602128690', '1602128690');
INSERT INTO `tp_login_log` VALUES ('102407458198261761', '1', 'admini', '127.0.0.1', '1602128776', '超级管理员', '1602128776', '1602128776');
INSERT INTO `tp_login_log` VALUES ('102410495042129921', '1', 'admini', '127.0.0.1', '1602129500', '超级管理员', '1602129500', '1602129500');
INSERT INTO `tp_login_log` VALUES ('102410901231112193', '1', 'admini', '127.0.0.1', '1602129597', '超级管理员', '1602129597', '1602129597');
INSERT INTO `tp_login_log` VALUES ('102411124300976129', '1', 'admini', '127.0.0.1', '1602129650', '超级管理员', '1602129650', '1602129650');
INSERT INTO `tp_login_log` VALUES ('102415172693528577', '1', 'admini', '127.0.0.1', '1602130615', '超级管理员', '1602130615', '1602130615');
INSERT INTO `tp_login_log` VALUES ('103842419090526209', '1', 'admini', '127.0.0.1', '1602470898', '超级管理员', '1602470898', '1602470898');
INSERT INTO `tp_login_log` VALUES ('103893957813080065', '1', 'admini', '127.0.0.1', '1602483185', '超级管理员', '1602483185', '1602483185');
INSERT INTO `tp_login_log` VALUES ('103894134623965185', '1', 'admini', '127.0.0.1', '1602483227', '超级管理员', '1602483227', '1602483227');
INSERT INTO `tp_login_log` VALUES ('103896067044675584', '1', 'admini', '127.0.0.1', '1602483688', '超级管理员', '1602483688', '1602483688');
INSERT INTO `tp_login_log` VALUES ('103896360247496705', '1', 'admini', '127.0.0.1', '1602483758', '超级管理员', '1602483758', '1602483758');
INSERT INTO `tp_login_log` VALUES ('103896446155231233', '1', 'admini', '127.0.0.1', '1602483779', '超级管理员', '1602483779', '1602483779');
INSERT INTO `tp_login_log` VALUES ('103896850603577345', '1', 'admini', '127.0.0.1', '1602483875', '超级管理员', '1602483875', '1602483875');
INSERT INTO `tp_login_log` VALUES ('103897220390195201', '1', 'admini', '127.0.0.1', '1602483963', '超级管理员', '1602483963', '1602483963');
INSERT INTO `tp_login_log` VALUES ('103898067396333569', '1', 'admini', '127.0.0.1', '1602484165', '超级管理员', '1602484165', '1602484165');
INSERT INTO `tp_login_log` VALUES ('103898262284668929', '1', 'admini', '127.0.0.1', '1602484212', '超级管理员', '1602484212', '1602484212');
INSERT INTO `tp_login_log` VALUES ('103898790142021633', '1', 'admini', '127.0.0.1', '1602484337', '超级管理员', '1602484337', '1602484337');
INSERT INTO `tp_login_log` VALUES ('106867688265093121', '1', 'admini', '127.0.0.1', '1603192178', '超级管理员', '1603192178', '1603192178');
INSERT INTO `tp_login_log` VALUES ('106870529230770177', '1', 'admini', '127.0.0.1', '1603192855', '超级管理员', '1603192855', '1603192855');
INSERT INTO `tp_login_log` VALUES ('106920849415737345', '1', 'admini', '127.0.0.1', '1603204852', '超级管理员', '1603204852', '1603204852');
INSERT INTO `tp_login_log` VALUES ('107644029277179905', '1', 'admini', '127.0.0.1', '1603377271', '超级管理员', '1603377272', '1603377272');
INSERT INTO `tp_login_log` VALUES ('107644190845964289', '1', 'admini', '127.0.0.1', '1603377310', '超级管理员', '1603377311', '1603377311');
INSERT INTO `tp_login_log` VALUES ('107646811736510465', '1', 'admini', '127.0.0.1', '1603377935', '超级管理员', '1603377935', '1603377935');
INSERT INTO `tp_login_log` VALUES ('108023638355218433', '1', 'admini', '127.0.0.1', '1603467778', '超级管理员', '1603467778', '1603467778');
INSERT INTO `tp_login_log` VALUES ('108072872412581889', '1', 'admini', '127.0.0.1', '1603479516', '超级管理员', '1603479516', '1603479516');
INSERT INTO `tp_login_log` VALUES ('108343354206588929', '1', 'admini', '127.0.0.1', '1603544004', '超级管理员', '1603544004', '1603544004');

-- ----------------------------
-- Table structure for `tp_notice_send_log`
-- ----------------------------
DROP TABLE IF EXISTS `tp_notice_send_log`;
CREATE TABLE `tp_notice_send_log` (
  `id` bigint(20) NOT NULL,
  `type` tinyint(1) DEFAULT '1' COMMENT '1=小程序，2=公众号，3=短信',
  `data` text COMMENT '数据',
  `create_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `result` text COMMENT '结果',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知消息发送记录';

-- ----------------------------
-- Records of tp_notice_send_log
-- ----------------------------

-- ----------------------------
-- Table structure for `tp_sms`
-- ----------------------------
DROP TABLE IF EXISTS `tp_sms`;
CREATE TABLE `tp_sms` (
  `id` bigint(20) unsigned NOT NULL,
  `phone` char(11) NOT NULL COMMENT '手机号',
  `code` varchar(10) NOT NULL COMMENT '验证码',
  `ip` varchar(50) NOT NULL COMMENT 'ip地址',
  `deadline` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=注册，2=登录，3=找回密码',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 未使用，1已使用',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='手机验证码';

-- ----------------------------
-- Records of tp_sms
-- ----------------------------

-- ----------------------------
-- Table structure for `tp_user`
-- ----------------------------
DROP TABLE IF EXISTS `tp_user`;
CREATE TABLE `tp_user` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `openid` varchar(150) NOT NULL DEFAULT '' COMMENT '微信身份标识',
  `password` char(32) NOT NULL DEFAULT '' COMMENT '32位小写MD5密码',
  `phone` varchar(30) NOT NULL DEFAULT '' COMMENT '手机号',
  `username` varchar(30) NOT NULL DEFAULT '' COMMENT '用户名',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `nickname` varchar(20) NOT NULL COMMENT '用户昵称',
  `img` varchar(255) NOT NULL DEFAULT '' COMMENT '头像URL',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别标志：0，其他；1，男；2，女',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '账户余额',
  `birth` varchar(50) NOT NULL DEFAULT '' COMMENT '生日',
  `descript` varchar(200) NOT NULL DEFAULT '',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '账户总金额',
  `create_time` int(10) NOT NULL DEFAULT '0' COMMENT '注册时间',
  `reg_ip` varchar(20) NOT NULL DEFAULT '' COMMENT '注册IP',
  `login_ip` varchar(20) NOT NULL DEFAULT '' COMMENT 'IP',
  `login_time` int(10) NOT NULL DEFAULT '0' COMMENT '登录时间',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '时间',
  `delete_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='主系统用户表。';

-- ----------------------------
-- Records of tp_user
-- ----------------------------
INSERT INTO `tp_user` VALUES ('1', '', '', '15237156573', '12312333', '1', 'xiegaolei', '/uploads/images/20180512/6c7cf3ee6e3e83c031e260c5fa0844fb.jpg', '0', '20210.00', '1989-10-10', '我要给你一个拥抱 给你一双温热手掌', '525225.00', '1515057952', '123.149.214.69', '', '0', '0', '0');
INSERT INTO `tp_user` VALUES ('10', '', '', '', '', '1', '', '', '0', '0.00', '', '', '0.00', '0', '', '', '0', '0', '0');

-- ----------------------------
-- Table structure for `tp_visual_component_type`
-- ----------------------------
DROP TABLE IF EXISTS `tp_visual_component_type`;
CREATE TABLE `tp_visual_component_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component_type_en` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '英文名称',
  `component_type_cn` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '中文名称',
  `data_attribute_json` text COLLATE utf8_unicode_ci NOT NULL COMMENT '组件数据属性',
  `remark` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='组件类型表';

-- ----------------------------
-- Records of tp_visual_component_type
-- ----------------------------
INSERT INTO `tp_visual_component_type` VALUES ('1', 'queryControl', '查询控件', '', '');
INSERT INTO `tp_visual_component_type` VALUES ('2', 'textBox', '文本框', '{\"column\":[{\"title\":\"字体\",\"type\":\"input\"},{\"title\":\"背景色\",\"type\":\"bg\"}]}', '');
INSERT INTO `tp_visual_component_type` VALUES ('3', 'lineChart', '折线图', '{\"column\":[{\"title\":\"纵轴/指标\",\"type\":\"options_column\",\"maxLen\":5},{\"title\":\"横轴/维度\",\"type\":\"options_column\",\"maxLen\":1},{\"title\":\"颜色/维度\",\"type\":\"options_column\",\"maxLen\":1}],\"filter\":[{\"title\":\"过滤条件\",\"type\":\"options_column\"}]}', '');
INSERT INTO `tp_visual_component_type` VALUES ('4', 'barChart', '柱状图', '{\"column\":[{\"title\":\"纵轴/指标\",\"type\":\"options_column\",\"maxLen\":5},{\"title\":\"横轴/维度\",\"type\":\"options_column\",\"maxLen\":1},{\"title\":\"颜色/维度\",\"type\":\"options_column\",\"maxLen\":1}],\"filter\":[{\"title\":\"过滤条件\",\"type\":\"options_column\"}]}', '');
INSERT INTO `tp_visual_component_type` VALUES ('5', 'composeChart', '组合图', '{\"column\":[{\"title\":\"主纵轴/指标\",\"type\":\"options_column\",\"maxLen\":3},{\"title\":\"次纵轴/指标\",\"type\":\"options_column\",\"maxLen\":3},{\"title\":\"横轴/维度\",\"type\":\"options_column\",\"maxLen\":1}],\"filter\":[{\"title\":\"过滤条件\",\"type\":\"options_column\"}]}', '');
INSERT INTO `tp_visual_component_type` VALUES ('6', 'pieChart', '饼图', '{\"column\":[{\"title\":\"扇形区域/指标\",\"type\":\"options_column\",\"maxLen\":3},{\"title\":\"扇形颜色/维度\",\"type\":\"options_column\",\"maxLen\":3}],\"filter\":[{\"title\":\"过滤条件\",\"type\":\"options_column\"}]}', '');
INSERT INTO `tp_visual_component_type` VALUES ('7', 'table', '表格', '{\"column\":[{\"title\":\"列/指标\",\"type\":\"options_column\"},{\"title\":\"行/维度\",\"type\":\"options_column\"}],\"filter\":[{\"title\":\"过滤条件\",\"type\":\"options_column\"}]}', '');
INSERT INTO `tp_visual_component_type` VALUES ('8', 'funnelChart', '漏斗图', '{\"column\":[{\"title\":\"漏斗层/指标\",\"type\":\"options_column\",\"maxlen\":10}],\"filter\":[{\"title\":\"过滤条件\",\"type\":\"options_column\"}]}', '');
INSERT INTO `tp_visual_component_type` VALUES ('9', 'indicate', '指示看板', '{\"column\":[{\"title\":\"看板指标\",\"type\":\"options_column\",\"maxlen\":1},{\"title\":\"看板维度\",\"type\":\"options_column\",\"maxlen\":1}],\"filter\":[{\"title\":\"过滤条件\",\"type\":\"options_column\"}]}', '');

-- ----------------------------
-- Table structure for `tp_visual_data_model`
-- ----------------------------
DROP TABLE IF EXISTS `tp_visual_data_model`;
CREATE TABLE `tp_visual_data_model` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_id` int(11) NOT NULL DEFAULT '0' COMMENT '所属数据源id',
  `caption` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '数据集名称',
  `fac_table` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '实际表名称',
  `data_source` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `f_source_id` (`source_id`) USING BTREE,
  CONSTRAINT `tp_visual_data_model_ibfk_1` FOREIGN KEY (`source_id`) REFERENCES `tp_visual_data_source` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='数据模型';

-- ----------------------------
-- Records of tp_visual_data_model
-- ----------------------------

-- ----------------------------
-- Table structure for `tp_visual_data_model_column`
-- ----------------------------
DROP TABLE IF EXISTS `tp_visual_data_model_column`;
CREATE TABLE `tp_visual_data_model_column` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_id` int(11) NOT NULL COMMENT '所属模型id',
  `column` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '维度或指标名称',
  `coltype` enum('string','number') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'string' COMMENT '字段类型',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型 1：维度 2：指标',
  `fact_column` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '实时字段',
  `sort` tinyint(4) NOT NULL DEFAULT '10' COMMENT '排序，数值越大越靠前',
  `dim_relation` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '维度关联表',
  `dim_relation_field` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '关联维度表所取的字段',
  `deduplication_count` tinyint(1) DEFAULT '0' COMMENT '是否支持去重',
  `field_visible` tinyint(1) DEFAULT '1' COMMENT '字段是否可见',
  PRIMARY KEY (`id`),
  KEY `f_model_id` (`model_id`) USING BTREE,
  CONSTRAINT `tp_visual_data_model_column_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `tp_visual_data_model` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='数据模型维度和指标表';

-- ----------------------------
-- Records of tp_visual_data_model_column
-- ----------------------------

-- ----------------------------
-- Table structure for `tp_visual_data_source`
-- ----------------------------
DROP TABLE IF EXISTS `tp_visual_data_source`;
CREATE TABLE `tp_visual_data_source` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '数据源名称',
  `source_type` enum('impala','kylin','es','mysql') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'impala' COMMENT '数据类型',
  `db_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '库名',
  `source_config` text COLLATE utf8_unicode_ci COMMENT '数据源配置',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='数据源';

-- ----------------------------
-- Records of tp_visual_data_source
-- ----------------------------
INSERT INTO `tp_visual_data_source` VALUES ('1', '本地mysql', 'mysql', 'tp6_element', '{\"host\":\"127.0.0.1\",\"port\":\"3306\",\"user\":\"root\",\"password\":\"root\",\"database\":\"tp6_element\"}');
INSERT INTO `tp_visual_data_source` VALUES ('2', '员工库mysql', 'mysql', 'employees', '{\"host\":\"127.0.0.1\",\"port\":\"3306\",\"user\":\"root\",\"password\":\"root\",\"database\":\"employees\"}');

-- ----------------------------
-- Table structure for `tp_visual_relational_dim_tab`
-- ----------------------------
DROP TABLE IF EXISTS `tp_visual_relational_dim_tab`;
CREATE TABLE `tp_visual_relational_dim_tab` (
  `id` int(11) NOT NULL,
  `relationa_dim_tab` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '关联维度表id',
  `rely_ren` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '维度重命名',
  `model_id` int(100) DEFAULT NULL COMMENT '关联模型',
  `main_field` varchar(100) DEFAULT NULL,
  `relation_field` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tp_visual_relational_dim_tab
-- ----------------------------

-- ----------------------------
-- Table structure for `tp_visual_report_page`
-- ----------------------------
DROP TABLE IF EXISTS `tp_visual_report_page`;
CREATE TABLE `tp_visual_report_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identification` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '唯一标识',
  `creat_user_id` int(11) NOT NULL DEFAULT '0' COMMENT '创建人id',
  `last_modify_user_id` int(11) NOT NULL DEFAULT '0' COMMENT '最后修改人id',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0未发布 1已发布（当修改时间大于发布时间为未发布）',
  `is_allow_down` tinyint(2) NOT NULL DEFAULT '0' COMMENT '允许下载 0:不允许 1:允许',
  `is_show_watermark` tinyint(2) NOT NULL DEFAULT '1' COMMENT '显示水印 0:不显示 1:显示',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `page_name` varchar(11) COLLATE utf8_unicode_ci NOT NULL COMMENT '报表名称',
  `user_name` varchar(11) COLLATE utf8_unicode_ci DEFAULT '创建人名称',
  `rpt_menu_id` int(11) DEFAULT NULL COMMENT '页面ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_identification` (`identification`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='分析报表页面';

-- ----------------------------
-- Records of tp_visual_report_page
-- ----------------------------
INSERT INTO `tp_visual_report_page` VALUES ('165', 'test', '0', '0', '1', '0', '1', '2020-10-24 21:14:40', '2020-10-21 14:18:56', '2020-10-24 21:14:42', '测试', '测试运营号', '473');
INSERT INTO `tp_visual_report_page` VALUES ('166', 'dev', '0', '0', '0', '0', '1', '2020-10-24 21:14:43', '2020-10-24 00:13:34', '2020-10-24 21:15:54', '', '创建人名称', null);

-- ----------------------------
-- Table structure for `tp_visual_report_page_components`
-- ----------------------------
DROP TABLE IF EXISTS `tp_visual_report_page_components`;
CREATE TABLE `tp_visual_report_page_components` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_page_id` int(11) NOT NULL COMMENT '所属报表页面id',
  `component_type` varchar(11) COLLATE utf8_unicode_ci NOT NULL COMMENT '组件类型',
  `component_model` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT '组件绑定的数据类型',
  `layout_info` text COLLATE utf8_unicode_ci NOT NULL COMMENT '组件布局信息',
  `query_input` text COLLATE utf8_unicode_ci NOT NULL COMMENT '组件配置信息',
  `name` varchar(100) COLLATE utf8_unicode_ci DEFAULT '图表名称',
  `data_source` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `f_c_page_id` (`report_page_id`) USING BTREE,
  CONSTRAINT `tp_visual_report_page_components_ibfk_1` FOREIGN KEY (`report_page_id`) REFERENCES `tp_visual_report_page` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1913 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='报表页面组件表';

-- ----------------------------
-- Records of tp_visual_report_page_components
-- ----------------------------
INSERT INTO `tp_visual_report_page_components` VALUES ('1888', '165', 'tab', '', '{\"h\":11,\"w\":12,\"x\":0,\"y\":0,\"text\":\"\"}', '{\"second_measure\":[],\"area_measure\":[],\"area_dim\":[],\"second_dim\":[],\"filters\":[{\"speRequire\":\"dt\",\"operatorSymbol\":\"\",\"addValType\":2,\"conValue\":\"今日\",\"operatorSymbolArrs\":[],\"type\":1,\"labelZhCn\":\"日期\",\"dimOptions\":[{\"value\":\"今日\"},{\"value\":\"昨日\"},{\"value\":\"近两日(含今日)\"},{\"value\":\"近3天\"},{\"value\":\"近7天\"},{\"value\":\"近10天\"},{\"value\":\"近14天\"},{\"value\":\"近30天\"},{\"value\":\"本周\"},{\"value\":\"本月\"},{\"value\":\"上一周\"},{\"value\":\"上一个月\"}]}],\"getDataWay\":\"sql\",\"sqlDatasourceId\":1,\"sqlString\":\"SELECT \\n\\tid,\\n  title,\\n  photo\\nFROM v9_collection_content\\n${分页||show=false}\",\"searchItems\":[{\"label\":\"分页\",\"variable\":\"分页||show=false\",\"show\":\"false\",\"value\":\"\"}]}', '今日实时用户', '');
INSERT INTO `tp_visual_report_page_components` VALUES ('1910', '166', 'tab', '', '{\"h\":13,\"w\":6,\"x\":0,\"y\":0,\"text\":\"\"}', '{\"second_measure\":[],\"area_measure\":[],\"area_dim\":[],\"second_dim\":[],\"filters\":[],\"getDataWay\":\"sql\",\"sqlDatasourceId\":1,\"sqlString\":\"select \\nSname as `姓名`,\\nSage as `年龄`,\\nSsex as `性别`\\nfrom test_student\\nwhere Sname=\'${姓名||default=\' or Sname!=\'}\'\\n${分页||show=false}\",\"searchItems\":[{\"label\":\"姓名\",\"variable\":\"姓名||default=\' or Sname!=\'\",\"default\":\"\' or Sname!\",\"value\":\"\"},{\"label\":\"分页\",\"variable\":\"分页||show=false\",\"show\":\"false\",\"value\":1}]}', '学生表', '');
INSERT INTO `tp_visual_report_page_components` VALUES ('1911', '166', 'pie', '', '{\"h\":13,\"w\":6,\"x\":6,\"y\":0,\"text\":\"\"}', '{\"second_measure\":[],\"area_measure\":[],\"area_dim\":[],\"second_dim\":[],\"filters\":[],\"getDataWay\":\"sql\",\"sqlDatasourceId\":1,\"sqlString\":\"select \\nSsex as `性别`,\\ncount(1) as `数量`\\nfrom test_student\\ngroup by Ssex\",\"searchItems\":[]}', '学生男女比例', '');
INSERT INTO `tp_visual_report_page_components` VALUES ('1912', '166', 'line', '', '{\"h\":8,\"w\":12,\"x\":0,\"y\":13}', '{\"second_measure\":[],\"area_measure\":[],\"area_dim\":[],\"second_dim\":[],\"filters\":[],\"sortConfig\":{\"sortField\":\"\",\"sort\":\"\"},\"getDataWay\":\"sql\",\"sqlDatasourceId\":2,\"sqlString\":\"SELECT \\n\\tbirth_date as `生日`,\\n  count(1) as `人数` \\nfrom employees \\nWHERE \\n\\tbirth_date>\'1953-01-01\' \\n  and birth_date<=\'1953-12-31\' \\ngroup by birth_date \\nORDER BY birth_date asc \",\"searchItems\":[]}', '员工生日分布', '');

-- ----------------------------
-- Table structure for `tp_visual_report_page_layout`
-- ----------------------------
DROP TABLE IF EXISTS `tp_visual_report_page_layout`;
CREATE TABLE `tp_visual_report_page_layout` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_page_id` int(11) NOT NULL DEFAULT '0' COMMENT '所属页面id',
  `component_type_id` int(11) NOT NULL COMMENT '组件类型id',
  `layout_json` text COLLATE utf8_unicode_ci COMMENT '布局json',
  PRIMARY KEY (`id`),
  KEY `f_page_id` (`report_page_id`) USING BTREE,
  KEY `f_type_id` (`component_type_id`) USING BTREE,
  CONSTRAINT `tp_visual_report_page_layout_ibfk_1` FOREIGN KEY (`report_page_id`) REFERENCES `tp_visual_report_page` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tp_visual_report_page_layout_ibfk_2` FOREIGN KEY (`component_type_id`) REFERENCES `tp_visual_component_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='报表页面布局信息';

-- ----------------------------
-- Records of tp_visual_report_page_layout
-- ----------------------------

-- ----------------------------
-- Table structure for `tp_visual_report_page_publish`
-- ----------------------------
DROP TABLE IF EXISTS `tp_visual_report_page_publish`;
CREATE TABLE `tp_visual_report_page_publish` (
  `report_page_id` int(11) NOT NULL,
  `layout_json` text COLLATE utf8_unicode_ci COMMENT '布局信息',
  `components_json` text COLLATE utf8_unicode_ci COMMENT '组件信息',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '发布时间',
  PRIMARY KEY (`report_page_id`),
  CONSTRAINT `tp_visual_report_page_publish_ibfk_1` FOREIGN KEY (`report_page_id`) REFERENCES `tp_visual_report_page` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='发布页面信息';

-- ----------------------------
-- Records of tp_visual_report_page_publish
-- ----------------------------
