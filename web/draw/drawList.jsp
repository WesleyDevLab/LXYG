<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %> 
<!DOCTYPE HTML >
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
$(function(){
   loadData();
});

function loadData(){
     var type="";
     var brand="";
     $.get("${path}/goods/loadGoodsAttribute",function(result){
       if(result.code==10010){
	       for(var i=0;i<result.type.length;i++){
	           type+="<li><a href='javascript:void(0);' value="+result.type[i].id+"  onclick='searchByType($(this))' >"+result.type[i].name+"</a></li>"
	           
	       }
	        for(var i=0;i<result.brand.length;i++){
	           var b=result.brand[i]
	           brand+="<tr><td align='center'>"+b.id+"</td><td align='center'>"+b.name+"</td><td>"+b.p_type_name+"</td><td class='center'>"+
                      "<button type='button' class='btn btn-primary' onclick='JavaScript:update('${draw.drawid}');'>修改</button>"+
		              "<button type='button' class='btn' value='"+b.id+"' onclick='JavaScript:delRecord($(this));'>删除</button>	</td></tr>";
	       }
       }
        $("#column_type").append(type);
        $("#brand_list").append(brand);
    });
}

function searchByType(v){
  var typeId=v.attr("value");
  var brand="";
  $("#brand_list").text(brand);
  $.post("${path}/goods/loadGoodsAttribute",{"typeId":typeId},function(result){
     if(result.code==10010){
       for(var i=0;i<result.brand.length;i++){
         var b=result.brand[i];
         brand+="<tr><td align='center'>"+b.id+"</td><td align='center'>"+b.name+"</td><td>"+b.p_type_name+"</td><td class='center'>"+
                      "<button type='button' class='btn btn-primary' onclick='JavaScript:update('${draw.drawid}');'>修改</button>"+
		              "<button type='button' class='btn' onclick='JavaScript:delRecord($(this));'>删除</button>	</td></tr>";       
       }
       $("#brand_list").append(brand);
     }
     
  });
}

function delRecord(obj){
if(confirm("确定要删除产品品牌嘛？这样做或许会出现重大错误")){
     var v=obj.val();
	 $.post("${path}/goods/delProductBrand",{"brandId":v},function(result){
	      if(result.code==10010){
	         obj.parent().parent().remove();
	         alert(result.message);
	      }else{
	         alert(result.message);
	      }
	   });
	}
}

</script>
</head>
<%@ include file="../common/top.jsp"%>
<body >
    <!-- start: Content -->
            <div id="content" class="span10">
                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2>
	                            <i class="icon-align-justify"></i>
	                            <span class="break">
	                                                                                     产品品牌管理
	                            </span>
                            </h2>
                            <div class="box-icon">
								<a href="${path}/pageTo/addProductBrand"  class="btn-add"><i class="icon-edit" style="width:60px;">添加</i></a>                               
                            </div>
                        </div>
                        <div class="box-content" style="min-height: 600px">
                        	<div style="margin:10px 0;">
								<div class="btn-group">
								  <button class="btn btn-default btn-sm dropdown-toggle" type="button" data-toggle="dropdown">
									分类筛选<span class="caret"></span>
								  </button>
								  <ul class="dropdown-menu" role="menu" id="column_type">
									  <!--   <li><a href="javascript:void(0)" onclick="drawByCol('${col.id }')">${col.cname}</a></li>-->
								  </ul>
								</div>
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                    	<th align="center">序号</th>
                                        <th align="center">品牌名</th>
                                        <th align="center">所属类别</th>
                                        <th align="center">操作</th>
                                    </tr>
                                </thead>
                                <tbody id="brand_list">
                               
                                </tbody>
                            </table>
                            <div class="pagination pagination-centered">
                                <ul>
	                                <div class="bg">
										<div class="r_page">
											<script type="text/javascript">
												var url = location.href;
												var pageOne = new PageObject(url,'${pg}','${page.totalPage}','${page.totalRow}','pageOne');
											</script>
										</div>
									</div>
                                </ul>
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

    <div class="clearfix"></div>
    <%@include file="/common/bottom.jsp" %>
</body>
</html>
