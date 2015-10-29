<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%@ include file="../common/taglibs.jsp" %> 
 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>  
<link href="${path }/public/css/index.css" rel="stylesheet" type="text/css" />
<link href="${path }/public/css/right.css" rel="stylesheet" type="text/css" /> 
<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script> 
<script type="text/javascript" src="${path }/public/js/public.js"></script>
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
function addRole_Res(roleid){

	var resId = "";
	var ids = document.getElementsByTagName("input");
	//alert(ids.length);
	for(var i=0;i<ids.length;i++){
		if(ids[i].type== "checkbox" && ids[i].checked){ 
			resId += ids[i].value+","; 
		}
	}
	if(resId==""){
		resId=",";
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
$(function (){
		//alert($(".tr > td:first > input").val());
		$(".tr > td:first-child > input").click(function(){
	//	alert($(this).val());
			if($(this).attr("checked")==true){
			//alert("bbbb");
				//alert($(this).nextAll(".ch").html());
				//$(this).parent().next("td").children().attr("checked",true);
			}else{
			//alert("aaa");
				$(this).parent().next("td").children().attr("checked",false);
			}
		});
		$(".chi").click(function(){
			//alert($(this).prop("checked"));
			if($(this).attr("checked")==true){ 
			//alert($(this).parent().prev().html());
				$(this).parent().prev().children().attr("checked",true);
			}
		});	
	});
	
</script>
	<script type="text/javascript">
/*
$(function (){ 
		$(".fa > input").click(function(){
			if($(this).prop("checked")==true){
				//alert($(this).nextAll(".ch").html());
				$(this).next("ul").children().children().prop("checked",true);
			}else{
				$(this).next("ul").children().children().prop("checked",false);
			}
		})	
		$(".chi").click(function(){
			//alert($(this).prop("checked"));
			if($(this).prop("checked")==true){
				//alert($(this).nextAll(".ch").html());
				//alert($(this).parent().parent().parent().children("input").val());
				$(this).parent().parent().parent().children("input").prop("checked",true);
			}
		})	
	})*/
	
	
	
</script>
</head>
<body onload="initRow()">
	<div class="right_con">
		<div class="caozuo">
			 <input type="button" value="更新" onclick="javascript:addRole_Res('${roleId}')" class="caozuo_input f_l" /> 
		</div>
		<div class="tab">
			<table border="0" cellpadding="3" cellspacing="1" width="100%" style="font-size: 14px;">
				<thead>
					<tr>
						<th>菜单</th> 
						<th>子菜单</th>  
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${res}" var="res">
						<tr class="tr"> 
							<td class="fa">
							<c:choose>
								<c:when test="${fn:contains(roleRes,res.resid)}">
									<input type="checkbox" checked="checked"
										value="${res.resid }" name="ids" id="10" class="nobor" />${res.resid }
								</c:when>
								<c:otherwise>
									<input type="checkbox" value="${res.resid }" name="ids"
										id="10" class="nobor" />
								</c:otherwise>
							</c:choose> ${res.resname}</td> 
							<td >
							<c:forEach items="${res2}" var="res2">
								<c:if test="${res2.parentid==res.resid }">
									<c:choose>
										<c:when test="${fn:contains(roleRes,res2.resid)}">
											<input class="chi" type="checkbox" checked="checked"
												value="${res2.resid }" name="ids" id="10" class="nobor" />
										</c:when>
										<c:otherwise>
											<input class="chi" type="checkbox" value="${res2.resid }" name="ids"
												id="10" class="nobor" />
										</c:otherwise>
									</c:choose>
							${res2.resname}&nbsp;&nbsp;&nbsp;&nbsp;
						</c:if>

								</c:forEach></td>
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
	</div>
</body>
</html>