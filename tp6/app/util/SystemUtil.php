<?php
declare (strict_types=1);
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
    public static function composeUrl($url='') {                
        if (empty($url)) {
            $url = config('system.default_img');
        }           
        $web_site = config('system.web_site');
        $temp = substr($url, 0, 4);         
        if ($temp != 'http') {
            $url = $web_site.$url;
        }        
        return $url;
    }

    /**
     * 从字符串中匹配出${xxx}变量
     */
    public static function getVariablesByStr($str) {
        // $pattern = "/\$\{([^\}]+)\}/gi";
        $pattern = '/{(.*)}/';
        preg_match($pattern , $str, $matchRes);
        dump($str);
        dump($matchRes);
        exit;
        // let matchRes = str.match(reg)
        $variables = [];
        $labels = [];
        // if (matchRes) {		
        // matchRes.map(item=> {
        //     item = item.replace('${', '')
        //     item = item.replace('}', '')
        //     let arr = item.split('||')
        //     if (labels.indexOf(arr[0]) < 0) {
        //     let obj = {}
        //     obj.label = arr[0]
        //     obj.variable = item
        //     for (let i in arr) {
        //         if (i != 0) {              
        //         let pos = arr[i].indexOf('=')
        //         let key = arr[i].substr(0, pos)
        //         let value = arr[i].substr(pos+1)
        //         obj[key] = value
        //         }
        //     }
        //     labels.push(obj.label)
        //     variables.push(obj)
        //     }
        // })
        // }		
        return  variables;
    }

}