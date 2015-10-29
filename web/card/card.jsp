<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function init() {
	initRow();
}

function toUrl(url) {
	location.href = url;
}
function toUrl2(url,type){
	location.href = url + "?type=" + type;
};

function searchByType(val) {
	location.href = "${path}/card/searchByType?type=" + val;
}

function searchByShop() {
	$("#form1").submit();
}

function searchByCard() {
	var cardId = $("#cardID").val();
	alert(cardId);
	if (cardId == null) {
		alert("请输入会员乐享云购号");
	} else {
		location.href = "${path}/card/searchByCard?cardId=" + cardId;
	}
}

function del(url,id) {
	if(confirm("确定要删除吗,会删除此会员卡的消费记录！")){
		$.post(url, {"id" : id}, function(data){
		    if (data == 0) {
		    	alert("删除成功！");
		    	location.href="${path}/card/list";
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
			<form id="form1" name="form1" method="post" action='${path}/card/searchByShop'>
            <div id="content" class="span10">

                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2><i class="icon-align-justify"></i><span class="break"></span>会员卡管理</h2>
                            <div class="box-icon">
                                <c:if test="${viewKey==6}">
	                                <a href="javascript:void(0)" onclick="toUrl2('${path }/home/viewDate',6)" class="btn-setting">
	                                	<i class="icon-wrench" style="width:60px;">审阅</i>
	                                </a> 
								</c:if>
                            </div>
                        </div>
                        <div class="box-content">
                        	<%-- <div style="margin:10px 0;">
                        		<c:if test="${viewKey!=6 }">
									<div class="span6">
										<form id="form1" action="${path}/card/searchByCard" method="post">
											<c:if test="${viewKey!=1 }">
											  <label>卡号：	
												  <input name="username" id="username_search" placeholder="卡号"/> 
												  <input type="submit" value="卡号筛选" class="btn btn-primary" />
											  </label>
											</c:if>
										</form>
									</div>
                        		</c:if>
							</div> --%>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>卡名</th>
                                        <th>编号</th>
                                        <th>持有人</th>
                                        <th>所属店铺</th>
                                        <th>类型</th>
                                        <th>折扣比</th>
                                        <c:if test="${viewKey!=6 }">
                                        	<th>操作</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${pageBean.list}" var="card" varStatus="loopStatus">
                                    <tr>
                                        <td>
                                            ${loopStatus.count}
                                        </td>
                                        <td>${card.cardname}</td>
                                        <td class="center">${card.id }
                                        </td>
                                        <td class="center">${card.username}
                                        </td>
                                        <td class="center">${card.shopname}
                                        </td>
                                        <td class="center">${card.cardname}</td>
                                        <td class="center">${card.discount/10}折
                                        </td>
                                        <c:if test="${viewKey!=6 }">
	                                        <td class="center">
	                                            <input type="button" onclick="del('${path}/card/deleteById','${card.id}')" class="btn" value="删除"/>
	                                        </td>
                                        </c:if>
                                    </tr></c:forEach>
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
    </form>
    <!--/.fluid-container-->
</body>
</html>

