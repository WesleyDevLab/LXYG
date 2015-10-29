package com.lxyg.app.customer.tencent.common;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * User: rizenguo
 * Date: 2014/11/1
 * Time: 14:06
 */
public class XMLParser {

    public static Map<String,Object> getMapFromXML(String xmlString) throws ParserConfigurationException, IOException, SAXException {
        //这里用Dom的方式解析回包的最主要目的是防止API新增回包字段
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        InputStream is =  Util.getStringStream(xmlString);
        Document document = builder.parse(is);

        //获取到document里面的全部结点
        NodeList allNodes = document.getFirstChild().getChildNodes();
        Node node;
        Map<String, Object> map = new HashMap<String, Object>();
        int i=0;
        while (i < allNodes.getLength()) {
            node = allNodes.item(i);
            if(node instanceof Element){
                map.put(node.getNodeName(),node.getTextContent());
            }
            i++;
        }
        return map;

    }
    
    public static Map<String,Object> mapFromXml(String xml){
    	Map<String,Object> map = new HashMap<String,Object>();
    	org.dom4j.dom.DOMDocument dom = new org.dom4j.dom.DOMDocument(xml);
    	org.dom4j.Element root = dom.getRootElement();
    	List<Element> ls = root.elements();
    	for(Element e : ls){
    		map.put(e.getNodeName(), e.getTextContent());
    	}
    	
    	return map;
    	
    }
    
    public static void main(String[] args) {
    	try {
			Map m=getMapFromXML(" <xml><AppId><![CDATA[wx10ca6b09cca3d828]]></AppId>    <Encrypt><![CDATA[Ua+DI12k3ZQswPEEHoPUqMN2yvv2e+IpWglfXk2jUZabZoyWSDG0MBRFCVgucucDwY3ZE45gxu3JGT+TfrHGly1WC9HBuPLxP9FwsfiEMMkUZfdvvHAjDBNPSy+lqqhjulcBVEX3M62z5gl5qMcynqNOxt0SGgwHTWjMP9RO37E+YlZLsJyIwAVurC6cajkTruoyOtD4AKqZyCyiN3h2hxk7Uujn3xE1W7KrrQ230TmCETNcPNDhWTeGeBCkd5rvjTbQCFLFhRo9Wlq8fCdB4V9NIWvw46hk4FF+FX43rwefowzq8D4TAMdYIjENGxGQWuO4NQDRdk9il0MucWaQzUxH2nOZTD94et7BZ2PUmCNRiugTFo58DF7EmFpTpxNgcls87+IOx5HbQzgkTcyXPI5uZIR8+1hDo/dmW5ItJvEG3oUVkMpo5hwNuXiZb5jXEG3fx+G9VqnaH2YRSv49CQ==]]></Encrypt></xml>");
		    System.out.println(m);
    	} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}


}
