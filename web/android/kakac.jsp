<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>下载乐享云购 app</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript">



	   var userAgent = navigator.userAgent.toLowerCase();
       var ios = userAgent.match(/(iphone|ipod|ipad|wechat)/);
       var android=userAgent.match(/(android|wechat)/);
       var wechat = userAgent.match(/(micromessenger)/);
       if(android){
           if(wechat){
               alert("请点击右上角选择【在浏览器中打开】，以下载乐享云购");
           }
           var path="http://7xk59r.com2.z0.glb.qiniucdn.com/KKWUBiz081903.apk";
           window.top.location.href=path;
       }
       if(ios){
           if(wechat){
               alert("请点击右上角选择【在浏览器中打开】，以下载乐享云购商家端");
           }
           var path="http://www.pgyer.com/WCRq";
           window.top.location.href=path;
       }
       
	</script>
  </head>
  
  <body>
      正在下载乐享云购商户端
  </body>
</html>
