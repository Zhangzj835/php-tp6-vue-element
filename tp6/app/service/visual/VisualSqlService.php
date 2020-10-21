<?php

declare(static_types=1);

namespace app\service\visual;

class VisualSqlService
{

    /**
     * 根据sql获取
     */
    public static function getData($queryInput, $isGetAll = false)
    {

        dump($sql);
        // 变量参数替换
        $sqls = self::getSqlByStr($queryInput);
        $runSql = $isGetAll ? $sqls['originSql'] : $sqls['sql'];
        
        $data = [
            ["teacher" => "隆宇枭", "淘宝有效gmv" => "3074227826"]
        ];
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
