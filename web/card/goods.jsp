<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function init(){
	initRow();			
}

function toUrl2(url,type){
	location.href = url + "?type=" + type;
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
                            <h2><i class="icon-align-justify"></i><span class="break"></span>新增产品</h2>
                            <div class="box-icon">
                                <c:if test="${viewKey==5}">
	                                <a href="javascript:void(0)" onclick="toUrl2('${path }/home/viewDate',5)" class="btn-setting">
	                                	<i class="icon-wrench" style="width:60px;">审阅</i>
	                                </a> 
								</c:if>
                            </div>
                        </div>
                        <div class="box-content">
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
									<tr>
										<th width="5%">序号</th>
										<th width="20%">产品名称</th>
										<th width="20%">产品价格</th>
										<th width="35%">产品图片</th>
										<th width="20%">添加时间</th>
									</tr>
								</thead>
                                <tbody>
                                <c:forEach items="${pageBean.list}" var="goods" varStatus="loopStatus">
									<tr>
										<td>${loopStatus.count}</td>
										<td>
											<a href="${path }/goods/view?goodsId=${goods.goodsid}">${goods.goodsname}</a>
										</td>
										<td>
											<c:if test="${!empty goods.price }">
												<script type="text/javascript">formatNum(${goods.price});</script>元
											</c:if>
											<c:if test="${empty goods.price }">
												暂未定价
											</c:if>
										</td>
										<td><img src="<%=imgPath %>${goods.img}" width="34" height="34" />
										</td>
										<td>${goods.createtime}</td>
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
    <!--/.fluid-container-->
</body>
</html>
