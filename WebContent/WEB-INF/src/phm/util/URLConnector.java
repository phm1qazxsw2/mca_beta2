package phm.util;

import java.io.*;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

public class URLConnector{	
	private URLConnection connection = null;
	private boolean input = false;
    private InputStream instream = null;
    private OutputStream ostream = null;
    private boolean timedOut = false;
    
    protected URLConnector() {}    
    protected URLConnector(URLConnection connection) 
    {        
        this.connection = connection;
    }
    
    public static String getContent(String uurl, int timeout, String content_encoding)
        throws IOException
    {

        BufferedReader bfr = getContentReader(uurl, timeout, content_encoding);
        StringBuilder sb = new StringBuilder();
        String line = null;
        while((line=bfr.readLine()) != null)
        {
            sb.append(line+"\n");
        }
        return sb.toString();        
    }
    
    public static BufferedReader getContentReader(String uurl, int timeout, String content_encoding)
        throws IOException
    {
        InputStream in = URLConnector.getInputStream
            (new java.net.URL(uurl).openConnection(), timeout);        
        return new BufferedReader(new InputStreamReader(in, content_encoding));
    }
    
    public static InputStream getInputStream(URLConnection con, int timeout) throws IOException 
    {

        URLConnector uc2 = new URLConnector(con);
        return uc2.getInputStream(timeout);
    }
    
    public static OutputStream getOutputStream(URLConnection con, int timeout) throws IOException 
    {
        URLConnector uc2 = new URLConnector(con);
        return uc2.getOutputStream(timeout);
    }

    protected synchronized OutputStream getOutputStream(int timeout) throws IOException 
    {       
        this.input = false;
        this.connection.setDoOutput(true);
        Thread t = new Thread(new URLConnectorThread(this));
        t.start();
              
        try 
        {
            this.wait(timeout);
        } 
        catch (InterruptedException e) 
        {
            if (ostream == null) 
            {
                timedOut = true;
            } 
            else 
            {
                ostream.close();
                ostream=null;
            }
            doLog(timeout);
            throw new IOException("Connection never established");
        }

        if (ostream != null) 
        {
            return ostream;
        } 
        else 
        {   
            doLog(timeout);
            throw new IOException("Connection timed out");
        }
    }   
       
    protected synchronized InputStream getInputStream(int timeout) throws IOException 
    {       
        input = true;
        Thread t = new Thread(new URLConnectorThread(this));
        t.start();
              
        try 
        {
            this.wait(timeout);
        } 
        catch (InterruptedException e) 
        {
            if (instream == null) 
            {
                timedOut = true;
            } 
            else 
            {
                instream.close();
                instream=null;
            }
            doLog(timeout);
            throw new IOException("Connection never established");
        }

        if (instream != null) 
        {
            return instream;
        } 
        else 
        {   
            doLog(timeout);
            throw new IOException("Connection timed out");
        }
    }   
    
    protected void doLog(int t)
    {
        String urlstr = "";
        if (connection!=null)
            urlstr = connection.getURL().toString();
        //org.apache.log4j.Category log = 
        //    org.apache.log4j.Category.getInstance("timeout");    
        //log.warn(t+"\t"+urlstr);                    
    }
    
    // special thread to open the connection
    private class URLConnectorThread implements Runnable 
    {
        URLConnector ref;
        
        URLConnectorThread(URLConnector ref)
        {
            this.ref = ref;   
        }

        public void run() {            
            if(connection != null) 
            {
                try 
                {
                    if (input)
                    {
                        InputStream s = connection.getInputStream();                    
                        synchronized (ref) {
                            if (timedOut && s != null) 
                            {
                                s.close();
                            } 
                            else 
                            {
                                instream = s;
                                ref.notify();
                            }
                        }
                    }
                    else 
                    {
                        OutputStream os = connection.getOutputStream();
                        synchronized (ref) {
                            if (timedOut && os!=null)
                            {
                                os.close();   
                            }
                            else
                            {
                                ostream = os;
                                ref.notify();   
                            }
                        }   
                    }
                } 
                catch (Exception e) {
                    System.out.println("URLConnector: " + e.toString()); // this is a hidden thread, full error message is confusing
                    // e.printStackTrace();
                }
            }
        }
    }      
}
