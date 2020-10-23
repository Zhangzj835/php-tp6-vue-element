<?php
declare (strict_types=1);
namespace app\service;

use app\model\VisualReportPage;
use app\model\VisualReportPageComponents;
use app\service\Visual\VisualSqlService;
use app\traits\ServiceTrait;
use think\Db;

/**
 * 可视化
 * Class VisualService
 */
class VisualService
{
    //仓库，带命名空间
    public static $repository = 'app\repository\VisualRepository';

    use ServiceTrait;

    /**
     * 获取图表数据
     */
    public static function getComResultData($queryInput) {                
        $metaData = [];
        if ($queryInput['getDataWay'] == 'sql'){
            //sql原生获取数据
            $metaData = VisualSqlService::getData($queryInput);
        } else {
            //模型配置获取数据（未实现）

        }
        $data = [
            'dataRes'=> [
                "list"=>$metaData['list'],
                "total"=>$metaData['total']
            ],
            'dt'=> [],
            'metadata' => $metaData
        ];
        return $data;
    }

    /**
     * 保存/添加报表配置
     */
    public static function saveDashboardMaking($id, $components)
    {
        if (empty($id)) {
            return false;
        }
        $info = VisualReportPage::where('identification', $id)->select()->toArray();
        $reportPageId = 0;
        if (empty($info)) {
            //插入数据
            $insertData = [
                'identification'=>$id
            ];
            $insertRes = VisualReportPage::create($insertData);
            $reportPageId = $insertRes->id; //获取自增id
        } else {
            //删除组件数据
            VisualReportPageComponents::where('report_page_id', $info[0]['id'])->delete();
            $reportPageId = $info[0]['id'];
        }

        //插入图表组件
        if($reportPageId) {
            $insertComponents = [];
            foreach ($components as $value) {
                $arr = [];
                $arr['report_page_id'] = $reportPageId;
                $arr['component_type'] = empty($value['component_type'])?'':$value['component_type'];
                $arr['component_model'] = empty($value['component_model'])?'':$value['component_model'];
                $arr['layout_info'] = empty($value['layout_info'])?'':$value['layout_info'];
                $arr['query_input'] = empty($value['query_input'])?'':$value['query_input'];
                $arr['name'] = empty($value['name'])?'':$value['name'];
                $arr['data_source'] = empty($value['data_source'])?'':$value['data_source'];                    
                $insertComponents[] = $arr;
            }
            if ($insertComponents) {                
                $visualReportPageComponentsModel = new VisualReportPageComponents();
                $res = $visualReportPageComponentsModel->saveAll($insertComponents);                                
            }
        } 
        $res = [
            'page_id' => $id
        ];
        return $res;
    }
}
