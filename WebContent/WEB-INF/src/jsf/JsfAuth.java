package jsf;

import java.util.*;
import java.text.*;


public class JsfAuth
{
    private static JsfAuth instance;
    
    JsfAuth() {}
    
    public synchronized static JsfAuth getInstance()
    {
        if (instance==null)
        {
            instance = new JsfAuth();
        }
        return instance;
    }
	private String authKey="Xo4Y6GhL";

	public boolean setAuthSystemData(AuthSystem as)
	{
		AuthSystemMgr asm=AuthSystemMgr.getInstance();
		
        Object[] objs = asm.retrieve("authSystemType="+as.getAuthSystemType()+" and authSystemStatus=1", null);
        
        if (objs!=null)
        {
        
	        AuthSystem[] u = new AuthSystem[objs.length];
	        
	        for (int i=0; i<objs.length; i++)
	        {
	            u[i] = (AuthSystem)objs[i];
	            u[i].setAuthSystemStatus(0);
	            
	            asm.save(u[i]);
	        }
		}
	        	
    	as.setAuthSystemStatus(1);
    	asm.createWithIdReturned(as);
    	
    	return true;	
    }
	
	private AuthSystem getCodeType(int type)
	{
		AuthSystemMgr asm=AuthSystemMgr.getInstance();

        Object[] objs = asm.retrieve("authSystemType="+type+" and authSystemStatus=1", null);
		 
		 if (objs==null || objs.length==0)
            return null;
		
		AuthSystem u = (AuthSystem)objs[0];
	        
	    return u;   
		
	}	

	
	public String decode(String data)
	{
		try{
		
			byte[] xData=util.SymmetricCipher.hexStringToByteArray(data);
			String original=util.SymmetricCipher.decodeECBString(authKey, xData);
	
			return original;
		
		}catch(Exception e){
			
			return "no data";	
		}
	}	

	public String formatDate(String oString)
	{
		StringBuffer trueString=new StringBuffer();
		
		for(int i=1;i<17;i++)
		{
			if((i%2)==0)
				trueString.append(oString.charAt(i-1));
		
		}
		
		return trueString.toString();
	}
	
	public String getBackNickname()
	{
		
		AuthSystem as1=getCodeType(1);
		
		if(as1==null)
			return "no data";
		
		
		String oCode=decode(as1.getAuthSystemCode());	
		StringBuffer trueString=new StringBuffer();
		
		trueString.append(oCode.charAt(0));
		trueString.append(oCode.charAt(2));
		trueString.append(oCode.charAt(4));
		return trueString.toString();
	}
	
	public String getBackNicknumber()
	{
		
		AuthSystem as1=getCodeType(1);
		
		if(as1==null)
			return "no data";
		
		String oCode=decode(as1.getAuthSystemCode());	
		StringBuffer trueString=new StringBuffer();
		
		trueString.append(oCode.charAt(6));
		trueString.append(oCode.charAt(8));
		trueString.append(oCode.charAt(10));
		trueString.append(oCode.charAt(12));
		trueString.append(oCode.charAt(14));
		
		return trueString.toString();
	}

	public String getAuthDate(){
		
		AuthSystem as1=getCodeType(1);
		
		if(as1==null)
			return "no data";


		String oCode=decode(as1.getAuthSystemCode());
		String DateCode=formatDate(oCode);
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
		
		Date authDate;
		
		try
		{
			authDate=sdf.parse(DateCode);		
		}catch(Exception e){
			
			return "Exception "+e.getMessage();	
		}	
		SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
		
		return sdf2.format(authDate);
	}


	public String getAuthUpdate()
	{
		AuthSystem as1=getCodeType(1);
		
		if(as1==null)
			return "no data";
			
		Date update2=as1.getCreated();
		SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
		
		return sdf2.format(update2);
		
		
	}

	public boolean getCouldWork()
	{
        return true;
        /*
		AuthSystem as1=getCodeType(1);
		
		if(as1==null)
			return false;


		String oCode=decode(as1.getAuthSystemCode());
		String DateCode=formatDate(oCode);
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
		
		Date authDate;
		
		try
		{
			authDate=sdf.parse(DateCode);		
		}catch(Exception e){
			
			return false;	
		}	
		Date now=new Date();
		
		long nowL=now.getTime();
		
		long authL=authDate.getTime();
		
		if(authL>=nowL)
			return true;
		else	
			return false;		
        */
	}

	
	
}