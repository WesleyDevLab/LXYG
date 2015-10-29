<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%@ include file="../common/taglibs.jsp"%>


<!DOCTYPE HTML>
<html>
<head>
<link href="${path }/public/treeTable/script/treeTable/vsStyle/jquery.treeTable.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${path }/public/treeTable/script/jquery.js"></script>
<script src="${path }/public/treeTable/script/treeTable/jquery.treeTable.js" type="text/javascript"></script>
<style type="text/css">
table,td,th {
	border: 1px solid #8DB9DB;
	padding: 5px;
	border-collapse: collapse;
	font-size: 16px;
	background: white;
}
</style>
<script type="text/javascript">
 $(function(){
     var option = {
         theme:'vsStyle',
         expandLevel : 2,
         beforeExpand : function($treeTable, id) {
             //判断id是否已经有了孩子节点，如果有了就不再加载，这样就可以起到缓存的作用
             if ($('.' + id, $treeTable).length) { return; }
             //这里的html可以是ajax请求
            /*  var html = '<tr id="8" pId="6"><td>5.1</td><td>可以是ajax请求来的内容</td></tr>'
                      + '<tr id="9" pId="6"><td>5.2</td><td>动态的内容</td></tr>';

             $treeTable.addChilds(html); */
         },
         onSelect : function($treeTable, id) {
             window.console && console.log('onSelect:' + id);
         }
     };
     $('#treeTable1').treeTable(option);

 });
 </script>
<script type="text/javascript">	

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

	
</script>
<script type="text/javascript">

$(function (){ 	
	 $("#treeTable1 tr td span > input").click(function(){
	  var tid = $(this).val();
	  var pId= $(this).parent().parent().parent().attr("pId");
		if($(this).attr("checked")==true){	
			$("#"+pId).children().children().children().attr("checked",true);
			if(null!=$("#"+pId).attr("pId")){
				var ppId=$("#"+pId).attr("pId");
				$("#"+ppId).children().children().children().attr("checked",true);
			}				
		}else{
			$(".td"+tid).children().children("input").attr("checked",false); 
			var cId=$(".td"+tid).parent().attr("id"); 
			if(null!=$(".td"+cId))
				$(".td"+cId).children().children().attr("checked",false);				 
		}
	});
});
</script>
</head>
<body onload="initRow()">
	<div class="right_con">
		<div class="caozuo">
			<input type="button" value="更新" onclick="addRole_Res(${roleId})" class="caozuo_input f_l" />
		</div>
		<div class="tab">
			<table id="treeTable1" border="0" cellpadding="3" cellspacing="1" width="100%" style="font-size: 14px;">
				<thead>
					<tr>
						<th>菜单</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width:200px;">菜单项</td>
					</tr>
					<c:forEach items="${res}" var="res">
						<tr id="${res.resid}">
							<td id="res1">
							<span controller="true">
								<c:choose>
									<c:when test="${fn:contains(roleRes, res.resname)}">
										<input type="checkbox" checked="checked" value="${res.resid}" name="ids" class="nobor" />${res.resid }
									</c:when>
									<c:otherwise>
										<input type="checkbox" value="${res.resid }" name="ids" id="10" class="nobor" />
									</c:otherwise>
								</c:choose>
								${res.resname}
							</span>
							</td>
						</tr>
						<c:forEach items="${res2}" var="res2">
							<c:if test="${res2.parentid==res.resid }">
								<tr id="${res2.resid }" pId="${res.resid }">
									<td id="res2" class="td${res.resid }">
									<span controller="true">
										<c:choose>
											<c:when test="${fn:contains(roleRes, res2.resname)}">
												<input type="checkbox" checked="checked" value="${res2.resid }" name="ids" class="nobor" />${res2.resid }
											</c:when>
											<c:otherwise>
												<input type="checkbox" value="${res2.resid }" name="ids" id="10" class="nobor" />${res2.resid }
											</c:otherwise>
										</c:choose>
										${res2.resname} 
									</span>
									</td>
								</tr>
								<c:forEach items="${res3}" var="res3">
									<c:if test="${res3.parentid==res2.resid }">
										<tr id="${res3.resid }" pId="${res2.resid}">
											<td id="res3" class="td${res2.resid }">
											<span controller="true">
												<c:choose>
													<c:when test="${fn:contains(roleRes, res3.resname)}">
														<input type="checkbox" checked="checked" value="${res3.resid }" name="ids" class="nobor" />${res3.resid }
													</c:when>
													<c:otherwise>
														<input type="checkbox" value="${res3.resid }" name="ids" class="nobor" />
													</c:otherwise>
												</c:choose>
												${res3.resname} 
											</span>
											</td>
										</tr>
									</c:if>
								</c:forEach>
							</c:if>
						</c:forEach>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>