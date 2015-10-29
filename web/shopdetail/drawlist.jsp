<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function alertDraw(text, url) {
	art.dialog.open(url, {
		lock : true,
		title : text,
		width : '800px',
		height : '500px'
	});
}

//弹出窗
function alertJsp(text,url) {
	art.dialog.open(url,{
		lock:true,
		title: text,
		width: '800px',
		height:'500px',
		close : function () {
             art.dialog.open.origin.location.href='${path}/shop/drawList?shopId=${shopId}';
        }
	});
}

function toUrl(url) {
	location.href = url;
}

function del(id){
	var url = "${path}/shop/delDraw";
	if(confirm("确定要删除吗?","警告")){
		$.post(url, {"id" : id}, function(data){
		    if (data == 0) {
		    	alert("删除成功！");
		    	location.href="${path}/shop/drawList?shopId=${shopId}";
		    } else {
		    	alert("删除失败！");
		    	location.href="${path}/shop/drawList?shopId=${shopId}";
		    }
		});
	}
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
                            <div class="box-header">
								<h2> <i class="icon-edit"></i>展示图片管理</h2>
								<div class="box-icon">
									<a href="javascript:history.back()" class="btn-add"> 
										<i class="icon-edit" style="width: 60px;">返回</i> 
									</a>
								</div>
							</div>
                        </div>
                        <div class="box-content">
                        	<button type="button" class="btn btn-primary" onclick="alertJsp('展示图片管理','${path}/shop/preAddDraw?shopId=${shopId}')" style="margin: 20px 0px;">
								添加展示图片
							</button>
                        	
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
										<th>序号</th>
										<th>商家名称</th>
										<th>图片详细信息</th>
										<th>操作</th>
									</tr>
                                </thead>
                                <tbody>
									<c:if test="${!empty pg.list}">
										<c:forEach items="${pg.list}" var="draw" varStatus="loopStatus">
											<tr>
												<td>${loopStatus.count}</td>
												<td>${draw.shopname}</td>
												<td>
													<c:if test="${empty draw.img}">
														暂无图片
													</c:if>
													<c:if test="${!empty draw.img}">
														<a href="javascript:void(0)" onclick="alertDraw('查看图片','<%=imgPath %>${draw.img }')">点击查看图片</a>
													</c:if>
												</td>
												<td>
													<button type="button" class="btn btn-danger" onclick="alertJsp('展示图片管理','${path}/shop/preEditDraw?id=${draw.id}&shopId=${shopId}')">编辑</button>
													<button type="button" class="btn btn-remove" onclick="del('${draw.id}')">删除</button>
												</td>
											</tr>
										</c:forEach>
										<tr>
											<td colspan="4">
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

