<?php

declare(strict_types=1);

namespace app\controller\admin;

use app\controller\admin\Base;
use app\traits\ControllerTrait;
use think\annotation\route\Middleware;
use think\annotation\route\Group;
use think\annotation\Route;
use app\middleware\CheckAdmin;
use app\model\VisualDataModel;
use app\model\VisualDataModelColumn;
use app\model\VisualDataSource;
use app\model\VisualReportPage;
use app\model\VisualReportPageComponents;
use app\service\VisualService;

/**
 * 报表管理
 * Class Visual
 * @package app\controller\admin
 * @Group("admin/visual")
 * 
 */
class Visual extends Base
{
    /**
     * 获取页面信息
     * @Route("getPageInfo", method="GET")
     */
    public function getPageInfo()
    {
        $identification = input('identification');
        $pageInfo = VisualReportPage::where('identification', $identification)->select()->toArray();
        if ($pageInfo) {
            $components = VisualReportPageComponents::where('report_page_id', $pageInfo[0]['id'])->select()->toArray();
        }
        $data = [
            'components' => empty($components) ? [] : $components,
            'pageInfo' => empty($pageInfo) ? [] : $pageInfo
        ];
        return json_ok($data);
    }

    /**
     * 获取所有模型
     * @route("getDataModels", method="get")
     */
    public function getDataModels()
    {
        $models = VisualDataModel::where(1)->select()->toArray();
        $data = [
            'list' => $models
        ];
        return json_ok($data);
    }

    /**
     * 获取模型字段
     * @route("getDataModelColumn", method="get")
     */
    public function getDataModelColumn()
    {
        $modelId = input('model_id');
        $columns = VisualDataModelColumn::where('model_id', $modelId)->select()->toArray();
        $data = [
            'list' => $columns
        ];
        return json_ok($data);
    }

    /**
     * 获取数据源列表
     * @route("getDataSources", method="get")
     */
    public function getDataSources()
    {
        $sources = VisualDataSource::where(1)->select()->toArray();
        $data = [
            'list' => $sources
        ];
        return json_ok($data);
    }

    /**
     * 获取图表数据
     * @route("getComResultData", method="post")
     */
    public function getComResultData()
    {
        $queryInput = json_decode(input('queryInput'), true);
        $data = VisualService::getComResultData($queryInput);
        return json_ok($data);
    }

    /**
     * 保存/添加报表配置
     * @route("saveDashboardMaking", method="post")
     */
    public function saveDashboardMaking()
    {
        $id = input('id');
        $components = input('components');
        $data = VisualService::saveDashboardMaking($id, $components);
        return json_ok($data);
    }
}
