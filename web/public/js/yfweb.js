/*
  弹出层
*/
function show(popupdiv_psw,bar_blue){
	var Idiv=document.getElementById(popupdiv_psw);
	Idiv.style.display="block";
	//以下部分要将弹出层居中显示
	Idiv.style.left=(document.documentElement.clientWidth-Idiv.clientWidth)/2+document.documentElement.scrollLeft+"px";
	Idiv.style.top=(document.documentElement.clientHeight-Idiv.clientHeight)/2+document.documentElement.scrollTop-10+"px";

	//以下部分使整个页面至灰不可点击
	var procbg = document.createElement("div"); //首先创建一个div
	procbg.setAttribute("id","mybg"); //定义该div的id
	procbg.style.background = "#000000";
	procbg.style.width = "100%";
	procbg.style.height = "100%";
	procbg.style.position = "fixed";
	procbg.style.top = "0";
	procbg.style.left = "0";
	procbg.style.zIndex = "500";
	procbg.style.opacity = "0.6";
	procbg.style.filter = "Alpha(opacity=70)";

	//以上部分也可以用csstext代替
	// procbg.style.cssText="background:#000000;width:100%;height:100%;position:fixed;top:0;left:0;zIndex:500;opacity:0.6;filter:Alpha(opacity=70);";
	//背景层加入页面
	document.body.appendChild(procbg);
	document.body.style.overflow = "hidden"; //取消滚动条

	//以下部分实现弹出层的拖拽效果
	var posX;
	var posY;
	var barBlue=document.getElementById(bar_blue);
	barBlue.onmousedown=function(e)
	{
		if(!e) e = window.event; //IE
		posX = e.clientX - parseInt(Idiv.style.left);
		posY = e.clientY - parseInt(Idiv.style.top);
		document.onmousemove = mousemove;
	}
	document.onmouseup = function()
	{
		document.onmousemove = null;
	}
	function mousemove(ev)
	{
		if(ev==null) ev = window.event;//IE
		Idiv.style.left = (ev.clientX - posX) + "px";
		Idiv.style.top = (ev.clientY - posY) + "px";
	}
}
/*
  关闭弹出层
*/
function closeDiv(popupdiv_psw) {//关闭弹出层
	var Idiv=document.getElementById(popupdiv_psw);
	Idiv.style.display="none";
	document.body.style.overflow = "auto"; //恢复页面滚动条
	var body = document.getElementsByTagName("body");
	var mybg = document.getElementById("mybg");
	body[0].removeChild(mybg);
}

/*
  tab切换
*/

function tabChange(obj,id)
{
 var arrayli = obj.parentNode.getElementsByTagName("li"); //获取li数组
 var arrayul = document.getElementById(id).getElementsByTagName("ul"); //获取ul数组
 for(i=0;i<arrayul.length;i++)
 {
  if(obj==arrayli[i])
  {
   arrayli[i].className = "cli";
   arrayul[i].className = "";
  }
  else
  {
   arrayli[i].className = "";
   arrayul[i].className = "hidden";
  }
 }
}