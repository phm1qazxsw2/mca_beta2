import com.axiom.util.DbPool;
import beans.jdbc.DbConnectionPool;
import dbo.*;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import java.io.*;
import cardreader.*;

public class Start extends HttpServlet {
    static DbConnectionPool pool;
    static EmailNotifier notifier;
    public void init(ServletConfig config) 
        throws ServletException
    {
        try {
            pool = new DbConnectionPool(
                config.getInitParameter("jdbcDriver"),
                config.getInitParameter("jdbcURL"),
                config.getInitParameter("jdbcUser"),
                config.getInitParameter("jdbcPwd"));
            DbPool.setDbPool(pool); 
            
            ServletContext ctx = config.getServletContext();
            File f = new File(ctx.getRealPath("/"));
            File dsource = new File(f, "WEB-INF/datasource");
            DataSource.setup(dsource.getAbsolutePath());
            notifier = new EmailNotifier();
            mca.McaImEx.startImportThread();
            System.out.println("# ezcounting started...");
        }
        catch (Exception e) {
            throw new ServletException(e);
        }
    }
     

    public void destroy() {
        System.out.println("ezcounting service stopping...");
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        System.out.println("[" + df.format(new java.util.Date()) + "] ** releasing db connections");
        DataSource.shutdown();
        notifier.shutdown();
        mca.McaImEx.shutdown();
        /* 2009/3/5 并到 DataSource 的 shutdown 里
        DbConnectionPool pool = DbPool.getDbPool();
        pool.closePool();
        */
    }
}
