<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>JFinal 文件上传</title>
<link href="${path }/public/css/index.css" rel="stylesheet" type="text/css" />
<link href="${path }/public/css/right.css" rel="stylesheet" type="text/css" />
<link href="${path }/public/css/grid.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script>
<script type="text/javascript" src="${path }/public/js/jquery.form.js"></script>
 
<script type="text/javascript">
function change (val){
         /*  //var i = $(this).val();
          alert(val);
          $("input[type='file']").not($(this)).each(function () {
          alert($(this).val());
              if ($(this).val() == val && $(this).val() != "") {
                  $(this).css("background", "pink");
                  alert("有相同内容！");
              } 
      }); */
    var m=0;
    var array=document.getElementsByName("files");
	for(var i=0;i<array.length;i++ ){
		for(var j=i+1;j<array.length;j++){
			if(array[i].value!=""&&array[i].value==array[j].value){
				m++;
				if(m=2){
					alert("重复添加"); 
					break;
				}
			}
		}
	}
  }
 
	
	var i=1;
	function addFile1(){
		 if(i<10) 
		 {
			  var str = '<font id="tempobj'+i+'"><BR> <input type="file" name="files'+i+'"  onchange="change(this.value)" style="width: 300px"/></font>' 
			  document.getElementById('MyFile').insertAdjacentHTML("beforeEnd",str);
			  i++;
		 } 
		 else 
		 { 
		  	alert("您一次最多只能上传10张图片！") 
		 } 
	};
	function delFile1()
	{
		 if((i-1)>0)
		 {
			  MyFile.removeChild(eval('tempobj'+(i-1)));
			  i--;
		 }
		 else
		 {
		  	alert("必须保留一份文件！") 
		 }
	};
	function formsubmit() { 
		$("#add").ajaxSubmit({
	    	dataType:'text',
	    	success:function(msg){
	    		alert(msg); 
	    		$("#attachment").val(msg);
	    		/* if(msg.indexOf("</PRE>")>0){
	    			var bb = decodeURI(msg).replaceAll("</PRE>", "");
	    			var cc = decodeURI(bb).replaceAll("<PRE>", "");
	    			var aa = decodeURI(cc).replaceAll("%2F", "/");
	    			var dd = decodeURI(aa).replaceAll("%2C", ",");
	    			document.getElementById('attachment').value = dd;
	    			alert(dd);
	    		}else{
	    			var aa = decodeURI(msg).replaceAll("%2F", "/");
	    			var dd = decodeURI(aa).replaceAll("%2C", ",");
	    			document.getElementById('attachment').value = dd;
	    			alert(dd);
	    		} */
	    	}
	   	});
		alert("添加成功");	  
	}
	function send(){
		$("#imgForm").ajaxSubmit({
	    	dataType:'text',
	    	success:function(msg){
	    		alert(msg); 	    		 
	    	}
	   	});
	}
	
</script>
</head>

<body >
	<div class="right_con" >
		<div class="bor"> 
			 <div style="margin-top: 50px;" >
			 <table width="98%" border="0" align="center" cellpadding="0" 
					cellspacing="0" style="margin: 0px auto;" class="ptb">
			        <tr>
						<td width="84">
							<p>附件</p></td>
						<td> 
								<div>
									<form action="${path }/upload/files"  method="post"  id="add" enctype="multipart/form-data">
										<p id="MyFile">
										<input onclick="addFile1();" type="button" value="增加文件"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input onclick="delFile1();" type="button" value="减少文件"/><br />
										<input type="file" name="files"  onchange="change(this.value)" style="width: 300px" /></p>
										<div class="btn_bg clr">
										<input type="button" value="上传附件" onclick="formsubmit();" class="caozuo_input f_l" />
										</div>
								    </form>
								</div> </td>
					</tr>
					 <tr>
					
					 	<td> 
					 	<form action="${path }/img/add" id="imgForm" method="post" >
					 		<input type="hidden" id="attachment" name="img_url" />
					 		<input type="button" value="提交" onclick="send();"/>
					 	</form></td>
					 </tr>
		  </table></div>
		</div>
	</div>

</body>
</html>
