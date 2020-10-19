<?php
declare (strict_types=1);

namespace app\controller\admin;

use app\controller\admin\Base;
use app\traits\ControllerTrait;
use think\annotation\route\Middleware;
use think\annotation\route\Group;
use think\annotation\Route;
use app\middleware\CheckAdmin;


/**
 * 报表管理
* Class Visual
 * @package app\controller\admin
 * @Group("admin/visual")
 * 
 */
class Visual extends Base
{
    //服务，带命名空间
    public static $service = 'app\service\VisualService';    
    //状态变更允许字段,格式 字段名：允许值
    public static $enableField = ['status' => [0, 1]];

    use ControllerTrait;


    //查询条件前置处理
    public function beforeIndex()
    {
        //搜索参数
        $identification      = input('identification', '', 'trim');
        $where = true;        
        if ($identification != '') {
            $where .= " and identification = " . $identification;
        }
        return [$where, []];
    }

    /**
     * 获取页面信息
     * @Route("getPageInfo", method="GET")
     */
    public function getPageInfo() {
        $identification = input('identification');

        $data = [
            "components" => [],
            "pageInfo" => 0
        ];
        return json_ok($data);
    }

    
}
