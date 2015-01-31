package web;

import java.util.*;
import java.text.*;
import jsf.*;

public class WebAdmin
{
    private static WebAdmin instance;
    
    WebAdmin() {}
    
    public synchronized static WebAdmin getInstance()
    {
			
        if (instance==null)
        {
            instance = new WebAdmin();
        }
        return instance;
    }
    
    public Picorder[] getPicorderByStatus(int type,int userid,int status,int getWay)
    {
    	PicorderMgr bigr = PicorderMgr.getInstance();
        
        Object[] objs = bigr.retrieve("picorderClassType="+type+" and picorderUserId ="+userid+" and picorderStatus="+status+" and picorderGetway="+getWay, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Picorder[] u =new Picorder[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Picorder)objs[i];
        }
        
        return u;

    }
    public Picorder[] getPicorderByStatus2(int status,int getWay)
    {
    	PicorderMgr bigr = PicorderMgr.getInstance();
        
        Object[] objs = bigr.retrieve("picorderStatus="+status+" and picorderGetway="+getWay, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Picorder[] u =new Picorder[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Picorder)objs[i];
        }
        
        return u;

    }
    
    public Album[] getAlbumByClassId(int classId)
    {
    	String query="";
    	if(classId!=0)
    	{
    		if(classId==999)
    			query="albumClasstype='1'";
    		else
    			query="albumClassId='"+classId+"'";
    	}
    		
    	AlbumMgr bigr = AlbumMgr.getInstance();
        
        Object[] objs = bigr.retrieve(query, "order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Album[] u =new Album[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Album)objs[i];
        }
        
        return u;

    }
}    
    
  
