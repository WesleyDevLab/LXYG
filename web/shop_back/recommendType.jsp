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

// 校验是否全由数字组成
function isDigit(digit) {
	var patrn = /^[0-9]*$/;
	return patrn.test(digit);
}

function delRecord(shopId) {
	/* var shopId = "";
	var ids = document.getElementsByName("ids");
	for ( var i = 0; i < ids.length; i++) {
		if (ids[i].type == "checkbox" && ids[i].checked) {
			shopId += ids[i].value + ",";
		}
	} */
	if (confirm("确定要删除吗?", "警告")) {	
		$.post("${path }/shop/delRec", {
			"shopId" : shopId
		}, function(data) {
			if (data == '0') {
				alert("删除成功！");
				location.href = "${path }/shop/preRecomend?type=${type}";
			} else {
				alert("删除失败！");
			}
		});
	}
}

function getRec(type){
	location.href="${path}/shop/preRecomend?type="+type;
}

function add(type){
	location.href="${path}/shop/preAddRec?type="+type;
}

function upOrderBy(){
	var stid = "";
	var ids = document.getElementsByName("ids"); 
	for(var i=0;i<ids.length;i++){
		if(ids[i].type== "checkbox" && ids[i].checked){ 
			stid += ids[i].value+",";
		}
	}
	var cid = stid.split(',');
	var orderby = $("#orderby").val();
	if(cid[0] == "") {
		alert("最少选择一个！");
		return;
	} else if(cid.length-1 > 1){
		alert("只能选择一个！");
		return;
	} else if(orderby == "" || !isDigit(orderby)){
		alert("请输入数字，或者输入不是数字！");
		return;
	} else {
		var id = cid[0];
		$.post("${path }/shop/updateRecomend",{"id":id,"orderby":orderby},function(data){
		 	if(data=='0'){
				alert("修改成功！");
				location.href="${path }/shop/preRecomend?type=${type}";
			}else{
				alert("修改失败！");
			}
		});
	}
}
</script>
</head>
<%@ include file="../common/top.jsp"%>
<body>
	<!--  <div class="right_con">
		<form name="form2" id="form2" method="post">
			<div class="caozuo">
			<input name="" type="button" value="全选" 	onclick="selectAll(document.form2);" class="caozuo_input f_l" />
			<input name="" type="button" value="反选"		onclick="unselectAll(document.form2);" class="caozuo_input f_l" />
			<input name="" type="button" value="删除" onclick="delRecord();"	class="caozuo_input f_l" />
			<input name="orderby" id="orderby" value="" class="caozuo_input_shuru" style="width=20px;" />
			<input name="" type="button" value="修改排序" onclick="upOrderBy();"  class="caozuo_input f_l"/>	
			<select name="drawList" id="draw" class="b_block  width_35" onchange="getRec(this.value);"  style="float: left;display: inline;" >
								 <option value="5"> 推荐 </option>
														
								<c:forEach items="${drawList}" var="draw"> 
								<c:choose>
								<c:when test="${draw.drawid==type}">  
									<option value="${draw.drawid}" selected="selected">	${draw.title}</option>
								</c:when>
								<c:otherwise>
									<option value="${draw.drawid}">	${draw.title}</option>
								</c:otherwise>
							</c:choose>		
							 
								</c:forEach>
								
							</select> 
					<input type="button" value="添加" class="caozuo_input f_l" onclick="add('${type}')" >
			
				</div>
				<div class="bor">
				<div class="bar_blue">
				填写广告信息
			</div>
				<div class="bor_con">
				<table border="0" cellpadding="4" cellspacing="1" width="100%">
					<thead>
						<tr>
							<th>选择</th>
							<th>商家名称</th>  
							<th>排序</th>  
						</tr>
					</thead>

					<tbody>
					<c:if test="${empty pageBean.list}">
							<tr height="30" style="text-align: center;">
								<td colspan="6"><font style="font-size:16px;" color="red">暂无相关数据!</font>
								</td>
							</tr>
					</c:if>
					<c:forEach items="${pageBean.list}" var="shop" varStatus="loopStatus">
						<tr>
							<td align="left"><input type="checkbox" name="ids" id="ids"
								class="nobor" value="${shop.id}" />
							</td>
							<td>
								<a class="bj" href="${path }/shop/view?shopId=${shop.shopid}">${shop.shopname}</a>
							</td>
							<td>${shop.orderby}
							</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="2">
							<div class="bg">
								<div class="r_page">
									<script type="text/javascript">
										var url = location.href;
										var pageOne = new PageObject(url,'${pg}','${pageBean.totalPage}','${pageBean.totalRow}','pageOne');
									</script>
									<div class="clear"></div>
								</div>
							</div>
						</td>
					</tr>
					</tbody>
				</table>
			</div>
		</div>
		</form>
	</div>-->
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
                        		<c:if test="${viewKey!=2 }">
                        		<input name="orderby" id="orderby" class="input-xlarge" style="width:40px;" />
								<input type="button" value="修改排序" onclick="upOrderBy()"  class="btn btn-danger"/>
								<div class="btn-group">
								  <button class="btn btn-default btn-sm dropdown-toggle" type="button" data-toggle="dropdown">
									分类筛选<span class="caret"></span>
								  </button>
								  <ul class="dropdown-menu" role="menu">
							  		<li><a href="javascript:void(0)" onclick="getRec('5')">推荐</a></li>
								  	<c:forEach items="${drawList}" var="draw">
								  		<li><a href="javascript:void(0)" onclick="getRec('${draw.drawid}')">${draw.title}</a></li>
									</c:forEach>
								  </ul>
								  <input type="button" onclick="add('${type}')" value="添加" class="btn btn-primary" />
								</div> 
								</c:if>
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>选择</th>
                                        <th>商家名称</th>
                                        <th>排序</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${pageBean.list}" var="shop" varStatus="loopStatus">
                                    <tr>
                                        <td>
                                            <label class="checkbox">
                                                <input type="checkbox" name="ids" id="ids" value="${shop.id}" />
                                            </label>
                                        </td>
                                        <td>
                                        	<a class="bj" href="${path }/shop/view?shopId=${shop.shopid}">${shop.shopname}</a>
                                        </td>
                                        <td>${shop.orderby}
                                        </td>
                                        <td>
                                            <input type="button" class="btn" onclick="delRecord('${shop.id}')" value="删除" />
                                        </td>
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
</body>
</html>