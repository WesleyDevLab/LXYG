<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
 

<!DOCTYPE HTML>
<html>
<head>  
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
//弹出窗
function alertJsp(text,url) {
	art.dialog.open(url,{
		lock:true,
		title: text,
		width: '800px',
		height:'500px',
		close:function () {
        location.href="${path}/role/list";
        return true;
    }
		
	});
}
function alertRes(text,url) {
	art.dialog.open(url,{
		lock:true,
		title: text,
		width: '800px',
		height:'500px'
	});
}

</script>
<script type="text/javascript">
function del(id){
	   if(confirm("确定要删除吗?")){
	            $.post("${path}/role/del",{"roleId":id},function(data){
	           	 if(data=="0"){
	                 alert("删除成功！");
	                 window.location.href="${path }/role/list";
	             }else if(data=="2"){
	           		 alert("和菜单有关联！");
	           	 }else if(data=="3"){
	                 alert("和用户有关联！");
	             }else if(data=="0"){
	            	 alert("删除失败！");
	             }
	          });
	      }
	    }
	/**
	 *添加角色时的限制
	 **/
	 function add(){
			roleName=$("#roleName").val().replace(/^\s+|\s+$/g,"");
			 if(""==roleName){
				  document.getElementById("spanErro").innerHTML = "请认真填写每一项";
				  $("#roleName").focus();
				  return;
			  }
			 $.post("${path }/service/role/add",{"name":roleName},function(data){
				 if(data==0){
					 alert("添加成功");
					 window.location.href="${path }/service/role/list";
					 return;
				 }else if(data==1){
					 alert("已有此角色");
					 return;
				 }
			 });
		} 
		
 
function update(roleId,roleName){
	$("#authorize").hide();
    $("#addRole").hide();
	$("#updateRole").show();
    $("#updateName").val(roleName);
    popDiv('popupdiv_tuodong','bar_blue');
    $("#updateButton").click(function (){
    	roleName=$("#updateName").val().replace(/^\s+|\s+$/g,"");
		 if(""==roleName){
			  alert("角色名不能为空!");
			  $("#updateName").focus();
			  return;
		  }
		 $.post("${path }/service/role/update",{"roleId":roleId,"name":roleName},function(data){
			 if(data=="1"){
				 alert("修改成功");
				 window.location.href="${path }/service/role/list";
				 return;
			 }else if(data=="0"){
				 alert("修改失败");
				 return;
			 }else if(data=="2"){
				 alert("已经有此角色！");
				 return;
			 }
		 });
    });
}
</script>
</head>
<%@ include file="../common/top.jsp"%>
<body onload="initRow()">  
	<!-- <div class="right_con">
		<div class="caozuo">
			 <input type="button" value="添加" onclick="alertJsp('添加角色','${path}/sys/addRole.jsp')" class="caozuo_input f_l" /> 
		</div>
		<div class="tab">
			<table border="0" cellpadding="3" cellspacing="1" width="100%">
				<thead>
					<tr>
						<th>角色名</th>
						<th>描述</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty pagBean.list}">
						<tr style="text-align: center;height: 30">
							<td colspan="2">
							<font style="font-size:16px;" color="red">暂无相关数据!</font>
							</td>
						</tr>
					</c:if>
					<c:forEach items="${pagBean.list}" var="role">
							<tr>
								<td>${role.name}</td>
								<td>${role.remark}</td>
								<td><a class="bj" href="javascript:del('${role.roleid }')">删除</a>/ 
								<a class="bj" href="JavaScript:alertJsp('角色修改','${path }/role/preEdit?roleId=${role.roleid	 }')">修改</a> / 
								<a class="bj" href="JavaScript:alertRes('授权','${path }/res/role_res?roleId=${role.roleid }')">授权</a>
					
								</td>
							</tr>
						</c:forEach>
					<tr>
						<td colspan="3">
							<div class="bg">
								
							 	<div class="r_page"> 
									<script type="text/javascript">
										var url = location.href;
										var pageOne = new PageObject(url,'${pg}','${pagBean.totalPage}','${pagBean.totalRow}','pageOne');
									</script>
								<div class="clear"></div>
								</div>
							</div> 
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div> -->
	
	 <!-- start: Content -->
            <div id="content" class="span10">

                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2><i class="icon-align-justify"></i><span class="break"></span>角色管理</h2>
                            <div class="box-icon">
                                <a href="javascript:void(0)" onclick="alertJsp('添加角色','${path}/sys/addRole.jsp')" class="btn-add">
                                	<i class="icon-edit" style="width:60px">添加</i>
                                </a>
                            </div>
                        </div>
                        <div class="box-content">
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>角色名</th>
										<th>描述</th>
										<th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                               <c:forEach items="${pagBean.list}" var="role">
                                    <tr>
                                        <td>${role.name}</td>
										<td>${role.remark}</td>
										<td>
											<a class="btn btn-primary"  href="javascript:del('${role.roleid }')">删除</a>
											<a class="btn btn-primary"  href="JavaScript:alertJsp('角色修改','${path }/role/preEdit?roleId=${role.roleid	 }')">修改</a> 
											<a class="btn btn-primary"  href="JavaScript:alertRes('授权','${path }/res/role_res?roleId=${role.roleid }')">授权</a>
										</td>
                                    </tr>
									</c:forEach>
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


    <!--/.fluid-container-->
</body>
</html>