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
//������
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
	   if(confirm("ȷ��Ҫɾ����?")){
	            $.post("service/role/del",{"roleId":id},function(data){
	           	 if(data=="1"){
	                 alert("ɾ���ɹ���");
	                 window.location.href="${path }/service/role/list";
	             }else if(data=="2"){
	           		 alert("�Ͳ˵��й�����");
	           	 }else if(data=="3"){
	                 alert("���û��й�����");
	             }else if(data=="0"){
	            	 alert("ɾ��ʧ�ܣ�");
	             }
	          });
	      }
	    }
	/**
	 *��ӽ�ɫʱ������
	 **/
	 function add(){
			roleName=$("#roleName").val().replace(/^\s+|\s+$/g,"");
			 if(""==roleName){
				  document.getElementById("spanErro").innerHTML = "��������дÿһ��";
				  $("#roleName").focus();
				  return;
			  }
			 $.post("${path }/service/role/add",{"name":roleName},function(data){
				 if(data==0){
					 alert("��ӳɹ�");
					 window.location.href="${path }/service/role/list";
					 return;
				 }else if(data==1){
					 alert("���д˽�ɫ");
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
			  alert("��ɫ������Ϊ��!");
			  $("#updateName").focus();
			  return;
		  }
		 $.post("${path }/service/role/update",{"roleId":roleId,"name":roleName},function(data){
			 if(data=="1"){
				 alert("�޸ĳɹ�");
				 window.location.href="${path }/service/role/list";
				 return;
			 }else if(data=="0"){
				 alert("�޸�ʧ��");
				 return;
			 }else if(data=="2"){
				 alert("�Ѿ��д˽�ɫ��");
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
	        alert("���³ɹ�");  
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
			 <input type="button" value="����" onclick="javascript:addRole_Res('${roleId}')" class="caozuo_input f_l" /> 
		</div>
		<div class="tab">
			<table border="0" cellpadding="3" cellspacing="1" width="100%" style="font-size: 14px;">
				<thead>
					<tr>
						<th>�˵�</th> 
						<th>�Ӳ˵�</th>  
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