<?php
declare (strict_types=1);
namespace app\service;

use app\service\Visual\VisualSqlService;
use app\traits\ServiceTrait;

/**
 * 可视化
 * Class VisualService
 */
class VisualService
{
    //仓库，带命名空间
    public static $repository = 'app\repository\VisualRepository';

    use ServiceTrait;

    /**
     * 获取图表数据
     */
    public static function getComResultData($queryInput) {                
        $metaData = [];
        if ($queryInput->getDataWay == 'sql'){
            //sql原生获取数据
            $metaData = VisualSqlService::getData($queryInput);
        } else {
            //模型配置获取数据（未实现）

        }
        $data = [
            'dataRes'=> [
                "list"=>$metaData
            ],
            'dt'=> [],
            'metadata' => $metaData
        ];
        return $data;
    }


}
