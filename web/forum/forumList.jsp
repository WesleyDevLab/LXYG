<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%> 
<%@ include file="/common/taglibs.jsp" %> 
<!DOCTYPE HTML >
<html>
  <head>
	<jsp:include page="/metro.jsp"></jsp:include>

 <script type="text/javascript">

 	function init(){
		initRow();			
	}
 	function toUrl(url){
 		location.href=url;
 	}
 	function toUrl2(val){
 		location.href="${path}/forum/list?parId="+val;
 	}
     function loadInfo(page){
         var totalPage=${forms.totalPage};
         if(page==0){
             page=${forms.pageNumber}-1;
         }
         if(page==-1){
             page=${forms.pageNumber}+1;
         }
         if(page>totalPage || page<=0){
             alert("已经是最后一页");
             return;
         }
         location.href="${path}/app/user/v2/listForm/listForm?pg="+page+"&type=web"
     }


 	function delRecord(fid) {
        console.info(fid);
        $.post("${path}/app/user/v2/adminDelForm",{"formId":fid},function(result){
            if(result.code==10002){
                alert("删除成功");
                location.reload();
            }
        })
	}
	function update(forumId) {
		location.href = "${path}/forum/preEdit?forumId=" + forumId;
	}
 </script>
</head>
<%@ include file="../common/top.jsp"%>
<body >
<!-- <form name="form2" id="form2" method="post">
	<div class="right_con">
		<div class="caozuo">
		<form id="form1" name="form1">
			<input name="" type="button" value="全选" onclick="selectAll(document.form2);"  class="caozuo_input f_l" />
			<input name="" type="button" value="反选" onclick="unselectAll(document.form2);" class="caozuo_input f_l" />
			<input name="" type="button" value="删除" onclick="delRecord();" class="caozuo_input f_l" />
			<input type="button" value="添加" onclick="toUrl('${path }/forum/preAdd');"
				class="caozuo_input f_l" />
			<input name="input" type="button" value="返回" onclick="javascript:history.back()" class="caozuo_input f_l" />
			  <select  class="caozuo_input f_l" onchange="toUrl2(this.value);">
				<c:forEach items="${faList }" var="fa">
				<c:choose>
				<c:when test="${fa.fid==parId}">
				<option value="${fa.fid }" selected="selected">${fa.fname}</option>
				</c:when>
				<c:otherwise>
				<option value="${fa.fid }">${fa.fname}</option>
				</c:otherwise>
				</c:choose>
				
				</c:forEach>
			</select> 
			</form>
		</div>
		<div class="tab">
			<table border="0" cellpadding="4" cellspacing="1" width="100%">
				<thead>
					<tr>
						<th>选择</th>
						<th>分类名称</th>
						<th>URL</th>
						<th>描述</th>						 
						<th>操作</th>
					</tr>
				</thead>

				<tbody>
					<c:if test="${empty pageBean.list}">
						<tr height="30" style="text-align: center;">
							<td colspan="6"><font style="font-size:16px;" color="red">暂无相关数据!</font>
							</td>
						</tr>
					</c:if>
					<c:forEach items="${pageBean.list}" var="forum" varStatus="loopStatus">
						<tr>
							<td align="left"><input type="checkbox" name="ids" id="ids" class="nobor" value="${forum.fid}"/> </td>
							<td>${forum.fname}</td>
							<td>${forum.url }</td>
							<td>${forum.content }</td>
							<td>						 
							<a class="bj" href="javascript:update('${forum.fid}')">修改</a>
							</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="8"><div class="bg">
								<div class="r_page">
							<script type="text/javascript">
								var url = location.href;
								var pageOne = new PageObject(url,
										'${pg}',
										'${pageBean.totalPage}',
										'${pageBean.totalRow}',
										'pageOne');
							</script>
							<div class="clear"></div>
						</div>
								<div class="clear"></div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</form>-->
   <!-- start: Content -->
            <div id="content" class="span10">

                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2><i class="icon-align-justify"></i><span class="break"></span>论坛管理</h2>
                              <div class="box-icon">
                                <a href="javascript:void(0)" onclick="toUrl('${path }/forum/preAdd');" class="btn-add">
                                	<i class="icon-edit" style="width:60px">添加</i>
                                </a>
                            </div>
                        </div>
                        <div class="box-content">
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>内容</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                	<c:forEach items="${forms.list}" var="forum" varStatus="loopStatus">
                                    <tr>
                                        <td>
                                            ${loopStatus.count }
                                        </td>
                                        <td class="center">${forum.content }
                                        </td>
                                        <td class="center">
                                           <!-- <button type="button" class="btn btn-primary" onclick="update('${forum.form_id}')">修改</button>-->
                                            <button type="button" class="btn btn-danger"  onclick="delRecord('${forum.form_id}');">删除</button>
                                            <button type="button" class="btn btn-info" onclick="moreInfo('${forum.form_id}')">详情</button>
                                        </td>
                                    </tr></c:forEach>
                                </tbody>
                            </table>
                            <div class="pagination pagination-centered">
                              <div class="bg">
                                  <div class="r_page">
                                      <li id="page">
                                          第${forms.pageNumber}/${forms.totalPage}页    共${forms.totalRow}条
                                      </li>

                                      <li><a onclick="loadInfo(1)">首页</a></li>
                                      <li><a class="active" onclick="loadInfo(0)">上一页</a></li>
                                      <li><a class="active"  onclick="loadInfo(-1)">下一页</a></li>
                                      <li><a onclick="loadInfo(${forms.totalPage})">末页</a></li>
                                      跳转到第
                                      <input id="toPage" style="width:20px;ime-mode:disabled;" size="4">
                                      页
                                      <a class="label label-success"  onclick="loadInfo($(this).prev('input').val())">跳转</a>
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
    <!--<div class="modal hide fade" id="myModal">
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
-->
    <div class="clearfix"></div>
    <footer>
        <p>
            <span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
        </p>

    </footer>


</body>
</html>