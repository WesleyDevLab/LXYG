<%@ page language="java" contentType="text/html;" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>

<!DOCTYPE HTML>
<html>
<head>

<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script>
<script type="text/javascript" src="${path }/public/js/jquery.form.js"></script>
<script charset="utf-8" src="${path }/public/kindeditor/kindeditor.js"></script>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">

$(function(){
var type="<option value=0> 请选择... </option>";
 $.get("${path}/goods/loadGoodsAttribute",function(result){
       if(result.code==10010){
	       for(var i=0;i<result.type.length;i++){
	           type+="<option value="+result.type[i].id+">"+result.type[i].name+" </option>"
	       }
	       $("#column_type").append(type);
       }
    });
      
});

//表单提交验证
function checkForm() {
    var title = $("#title").val();
    var columnId = $("#columnId").val();
    var typeText=$("#column_type").find("option:selected").text();
	var typeValue=$("#column_type").val();
	
	if(title==""){
		alert("品牌名字没有填写！");
		return false;
	}
	if(typeValue==0){
		alert("产品类别没有选择！");
		return false;
	}
	
	$.post("${path}/goods/addProductBrand",{"brandname":title,"typeId":typeValue,"typeName":typeText},function(result){
	   if(result.code==10010){
	       alert("添加成功！");
	       window.location.href="${path}/pageTo/productBrand";
	   }else{
	      alert("添加失败！");
	   }
	});
}

</script>

</head>
<%@ include file="../common/top.jsp"%>
<body>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
					</h2>
				</div>
				<div class="box-content">
					<form class="form-horizontal" id="draw_ajax" enctype="multipart/form-data"  method="post">
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">标题：</label>
							<div class="controls">
								<input type="text" name="draw.title" id="title" onkeyup="this.value=this.value.substring(0,50)" class="span6 typeahead" />
								<p class="help-block">请填写标题，不要超过50个字</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="selectError3">所属栏目：</label>
							<div class="controls">
									<select name="draw.columnid" id="column_type">
									
									</select>
							</div>
						</div>
						<div class="form-actions">
							<input type="button" value="确定" class="btn btn-primary" onclick="checkForm()" />
							<input type="reset" value="重置" class="btn" />
						</div>
					</fieldset>
					</form>
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
    <%@include file="/common/bottom.jsp" %>
</body>
</html>