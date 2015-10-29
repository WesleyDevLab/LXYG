<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="com.jfinal.plugin.activerecord.*"%>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="/metro.jsp"></jsp:include>
</head>
<body>
<%
System.out.println("begin edit");
out.println("begin edit<br/>");
String q = "select cardid,shopid,cardname,discount from hc_shop_card ";
List<Record> shopcards = Db.find(q);
Map<Integer,Integer> cards = new HashMap<Integer,Integer>();
for(int i=0;i<shopcards.size();i++){
	Record card = shopcards.get(i);
	Integer shopid = card.getInt("shopid");
	Integer discount = card.getInt("discount");
	cards.put(shopid,discount);
}
String goodsq = "select * from hc_shop_goods";
List<Record> goods = Db.find(goodsq);
for(int i=0,len=goods.size();i<len;i++){
	Record ag = goods.get(i);
	Long marketp = ag.getNumber("marketprice").longValue();
	Integer shopId = ag.getInt("shopid");
	Integer discount = cards.get(shopId);
	Long ap = (marketp * discount)/100;
	Integer gid = ag.getInt("goodsid");
	String u = "update hc_shop_goods set price=? where goodsid=?";
	Db.update(u,ap,gid);
}
out.println("edit total:"+goods.size()+"<br/>");
out.println("end edit<br/>");
System.out.println("edit total:"+goods.size());
System.out.println("end edit");
%>
</body>
</html>