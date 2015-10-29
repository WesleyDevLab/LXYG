<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %> 
<!DOCTYPE HTML>
<html>
  <head>
  <title>栏目列表页</title>
  <jsp:include page="/metro.jsp"></jsp:include>
<script src="${path }/public/treeTable/script/treeTable/jquery.treeTable.js" type="text/javascript"></script>
<style type="text/css">
table,td,th {  border: 1px solid #8DB9DB; padding:5px; border-collapse: collapse; font-size:16px; }
</style>
<link href="${path }/public/treeTable/script/treeTable/vsStyle/jquery.treeTable.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
        $(function(){
            var option = {
                theme:'vsStyle',
                expandLevel : 2,
                beforeExpand : function($treeTable, id) {
                    //判断id是否已经有了孩子节点，如果有了就不再加载，这样就可以起到缓存的作用
                    if ($('.' + id, $treeTable).length) { return; }
                    //这里的html可以是ajax请求
                    var html = '<tr id="8" pId="6"><td>5.1</td><td>可以是ajax请求来的内容</td></tr>'
                             + '<tr id="9" pId="6"><td>5.2</td><td>动态的内容</td></tr>';

                    $treeTable.addChilds(html);
                },
                onSelect : function($treeTable, id) {
                    window.console && console.log('onSelect:' + id);
                    
                }

            };
            $('#treeTable1').treeTable(option);
 
        });
        </script>
</head>
<%@ include file="../common/top.jsp"%>
    <body>
   <!--  <div id="page">         
        <div> 
            <table id="treeTable1" style="width:100%">
                <tr>
                    <td style="width:200px;">标题</td>
                </tr> 
                <c:forEach items="${res}" var="res">
                 <tr id="${res.resid }">
                    <td><span controller="true"><input type="checkbox"> ${res.resname}</span></td>
                    </tr> 
				<c:forEach items="${res2}" var="res2">
				
					<c:if test="${res2.parentid==res.resid }">
						  <tr id="${res2.resid }" pId="${res.resid }">
                    <td><span controller="true"><input type="checkbox">${res2.resname} </span></td>
                    </tr> 
				 </c:if>
					</c:forEach>  
					</c:forEach> 
               
            </table>
             
        </div>
    </div> -->
    <!-- start: Content -->
            <div id="content" class="span10">
                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2><i class="icon-align-justify"></i><span class="break"></span>菜单管理</h2>
                            
                        </div>
                            <table class="table table-bordered table-striped table-condensed">
                                    <tr>
                                       标题
                                    </tr>
                                <c:forEach items="${res}" var="res">
                 <tr id="${res.resid }">
                    <td><span controller="true"><input type="checkbox"> ${res.resname}</span></td>
                    </tr> 
				<c:forEach items="${res2}" var="res2">
				
					<c:if test="${res2.parentid==res.resid }">
						  <tr id="${res2.resid }" pId="${res.resid }">
                    <td><span controller="true"><input type="checkbox">${res2.resname} </span></td>
                    </tr> 
				 </c:if>
					</c:forEach>  
					</c:forEach> 
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
