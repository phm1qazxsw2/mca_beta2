package jsi;

import web.*;
import java.util.*;
import java.text.*;


public class JsiAuth
{
    private static JsiAuth instance;
    
    JsiAuth() {}
    
    public synchronized static JsiAuth getInstance()
    {
        if (instance==null)
        {
            instance = new JsiAuth();
        }
        return instance;
    }
	private String authKey="XoHTCfhL";

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
	
	

	public String getAuthDate(){
		
		WebsetupMgr wm=WebsetupMgr.getInstance();
		Websetup  we=(Websetup)wm.find(1);

		String oCode=decode(we.getWebsetupAuthodCode());
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


	public boolean getCouldWork()
	{
		WebsetupMgr wm=WebsetupMgr.getInstance();
		Websetup  we=(Websetup)wm.find(1);


		String oCode=decode(we.getWebsetupAuthodCode());
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

	}
}