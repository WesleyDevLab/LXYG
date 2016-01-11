<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE HTML >
<html>
<head>

    <jsp:include page="/metro.jsp"></jsp:include>
    <style>
        #brandInfo {
            border-radius: 5px;
            display: none;
            position: absolute;
            top: 20%;
            left: 30%;
            width: 800px;
            height: 300px;
            padding: 10px 20px 20px 20px;
            border: 0px solid;
            background-color: #ffffff;
            z-index: 1002;
            overflow: auto;
            box-shadow: 2px 2px 10px #909090;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            loadData();
        });

        var res = new Array();
        function loadData() {
            var type = '<option value="0">所有类型</option>';
            var brand = "";
            $.get("${path}/goods/loadGoodsAttribute", function (result) {
                if (result.code == 10010) {
                    res = result.brand;
                    for (var i = 0; i < result.type.length; i++) {
                        type += "<option href='javascript:void(0);' value=" + result.type[i].id + "> " + result.type[i].name + "</option>"
                    }

                    for (var i = 0; i < result.brand.length; i++) {
                        var b = result.brand[i]
                        brand += "<tr><td align='center'>" + b.id + "</td><td align='center'>" + b.name + "</td><td>" + b.p_type_name + "</td><td>" + b.p_category_name + "</td><td class='center'>" +
                                "<button type='button' class='btn btn-primary' value='" + i + "' onclick='JavaScript:showTable($(this))'>修改</button>" +
                                "<button type='button' class='btn' value='" + b.id + "' onclick='JavaScript:delRecord($(this));'>删除</button>	</td></tr>";
                    }
                }
                $("#act").append(type);
                $("#brand_list").append(brand);
            });
        }

        function searchByType(v) {
            var typeId = v;
            var brand = "";
            res = new Array();
            $("#brand_list").text(brand);
            $.post("${path}/goods/loadGoodsAttribute", {"typeId": typeId}, function (result) {
                if (result.code == 10010) {
                    res = result.brand;
                    for (var i = 0; i < result.brand.length; i++) {
                        var b = result.brand[i];
                        brand += "<tr><td align='center'>" + b.id + "</td><td align='center'>" + b.name + "</td><td>" + b.p_type_name + "</td><td>" + b.p_category_name + "</td><td class='center'>" +
                                "<button type='button' class='btn btn-primary' value='" + i + "' onclick='JavaScript:showTable($(this));'>修改</button>" +
                                "<button type='button' class='btn' onclick='JavaScript:delRecord($(this));'>删除</button>	</td></tr>";
                    }
                    $("#brand_list").append(brand);
                }
            });
        }

        function delRecord(obj) {
            if (confirm("确定要删除产品品牌嘛？这样做或许会出现重大错误")) {
                var v = obj.val();
                $.post("${path}/goods/delProductBrand", {"brandId": v}, function (result) {
                    if (result.code == 10010) {
                        obj.parent().parent().remove();
                        alert(result.message);
                    } else {
                        alert(result.message);
                    }
                });
            }
        }

        function closeTable() {
            imgCover = "";
            $("#brandInfo").hide();
        }

        function showTable(obj) {



            var o = res[obj.val()];
            var cat_id= o.p_category_id;
            var type="";
            $.post("${path}/goods/loadGoodsAttribute",{"catId":cat_id},function(result){
                if(result.code==10010){
                    for(var i=0;i<result.type.length;i++){
                        type+="<option href='javascript:void(0);' value=" + result.type[i].id + "> " + result.type[i].name + "</option>";
                    }
                    $("#type").append(type);
                }
            });
            $("#brand_name").val(o.name);
            $("#brand_id").val(o.id);
            $("#c_name").val(o.p_category_name);
            $("#brandInfo").show();
        }
        function updateBrand() {
            var brand_id = $("#brand_id").val();
            var brand_name = $("#brand_name").val();
            $.post("${path}/goods/updateBrand", {"brand_id": brand_id, "brand_name": brand_name}, function (res) {
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
<div class="box-content" id="brandInfo">
    <div style="text-align: center"><h3>修改产品品牌</h3></div>
    <div class="form-horizontal" style="margin-left: 100px;margin-top:30px ">
        <fieldset>

            <div class="control-group">
                <label class="control-label">产品主类型：</label>
                <div class="controls">
                    <input disabled id="c_name">
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">产品类型：</label>
                <div class="controls">
                   <select class="form-control" id="type">

                   </select>
                </div>
            </div>


            <div class="control-group">
                <label class="control-label">产品品牌：</label>
                <div class="controls">
                    <input style="display: none" id="brand_id">
                    <input class="span5 " id="brand_name">
                </div>
            </div>

            <div class="form-actions">
                <button class="btn btn-info" onclick="updateBrand()">保存</button>
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
	                            <span class="break">
                                    产品品牌管理
	                            </span>
                </h2>

                <div class="box-icon">
                    <a href="${path}/pageTo/addProductBrand" class="btn-add"><i class="icon-edit"
                                                                                style="width:60px;">添加</i></a>
                </div>
            </div>
            <div class="box-content" style="min-height: 600px">
                <div style="margin:10px 0;">
                    <div class="btn-group">
                        <select class="form-control" id="act" onchange="searchByType(this.value)">

                        </select>
                        <ul class="dropdown-menu" role="menu" id="column_type">

                        </ul>
                    </div>
                </div>
                <table class="table table-bordered table-striped table-condensed">
                    <thead>
                    <tr>
                        <th align="center">序号</th>
                        <th align="center">品牌名</th>
                        <th align="center">所属类别</th>
                        <th align="center">所属主类别</th>
                        <th align="center">操作</th>
                    </tr>
                    </thead>
                    <tbody id="brand_list">

                    </tbody>
                </table>
                <div class="pagination pagination-centered">
                    <ul>
                        <div class="bg">
                            <div class="r_page">
                                <script type="text/javascript">
                                    var url = location.href;
                                    var pageOne = new PageObject(url, '${pg}', '${page.totalPage}', '${page.totalRow}', 'pageOne');
                                </script>
                            </div>
                        </div>
                    </ul>
                </div>
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
<div class="modal hide fade" id="myModal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>
        <h3>删除操作</h3>
    </div>
    <div class="modal-body">
        <p>您确定要删除该信息吗？...</p>
    </div>
    <div class="modal-footer">
        <a href="#" class="btn" data-dismiss="modal">取消</a>
        <a href="#" class="btn btn-primary">删除</a>
    </div>
</div>

<div class="clearfix"></div>
<%@include file="/common/bottom.jsp" %>
</body>
</html>
