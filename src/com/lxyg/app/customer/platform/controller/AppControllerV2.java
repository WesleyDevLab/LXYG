package com.lxyg.app.customer.platform.controller;

import com.jfinal.aop.Before;
import com.jfinal.core.ActionKey;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.lxyg.app.customer.platform.JPush.JPushKit;
import com.lxyg.app.customer.platform.interceptor.loginInterceptor;
import com.lxyg.app.customer.platform.model.*;
import com.lxyg.app.customer.platform.service.GoodsService;
import com.lxyg.app.customer.platform.service.OrderService;
import com.lxyg.app.customer.platform.util.*;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Administrator on 2015/9/11.
 */
@Before(loginInterceptor.class)
public class AppControllerV2 extends Controller {
    private static final Logger log = Logger.getLogger(AppControllerV2.class);
    public GoodsService goodsService = new GoodsService();
    public OrderService orderService = new OrderService();

    public void renderSuccess(String value, Object o) {
        setAttr("code", 10002);
        setAttr("msg", value);
        if (o == null) {
            setAttr("data", new JSONObject());
        } else {
            setAttr("data", o);
        }
        renderJson();
        return;
    }

    public void renderFaile(String value) {
        setAttr("code", 10001);
        setAttr("msg", value);
        renderJson();
        return;
    }

    public int checkUUID() {
        String info = getPara("info");
        JSONObject json = JSONObject.fromObject(info);
        String uid = json.getString("uid");
        Shop s = new Shop().findFirst("select * from kk_shop where uuid=?", new Object[]{uid});
        if (s != null) {
            return s.getInt("id");
        } else {
            return 0;
        }
    }

    /***
     * B端 fb产品添加
     **/
    @ActionKey("app/v2/addFBProduct")
    public void addFBProduct() {
        int sid = checkUUID();
        if (sid == 0) {
            renderFaile("uuid 错误");
            return;
        }
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        String uid = obj.getString("uid");
        int price = obj.getInt("price");
        int marketPrice = obj.getInt("marketPrice");
        int cash_pay = obj.getInt("cash_pay");
        FBGoods r = new FBGoods();
        r.set("name", obj.getString("name"));
        if (obj.containsKey("title")) {
            r.set("title", obj.getString("title"));
        }
        r.set("price", price);
        if (obj.containsKey("marketPrice")) {
            r.set("market_price", marketPrice);
        }
        r.set("cash_pay", cash_pay);
        r.set("cover_img", RegularUtil.retIMGURL(obj.getString("cover_img")));
        if (obj.containsKey("p_unit_name")) {
            r.set("p_unit_name", obj.getString("p_unit_name"));
        }
        if (obj.containsKey("descripation")) {
            r.set("descripation", obj.getString("descripation"));
        }
        r.set("s_uid", uid);
        r.set("hide", 0);
        if (obj.containsKey("index_show")) {
            r.set("index_show", obj.getInt("index_show"));
        } else {
            r.set("index_show", 1);
        }
        r.set("create_time", new Date());
        r.set("order_no", 1);
        String item = obj.getString("imgs");
        r.save();
        if (item != null) {
            goodsService.saveFB(r, item);
        }
        r.put("product_id", r.getInt("id"));
        renderSuccess("添加成功", r);
    }

    /***
     * B端 fb产品修改
     **/
    @ActionKey("app/v2/updateFBProduct")
    public void updateFBProduct() {
        int sid = checkUUID();
        if (sid == 0) {
            renderFaile("uuid 错误");
            return;
        }
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        int productId = obj.getInt("productId");
        FBGoods r = FBGoods.dao.findbyId(productId);

        int price = obj.getInt("price");
        int marketPrice = obj.getInt("marketPrice");
        int cash_pay = obj.getInt("cash_pay");
        r.set("name", obj.getString("name"));
        if (obj.containsKey("title")) {
            r.set("title", obj.getString("title"));
        }
        r.set("price", price);
        if (obj.containsKey("marketPrice")) {
            r.set("market_price", marketPrice);
        }
        r.set("cash_pay", cash_pay);

        if (obj.containsKey("p_unit_name")) {
            r.set("p_unit_name", obj.getString("p_unit_name"));
        }
        if (obj.containsKey("descripation")) {
            r.set("descripation", obj.getString("descripation"));
        }
        r.set("hide", 0);
        if (obj.containsKey("index_show")) {
            r.set("index_show", obj.getInt("index_show"));
        } else {
            r.set("index_show", 1);
        }

        r.set("order_no", 1);
        r.put("id", productId);
        if (obj.containsKey("imgs")) {
            net.sf.json.JSONArray array = net.sf.json.JSONArray.fromObject(obj.getString("imgs"));
            Db.update("DELETE FROM kk_product_fb_img where product_id=?", productId);
            r.set("cover_img", RegularUtil.retIMGURL(array.get(0).toString()));
            for (int i = 1; i < array.size(); i++) {
                Record r1 = new Record();
                r1.set("product_id", productId);
                r1.set("img_url", RegularUtil.retIMGURL(array.get(i).toString()));
                Db.save("kk_product_fb_img", r1);
            }
        }
        r.update();
        renderSuccess("修改成功", r);
    }

    @ActionKey("app/v2/updateFBProductImg")
    public void updateFBProductImg() {
        int sid = checkUUID();
        if (sid == 0) {
            renderFaile("uuid 错误");
            return;
        }
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        int productId = obj.getInt("productId");
        net.sf.json.JSONArray array = obj.getJSONArray("imgs");
        Db.update("delete from kk_product_fb_img pfi where pfi.product_id=?", productId);
        for (int i = 0; i < array.size(); i++) {
            Record r = new Record();
            r.set("product_id", productId);
            r.set("img_url", array.get(i).toString());
            Db.save("kk_product_fb_img", r);
        }
        renderSuccess("修改成功", null);
    }

    /***
     * B端 fb产品删除
     **/
    @ActionKey("app/v2/delFBProduct")
    public void deleteFBProduct() {
        int sid = checkUUID();
        if (sid == 0) {
            renderFaile("uuid 错误");
            return;
        }
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        int productId = obj.getInt("productId");
        Record r = Db.findById("kk_product_fb", productId);
        r.set("hide", 1);
        Db.update("kk_product_fb", r);
        renderSuccess("删除成功", r);
    }

    /***
     * B端 fb产品信息
     **/
    @ActionKey("app/v2/FBProduct")
    public void FBProduct() {
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        int productId = obj.getInt("productId");
        FBGoods fb = FBGoods.dao.findbyId(productId);
        if (fb == null) {
            renderSuccess("产品异常或丢失", null);
            return;
        }
        renderSuccess("获取成功", fb);
    }

    /***
     * B端 fb店面产品列表
     **/
    @ActionKey("app/v2/FBProducts")
    public void FBProducts() {
        int sid = checkUUID();
        if (sid == 0) {
            renderFaile("uuid 错误");
            return;
        }
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        String uid = obj.getString("uid");
        List<FBGoods> fbGoodses = FBGoods.dao.findBySID(uid);
        renderSuccess("获取成功", fbGoodses);
    }

    /***
     * B端 fb店面产品排序
     **/
    @ActionKey("app/v2/FBProductSort")
    public void FBProductSort() {
        int sid = checkUUID();
        if (sid == 0) {
            renderFaile("uuid 错误");
            return;
        }
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        String str = obj.getString("pids");
        String array[] = str.split(",");
        for (int i = 0; i < array.length; i++) {
            FBGoods f = FBGoods.dao.findById(array[i]);
            f.set("order_no", i);
            f.update();
        }
        renderSuccess("修改成功", null);
    }

    /***
     * B端 店铺类型
     **/
    @ActionKey("app/v2/shopTypes")
    public void shopTypes() {
        List<Record> records = Db.find("select id as type_id,name,title,imgs as img from kk_shop_type");
        renderSuccess("获取成功", records);
    }


    @ActionKey("app/v2/updateShopInfo")
    public void updateShopInfo() {
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        Shop shop = Shop.dao.findBysuid(obj.getString("uid"));
        Map<String, Object> m = new HashMap<String, Object>();
        if (obj.containsKey("name")) {
            m.put("name", obj.getString("name"));
        }
        if (obj.containsKey("title")) {
            m.put("title", obj.getString("title"));
        }

        if (obj.containsKey("title2")) {
            m.put("title2", obj.getString("title2"));
        }

        if (obj.containsKey("title3")) {
            m.put("title3", obj.getString("title3"));
        }

        if (obj.containsKey("shop_type")) {
            m.put("shop_type", obj.getInt("shop_type"));
            Record record = Db.findById("kk_shop_type", obj.getInt("shop_type"));
            if (record != null) {
                m.put("is_norm", record.getInt("is_norm"));
            }
        }

        if (obj.containsKey("password")) {
            m.put("password", obj.getString("password"));
        }
        if (obj.containsKey("concact")) {
            m.put("link_man", obj.getString("concact"));
        }
        if (obj.containsKey("phone")) {
            m.put("phone", obj.getString("phone"));
        }
        if (obj.containsKey("fulladdress")) {
            m.put("full_address", obj.getString("fulladdress"));
        }
        if (obj.containsKey("lat")) {
            m.put("lat", obj.getDouble("lat"));
        }
        if (obj.containsKey("lng")) {
            m.put("lng", obj.getDouble("lng"));
        }

        if (obj.containsKey("street")) {
            m.put("street", obj.getString("street"));
        }
        if (obj.containsKey("provinceName")) {
            Record r = Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + obj.getString("provinceName") + "%"});
            m.put("province_id", r.get("code"));
            m.put("province_name", obj.getString("provinceName"));
        }
        if (obj.containsKey("cityName")) {
            Record r = Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + obj.getString("cityName") + "%"});
            m.put("city_id", r.get("code"));
            m.put("city_name", obj.getString("cityName"));
        }
        if (obj.containsKey("areaName")) {
            Record r = Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + obj.getString("areaName") + "%"});
            m.put("area_id", r.get("code"));
            m.put("area_name", obj.getString("areaName"));
        }
        if (obj.containsKey("templeId")) {
            m.put("temple_id", obj.getInt("templeId"));
        }
        if (obj.containsKey("cover_img")) {
            m.put("cover_img", RegularUtil.retIMGURL(obj.getString("cover_img")));
        }
        if (obj.containsKey("mId")) {
            m.put("m_id", obj.getInt("mId"));
        }
        shop.setAttrs(m);
        shop.update();
        renderSuccess("修改成功", shop);
    }

    @ActionKey("app/v2/districts")
    public void loadDistricts() {
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        if (!obj.containsKey("area_id")) {
            renderFaile("数据异常");
        }
        int area_id = obj.getInt("area_id");
        List<District> districtList = District.dao.find("select id as districtId,name from kk_district where area_id=?", area_id);
        renderSuccess("获取成功", districtList);
    }

    @ActionKey("app/v2/productTypes")
    public void allProductTypes() {
        List<GoodCategory> goodCategories = GoodCategory.dao.find("select * from kk_product_category order by sort_id asc");
        for (GoodCategory goodCategory : goodCategories) {
            goodCategory.put("types", goodCategory.getGoodTypes(goodCategory.getInt("id")));
        }
        renderSuccess("获取成功", goodCategories);
    }


    @ActionKey("app/v2/searchProduct")
    public void search() {
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        int page = 1;
        if (obj.containsKey("pg")) {
            page = obj.getInt("pg");
        }
        Page<Goods> goodsPage = Goods.dao.findByName(obj.getString("name"), page);
        renderSuccess("获取成功", goodsPage);
    }


    /***
     * C端 首页列表
     **/
    @ActionKey("app/user/v2/homePage")
    public void homePage_1() {
        if (M.loadInfo() != 1) {
            return;
        }
        JSONObject json = JSONObject.fromObject(getPara("info"));
        if (!json.containsKey("s_uid")) {
            renderFaile("店铺id");
            return;
        }
        String s_uid = json.getString("s_uid");
        Shop s = Shop.dao.findFirst("SELECT s.id as shopId,s.name,s.uuid ,s.cover_img,s.shop_type,st.sort,s.is_norm from kk_shop s left join kk_shop_type st on s.id=st.s_id where s.uuid=? ", s_uid);
        if (s == null) {
            renderFaile("异常！");
            return;
        }
        if (s.getActivity() != null) {
            s.put("shopActivits", s.getActivity());
            s.put("activitys", s.getActivity(s.getInt("shopId")));
        }
        List<Map<String, Object>> maps = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> types = new ArrayList<Map<String, Object>>();
        List<Goods> recommGoods = new ArrayList<Goods>();
        if (s.getStr("sort") == null || s.getStr("sort").equals("")) {
            s.put("types", maps);
            s.put("shopCount", 1);
            s.put("category", types);
            s.put("recommGoods", recommGoods);
            renderSuccess("暂无上货", s);
            return;
        }
        recommGoods = Goods.dao.find("SELECT  p.id AS productId, p.name, p.title, p.price, p.p_type_id, p.p_brand_id, p.p_type_name, p.p_brand_name, p.cover_img, p.p_unit_id, p.p_unit_name, p.cash_pay, p.hide, p.index_show, p.server_id, p.server_name, p.payment, p.create_time, s.uuid " +
                "FROM kk_product p RIGHT JOIN kk_shop_product ps ON p.id = ps.product_id LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE hide = 1 AND is_recomm != 0 AND s.uuid=? GROUP BY p.id ORDER BY is_recomm DESC  LIMIT 6", s.getStr("uuid"));
        s.put("recommGoods", recommGoods);
        String[] sorts = s.getStr("sort").split(",");
        for (int i = 0; i < sorts.length; i++) {
            Map<String, Object> m = new HashMap<String, Object>();
            Record r = Db.findFirst("select id as typeId,name,img from kk_product_type where id=?", sorts[i]);
            Map<String, Object> obj = new HashMap<String, Object>();
            Record record = Db.findFirst("select * from kk_product_type pt where pt.id in (" + sorts[i] + ")");
            obj.put("typeId", record.getInt("id"));
            obj.put("name", record.getStr("name"));
            obj.put("img", record.getStr("img"));
            obj.put("is_norm", record.getInt("is_norm"));
            types.add(obj);
            m.put("type", r);
            List<Goods> g = new Goods().find("select p.id as productId,p.name,p.title,p.price,p.p_type_id,p.p_brand_id,p.p_type_name,p.p_brand_name,p.cover_img,p.p_unit_id,p.p_unit_name,p.cash_pay,p.hide,p.index_show,p.server_id,p.server_name,p.payment,p.create_time  " +
                    "from kk_product p right join kk_shop_product ps on p.id=ps.product_id " +
                    "LEFT JOIN kk_shop s on ps.shop_id=s.id where p.p_type_id=? and s.uuid=?  GROUP BY p.id order by ps.sort_id desc, is_recomm desc LIMIT 0,6", new Object[]{sorts[i], s.getStr("uuid")});
            if (g.size() != 0) {
                m.put("products", g);
                maps.add(m);
            }
        }
        s.put("types", maps);
        s.put("shopCount", 1);
        s.put("category", types);
        renderSuccess("获取成功", s);
    }

    /***
     * 乐享云购 订单下载
     * @author 秦帅
     */
    @ActionKey("app/user/v2/addOrderInfo")
    @Before(Tx.class)
    public void addOrderInfo() {
        JSONObject json = JSONObject.fromObject(getPara("info"));
        boolean b = new User().isLogin(json.getString("uid"));
        if (!b) {
            renderFaile("请登录！");
            return;
        }
        Map<String, Object> map = new HashMap<String, Object>();
        String orderNo = M.getOrderNo();
        String orderId = M.getOrderId();
        String sendTime = "";
        int sendId = 0;
        int orderStatus = IConstant.OrderStatus.order_status_chushi;
        int price = json.getInt("price");
        String uid = json.getString("uid");
        User u = new User().getUser(uid);

        String shopId = json.getString("shopId");
        if (shopId == null || shopId.equals("0")) {
            renderFaile("下单异常！");
            return;
        }
        int payType = json.getInt("payType");
        int sendType = json.getInt("sendType");
        int addressId = json.getInt("addressId");

        if (sendType == IConstant.send_type_dingshi) {
            sendTime = json.getString("sendTime");
            map.put("send_time", DateTools.unixTimeToDate(sendTime));
        }
        map.put("pay_type", payType);
        if (payType != 0) {
            Record r = Db.findById("kk_pay_type", payType);
            map.put("pay_name", r.get("pay_type_name"));
            if (payType == 3) {
                orderStatus = IConstant.OrderStatus.order_status_dfh;
            } else {
                orderStatus = IConstant.OrderStatus.order_status_chushi;
            }
        }
        map.put("order_no", orderNo);
        map.put("order_id", orderId);
        map.put("order_status", orderStatus);
        map.put("create_time", new Date());
        // map.put("price", price);
        map.put("order_no", orderNo);
        map.put("order_type", 1);
        map.put("u_uuid", uid);
        map.put("s_uuid", shopId);
        map.put("address_id", addressId);
        map.put("send_type", sendType);
        map.put("send_name", IConstant.sendType.get(sendType));
        map.put("send_id", sendId);
        map.put("is_rob", 1);
        if (json.containsKey("remark")) {
            map.put("remark", json.getString("remark"));
        }
        Shop shop = new Shop().findFirst("select * from kk_shop s where s.uuid=?", new Object[]{shopId});
        /**配送**/
        if (addressId != 0 && !shopId.equals("")) {
            Record r = Db.findById("kk_user_address", addressId);
            map.put("address", r.get("full_address"));
            map.put("shop_name", shop.get("name"));
            /**
             * 配送距离超过1000米 不让下单
             * */
//            Record dis=Db.findFirst("select distance(?,?,?,?) as dis",r.getDouble("lng"),r.getDouble("lat"),shop.getDouble("lng"),shop.getDouble("lat"));
//            if(dis.getDouble("dis")>1000){
//                renderFaile("太远了！！送不到啊 亲~");
//                return;
//            }
            /**
             * 是否在配送区域内
             * */
            if (shop.getStr("scope") != null) {
                JSONObject jsonObject = JSONObject.fromObject(shop.getStr("scope"));
                List objs = JsonUtils.json2list(jsonObject.getString("scope"));
                Point[] points = Point.list2point(objs);
                Point p = new Point(r.getDouble("lat"), r.getDouble("lng"));
                boolean flag = Point.inPolygon(p, points);
                if (!flag) {
                    renderFaile("超过指定区域,暂时无法下单");
                    return;
                }
            }
        }
        String receive_code = RegularUtil.gen();
        map.put("receive_code", receive_code);
        String items = json.getString("orderItems");

        /***价格总额**/
        int allPrice = 0;
        net.sf.json.JSONArray array = net.sf.json.JSONArray.fromObject(items);
        if (array.size() > 0) {
            for (int i = 0; i < array.size(); i++) {
                JSONObject o = array.getJSONObject(i);
                int productId = o.getInt("productId");
                int productNum = o.getInt("productNum");
                boolean flag = goodsService.isProEnough(productId, productNum, shop.getInt("id"));
                if (!flag) {
                    renderFaile("库存不够");
                    return;
                }
                Goods g = new Goods().findById(productId);
                int pric = g.getBigDecimal("price").intValue();
                allPrice += pric * productNum;
            }
        }
        /***代金劵
         * 抵扣**/
        if (json.containsKey("cashPay") && json.getInt("cashPay") != 0 && payType != 3) {
            Record r = Db.findFirst("select IFNULL(sum(cash),0) as cash,u_uuid from kk_user_cash uc left join kk_cash c on uc.cash_id=c.id  " +
                    "where uc.u_uuid=? and c.cash_status=1", new Object[]{uid});
            if (r.getBigDecimal("cash").intValue() != 0) {
                int cash = r.getBigDecimal("cash").intValue();
                Record record = Db.findFirst("select count(*) as count from kk_shop_activity sa where sa.shop_id=? and activity_type=7", shop.getInt("id"));
                if (record.getLong("count") > 0) {
                    int reduce = orderService.getReduceCash(shop.getInt("id"), allPrice);
                    allPrice = allPrice - reduce;
                    /***
                     * 总价减去活动区间红包可优惠代金券
                     * */
                    new User().dao.reduceCash(uid, reduce);
                }
            }
        }
        if (allPrice != price) {
            renderFaile("总金额异常");
            return;
        }
        map.put("price", allPrice);
        map.put("cash_pay", json.getInt("cashPay"));
        Order o = new Order();
        o.setAttrs(map);
        boolean f = orderService.splice2Create(orderId, items, json.getInt("cashPay"));
        if (f) {
            boolean s = o.save();
            if (s) {
                net.sf.json.JSONArray pros = net.sf.json.JSONArray.fromObject(items);
                if (array.size() > 0) {
                    for (int i = 0; i < array.size(); i++) {
                        JSONObject pro = array.getJSONObject(i);
                        int productId = pro.getInt("productId");
                        int productNum = pro.getInt("productNum");
                        goodsService.reduceProNum(productId, productNum, shop.getInt("id"));
                    }
                }
                /**下单后短信推送**/
                if (payType == 3) {
                    String str = ",收货人:" + o.getStr("name");
                    str += ",联系电话：" + o.getStr("phone");
                    str += ",收获地址:" + o.getStr("address");
                    str += ",支付方式：" + o.getStr("pay_name");
                    str += ",购买产品：【";
                    for (Record r : o.getOrderItems(o.getStr("uuid"))) {
                        str += r.getStr("name") + "*" + r.getInt("product_number") + ",";
                    }
                    str += "】";
                    str += "总价:" + o.getInt("price") / 100 + "元";
                    SdkMessage.sendUser(shop.getStr("phone"), str);
                }
                /**下单后 程序推送**/
                Map<String,Object> pu=new HashMap<String,Object>();
                pu.put("orderId",orderId);
                JPushKit.push(shop.getStr("phone"),"shop",IConstant.content_order_new,pu,"");
            }
        } else {
            renderFaile("购买出现异常");
            return;
        }
        renderSuccess("下单成功", o);
    }


    /***
     * C端 fb产品信息
     **/
    @ActionKey("app/user/v2/FBProduct")
    public void FBProductInfo() {
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        int productId = obj.getInt("productId");
        FBGoods fb = FBGoods.dao.findbyId(productId);
        if (fb == null) {
            renderSuccess("产品异常或丢失", null);
            return;
        }
        renderSuccess("获取成功", fb);
    }

    /**
     * @author M
     * c端 用户购物车产品id 查询匹配  客户端价格与服务器价格是否一致
     */
    @ActionKey("app/user/v2/SCProduct")
    public void SCProduct() {
        JSONObject json = JSONObject.fromObject(getPara("info"));
        net.sf.json.JSONArray pids = net.sf.json.JSONArray.fromObject(json.get("pids"));
        if (pids.size() == 0) {
            renderFaile("有异常！");
            return;
        }
        List goods = new ArrayList<Goods>();
        for (int i = 0; i < pids.size(); i++) {
            JSONObject obj = pids.getJSONObject(i);
            if (obj.getInt("is_norm") == 1) {
                Goods g = Goods.dao.findById_lazy(obj.getInt("productId"));
                goods.add(g);
            }
            if (obj.getInt("is_norm") == 2) {
                FBGoods f = FBGoods.dao.findById_lazy(obj.getInt("productId"));
                goods.add(f);
            }
        }
        renderSuccess("获取信息成功", goods);
    }

    /**
     * @author M
     * c端 非标类型返回店铺
     */
    @ActionKey("app/user/v2/findShopsByType")
    public void findShopsByType() {
        JSONObject json = JSONObject.fromObject(getPara("info"));
        int typeId = json.getInt("typeId");
        String lng = json.getString("lng");
        String lat = json.getString("lat");
        int pg = 1;
        if (json.containsKey("pg")) {
            pg = json.getInt("pg");
        }
        Record r = Db.findById("kk_product_type", typeId);
        Page<Shop> shops = Shop.dao.paginate(pg, IConstant.PAGE_DATA, "select id as shopId,name,full_address,shop_type,is_norm,cover_img,uuid,title,title2,title3", "from kk_shop s where shop_type=? order by distance(?,?,s.lng,s.lat) asc", new Object[]{r.getInt("shop_type"), lng, lat,});
        renderSuccess("success", shops);
    }

    /***
     * C端 fb店面产品列表
     **/
    @ActionKey("app/user/v2/FBProducts")
    public void userFBProducts() {
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        int pg = 1;
        if (obj.containsKey("pg")) {
            pg = obj.getInt("pg");
        }
        String uid = obj.getString("shopId");
        Shop s = Shop.dao.findBysuid(uid);
        Page<FBGoods> fbGoodses = null;
        if (s.getInt("is_norm") == 2) {
            fbGoodses = FBGoods.dao.findBySID(uid, pg);
        }
//        if(s.getInt("is_norm")==1){
//            Page<Goods> goods=Goods.dao.
//        }
        renderSuccess("获取成功", fbGoodses);
    }

    /***
     * C端 推荐产品列表
     **/
    @ActionKey("app/user/v2/recommProducts")
    public void recommProducts() {
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        int pg = 1;
        if (obj.containsKey("pg")) {
            pg = obj.getInt("pg");
        }
        String lat = obj.getString("lat");
        String lng = obj.getString("lng");
        Page<Goods> recommGoods = Goods.dao.paginate(pg, IConstant.PAGE_DATA, "SELECT p.id AS productId, p. name, p.title, p.price, p.p_type_id, p.p_brand_id, p.p_type_name, p.p_brand_name, p.cover_img, p.p_unit_id, p.p_unit_name, p.cash_pay, p.hide, p.index_show, p.server_id, p.server_name, p.payment, p.create_time", "FROM kk_product p RIGHT JOIN kk_shop_product ps ON p.id = ps.product_id LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE hide = 1 AND is_recomm != 0 GROUP BY p.id ORDER BY is_recomm DESC, distance ( ?, ?, s.lng, s.lat ) ASC", lng, lat);
        renderSuccess("获取成功", recommGoods);
    }

    /***
     * C端 小区列表
     **/
    @ActionKey("/app/user/v2/districtList")
    public void districtList() {
        JSONObject json = JSONObject.fromObject(getPara("info"));
        String lng = json.getString("lng");
        String lat = json.getString("lat");
        int pg = 1;
        if (json.containsKey("pg")) {
            pg = json.getInt("pg");
        }
        Page<District> district = District.dao.paginate(pg, IConstant.PAGE_DATA, "select id as districeId,name,province_name,city_name,area_name ", "from kk_district d where distance(?,?,d.lat,d.lng) <=500", lat, lng);
        renderSuccess("获取成功", district);
    }

    /***
     * C端 地区列表
     */
    @ActionKey("/app/user/v2/cityList")
    public void cityList() {
        JSONObject json = JSONObject.fromObject(getPara("info"));
        String lng = json.getString("lng");
        String lat = json.getString("lat");
        int code = json.getInt("code");
        List<District> cityList = District.dao.find("select city_id, city_name FROM kk_district d WHERE d.province_id = ? GROUP BY city_id ORDER BY  distance (?,?,d.lng,d.lat) ASC ", new Object[]{code, lng, lat});
        for (District district : cityList) {
            int cityId = district.getInt("city_id");
            List<District> districts = District.dao.find("select id as districe_id,name from kk_district d where d.city_id=?", cityId);
            district.put("district", districts);
            for (District district1 : districts) {
                List<Shop> shops = Shop.dao.find("select id as shop_id,uuid as s_uid,name,link_man,full_address,phone from kk_shop s where s.district_id=?", district1.getInt("districe_id"));
                district1.put("shops", shops);
            }
        }
        renderSuccess("获取成功", cityList);
    }

    @ActionKey("/app/user/v2/searchName")
    public void searchName() {
        JSONObject json = JSONObject.fromObject(getPara("info"));
        String s_uid = json.getString("s_uid");
        if (!json.containsKey("s_uid")) {
            renderFaile("异常");
        }
        int pg = 1;
        Page<Goods> products = null;
        if (json.containsKey("pg")) {
            pg = json.getInt("pg");
        }
        if (json.containsKey("txm_code") && !json.getString("txm_code").equals("")) {
            products = Goods.dao.findByTxm(s_uid, json.getString("txm_code"), pg);
        }
        if (json.containsKey("p_name") && !json.getString("p_name").equals("")) {
            products = Goods.dao.findByName(s_uid, json.getString("p_name"), pg);
        }
        renderSuccess("获取成功", products);
    }

    @ActionKey("/app/user/v2/types")
    public void productType() {
        JSONObject json = JSONObject.fromObject(getPara("info"));
        String s_uid = json.getString("s_uid");
        List<Record> records = Db.find("SELECT p.p_type_id, p.p_type_name, pt.img FROM kk_product p LEFT JOIN kk_shop_product ps ON ps.product_id = p.id LEFT JOIN kk_shop s ON ps.shop_id = s.id LEFT JOIN kk_product_type pt ON pt.id = p.p_type_id WHERE s.uuid = ? GROUP BY p_type_id", s_uid);
        renderSuccess("获取成功", records);
    }

    @ActionKey("/app/user/v2/searchBands")
    public void searchBands() {
        JSONObject json = JSONObject.fromObject(getPara("info"));
        int type_id = json.getInt("type_id");
        String s_uid = json.getString("s_uid");
        List<Record> records = Db.find("SELECT p.p_brand_id, p.p_brand_name,p.p_type_id, p.p_type_name FROM kk_product p LEFT JOIN kk_shop_product ps ON ps.product_id = p.id LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE s.uuid = ? AND p.p_type_id = ? GROUP BY p_brand_id;", s_uid, type_id);
        renderSuccess("获取成功", records);
    }

    @ActionKey("/app/user/v2/versionController")
    public void version() {
        log.info("version");
        JSONObject json = JSONObject.fromObject(getPara("info"));
        String system = json.getString("system");
        Record record = Db.findFirst("select * from kk_app where app like ?", "%" + system + "%");
        renderSuccess("获取成功", record);
    }

    @ActionKey("/app/user/v2/getShopLatLng")
    public void loadLatLng() {
        log.info("loadLatLng");
        JSONObject json = JSONObject.fromObject(getPara("info"));
        if (!json.containsKey("s_uid")) {
            renderFaile("异常");
        }
        String s_uid = json.getString("s_uid");
        Shop s = Shop.dao.findFirst("select name,link_man,phone,full_address,lat,lng,uuid as s_uid,create_time from kk_shop s where s.uuid=?", s_uid);
        renderSuccess("获取成功", s);
    }

    @ActionKey("/app/user/v2/getShopsByLatLng")
    public void getShopsByLatLng() {
        log.info("loadLatLng");
        JSONObject json = JSONObject.fromObject(getPara("info"));
        if (!json.containsKey("lat") || !json.containsKey("lng")) {
            renderFaile("异常");
            return;
        }
        String lng = json.getString("lng");
        String lat = json.getString("lat");
        List<Shop> s = Shop.dao.find("select name,link_man,phone,full_address,lat,lng,uuid as s_uid,create_time from kk_shop s where distance(?,?,s.lng,s.lat)<=1000 ", lng, lat);
        renderSuccess("获取成功", s);
    }

    @ActionKey("/app/user/v2/shopList")
    public void loadShopByArea() {
        log.info("loadShopByArea");
        JSONObject json = JSONObject.fromObject(getPara("info"));
        int areaCode = json.getInt("code");
        String lng = json.getString("lng");
        String lat = json.getString("lat");
        List<Shop> shops = Shop.dao.find("SELECT s.uuid AS s_uid, s.name,s.link_man, s.full_address, s.phone FROM kk_shop s LEFT JOIN kk_district d ON d.id = s.district_id WHERE d.area_id = ? ORDER BY  distance (?,?,d.lng,d.lat) ASC", areaCode, lng, lat);
        renderSuccess("获取成功", shops);
    }

    @ActionKey("/app/user/v2/searchShop")
    public void searchShop() {
        log.info("searchShop");
        JSONObject json = JSONObject.fromObject(getPara("info"));
        String name = json.getString("name");
        String lng = json.getString("lng");
        String lat = json.getString("lat");
        List<Shop> shops = Shop.dao.find("select s.uuid AS s_uid, s.name,s.link_man, s.full_address, s.phone from kk_shop s where s.name like ? ORDER BY  distance (?,?,s.lng,s.lat) ASC", "%" + name + "%", lng, lat);
        renderSuccess("获取成功", shops);
    }

    /**
     * @author M
     * 意见反馈接口
     */
    @ActionKey("/app/user/v2/feedBack")
    public void feedBack() {
        log.info("feedBack");
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        String uid = "";
        if (obj.containsKey("uid")) {
            uid = obj.getString("uid");
        }
        String content = obj.getString("content");
        Record r = new Record();
        r.set("u_uid", uid);
        r.set("content", content);
        r.set("create_time", new Date());
        Db.save("kk_feed_back", r);
        renderSuccess("成功", null);
    }

    /**签到**/
    @ActionKey("/app/user/v2/addSign")
    public void sign() {
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        if (!obj.containsKey("uid")) {
            renderFaile("异常");
            return;
        }
        new User().dao.addSignLog(obj.getString("uid"));
        renderSuccess("签到成功", null);
    }

    /**签到记录
     * jf_num 积分
     * lxqd_num 累计签到天数
     * zqd_num 总签到天数
     * **/
    @ActionKey("/app/user/v2/signLog")
    public void signLog() {
        log.info("signLog");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        if (!obj.containsKey("uid")) {
            renderFaile("异常");
            return;
        }
        List<Record> records = Db.find("select create_time from kk_login_sign ll where ll.u_uid=?", obj.getString("uid"));
        Record record = Db.findFirst("SELECT IFNULL(( SELECT ls.num FROM kk_login_sign ls WHERE ls.u_uid = ? order by id desc limit 0,1), 0 ) AS lxqd_num, " +
                "IFNULL(( SELECT integral FROM kk_integral i WHERE i.u_uid = ? and type=2), 0 ) AS jf_num, " +
                "IFNULL(( SELECT COUNT(ll.num) FROM kk_login_sign ll WHERE ll.u_uid = ? ), 0 ) AS zqd_num", obj.getString("uid"), obj.getString("uid"), obj.getString("uid"));
        Map<Object, Object> map = new HashMap<>();
        map.put("times", records);
        map.put("record", record);
        map.put("date", sdf.format(new Date()));
        renderSuccess("获取成功", map);
    }

    @ActionKey("/app/user/v2/categorys")
    public void categorys() {
        log.info("categorys");
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        List<GoodCategory> goodCategories = GoodCategory.dao.find("select * from kk_product_category order by sort_id asc");
        for (GoodCategory goodCategory : goodCategories) {
            goodCategory.put("types", goodCategory.getGoodTypes(goodCategory.getInt("id")));
        }
        renderSuccess("获取成功", goodCategories);
    }


    @ActionKey("/app/user/v2/categorys_1")
    public void homeCategory() {
        log.info("categorys");
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        List<GoodCategory> goodCategories = GoodCategory.dao.find("select * from kk_product_category order by sort_id asc");
        for (GoodCategory goodCategory : goodCategories) {
            goodCategory.put("types", goodCategory.getGoodTypes_1(goodCategory.getInt("id")));
        }
        renderSuccess("获取成功", goodCategories);
    }

    @ActionKey("/app/user/v2/homeCategory")
    public void homeCategory_1() {
        log.info("homeCategory");
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        List<GoodCategory> goodCategories = GoodCategory.dao.find("select * from kk_product_category order by sort_id asc");
        renderSuccess("获取成功", goodCategories);
    }

    /**
     * 红包减免规则
     */
    @ActionKey("/app/user/v2/hb")
    public void reductHB() {
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        String s_uid = obj.getString("s_uid");
        Shop shop = Shop.dao.findBysuid(s_uid);
        if (shop == null) {
            renderFaile("异常");
            return;
        }
        Record record = Db.findFirst("select * from kk_shop_activity sa where sa.shop_id=? and activity_type=7", shop.getInt("id"));
        if (record != null) {
            JSONObject o = JSONObject.fromObject(record.getStr("price_rule"));
            renderSuccess("price_rule", o);
            return;
        }
        renderFaile("异常");
    }

    @ActionKey("/app/user/v2/shopScope")
    public void shopScope() {
        log.info("shopScope");
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        String s_uid = obj.getString("s_uid");
        Shop shop = Shop.dao.findBysuid(s_uid);
        String scope = "";
        if (shop != null) {
            scope = shop.getStr("scope");
            JSONObject o = JSONObject.fromObject(scope);
            renderSuccess("price_rule", o);
            return;
        }
        renderFaile("店面异常");
    }

    @ActionKey("/app/user/v2/formIrr")
    public void formIrr() {
        log.info("formIrr");
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        String form_id = obj.getString("form_id");
        Form form=Form.dao.findById(form_id);
        Record record=new Record();
        String cause="";
        if(obj.containsKey("cause")){
            cause=obj.getString("cause");
        }
        record.set("form_id",form_id);
        record.set("uid",obj.getString("uid"));
        record.set("cause",cause);
        renderSuccess("成功",null);
    }

    @ActionKey("/app/user/v2/userJF")
    public void userJF(){
        log.info("userJF");
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        String u_id=obj.getString("u_id");
        User user=User.dao.getUser(u_id);
        if(user==null){
            renderFaile("u_id 异常");
            return;
        }
        Record record=Db.findFirst("SELECT IFNULL((SELECT integral from kk_integral where u_uid=? and type=1 ),0) as jf ,IFNULL((SELECT integral from kk_integral where u_uid=? and type=2 ),0) as mg",u_id,u_id);
        renderSuccess("获取成功",record);
    }
}
