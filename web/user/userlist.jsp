<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp" %> 

<!DOCTYPE html>
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript" charset="gbk" >
function init(){
	initRow();			
};

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
};

function del(url) {
	if (confirm("确定要删除吗?", "警告")) {	
		location.href = url;
	}
}

function toUrl(url,type){
	location.href = url + "?type=" + type;
}

function toUrl1(url) {
	location.href = url;
}

function toUrl2(url){
	location.href = "${path}/user/toadd";
}

function toSift(val) {
	var url = "${path}/user/toSift?type=${type}&approve=";
	location.href = url + val;
}
</script>
</head>
<%@ include file="../common/top.jsp"%>

<body onload="init();">

<!-- start: Content -->
            <div id="content" class="span10">

                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2><i class="icon-align-justify"></i><span class="break"></span>会员管理</h2>
                           	<div class="box-icon">
                                <c:if test="${viewKey==1}">
	                                <a href="javascript:void(0)" onclick="toUrl('${path }/home/viewDate',1)" class="btn-setting"><i class="icon-wrench" style="width:60px;">审阅</i>
	                                </a> 
								</c:if>
                            </div>
                        </div>
                        <div class="box-content">
                        	<div style="margin:10px 0;">
								<c:if test="${viewKey!=1 }">
									<c:choose>
										<c:when test="${type==0 }">
											<div class="span6">
												<div class="btn-group">
													<input type="button" value="添加管理员" onclick="toUrl2('${path }/user/addManage.jsp');" class="btn btn-primary f_l" />
												</div>
											</div> 
										</c:when>
										<c:otherwise>
											<table>
				                             <tr>
				                             	<form id="form1" action="${path}/user/list?type=${type}" method="post">
				                             		<td  valign="middle" style="padding-left:20px;  padding-right:10px;" >会员名称:</td>
													<td>
														<div class="dataTables_filter" id="DataTables_Table_0_filter">
															<input type="text" style="margin-bottom: -2px;width:170px;" id="realname" name="realname" value="${realname}" aria-controls="DataTables_Table_0">
														</div>
													</td>
													<td valign="top"><button type="submit" class="btn btn-primary">查询</button></td>
				                             	</form>
				                                
				                                <form action="${path}/user/searchByAddress?type=${type}" method="post">
													<td  valign="middle" style="padding-left:20px;  padding-right:10px;" >按地址搜索:</td>
													<td>
														<div class="dataTables_filter" id="DataTables_Table_0_filter">
															<input type="text" style="margin-bottom: -2px;width:170px;" id="address" name="address" value="${address}" aria-controls="DataTables_Table_0">
														</div>
													</td>
													<td valign="top"><button type="submit" class="btn btn-primary">搜索</button></td>
												</form>
												
												<form action="${path}/user/searchByMobile?type=${type}" method="post">
													<td  valign="middle" style="padding-left:20px;  padding-right:10px;" >手机号码:</td>
													<td>
														<div class="dataTables_filter" id="DataTables_Table_0_filter">
															<input type="text" style="margin-bottom: -2px;width:170px;" id="mobile" name="mobile" value="${mobile}" aria-controls="DataTables_Table_0">
														</div>
													</td>
													<td valign="top"><button type="submit" class="btn btn-primary">搜索</button></td>
												</form>
				                              </tr>
				                            </table>
										</c:otherwise>
									</c:choose>
								</c:if>
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>会员名称</th>
                                        <th>联系电话</th>
                                        <th>详细地址</th>
                                        <th>注册时间</th>
                                        <c:if test="${viewKey!=1 }">
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
                                        <td>${user.realname}</td>
                                        <td class="center">${user.mobile }
                                        </td>
                                        <td class="center">${user.address }
                                        </td>
                                        <td class="center">${user.createtime }
                                        </td>
                                        <c:if test="${viewKey!=1 }">
											<td>
												<c:if test="${type==0 }">
													<button type="button" class="btn btn-danger" onclick="alertJsp('角色管理','${path }/role/user_role?userId=${user.uid }')">角色管理</button>			
												</c:if>	
												<c:if test="${type==2 }">
													<button type="button" class="btn btn-danger" onclick="toUrl1('${path }/finance/list4Uid?uid=${user.uid}')">统计信息</button>
												</c:if>
												<button type="button" class="btn btn-primary" onclick="toUrl1('${path }/user/detail?uid=${user.uid}')">查看详细</button>
												<button type="button" class="btn" onclick="del('${path }/user/delete?uid=${user.uid}&type=${type}&pg=${pg}')">删除</button>
											</td>
										</c:if>
                                    </tr>
                                </c:forEach>
                                <tr>
									<td colspan="6">
										<div class="pagination pagination-centered">
			                                <div class="bg">
												<div class="r_page">
													<script type="text/javascript">
														var url = location.href;
														var realname = "${realname}";
														//alert(realname);
														if (realname != "") {
															url = url + "&realname=" + realname;
														}
														var address = "${address}";
														if (address != "") {
															url = url + "&address=" + address;
														}
														var mobile = "${mobile}";
														if (mobile != "") {
															url = url + "&mobile=" + mobile;
														}
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
            <!-- end: Content -->

        </div>
        <!--/fluid-row-->
        <!--/row-->

    </div>
    <!--/fluid-row-->
    <div class="modal hide fade" id="myModal">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">×</button>
            <h3>删除操作</h3>
        </div>
        <div class="modal-body">
            <p>您确定要删除该信息吗？...</p>
        </div>
        <div class="modal-footer">
            <a href="#" class="btn" data-dismiss="modal">取消</a>
            <a href="#" class="btn btn-primary">删除</a>
        </div>
    </div>

    <div class="modal hide fade" id="pinglundiv">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">×</button>
            <h3>动态评论管理（999条）</h3>
        </div>
        <div class="modal-body">
            <table class="table table-bordered table-striped table-condensed">
                <thead>
                    <tr>
                        <th>名称</th>
                        <th>排序</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>惠城科技征集禹州撰稿人</td>
                        <td class="center">5</td>
                        <td class="center">
                            <button type="button" class="btn btn-primary">修改</button>
                            <button type="button" class="btn">删除</button>
                        </td>
                    </tr>
                    <tr>
                        <td>惠城科技有限公司招聘启事</td>
                        <td class="center">5</td>
                        <td class="center">
                            <button type="button" class="btn btn-primary">修改</button>
                            <button type="button" class="btn">删除</button>
                        </td>
                    </tr>
                    <tr>
                        <td>乐享云购诚邀诚信商户加盟</td>
                        <td class="center">5</td>
                        <td class="center">
                            <button type="button" class="btn btn-primary">修改</button>
                            <button type="button" class="btn">删除</button>
                        </td>
                    </tr>
                    <tr>
                        <td>热烈庆贺乐享云购手机APP盛大公测</td>
                        <td class="center">5</td>
                        <td class="center">
                            <button type="button" class="btn btn-primary">修改</button>
                            <button type="button" class="btn">删除</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="modal-footer">
            <a href="#" class="btn" data-dismiss="modal">关闭</a>
        </div>
    </div>

    <div class="clearfix"></div>
    <footer>
        <p>
            <span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
        </p>

    </footer>


    <!--/.fluid-container-->
</body>
</html>

