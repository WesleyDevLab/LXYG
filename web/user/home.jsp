<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %> 
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE html>
<html lang="zh-cn">
<head>
<jsp:include page="/metro.jsp"></jsp:include>
</head>
<%@ include file="../common/top.jsp"%>
<body>
			<!-- start: Content -->
			<div id="content" class="span10">
				<div class="index_right_img">
					<ul>
						<li>
							<a href="${path }/home/newUser?viewKey=1"> 
								<img src="<%=basePath%>public/images/newmem.png"> 
								<span>新增用户 <b class="red">${new1 }</b>位</span>
							</a>
						</li>
						<li>
							<a href="${path }/home/newNews?viewKey=2"> 
								<img src="<%=basePath%>public/images/newnews.png"> 
								<span>新增发布动态 <b class="red">${new2 }</b>条</span>
							</a>
						</li>
						<li>
							<a href="${path }/home/newPlay?viewKey=3"> 
								<img src="<%=basePath%>public/images/newplay.png"> 
								<span>新增发布活动 <b class="red">${new3 }</b> </span>
							</a>
						</li>
						<li>
							<a href="${path }/home/newShop?viewKey=4"> 
								<img src="<%=basePath%>public/images/newshop.png"> 
								<span>新增商家 <b class="red">${new41 }</b> 新增认证商家 <b class="red">${new42}</b> </span>
							</a>
						</li>
						<li>
							<a href="${path }/home/newBalance?viewKey=10">
								<img src="<%=basePath%>public/images/goods.png">
								<span>结算记录<b class="red">${newbalance}</b>条</span>
							</a>					
						</li>
					    <li>
						    <a href="${path }/home/newComment?viewKey=11">
								<img src="<%=basePath%>public/images/hand.jpg">
								<span><b class="red">${com.scount}</b>个店铺新增评价<b class="red">${com.count}</b>条</span>
							</a>					
						</li>
						<li>
							<a href="${path }/home/newConsume?viewKey=7&ctype=3"> 
								<img src="<%=basePath%>public/images/newconsume.png"> 
								<span><b class="red">${new71 }</b>个会员有新的消费。消费金额为<b class="red"><fmt:formatNumber type='number' value='${new72/100}' maxFractionDigits='2' pattern="#,##0.00#"/></b>元。</span>
							</a>
						</li>
					</ul>
				</div>
			</div>
			<!-- end: Content -->

		</div>
		<!--/fluid-row-->

		<div class="clearfix"></div>

		<%@include file="/common/bottom.jsp" %>

	</div>
	<!--/.fluid-container-->

</body>
</html>