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


}