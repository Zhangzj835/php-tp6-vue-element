<?php
declare (strict_types=1);

namespace app\model;

use think\Model;
use app\traits\ModelTrait;

/**
 * 可视化报表
 * Class VisualReportPage
 * @package app\model
 */
class VisualReportPage extends Model
{
    //时间字段显示格式
    protected $dateFormat = 'Y-m-d H:i:s';
    // 开启自动写入时间戳字段
    protected $autoWriteTimestamp = 'int';
    //只读字段，不允许被更改
    protected $readonly = [];
    //数据输出隐藏的属性
    protected $hidden = [];

    //据输出显示的属性
    public static $showField = ['id', 'identification', 'status', 'is_allow_down', 'is_show_watermark', 'page_name', 'rpt_menu_id', 'create_time'];

    //查询类型转换, 与Model 中的type类型转化功能相同，只是新增字符串类型
    protected $selectType = [
        'identification' => 'string',
    ];

    use ModelTrait;
}
