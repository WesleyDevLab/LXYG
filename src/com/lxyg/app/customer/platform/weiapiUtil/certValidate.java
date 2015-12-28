package com.lxyg.app.customer.platform.weiapiUtil;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLContexts;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import javax.net.ssl.SSLContext;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.security.KeyStore;

/**
 * Created by ÇØË§ on 2015/12/25.
 */
public class certValidate {

    public static String validate(String path,String mac_id,String xml,String postURL) throws Exception{
        String text="";
        KeyStore keyStore  = KeyStore.getInstance("PKCS12");
        FileInputStream instream = new FileInputStream(new File(path));
        try {
            keyStore.load(instream, mac_id.toCharArray());
        } finally {
            instream.close();
        }
        // Trust own CA and all self-signed certs
        SSLContext sslcontext = SSLContexts.custom()
                .loadKeyMaterial(keyStore, mac_id.toCharArray())
                .build();
        // Allow TLSv1 protocol only
        SSLConnectionSocketFactory sslsf = new SSLConnectionSocketFactory(
                sslcontext,
                new String[] { "TLSv1" },
                null,
                SSLConnectionSocketFactory.BROWSER_COMPATIBLE_HOSTNAME_VERIFIER);
        CloseableHttpClient httpclient = HttpClients.custom()
                .setSSLSocketFactory(sslsf)
                .build();


        try {
            HttpPost httpPost=new HttpPost(postURL);
            httpPost.setEntity(new StringEntity(xml));
            CloseableHttpResponse response = httpclient.execute(httpPost);
            try {
                HttpEntity entity = response.getEntity();
                if (entity != null) {
                    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(entity.getContent()));
                    while ((text = bufferedReader.readLine()) != null) {
                        text=new String(text.getBytes(),"utf-8");
                    }
                }
                EntityUtils.consume(entity);
            } finally {
                response.close();
            }
        } finally {
            httpclient.close();
        }
        return  text;
    }

    public static void main(String[] args) {
        String str="<xml><sign>F6B046E002CE6C47767A2F1558D7D742</sign><refund_fee>1</refund_fee><mch_id>1281748701</mch_id><refund_fee_type>CNY</refund_fee_type><total_fee>1</total_fee><op_user_id>1281748701</op_user_id><appid>wx2d2b54b6349d8ef7</appid><out_refund_no>07d630da1ab24176</out_refund_no><nonce_str>2kc11ivvjpbgwy5lini5tzz58p62jb80</nonce_str><transaction_id>1008760584201512282365239423</transaction_id></xml>";
        //validate();
    }
}
