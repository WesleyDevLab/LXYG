/**
 * 回车触发搜索功能
 * @param ev
 */
function acckey_return(ev)
{
	if (  ev.keyCode == 13 )
	{
		search();
	}
}

/**
 * 字符串替换
 */
String.prototype.replaceAll = function(reallyDo, replaceWith, ignoreCase) {   
	if (!RegExp.prototype.isPrototypeOf(reallyDo)) {   
		return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi": "g")), replaceWith);   
	} else {   
		return this.replace(reallyDo, replaceWith);   
	}   
}

/**
 *    全选，反选
 */
function chooseall(obj){
	var arr =document.getElementsByName("checkbox");
	for(var i=0;i<arr.length;i++){
		switch(obj) {  case 1:if(arr[i].type == "checkbox") 
			arr[i].checked = true; 
			break; //全选
		case 2:arr[i].checked=false;break; //不选
		case 3:{ if(arr[i].checked==true)
		{ arr[i].checked=false; }
		else { arr[i].checked=true; }
		} break; //反选
		} 
	}
}

/**
 * 删除多个
 */
function selectdeletes(name){
	var s="";
	var arr=document.getElementsByName("checkbox");
	for(var i=0;i<arr.length;i++){
		if(arr[i].checked==true){
			var j= arr[i].value; s+=j+",";
		}  }
	if(s==""){
		alert("你没有选择要删除的内容！");
	}else{
		del_for_id(s,0,name);
	}
}  
/**
 * table 样式
 */
function showtable(){ 
	var color1 = "rgb(245,245,245)"; 
	var bgColor = "#D1EEEE"; 
	var trs = document.getElementById("tab").getElementsByTagName("tr"); 
	for (var i=0;i<trs.length;i++){ 
		if(trs[i].className!='b'){
			trs[i].style.backgroundColor=color1; 
			trs[i].onmouseover = function(){ 
				this.style.backgroundColor = bgColor; 
			} 
			trs[i].onmouseout = function(){ 
				this.style.backgroundColor = color1; 
			} 

		}
	} 
} 

/**
 * 判断输入的是否为数字	
 */
function isNumber(str){
	if(""==str){
		return false;
	}
	var   r   =   /^[0-9]*[1-9][0-9]*$/
	return r.test(str); 
} 
/**
 * 去掉左右空格
 */
function trim(str){   
	str = str.replace(/^(\s|\u00A0)+/,'');   
	for(var i=str.length-1; i>=0; i--){   
		if(/\S/.test(str.charAt(i))){   
			str = str.substring(0, i+1);   
			break;   
		}   
	}   
	return str;   
} 
/**
 * 判断字符串是不是只是字母，数字，中文
 * @param str
 * @returns
 */
function isNCE(str){
	if(""==str){
		return false;
	}
	var   r   =    /^(\w|[\u4E00-\u9FA5])+$/
	return r.test(str); 
} 
function isTEL(str){
	if(""==str){
		return false;
	}
	var   r   =    /^13\d{9}$/
	return r.test(str); 
}
/**
 * 单文件上传 限制上传图片的格式
 */
//限制文件类型
extArray = new Array(".gif", ".jpg", ".png");
//限制文件类型   form:表单   file：上传文件的值
function LimitAttach(form, file,id) {
	allowSubmit = false;
	if (!file) {
		alert("请选择要上传的文件！");
		return false;
	}
	while (file.indexOf("\\") != -1)
		file = file.slice(file.indexOf("\\") + 1);
	ext = file.slice(file.indexOf(".")).toLowerCase();
	for ( var i = 0; i < extArray.length; i++) {
		if (extArray[i] == ext) {
			allowSubmit = true;
			break;
		}
	}
	if (allowSubmit) {
		 $("#"+id).ajaxSubmit({
 			dataType:'text',
 			success:function(msg){
 				if(msg=='suc')
 				alert("上传成功！");
 				else
 				alert('上传失败！');
 				closeDiv('popupdiv_logo');
 			 }
          });
		    
	} else{
		alert("对不起，只能上传以下格式的文件:  " + (extArray.join("  "))
				+ "\n请重新选择符合条件的文件" + "再上传.");
		return false;
    }
}
/**
 * 多文件上传   限制格式
 */
function LimitImgsUpload(){
	files=document.getElementsByName("file");
	for(var i=0;i<files.length;i++){
		var  file=files[i].value;
		if (!file) {

		} else{
			while (file.indexOf("\\") != -1)
				file = file.slice(file.indexOf("\\") + 1);
			ext = file.slice(file.indexOf(".")).toLowerCase();
			allowSubmit=false;
			//遍历数组比较上传图片是否符合规定格式
			for ( var j = 0; j < extArray.length; j++) {
				if (extArray[j] == ext) {
					allowSubmit = true;
					break;
				}
			}
			if (!allowSubmit) {
				alert("对不起，只能上传以下格式的文件:  " + (extArray.join("  ")) + "\n请重新选择符合条件的文件" + "再上传.");
				return false;
			}  
		}
	}
	return true;
}
/**
 *   图片预览
 */

function previewImage(file,id)
{
	$("#look").append("<div style='float:left; border: 1px solid #000;width: 50px; height: 50px; ' id='preview"+id+"' > </div>")
	var MAXWIDTH  = 50;
	var MAXHEIGHT = 50;
	var div = document.getElementById("preview"+id);
	if (file.files && file.files[0])
	{
		div.innerHTML = "<img id='imghead"+id+"'>";
		var img = document.getElementById("imghead"+id);
		img.onload = function(){
			var rect = clacImgZoomParam(MAXWIDTH, MAXHEIGHT, img.offsetWidth, img.offsetHeight);
			img.width = rect.width;
			img.height = rect.height;
			img.style.marginLeft = rect.left+'px';
			img.style.marginTop = rect.top+'px';
		}
		var reader = new FileReader();
		reader.onload = function(evt){img.src = evt.target.result;}
		reader.readAsDataURL(file.files[0]);
	}
	else
	{
		var sFilter='filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src="';
		file.select();
		var src = document.selection.createRange().text;
		div.innerHTML = "<img id='imghead"+id+"'>";
		var img = document.getElementById("imghead"+id);
		img.filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src = src;
		var rect = clacImgZoomParam(MAXWIDTH, MAXHEIGHT, img.offsetWidth, img.offsetHeight);
		status =('rect:'+rect.top+','+rect.left+','+rect.width+','+rect.height);
		div.innerHTML = "<div id=divhead style='width:"+rect.width+"px;height:"+rect.height+"px;margin-top:"+rect.top+"px;margin-left:"+rect.left+"px;"+sFilter+src+"\"'></div>";
	}
}


function clacImgZoomParam( maxWidth, maxHeight, width, height ){
	var param = {top:0, left:0, width:width, height:height};
	if( width>maxWidth || height>maxHeight )
	{
		rateWidth = width / maxWidth;
		rateHeight = height / maxHeight;

		if( rateWidth > rateHeight )
		{
			param.width =  maxWidth;
			param.height = Math.round(height / rateWidth);
		}else
		{
			param.width = Math.round(width / rateHeight);
			param.height = maxHeight;
		}
	}

	param.left = Math.round((maxWidth - param.width) / 2);
	param.top = Math.round((maxHeight - param.height) / 2);
	return param;
}
/**
 * 显示时间
 */
function showtime() {
	var now = new Date();
	$("#mytime").innerHTML = now.getFullYear() + "-"
	+ (now.getMonth() + 1) + "-" + (now.getDate()) + " "
	+ now.getHours() + ":" + now.getMinutes() + ":"
	+ now.getSeconds();
	setTimeout("showtime()", 1000);

}

/**
 * 磁贴分配公司
 * @param parid
 */
function tile_comp(parid){
	userId=parid;
	$.post( "service/tiles/tileComp", {"tileId" : userId}, function(data) {

		var jsonobj = eval(data);
		$("#had").empty(); 
		$("#no").empty();
		$.each(jsonobj, function(idx, item) {
			var compId=item.compId; 
			var name=item.compName;

			if(item.version>0){
				$("#had").append("<option value="+compId+">" + name+ "</option>");
			}else{ 
				$("#no").append("<option value="+compId+">" + name+ "</option>"); 
			}});
		$("#no").get(0).selectedIndex=0;
		$("#had").get(0).selectedIndex=0;});
	show();
}
function  show() { 
	var oWin = document.getElementById("win");
	var oLay = document.getElementById("overlay");
	//var oClose = document.getElementById("close");
	var oe = document.getElementById("cancel");
	var oH2 = oWin.getElementsByTagName("h2")[0];
	var bDrag = false;var disX = disY = 0;
	var w = "";var n = 1;if (n > 0) {
		oLay.style.display = "block";
		oWin.style.display = "block";
		/*oClose.onclick = function() {
			oLay.style.display = "none";
			oWin.style.display = "none";
		};*/
		cancel.onclick = function() {
			oLay.style.display = "none";
			oWin.style.display = "none";
		};
		/*oClose.onmousedown = function(event) {
			(event || window.event).cancelBubble = true;
		};*/
		oH2.onmousedown = function(event) {
			var event = event || window.event;
			bDrag = true;
			disX = event.clientX - oWin.offsetLeft;
			disY = event.clientY - oWin.offsetTop;
			this.setCapture && this.setCapture();
			return false
		};
		document.onmousemove = function(event) {
			if (!bDrag)return;
			var event = event || window.event;
			var iL = event.clientX - disX;
			var iT = event.clientY - disY;
			var maxL = document.documentElement.clientWidth - oWin.offsetWidth;
			var maxT = document.documentElement.clientHeight- oWin.offsetHeight;
			iL = iL < 0 ? 0 : iL;
			iL = iL > maxL ? maxL : iL;
			iT = iT < 0 ? 0 : iT;
			iT = iT > maxT ? maxT : iT;
			oWin.style.marginTop = oWin.style.marginLeft = 0;
			oWin.style.left = iL + "px";
			oWin.style.top = iT + "px";
			return false
		};
		document.onmouseup = window.onblur = oH2.onlosecapture = function() {
			bDrag = false;
			oH2.releaseCapture && oH2.releaseCapture();};
	} 
};
function move(fbox,tbox) {
	for(var i=0; i<fbox.options.length; i++) {
		if(fbox.options[i].selected  &&  fbox.options[i].value != "") {
			var no = new Option();
			no.value = fbox.options[i].value;
			no.text = fbox.options[i].text;
			tbox.options[tbox.options.length] = no;
			fbox.options[i].value = "";
			fbox.options[i].text = "";
		}
	}
	BumpUp(fbox);
	if (sortitems) SortD(tbox);
}
function BumpUp(box)  {
	for(var i=0; i<box.options.length; i++) {
		if(box.options[i].value == "")  {
			for(var j=i; j<box.options.length-1; j++)  {
				box.options[j].value = box.options[j+1].value;
				box.options[j].text = box.options[j+1].text;
			}
			var ln = i;
			break;
		}
	}
	if(ln < box.options.length)  {
		box.options.length -= 1;
		BumpUp(box);
	}
}
function SortD(box)  {
	var temp_opts = new Array();
	var temp = new Object();
	for(var i=0; i<box.options.length; i++)  {
		temp_opts[i] = box.options[i];
	}
	for(var x=0; x<temp_opts.length-1; x++)  {
		for(var y=(x+1); y<temp_opts.length; y++)  {
			if(temp_opts[x].text > temp_opts[y].text)  {
				temp = temp_opts[x].text;
				temp_opts[x].text = temp_opts[y].text;
				temp_opts[y].text = temp;
				temp = temp_opts[x].value;
				temp_opts[x].value = temp_opts[y].value;
				temp_opts[y].value = temp;
			}
		}
	}
	for(var i=0; i<box.options.length; i++)  {
		box.options[i].value = temp_opts[i].value;
		box.options[i].text = temp_opts[i].text;
	}
}

function tile_comp_sub(){
	//全选
	$("#had").children().each(function(){$(this).attr("selected","selected")});
	var ids=$("#had").val();
	$.post(" service/tiles/addComp", {"tileId" : userId,"compIds":ids+","}, function(data) {
		alert(data);
		$("#win").hide()
		$("#overlay").hide(); 
	});
}



/**
 * admin
 *分配角色 
 */
function admin_adminRole(parid){
	userId=parid;
	$.post( "service/admin/adminRole", {"adminId" : userId}, function(data) {
		var jsonobj = eval(data);
		$("#had").empty(); $("#no").empty();
		$.each(jsonobj, function(idx, item) {
			var roleId=item.roleId; var name=item.name;
			if(item.orderNo>0){ $("#no").append("<option value="+roleId+">" + name+ "</option>"); 
			}else{ $("#had").append("<option value="+roleId+">" + name+ "</option>"); 
			}});
		$("#no").get(0).selectedIndex=0;
		$("#had").get(0).selectedIndex=0;});
	show();

}

function admin_show_sub(){
	$("#had").children().each(function(){$(this).attr("selected","selected")});
	var ids=$("#had").val();
	$.post("service/admin/addRole", {"adminId" : userId,"ids":ids+","}, function(data) {
		alert(data);
		closeDiv('popupdiv_tuodong');
	});

}

/**
 *  在公司列表中分配磁贴
 **/
function comp_tile(parid){
	userId=parid;
	$.post( "service/company/tileComp", {"compId" : userId}, function(data) {
		var jsonobj = eval(data);
		$("#had").empty(); 
		$("#no").empty();
		$.each(jsonobj, function(idx, item) {
			var tileId=item.tileId; 
			var name=item.tileName;

			if(item.version>0){
				$("#had").append("<option value="+tileId+">" + name+ "</option>");
			}else{ 
				$("#no").append("<option value="+tileId+">" + name+ "</option>"); 
			}});
		$("#no").get(0).selectedIndex=0;
		$("#had").get(0).selectedIndex=0;});
	show();
}
/**
 * 公司分配磁贴
 */
function comp_tile_sub(){
	//全选
	$("#had").children().each(function(){$(this).attr("selected","selected")});
	var ids=$("#had").val();
	$.post(" service/company/addtile", {"compId" : userId,"tileIds":ids+","}, function(data) {
		alert(data);
		$("#win").hide()
		$("#overlay").hide(); 
	});
}
//弹出
function pop(){
	var oWin = document.getElementById("win");
	var oLay = document.getElementById("overlay");
	var oClose = document.getElementById("close");
	var oe = document.getElementById("cancel");
	var oH2 = oWin.getElementsByTagName("h2")[0];
	var bDrag = false;var disX = disY = 0;
	var w = "";var n = 1;if (n > 0) {
		oLay.style.display = "block";
		oWin.style.display = "block";
		oClose.onclick = function() {
			oLay.style.display = "none";
			oWin.style.display = "none";
		};
		cancel.onclick = function() {
			oLay.style.display = "none";
			oWin.style.display = "none";
		};
		oClose.onmousedown = function(event) {
			(event || window.event).cancelBubble = true;
		};
		oH2.onmousedown = function(event) {
			var event = event || window.event;
			bDrag = true;
			disX = event.clientX - oWin.offsetLeft;
			disY = event.clientY - oWin.offsetTop;
			this.setCapture && this.setCapture();
			return false
		};
		document.onmousemove = function(event) {
			if (!bDrag)return;
			var event = event || window.event;
			var iL = event.clientX - disX;
			var iT = event.clientY - disY;
			var maxL = document.documentElement.clientWidth - oWin.offsetWidth;
			var maxT = document.documentElement.clientHeight- oWin.offsetHeight;
			iL = iL < 0 ? 0 : iL;
			iL = iL > maxL ? maxL : iL;
			iT = iT < 0 ? 0 : iT;
			iT = iT > maxT ? maxT : iT;
			oWin.style.marginTop = oWin.style.marginLeft = 0;
			oWin.style.left = iL + "px";
			oWin.style.top = iT + "px";
			return false
		};
		document.onmouseup = window.onblur = oH2.onlosecapture = function() {
			bDrag = false;
			oH2.releaseCapture && oH2.releaseCapture();};
	} 
}
