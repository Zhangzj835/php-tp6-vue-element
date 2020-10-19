<?php
declare (strict_types=1);
namespace app\repository;

use app\traits\RepositoryTrait;

/**
 * 文章分类
 * Class VisualRepository
 */
class VisualRepository
{
    //模型，带命名空间
    public static $model = 'app\model\VisualReportPage';
    //模型主键
    public static $pk = 'id';
    //name字段名称
    public static $name = 'page_name';

    use RepositoryTrait;

}
