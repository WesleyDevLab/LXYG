<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function alertJsp(text,url) {
	art.dialog.open(url,{
		lock:true,
		title: text,
		width: '800px',
		height:'500px'
	});
}
function init() {
	initRow();
}

function shopByCol(val) {
	if (val != 0) {
		location.href = "${path}/shop/preAddRec?type=${type}&colId="+val;
	}
}

function addRecord(type) {
	var shopId = "";
	var ids = document.getElementsByName("ids");
	for ( var i = 0; i < ids.length; i++) {
		if (ids[i].type == "checkbox" && ids[i].checked) {
			shopId += ids[i].value + ",";
		}
	}
	$.post("${path }/shop/addRec", {
		"shopId" : shopId,"type":type
	}, function(data) {
		if (data == '0') {
			alert("添加成功！");
			location.href = "${path }/shop/preAddRec?type=${type}";
		} else {
			alert("添加失败！");
		}
	});

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
                            <h2><i class="icon-align-justify"></i><span class="break"></span>推荐管理</h2>
                            <div class="box-icon">
                                <a href="#" class="btn-minimize"><i class="icon-chevron-up"></i></a>
                            </div>
                        </div>
                        <div class="box-content">
                        	<div style="margin:10px 0;">
								<input type="button" onclick="addRecord('${type}')" value="添加" class="btn btn-primary" />
								<div class="btn-group">
								  <button class="btn btn-default btn-sm dropdown-toggle" type="button" data-toggle="dropdown">
									分类筛选<span class="caret"></span>
								  </button>
								  <ul class="dropdown-menu" role="menu">
								  	<c:forEach items="${colList}" var="col">
								  		<li><a href="javascript:void(0)" onclick="shopByCol('${col.id}')">${col.cname}</a></li>
									</c:forEach>
								  </ul>
								</div> 
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
										<th>选择</th>
										<th>店铺名称</th>
									</tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${pageBean.list}" var="shop" varStatus="loopStatus">
                                    <tr>
                                        <td>
                                            <label class="checkbox">
                                                <input type="checkbox" name="ids" id="ids" value="${shop.shopid}" />
                                            </label>
                                        </td>
										<td>${shop.shopname}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
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
	<%-- <form name="form2" id="form2" method="post">
		<div class="right_con">
			<div class="caozuo">
				<form id="form1" name="form1">
					<input name="" type="button" value="全选" onclick="selectAll(document.form2);" class="caozuo_input f_l" />
					<input name="" type="button" value="反选" onclick="unselectAll(document.form2);" class="caozuo_input f_l" />
					 <input type="button" value="添加" onclick="addRecord('${type}');" class="caozuo_input f_l" /> 
					 <input name="input" type="button" value="返回" onclick="javascript:history.back()" class="caozuo_input f_l" />
					 	  <select class="caozuo_input f_l"
						onchange="shopByCol(this.value)">
						<option value="'0'">分类筛选</option>
						<c:forEach items="${colList }" var="col">
							<c:choose>
								<c:when test="${col.id==colId}">
									<option value="${col.id }" selected="selected">${col.cname
										}</option>
								</c:when>
								<c:otherwise>
									<option value="${col.id }">${col.cname }</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</select> <input id="adminId" type="hidden" value="${admin.adminId }" />
				</form>
			</div>
			<div class="tab">
				<table border="0" cellpadding="4" cellspacing="1" width="100%">
					<thead>
						<tr>
							<th>选择</th>
							<th>店铺名称</th>
						</tr>
					</thead>

					<tbody>
						<c:if test="${empty pageBean.list}">
							<tr height="30" style="text-align: center;">
								<td colspan="6"><font style="font-size:16px;" color="red">暂无相关数据!</font>
								</td>
							</tr>
						</c:if>
						<c:forEach items="${pageBean.list}" var="shop"
							varStatus="loopStatus">
							<tr>
								<td align="left"><input type="checkbox" name="ids" id="ids"
									class="nobor" value="${shop.shopid}" />
								</td>
								<td><a href="${path }/news/view?newsId=${shop.shopid}">${shop.shopname}</a>
								 
								 
						</c:forEach>
						<tr>
							<td colspan="6"><div class="bg">
									<div class="r_page">
										<script type="text/javascript">
											var url = location.href;
											var pageOne = new PageObject(url,'${pg}','${pageBean.totalPage}','${pageBean.totalRow}','pageOne');
										</script>
										<div class="clear"></div>
									</div>
									<div class="clear"></div>
								</div></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</form> --%>
</body>
</html>