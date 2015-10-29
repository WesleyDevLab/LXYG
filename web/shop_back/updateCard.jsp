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
function init(){
	initRow();			
}

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
	var url = "<%=basePath%>user/toSift?type=${type}&approve=";
	location.href = url + val;
}

function upFlag(shopId,type,val){
	$.post("${path }/shop/edit", 
	{"type":type,"val":val,"shopId":shopId}, 
	function(data) {
		if (data == '0') {
			alert("操作成功！");
			location.href = "${path }/user/list?type=1";
		} else {
			alert("删除失败！");
		}
	});
}

function del(shopId){
	var url = "<%=basePath%>user/delShop";
	if(confirm("确定要删除吗?","警告")){
		$.post(url, {"shopId":shopId}, function(data){
		    if (data == 0) {
		    	alert("删除成功！");
		    	location.href="${path }/user/list?type=1";
		    } else {
		    	alert("删除失败！");
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
                            <h2><i class="icon-align-justify"></i><span class="break"></span>优惠商家管理</h2>
                            <div class="box-icon">
                                <c:if test="${viewKey==9}">
                                	<a href="javascript:void(0)" onclick="toUrl('${path }/home/viewDate','${viewKey}')" class="btn-add">
	                                	<i class="icon-edit" style="width:60px;">审阅</i>
	                                </a>
                                </c:if>
                            </div>
                        </div>
                        <div class="box-content">
                        	<div style="margin:10px 0;">
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>商家名称</th>
                                        <th>联系电话</th>
                                        <th>原折扣</th>
                                        <th>修改后折扣</th>
                                        <th>修改时间</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${pageBean.list}" var="card" varStatus="status">
                                    <tr>
                                        <td>
                                            ${status.count}
                                        </td>
                                        <td>${card.shopname}</td>
                                        <td>
                                        	${card.telphone}
                                        </td>
                                        <td>
                                        	<span class="font_red"><fmt:formatNumber type='number' value='${card.bediscount/10}' maxFractionDigits='1' pattern="#,##0.0#" /></span>折
                                        </td>
                                        <td>
                                        	<span class="font_red"><fmt:formatNumber type='number' value='${card.discount/10}' maxFractionDigits='1' pattern="#,##0.0#" /></span>折
                                        </td>
                                        <td>
	                                        ${card.changetime}
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

