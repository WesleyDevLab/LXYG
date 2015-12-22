<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%> 

<!DOCTYPE HTML>
<html>
<head>
<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script>
<script type="text/javascript" src="${path }/public/js/jquery.form.js"></script>
<jsp:include page="/metro.jsp"></jsp:include>
<%--<script type="text/javascript" src="${path }/js/jquery.fileupload.js"></script>--%>
<script type="text/javascript" src="${path }/public/kindeditor/kindeditor.js"></script>
<script type="text/javascript" src="${path }/public/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${path}/upYun/lib/async.js"></script>
	<script type="text/javascript" src="${path}/upYun/lib/spark-md5.js"></script>
	<script type="text/javascript" src="${path}/upYun/lib/upyun-mu.js"></script>
	<script type="text/javascript" src="${path}/upYun/lib/uuid.js"></script>
<script type="text/javascript">
var serverUrl="${qiniuServer}";
var imgCover="";
var imgs=new Array();

$(document).ready(function(){
	var type="<option value=0> 请选择... </option>";
	var brand="<option value=0> 请选择... </option>";
	var unit="<option value=0> 请选择... </option>";
	var payType="";
	var server="<option value=0> 请选择... </option>";
    var url="${path}/goods/loadGoodsAttribute";
    $.get(url,function(result){
       if(result.code==10010){
	       for(var i=0;i<result.type.length;i++){
	           type+="<option value="+result.type[i].id+"> "+result.type[i].name+" </option>"
	       }
	        for(var i=0;i<result.unit.length;i++){
	           unit+="<option value="+result.unit[i].id+"> "+result.unit[i].name+" </option>"
	       }
	        for(var i=0;i<result.payType.length;i++){
	           payType+="<input type='checkbox' name='payType'  value="+result.payType[i].id+"><span style='padding-right:10px'>"+result.payType[i].pay_type_name+"</span>"
	       }
	       for(var i=0;i<result.server.length;i++){
	           server+="<option value="+result.server[i].id+"> "+result.server[i].type_name+" </option>"
	       }
	       $("#column_type").append(type);
	       $("#column_unit").append(unit);
	       $("#column_server").append(server);
	       $("#column_payType").append(payType);
		   $("#fb_column_unit").append(unit);
       }
    });  
});


function showImg(type){
	if(type==1){
		var files=document.getElementById('coverFile').files;
		for(var i=0;i<files.length;i++){
			var file=files[i];
			var fileReader=new FileReader();
			fileReader.onloadend=function(e){
				$("#imgs").append('<img width="100px" height="100px"  src='+e.target.result+'></img>')
			}
			fileReader.readAsDataURL(file);
		}
		imgCover=selectFile(files)[0];
	}
	if(type==2){
		var files=document.getElementById('coverFiles').files;
		for(var i=0;i<files.length;i++){
			var file=files[i];
			var fileReader=new FileReader();
			fileReader.onloadend=function(e){
				$("#imgss").append('<img width="100px" height="100px"  src='+e.target.result+'></img>')
			}
			fileReader.readAsDataURL(file);
		}
		imgs=selectFile(files);
	}
}

function selectFile(files){
	var img_urls=new Array();
	for(var i=0;i<files.length;i++){
		var ext = '.' +files[i].name.split('.').pop();
		var path='/platform/' + Math.uuid(16,"")+ext;
		uploadImg(path,files[i])
		img_urls[i]=path;
	}
	return img_urls;
}

function uploadImg(path,file){
	var config={
		bucket:'lxyg8',
		expiration: parseInt((new Date().getTime() + 3600000) / 1000),
		form_api_secret: 'Jcrn4om4KRTt6FTvMb04r72P4XU='
	};
	var instance=new Sand(config);
	var options = {
		'notify_url': 'http://upyun.com'
	};
	instance.setOptions(options);
	instance.upload(path,file);
};





<%--$(function(){--%>
	<%--$("#img").click(function(){--%>
		<%--$("#coverFile").click();--%>
	<%--});--%>
	<%--$("#coverFile").fileupload({--%>
		<%--url: "http://upload.qiniu.com/",--%>
		<%--formData:{--%>
			<%--"token": "${token}"--%>
		<%--},--%>
		<%--done: function (e, data) {--%>
			<%--$("#img").html("上传成功,读取中...");--%>
			<%--if(data.result.key && data.result.hash){--%>
				<%--imgCover=data.result.key;--%>
				<%--var url=serverUrl+data.result.key--%>
				<%--$("#imgs").append("<img key='"+data.result.key+"' src='"+url+"' style='width:100px;height:100px;padding:5px' />")--%>
			<%--}else{--%>
				<%--alert("上传失败");--%>
			<%--}--%>
		<%--},--%>
		<%--progressall: function (e, data) {--%>
			<%--var progress = data.loaded / data.total;--%>
		<%--},--%>
		<%--start:function(e){--%>
			<%--$("#img").html("上传中...");--%>
		<%--}--%>
	<%--});--%>
<%--});--%>


 <%--var i=0;--%>
<%--$(function(){--%>
   <%--$("#details").click(function(){--%>
		<%--$("#coverFiles").click();--%>
	<%--});--%>
   <%--$("#coverFiles").fileupload({--%>
        <%--url: "http://upload.qiniu.com/",--%>
        <%--formData:{--%>
        	<%--"token": "${token}"--%>
        <%--},--%>
        <%--done: function (e, data) {--%>
        	<%--$("#details").html("上传成功,读取中...");--%>
	        <%--if(data.result.key && data.result.hash){--%>
	        <%--var url=serverUrl+data.result.key--%>
	           <%--$("#imgss").append("<img key='"+data.result.key+"' src='"+url+"' style='width:100px;height:100px;padding:5px'/>");--%>
        	   <%--imgs[i]=data.result.key;--%>
        	   <%--i++;--%>
	        <%--}else{--%>
				<%--alert("上传失败");--%>
	        <%--}--%>
        <%--},--%>
        <%--progressall: function (e, data) {--%>
            <%--var progress = data.loaded / data.total;--%>
        <%--},--%>
        <%--start:function(e){--%>
        	<%--$("#details").html("上传中...");--%>
        <%--}--%>
        <%----%>
    <%--});--%>
 <%----%>
<%--});--%>

var editor;
KindEditor.ready(function(K) {
	editor = K.create('textarea[name="play.content"]',
	{
		heigth : '400px',
		cssPath : '${path}/public/kindeditor/plugins/code/prettify.css',
		uploadJson : '${path}/public/kindeditor/jsp/upload_json.jsp',
		fileManagerJson : '${path}/public/kindeditor/jsp/file_manager_json.jsp',
		allowFileManager : true,
		afterCreate : function() {
			this.sync();
		},
		afterChange : function() {
			this.sync();
		}
	});
});

function load(data){
   $.post("${path}/goods/loadBrandByType",{"typeId":data},function(result){
      var brand="";
      $("#column_brand").html(brand);
      if(result.code==10002){
           if(result.brands.length==0){
               $("#column_brand").append("<option  selected='selected' value=0>暂无</option>");
           }else{
	          for(var i=0;i<result.brands.length;i++){
	             brand+="<option  selected='selected' value="+result.brands[i].id+">"+result.brands[i].name+" </option>"
	          }
	          $("#column_brand").append(brand);
           }
      }
   });
}



//表单提交验证
function checkForm() {
	var name=$("#name").val();
	var content=editor.html();
	var title=$("#title").val();
	var price=$("#price").val();
	var market_price=$("#market_price").val();
	var cash_pay=$("#cash_pay").val();
	var code=$("#market_code").val();
	
	var typeText=$("#column_type").find("option:selected").text();
	var typeValue=$("#column_type").val();
	
	var brandText=$("#column_brand").find("option:selected").text();
	var brandValue=$("#column_brand").val();
	
	var unitText=$("#column_unit").find("option:selected").text();
	var unitValue=$("#column_unit").val();
	var isShow;
	
	var serverText=$("#column_server").find("option:selected").text();
	var serverValue=$("#column_server").val();


	var key=new Array();
	var value=new Array();
	$("input[name='payType']").each(function(j){
	    if($(this).is(":checked")){
	      key[j]=this.value;
	      value[j]= $(this).next("span").text(); 
	    }
	});
	
	var payType="[";
	for(var k=0;k<key.length;k++){
	   payType+="{payId:"+key[k]+",payName:"+value[k]+"},"
	}	
	payType=payType.substring(0, payType.length-1)+"]";
	
	
	var imgDetail="";
	if(imgs.length!=0){
	    imgDetail+="[";
		for(var k=0;k<imgs.length;k++){
		   imgDetail+="\""+imgs[k]+"\",";
		}
		imgDetail=imgDetail.substr(0,imgDetail.length-1)+"]";
	}
	
	
	if (name == "") {
		alert("产品名字！");
		return false;
	}
	if (title == "") {
		alert("产品title！");
		return false;
	}
	if (price == "") {
		alert("产品价格！");
		return false;
	}
	if (market_price == "") {
		alert("市场价格！");
		return false;
	} 
	if (cash_pay == "") {
		alert("可用的电子现金券 ！");
		return false;
	}
	
	if($("#isShow").is(":checked")){
	  isShow=1;
	}else{
	  isShow=2;
	}
	
	if(serverValue==0){
	   alert("选择产品来源 ！");
	   return false;
	}
	if(typeValue==0){
	   alert("选择产品类型 ！");
	   return false;
	}
	if(brandValue==0){
	   alert("选择产品品牌 ！");
	   return false;
	}
	if(unitValue==0){
	   alert("选择产品单位 ！");
	   return false;
	}
	
	$.post("${path}/goods/add",{"name":name,"title":title,"price":price*100,"marketPrice":market_price*100,
	           "typeId":typeValue,"code":code,"brandId":brandValue,"unitId":unitValue,"typeName":typeText,"brandName":brandText,"descripation":content,
	           "unitName":unitText,"payment":payType ,"serverId":serverValue,"serverName":serverText,
	           "cashPay":cash_pay,"isShow":isShow,cover:imgCover,"imgs":imgDetail},
	function(result){
	   if(result.code==10010){
	      alert(result.message);
	      $("#imgs").text("");
	      $("#imgss").text("");
	      window.location.href="${path}/pageTo/product";
	   }else{
	      alert(result.message);
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
						<i class="icon-edit"></i>添加产品
					</h2>
				</div>
				<div id="bz" class="box-content" style="display: block">
					<form class="form-horizontal" id="play_ajax" enctype="multipart/form-data" action="${path}/play/add" method="post" />
					<fieldset>
						<div class="control-group">
							<label class="control-label">产品名字：</label>
							<div class="controls">
								<input type="text" name="name" id="name" onkeyup="this.value=this.value.substring(0,50)" class="span6 typeahead" />
								<p class="help-block">* 请填写产品名称，不要超过20个字</p>
							</div>
						</div>
						
						<div class="control-group">
							<label class="control-label" >产品简介：</label>
							<div class="controls">
								<input type="text" name="title" id="title" onkeyup="this.value=this.value.substring(0,50)" class="span6 typeahead" />
								<p class="help-block">请填写产品介绍，不要超过20个字</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" >供货商价格：</label>
							<div class="controls">
								<input type="text" name="price" id="supplier_price" onkeyup="this.value=this.value.substring(0,50)" class="input-xlarge" />
								<p class="help-block">*请填写乐享云购价格，该价格为供货商</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" >乐享云购价格：</label>
							<div class="controls">
								<input type="text" name="price" id="price" onkeyup="this.value=this.value.substring(0,50)" class="input-xlarge" />
								<p class="help-block">*请填写乐享云购价格，该价格为交易价格</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" >市场价格：</label>
							<div class="controls">
								<input type="text" name="markey_price" id="market_price" onkeyup="this.value=this.value.substring(0,50)" class="span6 typeahead" />
								<p class="help-block">*请填写市场价格</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" >可用电子现金券：</label>
							<div class="controls">
								<input type="text" name="cash_pay" id="cash_pay" onkeyup="this.value=this.value.substring(0,5)" class="span6 typeahead" />
								<p class="help-block">该产品可以使用的电子现金打折券</p>
							</div>
						</div>


						<div class="control-group">
							<label class="control-label">条形码：</label>
							<div class="controls">
								<input type="text" name="market_code" id="market_code" onkeyup="this.value=this.value.substring(0,50)" class="span6 typeahead" />
								<p class="help-block">*请填写产品条形码</p>
							</div>
						</div>

						<div class="control-group">
							<label class="control-label" >产品类型：</label>
							<div class="controls">
								<select name="play.columnid" id="column_type" onchange="load(this.value)">
								</select>
							</div>
						</div>

						<div class="control-group">
							<label class="control-label" >产品品牌：</label>
							<div class="controls">
								<select name="play.columnid" id="column_brand">
								</select>
							</div>
						</div>

						<div class="control-group">
							<label class="control-label" >产品计量单位：</label>
							
							<div class="controls">
								<select name="play.columnid" id="column_unit">
								</select>
							</div>
						</div>
						
						<div class="control-group">
							<label class="control-label" >产品来源：</label>
							<div class="controls">
								<select name="play.columnid" id="column_server">
								</select>
							</div>
						</div>


						
						<div class="control-group">
							<label class="control-label" >支付方式：</label>
							<div class="controls" id="column_payType">
							</div>
						</div>

						
						<%--<div class="control-group">--%>
							<%--<label class="control-label" >产品图片：</label>--%>
							<%--<div class="controls">--%>
								<%--<input  name="img" id="img" type="button" value="选择封面图片" />--%>
								<%--<input id="coverFile" name="file" style="display:none;" type="file" /><br/>--%>
							<%--<div style="border: 10px"  id="imgs">--%>
							   <%----%>
							<%--</div>--%>
							<%--</div>--%>
						<%--</div>--%>
						<div class="control-group">
							<label class="control-label" >产品封面：</label>
							<div class="controls">
								<input id="coverFile" name="file"  type="file" value="选择封面图片" onchange="showImg(1)"/><br/>
								<div style="border: 10px"  id="imgs">

								</div>
							</div>
						</div>
						
						<%--<div class="control-group">--%>
							<%--<label class="control-label" >产品图片：</label>--%>
							<%--<div class="controls">--%>
								<%--<input class="input-file uniform_on" name="img" id="details" type="button" value="选择产品详细图片" />--%>
								<%--<input id="coverFiles" name="file" style="display:none;" type="file"  multiple="multiple" onchange="showImg()"/><br/>--%>
							<%--<div style="border: 10px"  id="imgss">--%>
							   <%----%>
							<%--</div>--%>
							<%--</div>--%>
						<%--</div>--%>
						<div class="control-group">
							<label class="control-label" >产品详细图片：</label>
							<div class="controls">
								<input id="coverFiles" name="file" type="file"  multiple="multiple" onchange="showImg(2)"/><br/>
								<div style="border: 10px"  id="imgss">

								</div>
							</div>
						</div>


						<div class="control-group">
							<label class="control-label" >是否首页展示：</label>
								<div class="controls">
								   <input type="checkbox" id="isShow">
								</div>
						</div>
						<div class="control-group hidden-phone">
							<label class="control-label" >详细内容：</label>
							<div class="controls">
								<textarea name="play.content" id="bz_content" rows="3" style="width:700px;height:400px;"></textarea>
							</div>
						</div>
						
						<div class="form-actions">
							<input type="button" value="保存" class="btn btn-primary" onclick="checkForm()" />
							<input type="reset" class="btn" value="重置" />
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
	<%@include file="/common/bottom.jsp"%>
</body>
</html>