/*
 * ====================================================================
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 *
 */
package com.lxyg.app.customer.platform.weiapiUtil;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.security.KeyStore;

import javax.net.ssl.SSLContext;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ssl.SSLContexts;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

/**
 * This example demonstrates how to create secure connections with a custom SSL
 * context.
 */
public class ClientCustomSSL {
    public final static void main(String[] args) throws Exception {
        KeyStore keyStore  = KeyStore.getInstance("PKCS12");
        File f=new File("");
        String path=f.getAbsoluteFile()+File.separator+"src"+File.separator+"res"+File.separator+"apiclient_cert.p12";
        FileInputStream instream = new FileInputStream(new File(path));
        try {
            keyStore.load(instream, "1281748701".toCharArray());
        } finally {
            instream.close();
        }
        // Trust own CA and all self-signed certs
        SSLContext sslcontext = SSLContexts.custom()
                .loadKeyMaterial(keyStore, "1281748701".toCharArray())
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
//            HttpGet httpget = new HttpGet("https://api.mch.weixin.qq.com/secapi/pay/refund");
            HttpPost httpPost=new HttpPost("https://api.mch.weixin.qq.com/secapi/pay/refund");
            String str="<xml><sign>48A44D407032DD972047FCA963CEB5F5</sign><refund_fee>2</refund_fee><mch_id>1281748701</mch_id><refund_fee_type>CNY</refund_fee_type><total_fee>2</total_fee><op_user_id>1281748701</op_user_id><appid>wx2d2b54b6349d8ef7</appid><out_refund_no>0f0929d278b248aa</out_refund_no><nonce_str>xisaohkmco42xktmmxhjvzvxj6w2xsr3</nonce_str><transaction_id>1008760584201512292384335393</transaction_id></xml>\n";
            httpPost.setEntity(new StringEntity(str));
            System.out.println("executing request" + httpPost.getRequestLine());
            CloseableHttpResponse response = httpclient.execute(httpPost);
            try {
                HttpEntity entity = response.getEntity();
                System.out.println("----------------------------------------");
                System.out.println(response.getStatusLine());
                if (entity != null) {
                    System.out.println("Response content length: " + entity.getContentLength());
                    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(entity.getContent()));
                    String text;
                    while ((text = bufferedReader.readLine()) != null) {
                        System.out.println(new String(text.getBytes(),"utf-8"));
                    }
                }
                EntityUtils.consume(entity);
            } finally {
                response.close();
            }
        } finally {
            httpclient.close();
        }
    }

}
