<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">

function update(colId){
	location.href="${path}/column/preUpdate?colId="+colId;
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
	                            <i class="icon-align-justify"></i>
                       			APP首页分类管理
                            </h2>
                        </div>
                        <div class="box-content">
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>栏目名称</th>
                                        <th>缩略图</th>
                                        <th>排序</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${colList}" var="col" varStatus="status">
                                    <tr>
                                        <td>
                                            ${status.count}
                                        </td>
                                        <td>${col.cname }</td>
                                        <td class="center"><img src="${imgPath}${col.img}" style="width:50px;"></td>
                                        <td class="center">${col.orderby}
                                        </td>
                                        <td class="center">
                                        	<c:if test="${session['user'].uid==209628}">
	                                            <button type="button" class="btn btn-primary" onclick="update('${col.id}')">修改</button>
	                                            <!--<button type="button" class="btn" onclick="JavaScript:delRecord('${col.id}');">删除</button>
                                            --></c:if>
                                            <c:if test="${session['user'].uid!=209628}">
                                            	无权限
                                            </c:if>
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

