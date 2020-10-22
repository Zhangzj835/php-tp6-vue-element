<?php

declare(static_types=1);

namespace app\service\visual;

use app\model\VisualDataSource;
use app\service\db\mysql\Mysql;
use app\util\SystemUtil;
use app\util\TimeUtil;
use think\facade\Db;
use think\DbManager;

class VisualSqlService
{

    /**
     * 根据sql获取
     */
    public static function getData($queryInput, $isGetAll = false)
    {
        // 变量参数替换
        $sqls = self::getSqlByStr($queryInput);
        $runSql = $isGetAll ? $sqls['originSql'] : $sqls['sql'];
        // 获取数据源配置        
        $config = VisualDataSource::where('id', $queryInput['sqlDatasourceId'])->find()->toArray();                
        if (!$config['source_config']) {
            return [];
        }
        $sourceConfig = json_decode($config['source_config'], true);
        // 根据sql获取数据集
        $data = [];
        $total = 0; 
        if ($config['source_type'] == 'mysql') {                  
            Mysql::query($runSql, $data, $sourceConfig);
            
        } elseif ($config['source_type'] == 'kylin') {
            
        } elseif ($config['source_type'] == 'impala') {
            
        }

        return $data;
    }

    /**
     * 获取可执行sql
     */
    private static function getSqlByStr($queryInput)
    {
        $sql = $queryInput['sqlString'];
        $filters = $queryInput['filters'];
        //过滤条件
        $filterDate = self::getFilterDate($filters);        
        //找出sql中的参数
        $matchArr = SystemUtil::getVariablesByStr($sql);
        // //可变参数替换
        // let searchItems = queryInput.searchItems? queryInput.searchItems: [];
        //分页参数        
        $pagination = [
            "enable"=> false,
            "pageNumber"=> 1,
            "pageSize"=> 5
        ];


        // 检查sql是否含有特殊字符（防止增删改数据）
        self::checkSql($sql);

        $res = [
            'sql' => $sql,
            'totalSql' => '',
            'originSql' => ''
        ];
        return $res;
    }

    /**
     * 检查sql中是否含有非法字符
     */
    private static function checkSql($Sql)
    {

    }

    /**
     * 获取过滤条件
     */
    private static function getFilterDate($filters) {
        $filter_date = [];    
        foreach ($filters as $item ) {
            if ($item['speRequire'] == 'dt') {                
                $filter_date = TimeUtil::getRadioDate($item['conValue']);                
                if (count($filter_date) == 0) {
                    $filter_date = explode(',', $item['conValue']);
                }
            }
        }          
        return $filter_date;
    }
}
