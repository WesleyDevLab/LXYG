<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %> 
<!DOCTYPE HTML>
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function init(){
	initRow();			
}

function toUrl(url) {
	location.href = url;
}

function update(mid) {
	location.href = "${path}/message/preEdit?mid=" + mid + "&type=${type}";
}
</script>
</head>
<%@ include file="../common/top.jsp"%>
<body onload="init()">
	<!-- start: Content -->
	<div id="content" class="span10">

		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-align-justify"></i><span class="break"></span>消息管理
					</h2>
					<div class="box-icon">
						<a href="javascript:void(0)" onclick="toUrl('${path}/message/preAdd?type=${type}')" class="btn-add">
                        	<i class="icon-edit" style="width:60px">添加</i>
                        </a>
					</div>
				</div>
				<div class="box-content">
					<table class="table table-bordered table-striped table-condensed">
						<thead>
							<tr>
								<th>序号</th>
								<th>类型</th>
								<th>接收人</th>
								<th>添加时间</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${page.list}" var="msg" varStatus="loopStatus">
								<tr>
									<td>${loopStatus.count}</td>
									<td class="center">
										<c:if test="${msg.type == 1}">
											系统消息
										</c:if>
										<c:if test="${msg.type == 2}">
											个人消息
										</c:if>
									</td>
									<td class="center">${msg.username}</td>
									<td class="center">${msg.time}</td>
									<td class="center">
										<button type="button" class="btn btn-primary" onclick="update('${msg.mid}')">修改</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="pagination pagination-centered">
						<div class="bg">
							<div class="r_page">
								<script type="text/javascript">
									var url = location.href;
									var pageOne = new PageObject(url,'${pg}','${page.totalPage}','${page.totalRow}','pageOne');
								</script>
							</div>
							<div class="clear"></div>
						</div>
					</div>
				</div>
			</div>
			<!--/span-->
		</div>
		<!--/row-->


	</div>
	<!-- end: Content -->

	</div>
	<!--/fluid-row-->
	<!--/row-->

	</div>
	<!--/fluid-row-->

	<div class="clearfix"></div>
	<footer>
		<p>
			<span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
		</p>
	</footer>

</body>
</html>


