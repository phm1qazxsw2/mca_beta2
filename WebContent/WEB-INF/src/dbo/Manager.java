package dbo;

import java.sql.*;
import java.util.*;
import java.io.*;

public abstract class Manager<T>
{
    protected abstract Object makeBean();
    protected abstract void fillBean(ResultSet rs, Object item, Connection con) throws Exception;
    protected String alt_data_source = null;
    protected String alt_table_name = null;    

    protected Manager() {}
    protected Manager(int tran_id) throws Exception
    {
        if (tran_id>0 && conmap.get(new Integer(tran_id))==null)
            throw new Exception("tran_id is not a valid transaction!");
        this.tran_id = tran_id;
    }
    protected int tran_id = 0;
    private static Map conmap = new HashMap();
    private static int _next_trans_id = 0;

    //目前只支援 main DataSource
    public static int startTransaction()
        throws Exception
    {
        synchronized (conmap) {
            _next_trans_id ++;
        }

        Connection con = null;
        try {
            con = DataSource.getDbConnection("main"); 
            synchronized (conmap) {
                conmap.put(new Integer(_next_trans_id), con);
            }
            Statement stmt = con.createStatement();
            stmt.execute("start transaction");
        }
        catch (Exception e)
        {
            e.printStackTrace();
            System.out.println("START TRANSACTION FAILED!");  // only print out if error occurs
            conmap.remove(new Integer(_next_trans_id));
            if (con!=null)
                DataSource.releaseDbConnection("main", con);
            throw new RuntimeException(e);
        }
        return _next_trans_id;
    }

    public static void rollback(int tid) 
        throws Exception
    {
        Connection con = null;
        synchronized (conmap) {
            con = (Connection) conmap.get(new Integer(tid));
        }
        if (con==null)
            throw new Exception("not in a transaction");

        try {
            Statement stmt = con.createStatement();
            stmt.execute("rollback");
        }
        catch (Exception e)
        {
            System.out.println("ROLLBACK TRANSACTION FAILED!");  // only print out if error occurs
            if (con!=null)
                DataSource.releaseDbConnection("main",con);
            throw new RuntimeException(e);
        }
        finally {
            synchronized (conmap) {
                conmap.remove(new Integer(tid));
            }
            if (con!=null) {
                DataSource.releaseDbConnection("main",con);
            }
        }
    }

    public static void commit(int tid) 
        throws Exception
    {
        Connection con = null;
        synchronized (conmap) {
            con = (Connection) conmap.get(new Integer(tid));
        }
        if (con==null)
            throw new Exception("not in a transaction");

        try {
            Statement stmt = con.createStatement();
            stmt.execute("commit");
        }
        catch (Exception e)
        {
            System.out.println("COMMIT TRANSACTION FAILED!");  // only print out if error occurs
            if (con!=null)
                DataSource.releaseDbConnection("main",con);
            throw new RuntimeException(e);
        }
        finally {
            synchronized (conmap) {
                conmap.remove(new Integer(tid));
            }
            if (con!=null) {
                DataSource.releaseDbConnection("main",con);
            }
        }
    }

    public Connection _get_conn()
         throws Exception
    {
        if (tran_id!=0) { // in transaction, get it from connmap
            if (!getDataSourceName().equals("main"))
                throw new Exception("transaction only allowed in main DataSource");
            return (Connection) conmap.get(new Integer(tran_id));
        }
        else 
            return DataSource.getDbConnection(getDataSourceName());
    }

    public void _recycle_conn(Connection con)
    {
        if (tran_id!=0) // in transaction, no need to recycle
            return; 
        if (con!=null)
            DataSource.releaseDbConnection(getDataSourceName(), con);        
    }

    // usually subclass will overwrite this function
    // but in rare case where we want to dynamicly decide the table name
    // we can erase the overloading in subclass and use 
    // setTableName/getTableName to achive it.
    // LiteralMgr is an example that decide which literal table to
    // retrieve at run time.
    protected String getTableName()
    {
        return alt_table_name; 
    }

    public void setTableName(String tablename)
    {
        alt_table_name = tablename;
    }
    
    public void executeSQL(String sqlquery)
    {
        Connection con = null;
        Statement stmt = null;
        try {
            con = _get_conn();
            stmt = con.createStatement();            
            stmt.execute(sqlquery);
        }
        catch (Exception e)
        {
            System.out.println(sqlquery);  // only print out if error occurs
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (stmt!=null)
                try { stmt.close(); } catch (java.sql.SQLException e) {}
            if (con!=null)
                _recycle_conn(con);               
        }        
    }
    
    public String getDataSourceName()
    {
        if (alt_data_source!=null)
            return alt_data_source;
        return "main";   
    }
    
    public void setDataSourceName(String datasource)
    {
        if (!DataSource.hasSource(datasource))
            throw new RuntimeException("datasource ["+datasource+"] not found");
        alt_data_source = datasource;
    }

    public ArrayList<T> retrieveSQLList(String qry)
    {
        Connection con = null;
        Statement stmt = null;
        ArrayList<T> l = new ArrayList<T>(300);

        try {
            con = _get_conn();
            stmt = con.createStatement();
            ResultSet rs = null;
            rs = stmt.executeQuery(qry);

            if (!ServerTool.hasAnyResult(rs))
                return l;
                
            int i = 0;
            while (rs.next())
            {
                T o = (T) makeBean();
                fillBean(rs, o, con);
                l.add(o);
                i ++;
            }
            return l;
        }
        catch (Exception e)
        {
            System.out.println(qry);  // only print out if error occurs
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (stmt!=null)
                try { stmt.close(); } catch (java.sql.SQLException e) {}
            if (con!=null)
                _recycle_conn(con);
        }        
    }

    public Object[] retrieveSQL(String sqlquery)
    {
        ArrayList<T> l = retrieveSQLList(sqlquery);
        if (l.size()==0)
            return null; //backward compatibility
        return l.toArray();
    }    

    public T findX(String identifier, String space)
        throws NotUniqueException
    {
        if (space!=null) {
            if (identifier.length()>0)
                identifier = space + " and (" + identifier + ")";
            else
                identifier = space;
        }
        return find(identifier);
    }

    public T find(String identifier)
        throws NotUniqueException
    {
        ArrayList<T> list = retrieveList(identifier, "");
        if (list.size()==0)
            return null;
        if (list.size()>1)
            throw new NotUniqueException("identifier [" + identifier + "] in " + this.getClass().getName());
        return list.get(0);
    }

    public ArrayList<T> retrieveListX(String qry, String spec, String space)
    {
        ArrayList<T> l = new ArrayList<T>(50);
        if (space!=null) {
            if (qry.length()>0)
                qry = space + " and (" + qry + ")";
            else
                qry = space;
        }
        retrieveList(qry, spec, l);
        return l;
    }

    public ArrayList<T> retrieveList(String qry, String spec)
    {
        ArrayList<T> l = new ArrayList<T>(50);
        retrieveList(qry, spec, l);
        return l;
    }

    public void retrieveListX(String qry, String spec, ArrayList<T> l, String space)
    {
        if (space!=null) {
            if (qry.length()>0)
                qry = space + " and (" + qry + ")";
            else
                qry = space;
        }
        retrieveList(qry, spec, l);
    }

    public void retrieveList(String qry, String spec, ArrayList<T> l)
    {
        Connection con = null;
        Statement stmt = null;
        int maxsize = 300;

        String query = "SELECT "+getFieldList()+" FROM ";
        query += getTableName();
        query += " ";

        String leftjoins = getLeftJoins();
        if (leftjoins!=null)
            query += leftjoins + " ";        

        boolean hasWhere = false;
        if (JoinSpace()!=null)
        {
            query += "WHERE " + JoinSpace();
            hasWhere = true;
        }

        if (qry!=null && qry.length()>0)
        {
            if (!hasWhere)
                query += "WHERE ";
            else
                query += " AND ";
            query += qry;
        }
                    
        if (spec==null)
            query += " LIMIT 0," + maxsize;
        else
            query += " " + spec;
//System.out.println(query); //##
        try {
            con = _get_conn();
            stmt = con.createStatement();
            ResultSet rs = null;
            rs = stmt.executeQuery(query);            
            if (!ServerTool.hasAnyResult(rs))
                return;
            int i = 0;
            while (rs.next())
            {
                T o = (T)makeBean();
                fillBean(rs, o, con);
                l.add(o);
                i ++;
            }
        }
        catch (Exception e)
        {
            System.out.println(query);  // only print out if error occurs
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (stmt!=null)
                try { stmt.close(); } catch (java.sql.SQLException e) {}
            if (con!=null)
                _recycle_conn(con);
        }
    }

    public Object[] retrieveX(String qry, String spec, String space)
    {
        if (space!=null) {
            if (qry.length()>0)
                qry = space + " and (" + qry + ")";
            else
                qry = space;
        }
        return retrieve(qry, spec);
    }
    
    public Object[] retrieve(String qry, String spec)
    {
        ArrayList<T> l = retrieveList(qry, spec);
        if (l.size()==0)
            return null; //backward compatibility
        return l.toArray();
    }

    public int numOfRowsX(String qry, String space)
    {
        if (space!=null) {
            if (qry.length()>0)
                qry = space + " and (" + qry + ")";
            else
                qry = space;
        }
        return numOfRows(qry);
    }

    public int numOfRows(String q)
    {
        Connection con = null;
        Statement stmt = null;
        String query = "";
        try {
            con = _get_conn();
            query = "SELECT COUNT(*) AS total FROM ";
            query += getTableName();
            query += " ";

            String leftjoins = getLeftJoins();
            if (leftjoins!=null)
                query += leftjoins + " ";        

            boolean hasWhere = false;
            if (JoinSpace()!=null)
            {
                query += "WHERE " + JoinSpace();
                hasWhere = true;
            }

            if (q!=null && q.length()>0)
            {
                if(!hasWhere)
                    query += "WHERE ";
                else
                    query += " AND ";
                query += q;
            }

            stmt = con.createStatement();
            ResultSet rs = null;
            rs = stmt.executeQuery(query);
            rs.next();
            return rs.getInt(1);
        }
        catch (Exception e)
        {
            System.out.println(query);
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (stmt!=null)
                try { stmt.close(); } catch (java.sql.SQLException e) {}
            if (con!=null)
                _recycle_conn(con);
        }
    }

    /**
     * Get last created id, obsolete, use createWithIdReturned instead
    public int getLastCreatedId()
    {
        Connection con = null;
        try {
            con = DataSource.getDbConnection(getDataSourceName());
            String query = "SELECT MAX(id) AS maxid FROM ";
            query += getTableName();
            query +=" ";

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            rs.next();
            return rs.getInt("maxid");
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (con!=null)
                DataSource.releaseDbConnection(getDataSourceName(),con);
        }
    }
    */
    /*
    public Object find (int id)
    {
        Object item = makeBean();
        Connection con = null;
        try {
            con = DataSource.getDbConnection(getDataSourceName());
            String query = "SELECT * FROM " + getTableName() + " WHERE id=" + id;
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            if (!ServerTool.hasAnyResult(rs))
                return null;

            rs.next(); // should only return one (or none if id not
                       // found)

            fillBean(rs, item, con);

            return item;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (con!=null)
                DataSource.releaseDbConnection(getDataSourceName(),con);
        }
    }
    */


    public void save(Object obj)
    {
        Connection con = null;
        Statement stmt = null;
        String command = "";
        try {
            con = _get_conn();
            stmt = con.createStatement();
/*
Class cc = obj.getClass();
System.out.println("### saving " + cc.getName() + " where " + getIdentifier(obj));
if (cc.getName().equals("mca.McaStudent")) {
	System.out.println("### here in mcastudent save");
	throw new RuntimeException("here3");
}
*/
            command = "UPDATE " + getTableName() + " SET "
                + getSaveString(obj);

            // command += " WHERE id=" + getBeanId(obj);
            command += " WHERE " + getIdentifier(obj);
            stmt.execute(command);
            // saveBlob(con, obj, getBeanId(obj));//### for blob
            saveBlob(con, obj, getIdentifier(obj));//### for blob
        }
        catch (Exception e)
        {
            System.out.println(command);
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (stmt!=null)
                try { stmt.close(); } catch (java.sql.SQLException e) {}
            if (con!=null)
                _recycle_conn(con);
        }
        return;
    }

    /*
    public int createWithIdReturned(Object obj)
    {
        Connection con = null;
        Statement stmt = null;
        String command = "";
        int ret = -1;
        try {
            con = DataSource.getDbConnection(getDataSourceName());
            stmt = con.createStatement();

            command = 
                "INSERT INTO " + getTableName() + " (" + getInsertString() + ") VALUES (";
                                                            
            command += getCreateString(obj);

            command += ")";
            stmt.execute(command);
            stmt.close();
            
            stmt = con.createStatement();
            // command = "SELECT LAST_INSERT_ID(id) as lastId FROM " + getTableName();
            command = "SELECT LAST_INSERT_ID()";
            ResultSet rs = stmt.executeQuery(command);
            
            setIfAutoId(obj, rs);
            String identifier = getIdentifier(obj);
            //rs.next();
            //ret = rs.getInt(1);
            saveBlob(con, obj, ret);//### for blob
            stmt.close();
        }
        catch (Exception e)
        {
            System.out.println("** " + command);
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (con!=null)
                DataSource.releaseDbConnection(getDataSourceName(),con);
        }
        System.out.println("### id=" + ret + " " + obj);
        return ret;
    }
    */

    public int getLastId()
    {
        int ret = 0;
        Connection con = null;
        Statement stmt = null;
        String command = "";
        try {
            con = _get_conn();
            stmt = con.createStatement();
            command = "SELECT MAX(id) FROM " + getTableName();
            ResultSet rs = stmt.executeQuery(command);
            rs.next();
            ret = rs.getInt(1);
        }
        catch (Exception e)
        {
            System.out.println("** " + command);
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (stmt!=null)
                try { stmt.close(); } catch (java.sql.SQLException e) {}
            if (con!=null)
                _recycle_conn(con);
        }
        return ret;
    }
    
    /**
     * Create object, fill in the id into obj
     */
    public synchronized void create(Object obj)
    {
        Connection con = null;
        Statement stmt = null;
        String command = "";
        try {
            con = _get_conn();
            stmt = con.createStatement();

            command = 
                "INSERT INTO " + getTableName() + " (" + getInsertString() + ") VALUES (";
                                                            
            command += getCreateString(obj);

            command += ")";            

            stmt.execute(command);
            stmt.close();            
            stmt = con.createStatement();
            // command = "SELECT LAST_INSERT_ID(id) as lastId FROM " + getTableName();
            command = "SELECT LAST_INSERT_ID()";
            ResultSet rs = stmt.executeQuery(command);
            if (isAutoId())      
            {             
                rs.next();
                int auto_id = rs.getInt(1);
                setAutoId(obj, auto_id);
            }
            String identifier = getIdentifier(obj);
            saveBlob(con, obj, identifier);//### for blob            
        }
        catch (Exception e)
        {
            System.out.println("** " + command);
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (stmt!=null)
                try { stmt.close(); } catch (java.sql.SQLException e) {}
            if (con!=null)
                _recycle_conn(con);
        }
        return;
    }
    
    public void remove(Object[] objs)
    {
        Connection con = null;
        Statement stmt = null;
        if (objs==null || objs.length==0)
            return;
        try {
            con = _get_conn();
            stmt = con.createStatement();

            String com1 = "DELETE from " + getTableName() + " WHERE ";
            for (int i=0; i<objs.length; i++)
            {
                if (i>0)
                    com1 += " or ";
                com1 += "(" + getIdentifier(objs[i]) + ")";
            }         
//System.out.println("## com1=" +  com1);           
            stmt.execute(com1);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (con!=null)
                _recycle_conn(con);
        }        
    }
    
    public void batchCreate(Object[] objs)
    {
        Connection con = null;
        Statement stmt = null;
        StringBuilder sb = null;
        try {

            sb = new StringBuilder("INSERT INTO ");
            sb.append(getTableName());
            sb.append("(" + getInsertString() + ") VALUES ");
            for (int i=0; i<objs.length; i++)
            {
                if (i>0) sb.append(",");
                sb.append("(");
                sb.append(getCreateString(objs[i]));
                sb.append(")");
            }

            con = _get_conn();
            stmt = con.createStatement();
            stmt.execute(sb.toString());
        }
        catch (Exception e)
        {
            if (sb!=null)
                System.out.println("** " + sb.toString());
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (stmt!=null)
                try { stmt.close(); } catch (java.sql.SQLException e) {}
            if (con!=null)
                _recycle_conn(con);
        }
        return;
    }

    /*
    public void remove(int ids[])
    {
        Connection con = null;
        Statement stmt = null;
        if (ids==null || ids.length==0)
            return;
        try {
            con = DataSource.getDbConnection(getDataSourceName());
            //con.setAutoCommit(false);
            stmt = con.createStatement();

            String com1 = "DELETE from " + getTableName() + " WHERE ";
            for (int i=0; i<ids.length; i++)
            {
                if (i>0)
                    com1 += " or ";
                com1 += "id=" + ids[i];
            }

            stmt.execute(com1);
            //con.commit();
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (con!=null)
                DataSource.releaseDbConnection(getDataSourceName(),con);
        }
    }

    public boolean remove(int id)
    {
        Connection con = null;
        Statement stmt = null;
        try {
            con = DataSource.getDbConnection(getDataSourceName());
            stmt = con.createStatement();

            String command = "DELETE from " + getTableName() + " WHERE id=" + id;
            stmt.execute(command);

            return true;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        finally 
        {
            if (con!=null)
                DataSource.releaseDbConnection(getDataSourceName(),con);
        }
    }
    */

    public void clear()
    {
        String command = "delete from " + getTableName();
        executeSQL(command);
    }

    protected String JoinSpace()
    {
        return null;
    }

    protected String getSaveString(Object obj)
    {
        throw new RuntimeException("not applicable");
    }

    protected String getCreateString(Object obj)
    {
        throw new RuntimeException("not applicable");
    }

    protected String getInsertString()
    {
        throw new RuntimeException("not applicable");
    }

    //protected int    getBeanId(Object obj)
    //{
    //    throw new RuntimeException("not applicable");
    //}
    
    protected String getIdentifier(Object obj)
    {
        throw new RuntimeException("not applicable");        
    }
    
    protected void setAutoId(Object obj, int auto_id)
    {
    }
    
    protected boolean isAutoId()
    {
        return false;   
    }
    
    protected String getLeftJoins()
    {
        return null;   
    }
    
    //### for blob
    public static Object getBlob(ResultSet result, String columnName) 
        throws SQLException, IOException, ClassNotFoundException 
    {
        Object o = null;
        Blob blob = result.getBlob(columnName);
        if (blob==null)
            return null;
        byte[] rx_buffer = blob.getBytes(1, (int)blob.length());
        //System.out.println("getBlob size="+rx_buffer.length);
        ObjectInputStream objIn2 = new ObjectInputStream(new ByteArrayInputStream(rx_buffer));
        o = objIn2.readObject();
        return o;
    }
    
    protected String getBlobSaveString() {
        return "";
    }
    
    protected void saveBlob(Connection conn, Object bean, String identifier) 
    // protected void saveBlob(Connection conn, Object bean, int id) 
        throws SQLException, IOException 
    {
        if(getBlobSaveString().equals("")) return;
        ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
        ObjectOutputStream objOut=new ObjectOutputStream(byteOut);
        objOut.writeObject(getBlob(bean));
        byte[] tx_buffer=byteOut.toByteArray();    
        // String cmd = getBlobSaveString() + " WHERE id=" + id;
        String cmd = getBlobSaveString() + " WHERE " + identifier;
        //System.out.println("saveBlob cmd="+cmd);
        PreparedStatement pstmt = conn.prepareStatement(cmd);    
        pstmt.setBytes(1, tx_buffer);
        pstmt.executeUpdate();
        pstmt.clearParameters();
        pstmt.close();
        pstmt = null;
        cmd = null;
        objOut.close();
        byteOut.close();
        objOut = null;  
        byteOut = null; 
        tx_buffer = null;         
    }
        
    protected Object getBlob(Object obj) {
        return null;
    }    

    protected String getFieldList()
    {
        return "*";
    }
}