<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="com.kaka.platform.util.ConfigUtils" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String imgPath = ConfigUtils.getProperty("nginx.root");
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>商家后台办公系统</title>
<link href="<%=basePath %>public/css/index.css" rel="stylesheet" type="text/css" />
<link href="<%=basePath %>public/css/right.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath %>public/js/public.js"></script>
<script type="text/javascript" src="<%=basePath %>public/js/query/jquery.js"></script>
</head>

<body>
<form name="form1" id="form1" method="post">
<div class="c_m_bj"><span class="title02">产品管理 &nbsp;--&gt;&nbsp;查看产品</span></div>
	<div class="right_con">
		<div class="chaxun">产品详情</div>
		<span><img src="<%=imgPath %>${goods.img }" /></span>
		<div class="news_title">${goods.goodsname}&nbsp;&nbsp;价格：${goods.price/100}元</div>
		<div class="news_content">
			描述：<br/>${goods.remark} 
		</div>
	</div>
</form>
</body>
</html>


