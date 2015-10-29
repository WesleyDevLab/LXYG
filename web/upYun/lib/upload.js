/**
 * Created by  on 2015/10/28.
 */



    function upload() {
        var files = document.getElementById('file').files;
        for (var i = 0; i < files.length; i++) {
            var file = files[i];
            var reader=new FileReader();
            var uinfo={};
            reader.onload=function(e){
                uinfo['ImgData']=encodeURIComponent(e.target.result);
                var info = JSON.stringify(uinfo);

                $.ajax({
                    url:'http://127.0.0.1/LXYG/res/addImg',
                    type:'post',
                    data:'info='+info,
                    dataType:'json',
                    success: function (msg) {
                        console.info(msg);
                    }
                });
                //var xhr = new XMLHttpRequest();
                //xhr.open("post","http://127.0.0.1/LXYG/res/addImg",true);
                //xhr.setRequestHeader("Content-Type", "multipart/form-data");
                //xhr.send("info="+info);
            }
            reader.readAsDataURL(file);
        }
    }


