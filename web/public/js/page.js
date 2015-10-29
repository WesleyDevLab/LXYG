function formatNum(num){
	if (num==null||typeof(num)=='undefined') {
		num = 0;
	}
	document.writeln((num/100).toFixed(2));
}

function checkNumber(number){    
	var reg = /^[0-9]+$/;
	return reg.test(number);
}

function PageObject(url,currentPage,totalPage,recordSize,objName){
	var index1 = url.indexOf("?");
	var index2 = url.indexOf("pg");
	if(index1>0){
		if(index2>0){
			this.url = url.substring(0,index2);
		}else{
			this.url = url+"&";
		}
	}else{
		this.url = url+"?";
	}

	this.page    	= currentPage;
	this.pageSize   = totalPage;
	this.recordSize = recordSize;
	this.name       = objName;
	this.toWrite    = "";
	this.init();
}
PageObject.prototype.init	=	function(){
	var head = "<li><a>第<font color='blue'>"+this.page+"</font>/"+this.pageSize+"页 共"+this.recordSize+"条</a></li>";
	var control = "&nbsp;跳转到第&nbsp;&nbsp;<input id='toPage' size='4' style='width:20px;ime-mode:disabled;'>&nbsp;&nbsp;页&nbsp;&nbsp;" +
			"<a class='label label-success' onclick='"+this.name+".forward();'>跳转</a>";
	if(this.pageSize == 1 && this.page == 1){
		this.toWrite = head;
		this.toWrite += "<li><a>首页</a></li><li><a class='active'>上一页</li></a><li>下一页</li><li><a>末页</li></a>"
			this.toWrite += control;
	}else if(this.pageSize > 1 && this.page==1){
		var next     = parseInt(this.page) + 1;
		this.toWrite = head;
		this.toWrite += "<li><a>首页</a></li>" +
				"<li><a class='active'>上一页</a></li><li><a href='"+this.url+"pg="+next+"'>下一页</a></li>";
		this.toWrite += "<li><a href='"+this.url+"pg="+this.pageSize+"'>末页</a></li>"
		this.toWrite += control;
	}else if(this.pageSize >1 && this.page != this.pageSize){
		var next     = parseInt(this.page) + 1;
		var previous = parseInt(this.page) - 1;
		this.toWrite = head;
		this.toWrite += "<li><a href='"+this.url+"pg=1'>首页</a></li>" +
				"<li><a href='"+this.url+"pg="+previous+"' class='active'>上一页</a></li>";
		this.toWrite += "<li><a href='"+this.url+"pg="+next+"'>下一页</a></li>" +
				"<li><a href='"+this.url+"pg="+this.pageSize+"'>末页</a></li>";
		this.toWrite += control;
	}else if(this.pageSize>1 && this.page==this.pageSize){
		var previous = parseInt(this.page) - 1;
		this.toWrite = head;
		this.toWrite += "<li><a href='"+this.url+"pg=1'>首页</a></li>" +
				"<li><a href='"+this.url+"pg="+previous+"' class='active'>上一页</a></li>";
		this.toWrite += "<li><a>下一页</a></li><li><a>末页</a></li>";
		this.toWrite += control;
	}			
	document.write(this.toWrite);
}
PageObject.prototype.forward = function(){		
	var elemId = "toPage";	
	var val = document.getElementById(elemId).value;
	if(!checkNumber(val)){
		alert('请输入数字！');			
		document.getElementById(elemId).select();
		return;
	}
	if(parseInt(val) > this.pageSize){
		alert('不能超过最大的页数！')					
		document.getElementById(elemId).value = this.pageSize;
		return;
	}
	if(parseInt(val) < 1){
		alert('最小页数不能小于1！');					
		document.getElementById(elemId).value = 1;
		return;
	}				
	var b = parseInt(val);	
	location.href =this.url+"pg=" + b;
}