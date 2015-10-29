<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp" %> 
 

<!DOCTYPE HTML>
<html>
  <head>  
<link href="${path }/public/css/index.css" rel="stylesheet" type="text/css" />
<link href="${path }/public/css/right.css" rel="stylesheet" type="text/css" /> 
<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script> 

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
function addRole_Res(roleid){

	var resId = "";
	var ids = document.getElementsByTagName("input");
	//alert(ids.length);
	for(var i=0;i<ids.length;i++){
		if(ids[i].type== "checkbox" && ids[i].checked){ 
			resId += ids[i].value+","; 
		}
	}
	$.ajax({ 
	    type : "POST", 
	    url : "${path}/role/addRes?resId="+resId+"&roleId="+roleid, 
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
 
function addRes() {
	 var par=$("#parentid").val();
	 alert(par);
	 if(par==0){
		 $("#restype").val(0);
	 }else{
	 	$("#restype").val(1);
	 }
	 $("#resForm").submit();
}	
</script>
 
</head>
<body onload="initRow()">
 
 <c:if test="${msg eq 'Suc' }">
 	<script type="text/javascript">
 		alert("添加成功");
 	</script>
 </c:if>

	<div class="c_m_bj">
		<span class="title02">系统管理--&gt;菜单列表</span>
	</div>
	<div class="right_con">
		<div class="caozuo">
			 <input type="button" value="添加" onclick="addRes()" class="caozuo_input f_l" /> 
		</div>
		<div class="tab">
		<form id="resForm" action="${path }/res/add" method="post" >
		<input type="hidden" id="restype" name="res.restype">
		<input type="hidden" id="flag" name="res.flag" value="1">
			<table border="0" cellpadding="3" cellspacing="1" width="100%" style="font-size: 14px;">
				<thead>
					<tr>
						<th>菜单名称</th> 
						<th>父菜单</th>  
						<th>url</th> 
					</tr>
				</thead>
				<tbody>
					<tr>
					<td> <input type="text" value="菜单名称" name="res.resname"> </td>
					<td> <select name="res.parentid" id="parentid">
					<option value="0">无</option>
						<c:forEach items="${res}" var="res">
							<option value="${res.resid }">${res.resname }</option>
						</c:forEach>
					</select> </td>
					<td> <input type="text"  name="res.url"><span style="color:red;">如：user/list 、 user/addUser.jsp</span> </td>
					</tr>
				</tbody>
			</table>
			</form>
		</div>
	</div>
</body>
</html>