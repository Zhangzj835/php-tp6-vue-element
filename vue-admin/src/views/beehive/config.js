module.exports = {
    //用户表格字段 (type:1-维度；2-过滤树形；3-统计指标)
    userTabColumn: [
        {
            label:'时间',
            prop:'dt',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'varchar'
        },
        {
            label:'用户ID',
            prop:'user_id',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'是否plus',
            prop:'is_plus',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'直接上级用户ID',
            prop:'leader_user_id',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'用户手机号',
            prop:'phone',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'varchar'
        },
        {
            label:'邀请码',
            prop:'invite_code',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'varchar'
        },
        {
            label:'用户类型',
            prop:'user_type',
            type:1,
            rely:'a',
            cField:'dimension',
            dataType:'integer'
        },
        {
            label:'标签分组',          
            prop:'class_type_name',
            type:1,
            rely:'a',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'班级标签',
            prop:'class_label_name',
            type:1,
            rely:'a',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'团队名称',
            prop:'team_name',
            type:1,
            rely:'a',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'直邀粉丝数',
            prop:'invite_a_fans_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'间邀粉丝数',
            prop:'invite_b_fans_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'VIP粉丝数',
            prop:'vip_fans_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'直属VIP粉丝数',
            prop:'vip_a_fans_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'推荐VIP粉丝数',
            prop:'vip_b_t_fans_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'有效VIP粉丝数',
            prop:'valid_vip_fans_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'无效VIP粉丝数',
            prop:'invalid_vip_fans_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'有效直属VIP粉丝数',
            prop:'valid_vip_a_fans_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'有效推荐VIP粉丝数',
            prop:'valid_vip_b_t_fans_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'微信VIP粉丝数',
            prop:'wx_vip_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'非微信VIP粉丝数',
            prop:'un_wx_vip_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'授权VIP粉丝数',
            prop:'auth_vip_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'未授权VIP粉丝数',
            prop:'unauth_vip_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'零邀请VIP粉丝数',
            prop:'zero_invite_vip_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'流失VIP粉丝数',
            prop:'loss_vip_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'运营专员黄金数',
            prop:'operator_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'直属运营专员<黄金>数',
            prop:'a_operator_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'间接运营专员<黄金>数',
            prop:'b_operator_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'有效运营专员<黄金>数',
            prop:'valid_operator_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'无效运营专员<黄金>数',
            prop:'invalid_operator_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'有效直属运营专员<黄金>数',
            prop:'valid_a_operator_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'有效间接运营专员<黄金>数',
            prop:'valid_b_operator_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'运营专员<钻石>数',
            prop:'company_num',
            type:1,
            rely:'a',
            cField:'property',
            dataType:'integer'
        },
        {
            label:'付款金额',
            prop:'gmv',
            type:2,
            rely:'c',
            cField:'index',
            dataType:'integer'
        },
        {
            label:'付款订单量',
            prop:'order_num',
            type:2,
            rely:'c',
            cField:'index',
            dataType:'integer'
        },
        {
            label:'成交预估佣金',
            prop:'commission_self_union_platform',
            type:2,
            rely:'c',
            cField:'index',
            dataType:'integer'
        },
        {
            label:'成交预估补贴',
            prop:'commission_self_miyuan_subsidy',
            type:2,
            rely:'c',
            cField:'index',
            dataType:'integer'
        },
        
        {
            label:'成交预估收入',
            prop:'commission_self',
            type:2,
            rely:'c',
            cField:'index',
            dataType:'integer'
        },
        {
            label:'结算金额',
            prop:'settle_gmv',
            type:2,
            rely:'c',
            cField:'index',
            dataType:'integer'
        },
        {
            label:'结算订单量',
            prop:'settle_order_num',
            type:2,
            rely:'c',
            cField:'index',
            dataType:'integer'
        },
        {
            label:'结算预估联盟佣金',
            prop:'settle_commission_self_union_platform',
            type:2,
            rely:'c',
            cField:'index',
            dataType:'integer'
        },
        
        {
            label:'结算预估补贴',
            prop:'settle_commission_self_miyuan_subsidy',
            type:2,
            rely:'c',
            cField:'index',
            dataType:'integer'
        },
        {
            label:'结算预估收入',
            prop:'settle_commission_self',
            type:2,
            rely:'c',
            cField:'index',
            dataType:'integer'
        },
        {
            label:'新增VIP粉丝数',
            prop:'vip_new_register_num',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'bigint'
        },
        {
            label:'新增运营专员黄金数',
            prop:'operator_new_upgrade_num',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'bigint'
        },
        {
            label:'新增直属VIP粉丝数',
            prop:'vip_new_a_num',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'bigint'
        },
        {
            label:'新增间接VIP粉丝数',
            prop:'vip_new_b_num',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'bigint'
        },
        {
            label:'新增有效直属VIP粉丝数',
            prop:'vip_new_valid_a_num',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'bigint'
        },
        {
            label:'新增有效间接VIP粉丝数',
            prop:'vip_new_valid_b_num',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'bigint'
        },
        {
            label:'新增有效VIP粉丝数',
            prop:'vip_new_valid_num',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'bigint'
        },
        {
            label:'新增授权VIP粉丝数',
            prop:'vip_new_auth_num',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'bigint'
        },
        
    ],
    operatorSymbol:[
        {
            description:'等于',
            value:'='
        },
        {
            description:'不等于',
            value:'!='
        },
        {
            description:'大于',
            value:'>'
        },
        {
            description:'小于',
            value:'<'
        },
        {
            description:'小于等于',
            value:'<='
        },
        {
            description:'大于等于',
            value:'>='
        },
        {
            description:'在集合中',
            value:'IN'
        },
        // {
        //     description:'不在集合中',
        //     value:'NOT IN'
        // },
        {
            description:'模糊匹配',
            value:'LIKE'
        },
    ],
    revenueTabColumn:[
        {
            label:'时间',
            prop:'dt',
            type:1,
            rely:'a',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'渠道类型',
            prop:'platform_type_name',
            type:1,
            rely:'c',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'平台',
            prop:'client_name',
            type:1,
            rely:'f',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'渠道',
            prop:'platform_name',
            type:1,
            rely:'c',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'子渠道',
            prop:'sub_platform_name',
            type:1,
            rely:'c',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'一级品类',
            prop:'first_category',
            type:1,
            rely:'e',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'二级品类',
            prop:'second_category',
            type:1,
            rely:'e',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'三级品类',
            prop:'third_category',
            type:1,
            rely:'e',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'订单状态',
            prop:'order_status_name',
            type:1,
            rely:'d',
            cField:'dimension',
            dataType:'varchar'
        },
        {
            label:'付款金额',
            prop:'gmv',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'decimal'
        },
        {
            label:'订单量',
            prop:'order_num',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'integer'
        },
        {
            label:'税前总佣金',
            prop:'commission_total',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'decimal'
        },
        {
            label:'税后总佣金',
            prop:'commission_total_after_tax',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'decimal'
        },
        {
            label:'结算金额',
            prop:'settle_gmv',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'decimal'
        },
        {
            label:'结算订单量',
            prop:'settle_order_num',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'decimal'
        },
        {
            label:'结算佣金',
            prop:'settle_commission_total_after_tax',
            type:2,
            rely:'a',
            cField:'index',
            dataType:'decimal'
        }
    ]
}
  