<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%@ include file="../common/taglibs.jsp" %> 
 

<!DOCTYPE HTML>
<html>
  <head>  
<link href="${path }/public/css/index.css" rel="stylesheet" type="text/css" />
<link href="${path }/public/css/right.css" rel="stylesheet" type="text/css" /> 
<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script> 
<script type="text/javascript" src="${path }/public/js/public.js"></script>
<script type="text/javascript" src="${path }/public/js/artDialog.js?skin=green"></script><!--default,aero,chrome,opera,simple,idialog,twitter,blue,black,green -->
<script type="text/javascript" src="${path }/public/js/iframeTools.js"></script>
<script type="text/javascript">
//������
function addRes(text,url) {
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
 
	
</script>
 
</head>
<body onload="initRow()">
	<div class="right_con">
		<div class="caozuo">
			 <input type="button" value="����²˵�" onclick="addRes('��Ӳ˵�','${path}/res/faList')" class="caozuo_input f_l" /> 
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
						<tr > 
							<td class="fa">
							 <div style="display: inline;float: left;"> ${res.resname}</div><div style="display: inline;float: left;"><div>
							<img src="${path }/public/images/del.gif">
							</div><div>
							<img src="${path }/public/images/edit.png"></div></div></td> 
							<td >
							<c:forEach items="${res2}" var="res2">
								<c:if test="${res2.parentid==res.resid }">
									 
							<div style="display: inline;float: left;">${res2.resname}</div>
							<div style="display: inline;float: left;"><div>
							<img src="${path }/public/images/del.gif">
							</div><div>
							<img src="${path }/public/images/edit.png"></div></div>&nbsp;&nbsp;&nbsp;&nbsp;
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