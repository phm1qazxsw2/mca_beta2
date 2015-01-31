package phm.util;

import java.util.*;
import java.net.*;
import org.dom4j.*;
import org.dom4j.io.SAXReader;
import util.*;

public class SmsTool {

    public static String getSession() throws Exception {
        String url = "http://60.250.41.7:8080/smsCenter/login.jsp?id=koala&pw=ko1234";
        String result = URLConnector.getContent(url, 3000, "UTF-8");
        System.out.println("session url=" + result);
        int c1 = result.indexOf("<session>");
        int c2 = result.indexOf("</session>");
        if (c1<0 || c2<0)
            return null;
        String session = result.substring(c1+9, c2);
        return session;

        /*
        URL url = new URL("http://60.250.41.7:8080/smsCenter/login.jsp?id=koala&pw=ko1234");
        SAXReader reader = new SAXReader();
        Document document = reader.read(url);

//<sms>
//  <status>0</status>
//  <msg>login ok</msg>
//  <session>01E7AD1D5384C522D1F8335A5D570D3D</session>
//  <smsqty>25</smsqty>
//</sms>

        Element rootElement = document.getRootElement();
        String rootName = rootElement.getName();

        if (rootName.equals("sms")) {
            for (Iterator i = rootElement.elementIterator(); i.hasNext();) {
                Element e = (Element) i.next();
                if (e.getName().equals("session"))
                    return e.getText();
            }
        }
        return null;
        */
    }

    public static void logout(String session)
        throws Exception
    {
        String logouturl = "http://60.250.41.7:8080/smsCenter/logout.jsp?jsessionid=" + session;
        String result = URLConnector.getContent(logouturl, 3000, "UTF-8");
        System.out.println("logout=" + result);
    }

    public static void send(String session, String number, String subject, String content)
        throws Exception
    {
        //http://60.250.41.7:8080/smsCenter/sendSMS.jsp?receiver=0936659619&subject=test&content=測試一下&jsessionid=BCF76545E09113379E76C2FED0ABDACB
        String urlstr = "http://60.250.41.7:8080/smsCenter/sendSMS.jsp?receiver=" + number + 
            "&subject=" + java.net.URLEncoder.encode(subject,"BIG5") + 
            "&content=" + java.net.URLEncoder.encode(content,"BIG5") + 
            "&jsessionid=" + session;
        System.out.println("## url=" + urlstr);
        String result = URLConnector.getContent(urlstr, 3000, "BIG5");
        System.out.println("send=" + result);
    }

    public static void main(String[] args)
    {
        try {
            String session = SmsTool.getSession();
            System.out.println("## session=" + session);
            SmsTool.send(session, "0921120329", "test", "測試一下");
            SmsTool.logout(session);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

}