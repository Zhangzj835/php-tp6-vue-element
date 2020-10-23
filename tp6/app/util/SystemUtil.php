<?php

declare(strict_types=1);

namespace app\util;

/**
 * 数据处理
 * Class SystemUtil
 * @package app\util
 */
class SystemUtil
{

    /**
     * 组装url地址
     */
    public static function composeUrl($url = '')
    {
        if (empty($url)) {
            $url = config('system.default_img');
        }
        $web_site = config('system.web_site');
        $temp = substr($url, 0, 4);
        if ($temp != 'http') {
            $url = $web_site . $url;
        }
        return $url;
    }

    /**
     * 从字符串中匹配出${xxx}变量
     */
    public static function getVariablesByStr($str)
    {
        $pattern = '/\$\{([^\}]+)\}/i';
        preg_match_all($pattern, $str, $matchRes);
        $variables = [];
        $labels = [];
        if ($matchRes[1]) {
            foreach ($matchRes[1] as $item) {
                $arr = explode('||', $item);
                if (!in_array($arr[0], $labels)) {
                    $obj = [];
                    $obj['label'] = $arr[0];
                    $obj['variable'] = $item;
                    foreach ($arr as $k => $v) {
                        if ($k != 0) {
                            $pos = strpos($v, '=');
                            $key = substr($v, 0, $pos);
                            $value = substr($v, $pos + 1);
                            $obj[$key] = $value;
                        }
                    }
                    $labels[] = $arr[0];
                    $variables[] = $obj;
                }
            }
        }
        return  $variables;
    }
}
