package com.lxyg.app.customer.platform.controller;

import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.weiapiUtil.DateUtil;
import com.lxyg.app.customer.platform.weiapiUtil.WXUtil;
import com.lxyg.app.customer.tencent.common.XMLParser;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.*;

public class wxContronller extends Controller {
	private static Logger log= Logger.getLogger(wxContronller.class);
	
	public void autoMessage(){
		log.error("autoMessage--");
		HttpServletRequest request=getRequest();
		HttpServletResponse response=getResponse();
		try {
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter pw=response.getWriter();
			String timestamp = request.getParameter("timestamp");
			String nonce = request.getParameter("nonce");
			String signature = request.getParameter("signature");
			String echostr = request.getParameter("echostr");
			log.error(timestamp+"_"+nonce+"_"+signature+"_"+echostr);
			if(echostr!=null){
				String[] str = {"kaka",timestamp,nonce};
				Arrays.sort(str);
				String bigStr = str[0] + str[1] + str[2];
				String digest = DigestUtils.shaHex(bigStr);
				if (digest.equals(signature)) {
					renderText(echostr);
					return;
				}
			}
			log.error("autoMessage--");
			BufferedReader reader = request.getReader();
			StringBuffer buffer = new StringBuffer();
			
			String string;
			while ((string = reader.readLine()) != null) {
				buffer.append(string);
			}
			reader.close();
			String notifyJson = new String(buffer);
			log.error("notifyJson:"+notifyJson);
			Map<String,Object> map=XMLParser.getMapFromXML(notifyJson);
			
			String wx=map.get("ToUserName").toString();
			String MsgType=map.get("MsgType").toString();
			String FromUserName=map.get("FromUserName").toString();
			
			
			List<Record> res=new ArrayList<Record>();
			Map<String,Object> resultMap=new HashMap<String, Object>();
			resultMap.put("ToUserName", FromUserName);
			resultMap.put("FromUserName", wx);
			resultMap.put("CreateTime", DateUtil.getTimeStamp());
			resultMap.put("MsgType", "news");
			
			List<Map<String,Object>> maps=new ArrayList<Map<String,Object>>();
			if(MsgType.equals("event")){
				String event=map.get("Event").toString();
				if(event.equals("CLICK")){
					String EventKey=map.get("EventKey").toString();
					res= Db.find("select wm.* from kk_wx_event wx left join kk_wx_msg wm on wx.id=wm.wx_msg_id where msg_type=? and event=? and wx=? and event_key=?", new Object[]{MsgType, event, wx, EventKey});
				}
				if(event.equals("subscribe")){
					res= Db.find("select wm.* from kk_wx_event wx left join kk_wx_msg wm on wx.id=wm.wx_msg_id where msg_type=? and event=? and wx=?", new Object[]{MsgType, event, wx});
				}
			}
			
			if(MsgType.equals("text")){
				res= Db.find("select wm.* from kk_wx_event wx left join kk_wx_msg wm on wx.id=wm.wx_msg_id where msg_type=? and wx=?", new Object[]{MsgType, wx});
			}
			
			
			resultMap.put("ArticleCount", res.size());
			if(res.size()!=0){
				for(Record r:res){
					Map<String,Object> m=new HashMap<String, Object>();
					m.put("Title", r.getStr("title"));
					m.put("Description", r.getStr("content"));
					m.put("PicUrl", r.getStr("pic_url"));
					m.put("Url", r.getStr("url"));
					maps.add(m);
				}
				resultMap.put("Articles", maps);
			}
			String resXml=WXUtil.MapToXml(resultMap);
			if(resXml!=null){
				renderText(resXml);
			}else{
				renderText("success");
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
	}


}
