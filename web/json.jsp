<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'json.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script></head>
  
  <script type="text/javascript">
     //var obj="productImgs:[com.kaka.platform.model.GoodsImg@fb0d63b7 {img_url:http://7xk59r.com1.z0.glb.clouddn.com/FiIbyd1TjZr7XOcHr2nbG7eMSjBn, imgId:24, product_id:36, alt:}]";
   var str='[{"img_url":"http://7xk59r.com1.z0.glb.clouddn.com/FiIbyd1TjZr7XOcHr2nbG7eMSjBn"}]';
   var obj = jQuery.parseJSON(str);
   alert(obj[0].img_url);
    
  </script>
  
  <body>
    This is my JSP page. <br>
  </body>
</html>
