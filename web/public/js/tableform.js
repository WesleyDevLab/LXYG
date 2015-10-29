//*********表单选择***********//
function selectInput(choose)
 {  var a=choose.value;
    if(a==1)
	{document.getElementById("shijian").className="block";
     document.getElementById("fanwei").className="block";	}
    if(a==2)
	{
     document.getElementById("shijian").className="hide";
	 document.getElementById("fanwei").className="hide";
	}
 }
//*********弹出对话框***********//
function showDetail() {
//背景
  var bgObj=document.getElementById("bgDiv");
  bgObj.style.width = document.body.offsetWidth + "px";
  bgObj.style.height = screen.height + "px";

//定义窗口
  var msgObj=document.getElementById("msgDiv");
  msgObj.style.marginTop = -75 +  document.documentElement.scrollTop + "px";

//关闭
  document.getElementById("msgShut").onclick = function(){
	bgObj.style.display = msgObj.style.display = "none";
  }
  msgObj.style.display = bgObj.style.display = "block";  
}
//*********切换-框架新增栏目***********//
function aa(s_id){
for(i=1;i<3;i++){
if(i==s_id){
document.getElementById("s"+i).className="block";
document.getElementById("m"+i).className="c_on";
}
else {
document.getElementById("s"+i).className="none";
document.getElementById("m"+i).className="c_out";
}
}
}
//*****************全选******************//
function switchAll() {
	for (var j = 1; j <= 3; j++) {
		box = eval("document.checkboxform.C" + j); 
		box.checked = !box.checked;
   }
}

//*****************加减号的展开与折叠**********************//
function menu_display_icon(t_id,i_id){//显示隐藏程序
        var t_id;//表格ID
        var i_id;//图片ID
        var on_img="images/jian.jpg";//打开时图片
        var off_img="images/jia.jpg";//隐藏时图片
        if (t_id.style.display == "none") {//如果为隐藏状态
			t_id.style.display="";//切换为显示状态
			i_id.src=on_img;//换图                
		}else{//否则
			t_id.style.display="none";//切换为隐藏状态
			i_id.src=off_img;
		}//换图
}