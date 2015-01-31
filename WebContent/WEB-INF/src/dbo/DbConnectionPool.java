package dbo;

import java.util.Properties;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnectionPool extends ConnectionPool {
   private final String driver, url, user, pwd;
   private boolean driverLoaded = false;

   public DbConnectionPool(String driver, String url) {
      this(driver, url, null, null);
   }
   public DbConnectionPool(String driver, String url, 
                           String user, String pwd) {
      this.driver = driver;
      this.url    = url;
      this.user   = user;
      this.pwd    = pwd;

      try {
         int pool_size = 5;
         for(int i=0; i < pool_size; ++i) 
         {
            availableConnections.addElement(createConnection());
         }            
         System.out.println("## jdbc connection pool size " + pool_size);
      }
      catch(Exception ex) 
      {
        ex.printStackTrace();
      }
   }
   
   public DbConnectionPool(String driver, String url, 
                           String user, String pwd, int pool_size) {
      this.driver = driver;
      this.url    = url;
      this.user   = user;
      this.pwd    = pwd;

      try {
         for(int i=0; i < pool_size; ++i) 
         {
            availableConnections.addElement(createConnection());
            //System.out.println("jdbc connection added in pool #" + i);
         }
         System.out.println("## jdbc connection pool size " + pool_size);
      }
      catch(Exception ex) {
         ex.printStackTrace();  
      }
   }
      
   public Object createConnection() throws ConnectionException {
      Connection connection = null;
      
	  Properties pr;

	  pr = new Properties();
	  pr.put("characterEncoding", "UTF8");
	  pr.put("useUnicode", "TRUE");
	  pr.put("autoReconnect", "TRUE");

	  try 
	  {
         if(!driverLoaded) {
            Class.forName(driver);
            driverLoaded = true;
         }
         if (user!=null)
            pr.put("user", user);
         if (pwd!=null)
            pr.put("password", pwd);
         connection = DriverManager.getConnection(url, pr);
         
         /*
         if(user == null || pwd == null)
            connection = DriverManager.getConnection(url, pr);
         else
            connection = DriverManager.getConnection(url, user, 
                                                          pwd);
         */
      }
      catch(Exception ex) {
         // ex is ClassNotFoundException or SQLException
         throw new ConnectionException(ex.getMessage());
      }
      return connection;
   }
   public void disconnect(Object connection) {
      try {
         ((Connection)connection).close();
      }
      catch(SQLException ex) {
         // ignore exception
      }
   }
   public boolean isConnectionValid(Object object) {
      Connection connection = (Connection)object;      
      boolean valid = false;

      try {
         valid = ! connection.isClosed();
      }
      catch(SQLException ex) {
         valid = false;
      }
      return valid;
   }
   
   public void closePool()
   {
      int size = availableConnections.size();
      for (int i=0; i<size; i++)
      {
         disconnect(availableConnections.elementAt(i));
      }
      System.out.println("## jdbc connection pool closed " + size);      
   }
   
   public int getAvailableCount()
   {
      return availableConnections.size();
   }
   
   public int getUsedCount()
   {
      return inUseConnections.size();
   }
       
}
