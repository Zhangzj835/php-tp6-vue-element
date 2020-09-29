<?php
declare (strict_types=1);

namespace app\controller\admin;

use app\traits\ControllerTrait;
use think\annotation\route\Middleware;
use think\annotation\route\Group;
use think\annotation\Route;

/**
 * 控制器测试
 * @Group("admin/test")
 */
class Test
{

    use ControllerTrait;

    //index前置方法
    public function beforeIndex() {
        echo "this is beforeIndex";
    }

    /**
     * 方法测试
     * @Route("test", method="GET")
     */
    public function test() {
        return "this is test!";
    }
}
