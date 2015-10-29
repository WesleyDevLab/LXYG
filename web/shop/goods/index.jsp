<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.kaka.platform.util.ConfigUtils"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	String imgPath = ConfigUtils.getProperty("nginx.root");
%>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>商家后台办公系统</title>
<link href="<%=basePath%>shop/css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath%>public/js/public.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath%>shop/js/page.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/artDialog.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/iframeTools.js"></script>
<script type="text/javascript">
function alertJsp(text, url) {
	art.dialog.open(url, {
		lock : true,
		title : text,
		width : '800px',
		height : '500px'
	});
}

function init(){
	initRow();			
}

function toUrl(url) {
	location.href = url;
}

function update(goodsId) {
	location.href = "<%=basePath%>goods/preUpdate/" + goodsId;
}

function del(url, goodsId){
	if(confirm("确定要删除吗?","警告")){
		$.post(url, {"goodsId" : goodsId}, function(data){
		    if (data == 0) {
		    	alert("删除成功！");
		    	location.href="<%=basePath %>goods";
		    } else {
		    	alert("删除失败！");
		    	location.href="<%=basePath %>goods";
		    }
		});
	}
}

function formatNum(num){
	if (num==null||typeof(num)=='undefined') {
		num = 0;
	}
	document.writeln((num/100).toFixed(2));
}
</script>
</head>

<body>
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：产品管理
	</div>
	<h1 class="tittle">产品列表</h1>
	<div class="con">

		<%-- <div class="search">
			<form name="form1" id="form1" action="<%=basePath %>goods" method="post">
				<input name="str" type="text" class="search_input" placeholder="产品名称、产品价格等" title="产品名称、产品价格等" />
				<input type="submit" value="搜索" class="search_btn" /> 
				<input type="button" value="添加产品" onclick="toUrl('<%=basePath %>goods/preAdd');" class="add_pro" />
			</form>
		</div> --%>
		<table width="100%" border="0" cellspacing="1" cellpadding="1" class="tab_list" bgcolor="#e6e6e6">
			<thead>
				<tr>
					<th>序号</th>
					<th>产品名称</th>
					<th>原价</th>
					<th>现价</th>
					<th>产品图片</th>
					<th>是否限购</th>
					<th>已售</th>
					<th>库存</th>
					<th>添加时间</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty pg.list}">
					<tr height="30" style="text-align: center;">
						<td colspan="6"><font style="font-size:16px;" color="red">暂无相关数据!</font>
						</td>
					</tr>
				</c:if>
				<c:if test="${!empty pg.list}">
					<c:forEach items="${pg.list}" var="goods" varStatus="loopStatus">
						<tr>
							<td>
								${loopStatus.count}
							</td>
							<td>
								${goods.goodsname}
							</td>
							<td>
								<script type="text/javascript">formatNum(${goods.marketprice});</script>元
							</td>
							<td>
								<script type="text/javascript">formatNum(${goods.price});</script>元
							</td>
							<td>
								<c:if test="${empty goods.img}">
									暂无图片
								</c:if>
								<c:if test="${!empty goods.img}">
									<a href="javascript:void(0)" onclick="alertJsp('查看图片','<%=imgPath %>${goods.img }')">点击查看图片</a>
								</c:if>
							</td>
							<td>
								<c:if test="${goods.isstint==1}">
									限购
								</c:if>
								<c:if test="${goods.isstint==0}">
									不限购
								</c:if>
							</td>
							<td>${goods.count}</td>
							<td>${goods.instock}</td>
							<td>${goods.createtime}</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="9">
							<div class="bg">
								<div class="r_page">
								<script type="text/javascript">
									var url = location.href;
									var pageOne = new PageObject(url,'${page}','${pg.totalPage}','${pg.totalRow}','pageOne');
								</script>
							</div>
						</div>
						</td>
					</tr>
				</c:if>	
			</tbody>
		</table>

	</div>
</body>
</html>

