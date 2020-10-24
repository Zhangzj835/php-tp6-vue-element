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
    public static function getData($queryInput, $isGetAll = false, $componentType = 'tab')
    {
        // 变量参数替换
        $sqls = self::getSqlByStr($queryInput);
        $runSql = $isGetAll ? $sqls['originSql'] : $sqls['sql'];
        // 获取数据源配置        
        $config = self::getConfigBySourceId($queryInput['sqlDatasourceId']);
        // 根据sql获取数据集
        $data = [];
        $total = 0;
        if ($config['source_type'] == 'mysql') {
            Mysql::query($runSql, $data, $config['source_config']);
            //分页获取总条数
            if (!empty($sqls['totalSql'])) {
                Mysql::query($sqls['totalSql'], $totalData, $config['source_config']);
                $total = !empty($totalData[0]) ? (int)($totalData[0]['total']) : 0;
            }
        } elseif ($config['source_type'] == 'kylin') {
        } elseif ($config['source_type'] == 'impala') {
        }

        //图表数据整理(有空移到前端来处理)
        $echartData = self::assembleEchartOption($data, $total, $componentType);

        $res = [
            'metadata' => $data,
            'dataRes' => $echartData,
            'dt' => []
        ];
        return $res;
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
        //可变参数替换
        $searchItems = $queryInput['searchItems'] ?: [];
        //分页参数        
        $pagination = [
            "enable" => false,
            "pageNumber" => 1,
            "pageSize" => 5
        ];
        foreach ($matchArr as $value) {
            $flag = true;
            foreach ($searchItems as $v) {
                if ($v['label'] == $value['label']) {
                    if ($v['label'] == '分页') {
                        $sql = self::sqlReplace($sql, $value['variable'], '', false);
                        $pagination['enable'] = true;
                        $pagination['pageNumber'] = !empty($v['value']) ? $v['value'] : $pagination['pageNumber'];
                        $pagination['pageSize'] = !empty($value['pageSize']) ? $value['pageSize'] : $pagination['pageSize'];
                    }
                    $flag = false;
                }
            }
            if ($flag) {
                $sql = self::sqlReplace($sql, $value['variable'], '', false);
            }
        }
        //筛选参数替换
        foreach ($matchArr as $value) {
            foreach ($searchItems as $item) {
                if ($item['label'] == $value['label']) {
                    $value['columnType'] = !empty($value['columnType']) ? $value['columnType'] : '';
                    if ($item['value']) {
                        //组件内查询配置
                        $sql = self::sqlReplace($sql, $value['variable'], $item['value'], true, $value['columnType']);
                    } else if (empty($item['value']) && !empty($value['filterDate']) && $value['filterDate'] == 'start' && !empty($filterDate[0])) {
                        //页面时间控件
                        $sql = self::sqlReplace($sql, $value['variable'], date('Ymd', $filterDate[0]), true, $value['columnType']);
                    } else if (!$item['value'] && !empty($value['filterDate']) && $value['filterDate'] == 'end' && !empty($filterDate[1])) {
                        //页面时间控件
                        $sql = self::sqlReplace($sql, $value['variable'], date('Ymd', $filterDate[1]), true, $value['columnType']);
                    } else if (!empty($value['default'])) {
                        //sql内默认配置
                        $sql = self::sqlReplace($sql, $value['variable'], $value['default'], true, $value['columnType']);
                    } else if (TimeUtil::getValueByZh($item['label'])) {
                        //固定参数替换配置
                        $temp = TimeUtil::getValueByZh($item['label']);
                        $sql = self::sqlReplace($sql, $value['variable'], $temp, true, $value['columnType']);
                    } else {
                        $sql = self::sqlReplace($sql, $value['variable'], $item['value'], true, $value['columnType']);
                    }
                }
            }
        }
        //排序
        if (!empty($queryInput['sortConfig']) && !empty($queryInput['sortConfig']['sortField'])) {
            $sql = 'select * from (' . $sql . ') as tabA order by ' . $queryInput['sortConfig']['sortField'] . ' ' . $queryInput['sortConfig']['sort'];
        }
        //分页
        $totalSql = ''; //获取分页前总数sql
        $originSql = $sql; //分页前的sql
        if ($pagination['enable']) {
            $config = self::getConfigBySourceId($queryInput['sqlDatasourceId']);
            if ($config['source_config']) {
                $totalSql = 'select count(1) as total from (' . $sql . ') as tabPage';
                $sql = 'select * from (' . $sql . ') as tabPage limit ' . ($pagination['pageNumber'] - 1) * $pagination['pageSize'] . ',' . $pagination['pageSize'];
            }
        }

        // 检查sql是否含有特殊字符（防止增删改数据）
        self::checkSql($sql);

        $res = [
            'sql' => $sql,
            'totalSql' => $totalSql,
            'originSql' => $originSql
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
    private static function getFilterDate($filters)
    {
        $filter_date = [];
        foreach ($filters as $item) {
            if ($item['speRequire'] == 'dt') {
                $filter_date = TimeUtil::getRadioDate($item['conValue']);
                if (count($filter_date) == 0) {
                    $filter_date = explode(',', $item['conValue']);
                }
            }
        }
        return $filter_date;
    }

    /**
     * 可变参数替换
     */
    private static function sqlReplace($sql, $key, $value, $isAbstract = true, $columnType = '')
    {
        $key = '${' . $key . '}';
        if (!$isAbstract) {
            //直接替换
            $sql = str_replace($key, $value, $sql);
        } else {

            if ($columnType == 'string') {
                $sql = str_replace($key, $value, $sql);
            } else if ($columnType == 'number') {
                $sql = str_replace($key, $value ?: 0, $sql);
            } else {
                //字符串替换                
                $sql = str_replace('\'' . $key . '\'', '\'' . $value . '\'', $sql);
                //数值替换
                $sql = str_replace($key, $value ?: 0, $sql);
            }
        }
        return $sql;
    }

    /**
     * 根据数据源id获取数据源配置
     */
    private static function getConfigBySourceId($sourceId)
    {
        //获取数据源配置
        $config = VisualDataSource::where('id', $sourceId)->find()->toArray();
        if (!$config) {
            return [];
        }
        $config['source_config'] = json_decode($config['source_config'], true);
        return $config;
    }

    private static function assembleEchartOption($data, $total = 0, $type)
    {
        if (empty($data)) {
            return $data;
        }
        $dataRes = [];
        //配置各个组件的输出格式
        if ($type == 'line' || $type == 'bar') { //折线图&柱状图
            $dataRes['data'] = [];
            $dataRes['legends'] = [];
            $dataRes['xAxis'] = [];
            //指标类型
            $colKey = 0;
            foreach ($data[0] as $key => $value) {
                if ($colKey != 0) {
                    $dataRes['legends'][] = $key;
                    $arr = [];
                    $arr['barWidth'] = 30;
                    $arr['data'] = [];
                    $arr['name'] = $key;
                    $arr['smooth'] = false;
                    $arr['type'] = $type;
                    $arr['yAxisIndex'] = 0;
                    $dataRes['data'][] = $arr;
                }
                $colKey++;
            }
            //横坐标及数据            
            foreach ($data as $item) {
                $colKey = 0;
                foreach ($item as $value) {
                    if ($colKey == 0) {
                        $dataRes['xAxis'][] = $value;
                    } else {
                        $i = $colKey - 1;
                        $dataRes['data'][$i]['data'][] = $value;
                    }
                    $colKey++;
                }
            }
        } else if ($type == 'mix') {            //组合图                        
            $dataRes['data'] = [];
            $dataRes['legends'] = [];
            $dataRes['xAxis'] = [];
            $colKey = 0;
            foreach ($data[0] as $key => $value) {
                if ($colKey == 1) {
                    $dataRes['legends'][] = $key;
                    $arr = [];
                    $arr['barWidth'] = 30;
                    $arr['data'] = [];
                    $arr['name'] = $key;
                    $arr['smooth'] = false;
                    $arr['type'] = 'line';
                    $arr['yAxisIndex'] = 0;
                    $dataRes['data'][] = $arr;
                }
                if ($colKey == 2) {
                    $dataRes['legends'][] = $key;
                    $arr = [];
                    $arr['barWidth'] = 30;
                    $arr['data'] = [];
                    $arr['name'] = $key;
                    $arr['smooth'] = false;
                    $arr['type'] = 'bar';
                    $arr['yAxisIndex'] = 0;
                    $dataRes['data'][] = $arr;
                }
                $colKey++;
            }
            //横坐标及数据
            foreach ($data as $item) {
                $colKey = 0;
                foreach ($item as $value) {
                    if ($colKey == 0) {
                        $dataRes['xAxis'][] = $value;
                    } else if ($colKey == 1) {
                        $dataRes['data'][0]['data'][] = $value;
                    } else if ($colKey == 2) {
                        $dataRes['data'][1]['data'][] = $value;
                    }
                    $colKey++;
                }
            }
        } else if ($type == 'pie') {            //饼状图
            $dataRes['data'] = [];
            $dataRes['xAxis'] = [];
            foreach ($data as $item) {
                $arr = [
                    'name' => '',
                    'value' => 0
                ];
                $colKey = 0;
                foreach ($item as $key => $value) {
                    if ($colKey == 0) {
                        $arr['name'] = $value;
                    } else if ($colKey == 1) {
                        $arr['value'] = (float)$value;
                    }
                    $colKey++;
                }
                $dataRes['data'][] = $arr;
            }
        } else if ($type == 'index' || $type == 'funnel') {          //指标图&漏斗图
            $dataRes['data'] = [];
            $dataRes['xAxis'] = [];
            foreach ($data as $item) {
                $arr = [
                    'name' => '',
                    'value' => 0,
                    'label' => ''
                ];
                $colKey = 0;
                foreach ($item as $key => $value) {
                    if ($colKey == 0) {
                        $arr['name'] = $value;
                    } else if ($colKey == 1) {
                        $arr['value'] = (float)$value;
                        $arr['label'] = $key;
                    }
                    $colKey++;
                }
                $dataRes['data'][] = $arr;
            }
        } else if ($type == 'tab') {
            $dataRes['list'] = empty($data) ? [] : $data;
            $dataRes['total'] = $total;
        } else {
            $dataRes = $data;
        }

        return $dataRes;
    }
}
