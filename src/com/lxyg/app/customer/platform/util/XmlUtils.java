package com.lxyg.app.customer.platform.util;

import net.minidev.json.JSONObject;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import java.io.*;
import java.util.List;

public class XmlUtils {

	public Document loadDoc() throws DocumentException {
		SAXReader reader = new SAXReader();
		String file = "D:/projects/ar/Tracking.xml";
		Document doc = reader.read(new File(file));
		return doc;
	}
	
	public static Document loadStringDoc(String requestMsg) throws DocumentException {
		SAXReader reader = new SAXReader();
		byte[] bytes = requestMsg.getBytes();
		InputStream in = new ByteArrayInputStream(bytes);
		InputStreamReader strInStream = null;
		try {
			strInStream = new InputStreamReader(in, "GBK");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		Document doc = reader.read(strInStream);
		return doc;
	}
	public static String parseMessage(Document doc,String xml){
		String chatMessage = null;
		if(null == doc){
			try {
				doc = loadStringDoc(xml);
			} catch (DocumentException e) {
				e.printStackTrace();
			}
		}
		Element root = doc.getRootElement();
		String type = root.attributeValue("type");
		if(null != type && "chat".equals(type)){
			chatMessage = root.elementText("body");
		}
		return chatMessage;
	}
	public void parseDoc(Document doc){
		if(null == doc){
			try {
				doc = loadDoc();
			} catch (DocumentException e) {
				e.printStackTrace();
			}
		}
		Element root = doc.getRootElement();
		System.out.println(root.getName());
		List cosList = root.element("Connections").elements("COS");
		for(int i=0,s=cosList.size();i<s;i++){
			//System.out.println(i + ": size "+s);
			Element elem = (Element)cosList.get(i);
			String cosName = elem.element("Name").getText();
			String sensorCosID = elem.element("SensorSource").elementText("SensorCosID");
			System.out.println(cosName.concat(":").concat(sensorCosID));
		}
		Object cloneLast = ((Element)cosList.get(cosList.size()-1)).clone();
		Element cosX = (Element)cloneLast;
		String oldName = cosX.elementText("Name");
		String[] nameArray = oldName.split("_");
		Integer nameIndex = Integer.parseInt(nameArray[1]);
		String newName = nameArray[0].concat("_").concat(String.valueOf(nameIndex+1));
		//System.out.println(newName);
		cosX.element("Name").setText(newName);
		String strSensorCosIDX = "abctest123";
		Element sensorCosIDX = cosX.element("SensorSource").element("SensorCosID");
		sensorCosIDX.setText(strSensorCosIDX);
		//System.out.println("new xml ...");
		//System.out.println(cosX.asXML());
		root.element("Connections").add(cosX);
		//System.out.println(root.element("Connections").asXML());
		List sensorCosList = root.element("Sensors").element("Sensor").elements("SensorCOS");
		for(int j=0,s=sensorCosList.size();j<s;j++){
			System.out.println(j + ": size "+s);
			Element sensorCOS = (Element)sensorCosList.get(j);
			//System.out.println(sensorCOS.asXML());
			String strSensorCosID = sensorCOS.elementText("SensorCosID");
			String strReferenceImage = sensorCOS.element("Parameters").elementText("ReferenceImage");
			System.out.println(strSensorCosID.concat("[").concat(strReferenceImage));
			//String strMap = sensorCOS.element("Parameters").elementText("Map");
			//System.out.println(strSensorCosID.concat("[").concat(strReferenceImage).concat(",").concat(strMap).concat("]"));
		}
		Object cloneLastSensorCos = ((Element)sensorCosList.get(sensorCosList.size()-1)).clone();
		Element lastSensorCos = (Element)cloneLastSensorCos;
		lastSensorCos.element("SensorCosID").setText(strSensorCosIDX);
		lastSensorCos.element("Parameters").element("ReferenceImage").setText(strSensorCosIDX.concat(".jpg"));
		//lastSensorCos.element("Parameters").element("Map").setText(strSensorCosIDX.concat(".f2b"));
		root.element("Sensors").element("Sensor").add(lastSensorCos);
		//System.out.println(root.asXML());
	}

	public void writeDoc(Document doc){//http://www.cnblogs.com/yezhenhan/archive/2012/09/10/2678690.html
		String file = "D:/projects/ar/Tracking2.xml";
		BufferedOutputStream bufferOut = null;
		FileOutputStream fileOut = null; 
		try {   
			fileOut = new FileOutputStream(new File(file));   
			bufferOut = new BufferedOutputStream(fileOut);   
			bufferOut.write(doc.asXML().getBytes());
			bufferOut.flush();   
			bufferOut.close();   
		} catch (Exception e) {   

			e.printStackTrace();   

		}  
	}
	

	/**
	 * @param args
	 * @throws DocumentException
	 */
	public static void main(String[] args) throws DocumentException {
		XmlUtils xu = new XmlUtils();
		String xml = "<message id=\"6vKog-75\" to=\"caichao@txyfxtox1\" from=\"wangchaowei@txyfxtox1/Spark 2.6.3\" type=\"chat\"><body>xxxx</body><thread>mJQ21t</thread><x xmlns=\"jabber:x:event\"><offline/><composing/></x></message>";
		xml = "<message type=\"chat\" to=\"test@txyfxtox1/yunfengApp\" from=\"zhangbei@txyfxtox1/yunfengApp\"><body>{\"content\":\"http://res.xtox.net:8887/yuxintong/2014/6/4/fb4d0f2c-255e-4a0f-9c93-13f60447a645.mp3\",\"type\":1,\"length\":8}</body></message>";
		Document doc = xu.loadStringDoc(xml);
		String result = xu.parseMessage(doc, xml);
		JSONObject obj = (JSONObject) JsonUtils.json2pojo(result);
		String content = "";
		Integer type = (Integer)obj.get("type");
		if(type==1){
			content = "语音消息";
		}else if(type==2){
			content = obj.get("content").toString();
		}else if(type==3){
			content = "图片消息";
		}
		//xu.parseDoc(doc);
		//xu.writeDoc(doc);
	}

}
