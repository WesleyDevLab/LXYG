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
		height:'500px'
	});
}

</script>
<script type="text/javascript">
function del(id){
if(confirm("确定要删除吗?")){
         $.post("service/role/del",{"roleId":id},function(data){
        	 if(data=="1"){
              alert("删除成功！");
              window.location.href="${path }/service/role/list";
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
		
function addRole(){
	$("#authorize").hide();
	$("#updateRole").hide();
    $("#addRole").show();
    popDiv('popupdiv_tuodong','bar_blue');
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
function addUser_Role(userid){

	var roleId = "";
	var ids = document.getElementsByTagName("input");
	//alert(ids.length);
	for(var i=0;i<ids.length;i++){
		if(ids[i].type== "checkbox" && ids[i].checked){ 
			roleId += ids[i].value+","; 
		}
	}
	$.ajax({ 
	    type : "POST", 
	    url : "${path}/user/addRole?roleId="+roleId+"&userId="+userid, 
	    dataType : "json", 
	    success : function(data) { 
	        alert("更新成功");  
	        window.location.href="${path}/role/user_role?userId="+userid;
	    }, 
	    error : function(textStatus) { 
	        alert("error");  
	        window.location.href="${path}/role/user_role?userId="+userid;
	    } 
	});
}


</script>
</head>
<body onload="initRow()">
	<!-- start: Content -->
            <div id="content" class="span10">

                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2><i class="icon-align-justify"></i><span class="break"></span>角色管理</h2>
                        </div>
                        <div class="box-content">
							<div style="margin:10px 0;">						
								<input type="button" value="更新" onclick="addUser_Role('${userId}')" class="btn btn-primary" />
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
										<th>选择</th> 
										<th>角色名</th> 
										<!-- <th>操作</th> -->
                                    </tr>
                                </thead>
                                <tbody>
                                	<c:forEach items="${role}" var="role">
										<tr>
											<c:choose>
												<c:when test="${fn:contains(userRole, role.name)}">
													<td>
														<label class="checkbox">
			                                                <input type="checkbox" checked="checked" value="${role.roleid }" name="ids"/>
			                                            </label>
													</td>
												</c:when>
												<c:otherwise>
													<td>
														<label class="checkbox">
			                                                <input type="checkbox" value="${role.roleid }" name="ids"/>
			                                            </label>
													</td>
												</c:otherwise>
											</c:choose>
											<td>${role.name}</td>
											<%-- <td>
												<a class="bj" href="JavaScript:alertJsp('部门修改','${path }/user/userList')">查看权限</a>
											</td> --%>
										</tr>
									</c:forEach>
                                </tbody>
                            </table>
                            <div class="pagination pagination-centered">
                                <div class="bg">
									<div class="r_page">
										<script type="text/javascript">
											var url = location.href;
											var pageOne = new PageObject(url, '${page}', '${pg.totalPage}', '${pg.totalRow}', 'pageOne');
										</script>
									</div>
								<div class="clear"></div>
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


	<%-- <div class="right_con">
		<div class="caozuo">
			 <input type="button" value="更新" onclick="javascript:addUser_Role('${userId}')" class="caozuo_input f_l" /> 
		</div>
		<div class="tab">
			<table border="0" cellpadding="3" cellspacing="1" width="100%">
				<thead>
					<tr>
						<th>选择</th> 
						<th>角色名</th> 
						<th>操作</th> 
					</tr>
				</thead>
				<tbody>
				 
					<c:if test="${empty role}">
						<tr style="text-align: center;height: 30">
							<td colspan="2">
							<font style="font-size:16px;" color="red">暂无相关数据!</font>
							</td>
						</tr>
					</c:if>

					<c:forEach items="${role}" var="role">
						<tr>
							<c:choose>
								<c:when test="${fn:contains(userRole,role.roleid)}">
									<td><input type="checkbox" checked="checked"
										value="${role.roleid }" name="ids" id="10" class="nobor" /></td>
								</c:when>
								<c:otherwise>
									<td><input type="checkbox" value="${role.roleid }"
										name="ids" id="10" class="nobor" /></td>
								</c:otherwise>
							</c:choose>
							<td>${role.name}</td>
							<td><a class="bj"
								href="JavaScript:alertJsp('部门修改','${path }/user/userList')">查看权限</a>
							</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="2">
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
	</div> --%>
</body>
</html>