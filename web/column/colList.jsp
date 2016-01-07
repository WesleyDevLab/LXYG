<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>
<%@ include file="../common/taglibs.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <jsp:include page="/metro.jsp"></jsp:include>
    <style>
        #typeInfo {
            border-radius: 5px;
            display: none;
            position: absolute;
            top: 20%;
            left: 30%;
            width: 800px;
            height: 400px;
            padding: 10px 20px 20px 20px;
            border: 0px solid;
            background-color: #ffffff;
            z-index: 1002;
            overflow: auto;
            box-shadow: 2px 2px 10px #909090;
        }
    </style>
    <script type="text/javascript">

        var res = new Array();

        $(function () {
            loadData();
        });

        function delType(obj) {
            if (confirm("确定要删除产品类型嘛？这样做或许会出现重大错误")) {
                var v = obj.val();
                $.post("${path}/goods/delProductType", {"typeId": v}, function (result) {
                    if (result.code == 10010) {
                        obj.parent().parent().remove();
                        alert(result.message);
                    } else {
                        alert(result.message);
                    }
                });
            }
        }

        function loadData() {
            var type = "";
            var cat = "<option  value=0> 全部</option>";
            $("#type_list").html(type);
            $.get("${path}/goods/loadGoodsAttribute", function (result) {
                if (result.code == 10010) {
                    res = result.type;
                    for (var i = 0; i < result.type.length; i++) {
                        type += "<tr><td>" + result.type[i].id + "</td><td class='center'>" + result.type[i].name + "</td><td class='center'>" + result.type[i].pcName + "</td><td class='center'>" + result.type[i].create_time + "</td><td class='center'>" +
                                "<button type='button' class='btn btn-primary' onclick='showTabel($(this))' value='" + i + "'>修改</button>" +
                                "<button type='button' class='btn'  onclick='delType($(this))' value='" + result.type[i].id + "'>删除</button></td></tr>";
                    }
                    for (var i = 0; i < result.categorys.length; i++) {
                        cat += "<option href='javascript:void(0);' value=" + result.categorys[i].id + "> " + result.categorys[i].name + "</option>"
                    }
                    $("#type_list").append(type);
                    $("#cat").append(cat);
                    $("#act").append(cat);
                }
            });
        }

        function loadType(data){
          console.info(data);
            $.post("${path}/goods/loadGoodsAttribute",{"catId":data},function(result){
                var type="";
                $("#type_list").html(type);
                if(result.code==10010){
                    res = result.type;
                    for (var i = 0; i < result.type.length; i++) {
                        type += "<tr><td>" + result.type[i].id + "</td><td class='center'>" + result.type[i].name + "</td><td class='center'>" + result.type[i].pcName + "</td><td class='center'>" + result.type[i].create_time + "</td><td class='center'>" +
                                "<button type='button' class='btn btn-primary' onclick='showTabel($(this))' value='" + i + "'>修改</button>" +
                                "<button type='button' class='btn'  onclick='delType($(this))' value='" + result.type[i].id + "'>删除</button></td></tr>";
                    }
                }
                $("#type_list").append(type);
            });
        }

        function closeTable() {
            imgCover = "";
            $("#typeInfo").hide();
        }
        var cat_id=0;
        function showTabel(obj) {
            var obj = res[obj.val()];
            cat_id=obj.p_category_id;
            $("#type_id").val(obj.id);
            $("#type_name").val(obj.name);
            $("#cat").find("option[value="+cat_id+"]").attr("selected",true);

            $("#typeInfo").show();
        }

        function updateType() {
            var type_id = $("#type_id").val();
            var type_name = $("#type_name").val();
            var c=$("#cat").val();
            var postData=postData={"type_id": type_id, "type_name": type_name};
            if(c!=cat_id&&confirm("您确定要修该主分类吗?")){
                postData={"type_id": type_id, "type_name": type_name,"cat_id":c}
            }
            $.post("${path}/goods/updateType", postData, function (res) {
                if (res.code == 10002) {
                    alert("修改成功");
                    location.reload();
                }
            });
        }

    </script>
</head>
<%@ include file="../common/top.jsp" %>
<body>
<div class="box-content" id="typeInfo">
    <div style="text-align: center"><h3>修改产品类型</h3></div>
    <div class="form-horizontal" style="margin-left: 100px;margin-top:30px ">
        <fieldset>
            <div class="control-group">
                <label class="control-label">产品分类：</label>
                <select class="form-control" id="cat">

                </select>
            </div>

            <div class="control-group">
                <label class="control-label">产品类型：</label>
                <div class="controls">
                    <input style="display: none" id="type_id">
                    <input class="span5 " id="type_name">
                </div>
            </div>

            <div class="form-actions">
                <button class="btn btn-info" onclick="updateType()">保存</button>
                <button class="btn btn-danger" onclick="closeTable();">关闭</button>
            </div>
        </fieldset>
    </div>
</div>
<!-- start: Content -->
<div id="content" class="span10">
    <div class="row-fluid">
        <div class="box span12">
            <div class="box-header">

                <h2>
                    <i class="icon-align-justify"></i>
                    <span class="break">产品类型管理</span>
                </h2>

                <div class="box-icon">
                    <a href="${path}/pageTo/addProductType" class="btn-add">
                        <i class="icon-edit" style="width:60px;">添加</i>
                    </a>
                </div>
            </div>

            <div class="box-content">
                <div style="margin:10px 0;">
                    <div class="btn-group">
                        <select class="form-control" id="act" onchange="loadType(this.value)">

                        </select>
                        <ul class="dropdown-menu" role="menu" id="column_type">

                        </ul>
                    </div>
                </div>
                <table class="table table-bordered table-striped table-condensed">
                    <thead>
                    <tr>
                        <th>序号</th>
                        <th>类别名</th>
                        <th>主类别</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody id="type_list">

                    </tbody>
                </table>
                <div class="pagination pagination-centered">
                    <div class="bg">
                        <div class="r_page">
                            <script type="text/javascript">
                                var url = location.href;
                                var pageOne = new PageObject(url, '${pg}', '${pageBean.totalPage}', '${pageBean.totalRow}', 'pageOne');
                            </script>
                        </div>
                        <div class="clear"></div>
                    </div>
                </div>
            </div>
        </div>
        <!--/span-->
    </div>
    <!--/row-->
</div>

</div>

</div>
<!--/fluid-row-->

<div class="clearfix"></div>
<footer>
    <p>
        <span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
    </p>
</footer>
</body>
</html>

