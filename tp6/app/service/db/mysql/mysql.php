<?php

declare(static_types=1);

namespace app\service\db\mysql;

use think\DbManager;

class Mysql
{

    /**
     * 根据sql获取数据
     */
    public static function query($sql, &$data, $config=[])
    {
        //实例化数据获取数据源
        $db = new DbManager();
        //配置连接数据库参数
        if ($config) {            
            $database=config('database');
            $database['connections']['mysql']['hostname']= $config['host'];
            $database['connections']['mysql']['hostport']= $config['port'];
            $database['connections']['mysql']['username']= $config['user'];
            $database['connections']['mysql']['password']= $config['password'];
            $database['connections']['mysql']['database']= $config['database'];                        
            $db->setConfig($database);
        }        
        //获取数据
        $data = $db->query($sql);

        return $data;
    }

    
}
