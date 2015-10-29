<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %> 
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
var approve = "${approve}";
var cid = "${cid}";
var realname = "${realname}";
function alertJsp(text,url) {
	art.dialog.open(url,{
		lock:true,
		title: text,
		width: '800px',
		height:'500px'
	});
};

function search(){
	 $("#form1").submit();
}

function toUrl(url,type){
	location.href = url + "?type=" + type;
}

function toSift(val) {
	var url = "${path }/user/toSift?type=${type}&approve=";
	location.href = url + val;
}

function toColumn(val) {
	var url = "${path }/user/toColumn?type=${type}&cid=" + val;
	location.href = url;
}

function upFlag(shopId,type,val){
	$.post("${path }/shop/edit", 
	{"type":type,"val":val,"shopId":shopId}, 
	function(data) {
		if (data == '0') {
			alert("操作成功！");
			var url = "${path }/user/list?type=1&pg=${pg}";
			if (realname != "") {
				url = url + "&realname=" + realname;
			}
			if (cid != "") {
				url = "${path }/user/toColumn?type=${type}&pg=${pg}&cid="+cid;
			}
			if (approve) {
				var url = "${path }/user/toSift?type=${type}&pg=${pg}&approve="+approve;
			}
			location.href = url;
		} else {
			alert("操作失败！");
		}
	});
}

function del(shopId){
	var url = "<%=basePath%>user/delShop";
	if(confirm("确定要删除吗?","警告")){
		$.post(url, {"shopId":shopId}, function(data){
		    if (data == 0) {
		    	alert("删除成功！");
		    	var url = "${path }/user/list?type=${type}&pg=${pg}";
				if (realname != "") {
					url = url + "&realname="+realname;
				}
				if (cid != "") {
					url = "${path }/user/toColumn?type=${type}&pg=${pg}&cid="+cid;
				}
				if (approve) {
					url = "${path }/user/toSift?type=${type}&pg=${pg}&approve="+approve;
				}
				location.href = url;
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
                            <h2><i class="icon-align-justify"></i><span class="break"></span>优惠商家管理</h2>
                            <div class="box-icon">
                            	<c:if test="${viewKey!=4&&viewKey!=9&&viewKey!=10 }">
	                                <a href="javascript:void(0)" onclick="toUrl('<%=basePath%>user/preAdd','${type }')" class="btn-add">
	                                	<i class="icon-edit" style="width:60px;">添加</i>
	                                </a>
                                </c:if>
                                <c:if test="${viewKey==4||viewKey==9||viewKey==10 }">
                                	<a href="javascript:void(0)" onclick="toUrl('${path }/home/viewDate','${viewKey }')" class="btn-add">
	                                	<i class="icon-edit" style="width:60px;">审阅</i>
	                                </a>
                                </c:if>
                            </div>
                        </div>
                        <div class="box-content">
                        	<div style="margin:10px 0;">
                        		<c:if test="${viewKey!=4&&viewKey!=9&&viewKey!=10 }">
									<div class="span6">
										<div class="btn-group">
									  	  <button class="btn btn-default btn-sm dropdown-toggle" type="button" data-toggle="dropdown">
											认证筛选<span class="caret"></span>
										  </button>
										  <ul class="dropdown-menu" role="menu">
											<li><a href="javascript:void(0)" onclick="toSift('1')">已认证</a></li>
											<li><a href="javascript:void(0)" onclick="toSift('0')">未认证 </a></li>
										  </ul>							
										</div>
										<div style="margin-left: 20px;" class="btn-group">
									  	  <button class="btn btn-default btn-sm dropdown-toggle" type="button" data-toggle="dropdown">
											分类筛选<span class="caret"></span>
										  </button>
										  <ul class="dropdown-menu" role="menu">
										  	<c:forEach items="${colList}" var="col">
												<li><a href="javascript:void(0)" onclick="toColumn('${col.id}')">${col.cname}</a></li>
											</c:forEach>
										  </ul>							
										</div>
									</div>
									<div class="span6">
										<div class="dataTables_filter" id="DataTables_Table_0_filter">
											<c:if test="${viewKey!=1 }">
											<form id="form1" action="<%=basePath%>user/list?type=${type}" method="post">
											  <label>商家名称：	
												  <input name="realname" class="input-xlarge" id="username_search"/> 
												  <input type="button" onclick="search()" value="查询" class="btn btn-primary" />
											  </label>
											</form>
											</c:if>
										</div>
									</div>
								</c:if>
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>分类</th>
                                        <th>会员名称</th>
                                        <th>店铺名称</th>
                                        <th>联系电话</th>
                                        <th>详细地址</th>
                                        <th>认证时间</th>
                                        <c:if test="${viewKey!=4&&viewKey!=9&&viewKey!=10 }">
                                        	<th>操作</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${pageBean.list}" var="user" varStatus="status">
                                    <tr>
                                        <td>
                                            ${status.count}
                                        </td>
                                        <td>${user.cname}</td>
                                        <td>${user.username }</td>
                                        <td class="center">
                                        	<a class="color2" href="<%=basePath%>shop/viewShop?shopId=${user.shopid}">${user.shopname}</a>
                                        </td>
                                        <td class="center">${user.mobile}
                                        </td>
                                        <td class="center">${user.address}
                                        </td>
                                        <td class="center">
	                                        <c:if test="${user.approve==1}">${user.approvetime}</c:if>
											<c:if test="${user.approve==0}">未认证 </c:if>
                                        </td>
                                        <c:if test="${viewKey!=4&&viewKey!=9&&viewKey!=10 }">
											<td>
												<c:choose>
													<c:when test="${user.flag==1 }">
														<input name="" type="button" value="上架" class="btn btn-danger" onclick="upFlag('${user.shopid}','flag',0)"/>
													</c:when>
													<c:otherwise>
														<input name="" type="button" value="下架" class="btn btn-danger" onclick="upFlag('${user.shopid}','flag',1)" />
													</c:otherwise>
												</c:choose> 
												<c:choose>
													<c:when test="${user.approve==0 }">
														<button type="button" class="btn btn-primary" onclick="upFlag('${user.shopid}','approve',1)">认证</button>
													</c:when>
													<c:otherwise>
														<button type="button" class="btn btn-primary" onclick="upFlag('${user.shopid}','approve',0)">取消认证</button>
													</c:otherwise>
												</c:choose> 
												<c:if test="${session['user'].isseller==0}">
												    <button type="button" class="btn btn-remove" onclick="del('${user.shopid}')">删除</button>
												</c:if>
											</td>
										</c:if>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                            <div class="pagination pagination-centered">
                                <div class="bg">
									<div class="r_page">
										<script type="text/javascript">
											var url = location.href;
											//alert(url);
											if (realname != "") {
												url = url + "&realname=" + realname;
											}
											var pageOne = new PageObject(url, '${pg}', '${pageBean.totalPage}', '${pageBean.totalRow}', 'pageOne');
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

