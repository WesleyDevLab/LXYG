/**
 * Created by  on 2015/10/28.
 */
    function upload() {
        var files = document.getElementById('file').files;
        if (!files.length) {
            console.log('no file is selected');
            return;
        }
        for (var i = 0; i < files.length; i++) {
            var file = files[i];
            var reader=new FileReader();
            var uinfo={};
            reader.onload=function(e){
                uinfo['ImgData']=e.target.result;
                var info = JSON.stringify(uinfo);
                var xhr = new XMLHttpRequest();
                xhr.open("post","http://localhost/LXYG/res/addImg",true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
                xhr.send(encodeURIComponent("info="+info));
            }
            reader.readAsDataURL(file);
        }
    }


