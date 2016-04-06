package com.lxyg.app.customer.platform.controller;

import com.jfinal.core.ActionKey;
import com.jfinal.core.Controller;
import com.lxyg.app.customer.platform.model.Order;
import com.lxyg.app.customer.platform.model.Shop;
import com.lxyg.app.customer.platform.service.GoodsService;
import com.lxyg.app.customer.platform.service.OrderService;
import com.lxyg.app.customer.platform.util.IConstant;
import com.lxyg.app.customer.platform.util.M;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import com.lxyg.app.customer.platform.util.MD5;
import java.util.Date;


/**
 * Created by 秦帅 on 2016/3/9.
 */
public class synchDataController extends Controller {
    private static final Logger log = Logger.getLogger(synchDataController.class);
    private GoodsService goodsService=new GoodsService();
    private OrderService orderService=new OrderService();

    public void renderSuccess(String value, Object o) {
        setAttr("code", 10002);
        setAttr("msg", value);
        if (o == null) {
            setAttr("data", new JSONObject());
        } else {
            setAttr("data", o);
        }
        renderJson();
    }


    public void renderFaile(String value) {
        setAttr("code", 10001);
        setAttr("msg", value);
        renderJson();
    }


    @ActionKey("synch/push")
    public void push(){
        Order o=new Order(); //生成新的订单
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        System.out.println(obj);
        String push_order_no=obj.getString("push_id");
        int price=obj.getInt("price");
        String suid=obj.getString("shopId");
        String items=obj.getString("orderItems");
        Shop s=Shop.dao.findBysuid(suid);
        int allPrice = 0; //普通产品价格
        net.sf.json.JSONArray array = net.sf.json.JSONArray.fromObject(items);
        if(array.size()>0){
            for(int i=0;i<array.size();i++){
                JSONObject oj = array.getJSONObject(i);
                int productId = oj.getInt("productId");
                int productNum = oj.getInt("productNum");
                allPrice+=goodsService.getPrice(productId, productNum, 1);
            }
            if (allPrice!=price){
                renderFaile("价格异常");
                return;
            }
        }else{
            renderFaile("订单异常");
            return;
        }
        String orderNo = M.getOrderNo();
        String orderId = M.getOrderId();
        int orderStatus= IConstant.OrderStatus.order_status_ywc;
        Date d=new Date();
        int orderType=2; // 线下订单
        String uuid="";
        int addressId=0;
        String address=s.getStr("full_address");
        String shopName=s.getStr("name");
        int payType=3;
        String payTypeName="线下交易";
        int sendId=0;
        String sendName="立即送";
        int isRob=1;
        String receiveCode="000000";

        o.set("order_no",orderNo);
        o.set("order_id",orderId);
        o.set("order_status",orderStatus);
        o.set("create_time",d);
        o.set("finish_time",d);
        o.set("price",price);
        o.set("order_type",orderType);
        o.set("u_uuid",uuid);
        o.set("s_uuid",suid);
        o.set("address_id",addressId);
        o.set("address",address);
        o.set("shop_name",shopName);
        o.set("pay_type",payType);
        o.set("pay_name",payTypeName);
        o.set("send_type",1);
        o.set("send_id",sendId);
        o.set("send_name",sendName);
        o.set("is_rob",isRob);
        o.set("receive_code",receiveCode);
        o.set("alipay_no",push_order_no);
        boolean f=o.save();
        if(f){
            orderService.splice2Create_c(orderId, items, s.getInt("id"));
        }
        renderSuccess("10002","同步成功");
    }

    @ActionKey("synch/login")
    public void login(){
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        String phone=obj.getString("phone");
        String pwd=obj.getString("password");
        Shop shop=Shop.dao.findFirst("select uuid,name from kk_shop s where s.phone=? and password=?",phone, MD5.getMd5String(pwd).substring(0,16));
        renderSuccess("登陆成功",shop);
    }

    @ActionKey("synch/lastData")
    public void data(){
        JSONObject obj = JSONObject.fromObject(getPara("info"));
        String suid=obj.getString("shopId");
        Order order=Order.dao.findFirst("SELECT alipay_no FROM kk_order o where o.order_type=2 and o.s_uuid=? ORDER BY id desc LIMIT 0,1",suid);
        renderSuccess("获取成功",order!=null?order.getStr("alipay_no"):"");
    }
}
