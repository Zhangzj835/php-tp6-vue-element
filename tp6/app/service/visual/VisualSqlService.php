<?php

declare(static_types=1);

namespace app\service\visual;

use app\model\VisualDataSource;
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
        // $sqls = self::getSqlByStr($queryInput);
        // $runSql = $isGetAll ? $sqls['originSql'] : $sqls['sql'];
        // 获取数据源配置        
        $config = VisualDataSource::where('id', $queryInput['sqlDatasourceId'])->find()->toArray();                
        if (!$config['source_config']) {
            return [];
        }
        $sourceConfig = json_decode($config['source_config']);
        // 根据sql获取数据集
        $data = [
            ["teacher" => "隆宇枭", "淘宝有效gmv" => "3074227826"]
        ];
        $total = 0; 
        if ($config['source_type'] == 'mysql') {            
            $conf = [
                'type'              => 'mysqli',                
                'hostname'          => '127.0.0.1',
                'database'          => 'phpcmsv9',
                'username'          => 'root',
                'password'          => 'root',
                'hostport'          => '3306'
            ];  
            $config=config('database');
            $config['connections']['mysql']['hostname']=$conf['hostname'];
            $config['connections']['mysql']['hostport']=$conf['hostport'];
            $config['connections']['mysql']['username']=$conf['username'];
            $config['connections']['mysql']['password']=$conf['password'];
            $config['connections']['mysql']['database']=$conf['database']; 
            config($config, 'database');            
            $db = new DbManager();
            $db->setConfig($config);
            $data = $db->query("SELECT * FROM v9_collection_content limit 10");
            
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
        $sql = '';
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
    private static function checkSql($runSql)
    {

    }
}
