<template>
  <div class="container">
    <div class="container-box">
      <div class="mb-10">
        <el-button type="primary" size="small" @click="editModelDialogVisible=true">编辑文件夹名称</el-button>
        <el-button type="primary" size="small" @click="dashboardMaking(null)">新建报表</el-button>
        <el-button type="danger" size="small" @click="closeFolder">删除文件夹</el-button>
      </div>

      <el-table border :data="tableData" style="width: 100%">
        <el-table-column
          v-for="(item,index) in tableColumns"
          :key="index"
          :prop="item.prop"
          :label="item.label"
        >
          <template slot-scope="scope">
            <div v-if="item.prop!=='status'">{{scope.row[item.prop]}}</div>
            <div v-else-if="item.prop=='status'">
              <el-switch v-model="scope.row[item.prop]" @change="statusChange(scope.row)"></el-switch>
            </div>
          </template>
        </el-table-column>
        <el-table-column fixed="right" label="操作" width="300">
          <template slot-scope="scope">
            <el-button v-if="scope.row['status']==1" @click="handleClick(scope.row)" size="small">查看</el-button>
            <el-button size="small" @click="dashboardMaking(scope.row)">编辑</el-button>
            <el-button size="small" @click="dashboardMoving(scope.row)">移动</el-button>
            <el-button size="small" @click="delDashboard(scope.row.id,scope.row.rpt_menu_id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <el-dialog
      title="编辑文件夹名称"
      :visible.sync="editModelDialogVisible"
      width="30%"
      :before-close="handleClose"
    >
      <span>
        <el-input v-model="folderName" placeholder="请输入文件夹名称" maxlength="6"></el-input>
      </span>
      <span slot="footer" class="dialog-footer">
        <el-button @click="editModelDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editModelSubmit">确 定</el-button>
      </span>
    </el-dialog>

    <el-dialog :title=" '“' + moveForm.page_name +'” 移动到：'" :visible.sync="movePagedialogVisible" width="30%">
			
        <el-form ref="form" :model="moveForm">
          <el-form-item label="文件夹">
            <el-select v-model="moveForm.folderId" placeholder="请选择文件夹">
              <el-option 
                v-for="(item, index) in menuTree"
                :key="index"
                :label="item.label" 
                :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-form>
      
      <span slot="footer" class="dialog-footer">
        <el-button @click="movePagedialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="movePage">确 定</el-button>
      </span>
		</el-dialog>
    
  </div>
</template>

<script>
import {
  dashManagerMenuTree,
  getMenuChildren,
  setDashBoardStatus,
  delDashboard,
  updateFolderName,
  deleteFolder,
  updatePageToFolder,
} from "@/api/web";
export default {
  name: "dashboardManager",
  data() {
    return {
      folderName: "",
      //编辑文件夹弹框
      editModelDialogVisible: false,
      //移动报表弹框
      movePagedialogVisible: false,
      pageId: "",
      tableColumns: [
        {
          label: "报表名称",
          prop: "page_name",
        },
        {
          label: "创建人",
          prop: "user_name",
        },
        {
          label: "最近修改时间",
          prop: "update_time",
        },
        {
          label: "是否发布",
          prop: "status",
        },
      ],
      tableData: [],
      //菜单目录
      menuTree: [],
      //移动文件表单
      moveForm: {
        folderId: 0,        //需要移动到的菜单id
        page_name: '',    //页面名称
        id: 0,            //页面id
        parent_id: ''     //页面父级菜单id
      }
    };
  },
  watch: {
    $route() {
      this.init();
    },
  },
  mounted() {    
    this.init();
  },
  methods: {
    init() {
      console.log("this.$route", this.$route);
      if (localStorage.getItem('is_reload_page') == 1) {
        localStorage.setItem('is_reload_page', 0);
        window.location.reload();
      }
      this.folderName = this.$route.meta.title;
      this.pageId = this.$route.name;
      this.moveForm.folderId = parseInt(this.pageId);
      this.getMenuChildren();
      this.getMenuTree();
    },
    closeFolder() {
      if (this.tableData.length) {
        return this.$message({
          message: "请先删除该文件夹下所有仪表板",
          type: "warning",
        });
      }      
      this.$confirm("此操作将永久删除该文件夹, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          try {
            deleteFolder({
              pageId: this.pageId,
            }).then((res) => {
              let that = this;
              this.$message({
                message: "删除成功",
                type: "success",
                onClose(){
                  // window.location.reload();
                  localStorage.setItem('is_reload_page', 1);
                  that.$router.push('/dashboardManager/index')
                }
              });
            });
          } catch (error) {}
        })
        .catch(() => {
          this.$message({
            type: "info",
            message: "已取消删除",
          });
        });
    },
    editModelSubmit() {
      if (this.folderName == "") {
        return this.$message({
          message: "报表名称不能为空",
          type: "warning",
        });
      }
      try {
        updateFolderName({
          pageId: this.pageId,
          name: this.folderName,
        }).then((res) => {
          this.$message({
            message: "修改成功",
            type: "success",
            onClose() {
              window.location.reload();
            },
          });
        });
      } catch (error) {}
    },
    handleClose() {
      this.editModelDialogVisible = false;
    },
    delDashboard(menu_id, rpt_menu_id) {
      this.$confirm("此操作将永久删除该页面, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          try {
            delDashboard({
              menu_id,
              rpt_menu_id,
            }).then((res) => {
              this.$message({
                type: "success",
                message:
                  res.data.affectedRows === 1 ? "删除成功!" : "删除失败!",
              });
              this.getMenuChildren();
            });
          } catch (error) {}
        })
        .catch(() => {
          // this.$message({
          //   type: 'info',
          //   message: '已取消删除'
          // });
        });
    },
    dashboardMaking(row) {
      let params = row
        ? (params = {
            parent_id: this.pageId,
            menu_id: row.id,
            status: row.status,
          })
        : (params = {
            parent_id: this.pageId,
          });
      this.$router.push({
        path: "/dashboardManager/dashboardMaking",
        query: params,
      });
    },

    /**
     * 移动报表
     */
    dashboardMoving(row) {
      this.moveForm.page_name = row.page_name;
      this.moveForm.id = row.id;
      this.moveForm.parent_id = row.parent_id;
      this.movePagedialogVisible = true;
    },

    /**
     * 修改报表所属文件夹
     */
    movePage() {
      try {        
        updatePageToFolder(this.moveForm).then((res)=> {
          if (res.code == 200) {
            this.$message({
              message: '修改成功',
              type: "success",
              onClose() {
                window.location.reload();
              }
            });
          } else {
            this.$message({
              message: res.message,
              type: "error",
            });
          }
        })
      }catch(error) {}
    },

    getMenuChildren() {
      try {
        getMenuChildren({
          parent_id: this.pageId,
        }).then((res) => {
          res.data.map((item) => {
            item.status = item.status == 0 ? false : true;
          });
          this.tableData = res.data;
        });
      } catch (error) {}
    },
    
    /**
     * 获取星盘报表目录结构
     */
    getMenuTree() {
      try {
        let userInfo = JSON.parse(localStorage.getItem('userInfo'));
        dashManagerMenuTree({
          userId:userInfo.id
        }).then(res => {
          if (res.code == 200) {            
            this.menuTree = [];
            res.data.map(item=> {
              let arr = {}
              arr.label = item.meta.title;
              arr.value = parseInt(item.id);
              this.menuTree.push(arr);
            })
          }          
        })
      } catch(error) {}
    },

    handleClick(row) {
      console.log(row);
      this.$router.push({
        path: `/dashboard/${row.parent_id}/${row.rpt_menu_id}`,
      });
    },
    statusChange(row) {
      try {
        setDashBoardStatus({
          id: row.id,
          status: row.status ? 1 : 0,
        }).then((res) => {
          this.$message({
            message: "修改发布状态成功",
            type: "success",
          });
          this.getMenuChildren();
        });
      } catch (error) {}
    },
  },
};
</script>

<style lang="scss">
.el-radio-group {
  margin-right: 20px;
}
.el-form-item__content{
  position: static;
}
</style>

