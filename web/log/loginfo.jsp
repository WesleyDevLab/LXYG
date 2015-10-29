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

function delRecord() {
	var id = "";
	var ids = document.getElementsByName("ids");
	for ( var i = 0; i < ids.length; i++) {
		if (ids[i].type == "checkbox" && ids[i].checked) {
			id += ids[i].value + ",";
		}
	}
	if(id != null) {
		id = id.substring(0, id.length-1);
	}
	$.post("${path}/log/del", {
		"ids" : id
	}, function(data) {
		if (data == '0') {
			alert("删除成功！");
			location.href = "${path}/log";
		} else {
			alert("删除失败！");
		}
	});
}

function search() {
	$("#form1").submit();
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
								<div class="btn-group">
									<form id="form1" method="post" action="${path }/log/search">
										<label>会员名称：
											<input name="realname" class="input-xlarge" />
											<input type="submit" value="查询" onclick="search()"  class="btn btn-primary"/>
											<input type="button" value="删除" onclick="delRecord()" class="btn btn-danger" />
										</label>
								  	</form>
								</div> 
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th width="4%" >选择</th>
										<th width="19%">操作员</th>
										<th width="17%">操作类型</th>
										<th width="20%">操作内容</th>
										<th width="20%">登录IP</th>
										<th width="20%">操作时间</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${pg.list}" var="log" varStatus="loopStatus">
                                    <tr>
                                        <td align="left">
                                        	<label class="checkbox">
                                                <input type="checkbox" name="ids" id="ids" value="${log.id}" />
                                            </label>
                                        </td>
										<td>${log.realname}</td>
										<td>${log.action}</td>
										<td>${log.remark}</td>
										<td>${log.userip}</td>
										<td>${log.createtime}</td>
                                    </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <div class="pagination pagination-centered">
                               <div class="bg">
									<div class="r_page">
										<script type="text/javascript">
											var url = location.href;
											var pageOne = new PageObject(url,'${page}','${pg.totalPage}','${pg.totalRow}','pageOne');
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
<div class="c_m_bj"><span class="title02">系统管理&nbsp;--&gt;&nbsp;日志管理</span></div>
	<div class="right_con">
	  	<div class="caozuo">
	  	<form id="form1" method="post" action="${path }/log/search">
	  		<input type="button" value="全选" onclick="selectAll(document.form2);"  class="caozuo_input f_l" />
			<input type="button" value="反选" onclick="unselectAll(document.form2);" class="caozuo_input f_l" />
			<input type="button" value="删除" onclick="delRecord();" class="caozuo_input f_l" />
			<input name="realname" class="caozuo_input_shuru" placeholder="操作员等" />
			<input type="submit" value="查询" onclick="search();"  class="caozuo_input f_l"/>
	  	</form>
	  	</div>
	<div class="tab">
		<table border="0" cellpadding="4" cellspacing="1" width="100%">
		<thead>
			<tr>
				<th width="4%" >选择</th>
				<th width="19%">操作员</th>
				<th width="17%">操作类型</th>
				<th width="20%">操作内容</th>
				<th width="20%">登录IP</th>
				<th width="20%">操作时间</th>
			</tr>
		</thead>

		<tbody>
			<c:if test="${empty pg.list}">
				<tr height="30" style="text-align: center;">
					<td colspan="6"><font style="font-size:16px;" color="red">暂无相关数据!</font>
					</td>
				</tr>
			</c:if>
			<c:if test="${!empty pg.list}">
				<c:forEach items="${pg.list}" var="log" varStatus="loopStatus">
					<tr>
						<td align="left"><input type="checkbox" name="ids" id="ids" class="nobor" value="${log.id}"/></td>
						<td>${log.realname}</td>
						<td>${log.action}</td>
						<td>${log.remark}</td>
						<td>${log.userip}</td>
						<td>${log.createtime}</td>
					</tr>
				</c:forEach>
				<tr>
					<td colspan="6">
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
</form> --%>
</body>
</html>

