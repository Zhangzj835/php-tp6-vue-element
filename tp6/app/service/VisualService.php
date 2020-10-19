<?php
declare (strict_types=1);
namespace app\service;

use app\traits\ServiceTrait;

/**
 * 文章分类
 * Class VisualService
 */
class VisualService
{
    //仓库，带命名空间
    public static $repository = 'app\repository\VisualRepository';

    use ServiceTrait;

}
