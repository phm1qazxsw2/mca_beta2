package literalstore;

import java.io.*;
import java.nio.*;
import java.nio.channels.*;
import java.util.*;
import dbo.*;

public class LiteralStore
{
    private LiteralMgr lmgr = null;
    private String collection = null;

    public LiteralStore(int tran_id, String collection, String datasource)
        throws Exception
    {
        this.collection = collection;
        this.lmgr = (tran_id!=0)?new LiteralMgr(tran_id):LiteralMgr.getInstance();
        if (datasource!=null)
            this.lmgr.setDataSourceName(datasource);
        this.lmgr.setTableName(collection);
    }

    public long getNextId()
    {
        return (this.lmgr.getLastId()+1);
    }

    public static long create(LiteralStore store, String content)
        throws Exception
    {
        long id = store.getNextId();
        store.save(id, content);
        return id;
    }

    public void save(long id, String content)
        throws Exception
    {
        Object obj = lmgr.find("id=" + id);
        if (obj!=null) {
            Literal t = (Literal) obj;
            t.setText(content);
            lmgr.save(t);
        }
        else {
            Literal t = new Literal();
            t.setId(id);
            t.setText(content);
            lmgr.create(t);   
        }
    }
    
    
    public String restore(long id)
    {
        Object[] objs = lmgr.retrieve("id=" + id, null);
        if (objs!=null) {
            Literal t = (Literal) objs[0];
            return t.getText();
        }
        return null;
    }    

    public ArrayList<Literal> restore(String ids)
    {
        return lmgr.retrieveList("id in (" + ids + ")", "");
    }
    
    public void restore(long[] ids, Map result)
    {
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<ids.length; i++) {
            if (i>0)
                sb.append(",");
            sb.append(ids[i]);   
        }
        Object[] objs = lmgr.retrieve("id in (" + sb.toString() + ")", null);
        if (objs==null)
            return;
        for (int i=0; i<objs.length; i++)
        {            
            Literal t = (Literal) objs[i];
            result.put(new Long(t.getId()), t.getText());
        }
    }

    public void restoreAll(Map result)
    {
        StringBuffer sb = new StringBuffer();
        Object[] objs = lmgr.retrieve("", "");
        for (int i=0; objs!=null && i<objs.length; i++)
        {            
            Literal t = (Literal) objs[i];
            result.put(new Long(t.getId()), t.getText());
        }
    }
    
    public void append(long id, String content)
    {
        Object[] objs = lmgr.retrieve("id=" + id, null);
        if (objs!=null) {
            lmgr.executeSQL("update " + this.collection + " set text=concat(text,'"
                + ServerTool.escapeString(content) + "') where id=" + id);
        }
        else {
            Literal t = new Literal();
            t.setId(id);
            t.setText(content);
            lmgr.create(t);   
        }
    }

    public void insert(long id, String content)
    {
        Object[] objs = lmgr.retrieve("id=" + id, null);
        if (objs!=null) {
            lmgr.executeSQL("update " + this.collection + " set text=concat('"
                + ServerTool.escapeString(content) + "', text) where id=" + id);
        }
        else {
            Literal t = new Literal();
            t.setId(id);
            t.setText(content);
            lmgr.create(t);   
        }
    }

    public void batchCreate(long[] ids, String[] literals)
    {
        Literal[] objs = new Literal[ids.length];
        for (int i=0; i<ids.length; i++)
        {
            objs[i] = new Literal();
            objs[i].setId(ids[i]);
            objs[i].setText(literals[i]);
        }
        lmgr.batchCreate(objs);
    }        
}

