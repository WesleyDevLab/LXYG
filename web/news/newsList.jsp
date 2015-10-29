<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function alertJsp(text, url) {
	art.dialog.open(url, {
		lock : true,
		title : text,
		width : '800px',
		height : '500px'
	});
}

function init() {
	initRow();
}

function toUrl(url) {
	location.href = url;
}

function toUrl2(url, type) {
	location.href = url + "?type=" + type;
}

function newsByCol(val) {
	if (val != 0) {
		location.href = "${path}/news/list?parentId=${parentId}&pg=${pg}&resParId=${resParId}&colId="
				+ val;
	}
}

function delRecord(newsId) {
	if(confirm("确定要删除此条动态？")) {
		$.post("${path }/news/del", {
			"newsId" : newsId
		}, function(data) {
			if (data == '0') {
				alert("删除成功！");
				location.href = "${path }/news/list?parentId=${parentId}&resParId=${resParId}&pg=${pg}";
			} else {
				alert("删除失败！");
			}
		});
	}
}

function update(newsId, uid) {
	location.href = "${path}/news/preEdit?newsId=" + newsId
			+ "&parentId=${parentId}&resParId=${resParId}";
}

function closeMess(newsId, val) {
	$ .post( "${path }/news/automessage?parentId=${parentId}&resParId=${resParId}", {
		"newsId" : newsId,
		"automessage" : val
	}, function(data) {
		if (data == '0') {
			location.href = "${path}/news/list?parentId=${parentId}&resParId=${resParId}&pg=${pg}";
		} else {
		}
	});
}

function upOrderBy() {
	var newsId = "";
	var ids = document.getElementsByName("ids");
	for ( var i = 0; i < ids.length; i++) {
		if (ids[i].type == "checkbox" && ids[i].checked) {
			newsId += ids[i].value + ",";
		}
	}
	var cid = newsId.split(',');
	if (cid.length - 1 > 1) {
		alert("只能选择一个");
		return;
	} else {
		var id = cid[0];
		var orderby = $("#orderby").val();
		$.post("${path }/news/update", {
			"id" : id,
			"orderby" : orderby
		}, function(data) {
			if (data == '0') {
				alert("修改成功！");
				location.href = "${path }/news/list?parentId=${parentId}&resParId=76&pg=${pg}";
			} else {
				alert("修改失败！");
			}
		});
	}
}
</script>
</head>
<body onload="init()">
<%@ include file="../common/top.jsp"%>
	  <!-- start: Content -->
            <div id="content" class="span10">
                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2><i class="icon-align-justify"></i><span class="break"></span>动态管理</h2>
                            <div class="box-icon">
                            	<c:if test="${viewKey!=2 }">
                                <a href="javascript:void(0)" onclick="toUrl('${path}/news/preAdd?parentId=${parentId}&resParId=${resParId}');" class="btn-add">
                                	<i class="icon-edit" style="width:60px">添加</i>
                                </a>
                                </c:if>
                                <c:if test="${viewKey==2 }">
                                <a href="javascript:void(0)" onclick="toUrl2('${path }/home/viewDate',2)" class="btn-setting">
                                	<i class="icon-wrench" style="width:60px;">审阅</i>
                                </a> 
								</c:if>
                            </div>
                        </div>
                        <div class="box-content">
                        	<div style="margin:10px 0;">
                        		<c:if test="${viewKey!=2 }">
								<button type="button" onclick="toUrl('${path }/news/myList?parentId=${parentId }&resParId=${resParId }')" class="btn btn-primary">我发布的动态</button>
								<div class="btn-group">
								  <button class="btn btn-default btn-sm dropdown-toggle" type="button" data-toggle="dropdown">
									分类筛选<span class="caret"></span>
								  </button>
								  <ul class="dropdown-menu" role="menu">
								  	<c:forEach items="${colList }" var="col">
										<li><a href="javascript:void(0)" onclick="newsByCol('${col.id}')">${col.cname}</a></li>
									</c:forEach>
								  </ul>
								</div>
								</c:if>
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>新闻标题</th>
                                        <th>作者</th>
                                        <th>创建时间</th>
                                        <th>类型</th>
                                        <th>排序</th>
                                        <c:if test="${viewKey!=2 }">
											<th>操作</th>
										</c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${pageBean.list}" var="news" varStatus="loopStatus">
                                    <tr>
                                        <td>
                                            ${loopStatus.count}
                                        </td>
                                        <td>${news.title}</td>
                                        <td class="center">${news.username }
                                        </td>
                                        <td class="center">${news.createtime}
                                        </td>
                                        <td class="center">${news.cname}
                                        </td>
                                        <td class="center">${news.orderby}
                                        </td>
                                        <c:if test="${viewKey!=2 }">
	                                        <td class="center">
												<c:if test="${news.automessage==0 }">
												 	<button type="button" class="btn btn-danger" onclick="closeMess('${news.newsid}','1');">关闭评论</button>
												</c:if> 
												<c:if test="${news.automessage==1 }">
													<button type="button" class="btn btn-success" onclick="closeMess('${news.newsid}','0');">开启评论</button>
												</c:if> 
												<c:if test="${session['user'].uid==news.author}">
												    <button type="button" class="btn btn-primary" onclick="update('${news.newsid}','${news.author}');">修改</button>
												    <button type="button" class="btn" onclick="delRecord('${news.newsid}')">删除</button>
												</c:if> 
				                                <button type="button" class="btn" onclick="alertJsp('评论详情','${path }/news/getMessage?newsId=${news.newsid}&parentId=${parentId }')">查看评论</</button>
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