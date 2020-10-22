<?php

declare(strict_types=1);

namespace app\util;

/**
 * 数据处理
 * Class TimeUtil
 * @package app\util
 */
class TimeUtil
{

    /**
     * 获取当前日期
     */
    public function getCurrentDate()
    {
        return '';
    }

    /**
     * 根据中文返回日期数组
     */
    public static function getRadioDate($radio)
    {
        $res = [];
        switch ($radio) {
            case '今日':
                $res = [self::getDateByDay(0) . " 00:00:00", self::getDateByDay(0) . " 23:59:59"];
                break;
            case '昨日':
                $res = [self::getDateByDay(-1) . " 00:00:00", self::getDateByDay(-1) . " 23:59:59"];
                break;
            case '近两日(含今日)':
                $res = [self::getDateByDay(1) . " 00:00:00", self::getDateByDay(0) . " 23:59:59"];
                break;
            case '近3天':
                $res = [self::getDateByDay(-3) . " 00:00:00", self::getDateByDay(-1) . " 23:59:59"];
                break;
            case '近7天':
                $res = [self::getDateByDay(-7) . " 00:00:00", self::getDateByDay(-1) . " 23:59:59"];
                break;
            case '近10天':
                $res = [self::getDateByDay(-10) . " 00:00:00", self::getDateByDay(-1) . " 23:59:59"];
                break;
            case '近14天':
                $res = [self::getDateByDay(-14) . " 00:00:00", self::getDateByDay(-1) . " 23:59:59"];
                break;
            case '近30天':
                $res = [self::getDateByDay(-30) . " 00:00:00", self::getDateByDay(-1) . " 23:59:59"];
                break;
            case '近140天':
                $res = [self::getDateByDay(-140) . " 00:00:00", self::getDateByDay(-1) . " 23:59:59"];
                break;
            case '近180天':
                $res = [self::getDateByDay(-180) . " 00:00:00", self::getDateByDay(-1) . " 23:59:59"];
                break;
            case '本周':
                $res = self::getDateByWeek(0);
                break;
            case '本月':
                $res = self::getDateByMonth(0);
                break;
            case '上一周':
                $res = self::getDateByWeek(-1);
                break;
            case '下一周':
                $res = self::getDateByWeek(1);
                break;
            case '上一个月':
                $res = self::getDateByWeek(-1);
                break;
            default:
                break;
        }
        return $res;
    }

    /**
     * 获取前几天的数据
     */
    public static function getDateByDay($day = 0)
    {
        $day = ($day >= 0) ? "+" . $day : $day;
        $date = date("Y-m-d", strtotime($day . " day"));
        return $date;
    }

    /**
     * 获取某一周的第一天和最后一天日期
     */
    public static function getDateByWeek($week = 0)
    {
        $w = date("w");
        if ($w == 1) {
            $week >= 0 ? $week++ : $week;
        } else {
            $week <= 0 ? $week-- : $week;
        }
        $weekMonday = $week >= 0 ? "+" . $week : $week;
        $first = date('Y-m-d 00:00:00', strtotime($weekMonday . ' Monday'));
        $last = date('Y-m-d 23:59:59', (strtotime($first) + 3600 * 24 * 6));
        return [$first, $last];
    }

    /**
     * 获取某一月的第一天和最后一天日期
     */
    public static function getDateByMonth($month = 0)
    {
        $first = '';
        $last = '';
        if ($month == 0) {
            $first = date('Y-m-01 00:00:00', strtotime(date("Y-m-d")));
            $last = date('Y-m-d 23:59:59', strtotime("$first +1 month -1 day"));
        } else {
            $first = date('Y-m-01 00:00:00', strtotime($month . ' month'));
            $last = date('Y-m-t 23:59:59', strtotime($month . ' month'));
        }
        return [$first, $last];
    }
}
