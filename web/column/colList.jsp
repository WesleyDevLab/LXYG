<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
$(function(){  
loadData(); 
}); 

function delType(obj){
if(confirm("确定要删除产品类型嘛？这样做或许会出现重大错误")){
     var v=obj.val();
	 $.post("${path}/goods/delProductType",{"typeId":v},function(result){
	      if(result.code==10010){
	         obj.parent().parent().remove();
	         
	         alert(result.message);
	      }else{
	         alert(result.message);
	      }
	   });
	}
}

function loadData(){
    var type="";
    $("#type_list").html(type);
    $.get("${path}/goods/loadGoodsAttribute",function(result){
      if(result.code==10010){
        for(var i=0;i<result.type.length;i++){
           type+="<tr><td>"+result.type[i].id+"</td><td class='center'>"+result.type[i].name+"</td><td class='center'>"+result.type[i].create_time+"</td><td class='center'>"+
           "<button type='button' class='btn btn-primary' onclick='JavaScript:update('${draw.drawid}');'>修改</button>"+
		"<button type='button' class='btn'  onclick='delType($(this))' value='"+result.type[i].id+"'>删除</button></td></tr>";
       }
       $("#type_list").append(type);
      }
   }); 

}
</script>
</head>
<%@ include file="../common/top.jsp"%>
<body >
	 <!-- start: Content -->
            <div id="content" class="span10">
                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2>
	                            <i class="icon-align-justify"></i>
	                            <span class="break">产品类型管理</span>
                            </h2>
                            <div class="box-icon">
                                <a href="${path}/pageTo/addProductType" class="btn-add">
                                	<i class="icon-edit" style="width:60px;">添加</i>
                                </a>
                            </div>
                        </div>
                        <div class="box-content">
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>类别名</th>
                                        <th>创建时间</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody id="type_list">
                                  
                                </tbody>
                            </table>
                            <div class="pagination pagination-centered">
                                  <div class="bg">
									<div class="r_page">
										<script type="text/javascript">
											var url = location.href;
											var pageOne = new PageObject(url, '${pg}', '${pageBean.totalPage}', '${pageBean.totalRow}', 'pageOne');
										</script>
									</div>
									<div class="clear"></div>
								</div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>
                <!--/row-->
            </div>
            <!-- end: Content -->

        </div>
        <!--/fluid-row-->
        <!--/row-->

    </div>
    <!--/fluid-row-->

    <div class="clearfix"></div>
    <footer>
        <p>
            <span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
        </p>
    </footer>
</body>
</html>

