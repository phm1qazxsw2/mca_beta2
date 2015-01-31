package dbo;

import java.io.*;
import java.util.*;
import java.sql.*;
import com.axiom.util.DbPool;

public class DataSource
{
    private static Map sourcemap = new HashMap();
    private static String conf = null;
    
    public static void setup(String configfile)
        throws Exception
    {
        BufferedReader br = new BufferedReader(new InputStreamReader(
            new FileInputStream(configfile)));
        String line;
        while((line=br.readLine())!=null)
        {
            if (line.trim().length()==0)
                continue;
            int c = line.indexOf("=");
            String left = line.substring(0,c);
            String right = line.substring(c+1);

            String ds = left;
            String[] jdbc_args = right.split(",");
            int poolsize = (jdbc_args.length>4)?Integer.parseInt(jdbc_args[4]):1;
            
            DbConnectionPool p = new DbConnectionPool(
                jdbc_args[0], jdbc_args[1], jdbc_args[2], jdbc_args[3], poolsize);
            legacy_driver = jdbc_args[0];
            legacy_url = jdbc_args[1];
            legacy_user = jdbc_args[2];
            legacy_password = jdbc_args[3];
            System.out.println("ds=" + ds);
            sourcemap.put(ds, p);    
        }
        conf = configfile;
    }

    private static String legacy_driver = null;
    private static String legacy_url = null;
    private static String legacy_user = null;
    private static String legacy_password = null;
    private static beans.jdbc.DbConnectionPool legacy_pool;
    public static void setupLegacy()
        throws Exception
    {
        legacy_pool = new beans.jdbc.DbConnectionPool(legacy_driver, legacy_url, 
            legacy_user, legacy_password);
        DbPool.setDbPool(legacy_pool); 
    }
    public static void setupLegacy(String driver, String url, String user, String password)
        throws Exception
    {
        legacy_driver = driver;
        legacy_url = url;
        legacy_user = user;
        legacy_password = password;
    }

    public static void resetDbConns()
        throws Exception
    {
        shutdown();
        legacy_pool.closePool();
        setup(conf);
        setupLegacy(legacy_driver, legacy_url, legacy_user, legacy_password);
    }

    public static boolean hasSource(String ds)
    {
        DbConnectionPool p = (DbConnectionPool)sourcemap.get(ds);
        return p!=null;
    }

    public static Connection getDbConnection(String ds)
        throws Exception
    {
        DbConnectionPool p = (DbConnectionPool)sourcemap.get(ds);
        Connection con;
        return (Connection)p.getConnection(5000);
    }
    
    public static void releaseDbConnection(String ds, Connection con)
    {
        try {
            DbConnectionPool p = (DbConnectionPool) sourcemap.get(ds);
            p.recycleConnection(con);
        }
        catch (Exception e)
        {
            throw new RuntimeException(e.getMessage());
        }
    }   


    public static void kickoutDbConnection(String ds, Connection con)
    {
        try {
            DbConnectionPool p = (DbConnectionPool) sourcemap.get(ds);
            p.disconnect(con);
            p.kickout(con);
            System.out.println("## kicking out one bad db connection, remaining " + p.countConnections());
        }
        catch (Exception e)
        {
            throw new RuntimeException(e.getMessage());
        }
    }   


    public static void shutdown()
    {
        try {
            Set s = sourcemap.keySet();
            Iterator iter = s.iterator();
            while (iter.hasNext())
            {
                String k = (String) iter.next();
                System.out.println("shuting datasource [" + k + "]");
                DbConnectionPool p = (DbConnectionPool) sourcemap.get(k);
                p.closePool();
            }   
        }
        catch (Exception e)
        {
            e.printStackTrace(); 
        }        
    }
}