<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %> 
 

<!DOCTYPE html>
<html>
<head> 
    
<title></title>	
<link href="${path }/public/css/right.css" rel="stylesheet" type="text/css" /> 
<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script> 
<script>
function edit(){
	var shopId = $("#shopId").val();
	var account = $("#account").val();
	$.ajax({
			type : "POST",
			url : "${path }/shop/editShop",
			data : {"account":account,
					"shopId":shopId},
			dataType : "json",
			success : function(data) {
				if(data==0){
					alert("充值成功！");
					art.dialog.close();
				}else{
					alert("充值失败！");
				}
				
			},
			error : function(textStatus) {
				alert("error");  
			}
		});
}
	
</script>
  </head>
  
  <body>
   
	<div class="right_con">
		 
	</div> 
	<div id="popupdiv_psw" border:1px #000000 solid" >
		<div class="chaxun1" style="width:600px;">
				<div class="xiugai"> <span class="xuanxiang">商家名称：</span>
					${shop.shopname }</span>
                </div>
				<div class="xiugai"><span class="xuanxiang">充值金额：</span>
				  <input type="text" name="account" id="account"/> </div>
				 
				<div class="caozuo_bot01"> 
				<input name="b2" type="submit" value="充值" class="caozuo_input" onclick="edit();"/>
				<input name="b2" type="button" value="重置" class="caozuo_input"/>
				<input name="b3" type="button" value="取消" class="caozuo_input" onclick="art.dialog.close()"/>
				<input name="shopId" type="hidden" id="shopId" value="${shop.shopid}" class="caozuo_input"/>
			</div>
			</div>
		</div>
  </body>
</html>
