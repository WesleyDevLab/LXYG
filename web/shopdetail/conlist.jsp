<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function toUrl(url) {
	location.href=url;
}

//弹出窗
function alertJsp(text,url) {
	art.dialog.open(url,{
		lock:true,
		title: text,
		width: '800px',
		height:'500px',
		close : function () {
             art.dialog.open.origin.location.href='${path}/shop/conlist';
        }
	});
}

function del(id) {
	var url = "${path}/shop/deleteCon";
	if (confirm("确定要删除吗?", "警告")) {
		$.post(url, {
			"id" : id
		}, function(data) {
			if (data == 0) {
				alert("删除成功！");
				location.href = "${path}/shop/conlist?pg=${pg}";
			} else {
				alert("删除失败！");
			}
		});
	}
}
</script>
</head>
<%@ include file="../common/top.jsp"%>
<body>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>便民列表
					</h2>
				</div>
				<div class="box-content">
					<button type="button" class="btn btn-primary" onclick="alertJsp('便民管理','${path}/shop/preEditCon?type=ADD&id=${con.id}')" style="margin: 20px 0px;">
						添加便民
					</button>
					<table class="table table-bordered table-striped table-condensed">
	                    <thead>
		                    <tr>
			                    <th>序号</th>
			                    <th>标题</th>
			                    <th>电话号码</th>
			                    <th>描述</th>
								<th>图片</th>
								<th>排序</th>
								<th>添加时间</th>
			                    <th>操作</th>
		                    </tr>
	                    </thead>
	                    <tbody>
	                    	<c:forEach items="${pageBean.list}" var="con" varStatus="loopStatus">
								<tr>
									<td>${loopStatus.count}</td>
									<td>${con.title}</td>
									<td>${con.mobile}</td>
									<td>${con.remark}</td>
									<td>
										<!--<a href="#">点击查看</a>
										--><img src="<%=imgPath %>${con.img}" width="56" height="56" />
									</td>
									<td>${con.orderby}</td>
									<td>${con.createtime}</td>
									<td>
										<button type="button" class="btn btn-danger" onclick="alertJsp('便民管理','${path}/shop/preEditCon?type=EDIT&id=${con.id}')">编辑</button>
										<button type="button" class="btn btn-primary" onclick="del('${con.id}')">删除</button>
									</td>
								</tr>
							</c:forEach>
							<tr>
								<td colspan="7">
									<div class="pagination pagination-centered">
										<div class="bg">
											<div class="r_page">
												<script type="text/javascript">
													var url = location.href;
													var pageOne = new PageObject(url, '${pg}', '${pageBean.totalPage}', '${pageBean.totalRow}', 'pageOne');
												</script>
											</div>
											<div class="clear"></div>
										</div>
									</div>
								</td>
							</tr>
	                    </tbody>
                    </table>
				</div>
			</div>
			<!--/span-->

		</div>
		<!--/row-->


	</div>

	</div>
	<!--/fluid-row-->
	<!--/row-->

	</div>
	<!--/fluid-row-->

	<div class="clearfix"></div>
	<footer>
	<p>
		<span style="text-align: left; float: left">Copyright &copy;
			2014.乐享云购 All rights reserved.</span>
	</p>
	</footer>
</body>
</html>

