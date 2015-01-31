package jsi;
import java.util.*;
import java.io.File;
import java.io.FileOutputStream;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage; 
//import com.sun.image.codec.jpeg.JPEGCodec;
//import com.sun.image.codec.jpeg.JPEGImageEncoder;
import java.io.*;
import web.*;
import java.net.*;
import java.text.*;
import pchome.util.*;

public class Utility{
	
	 private static Utility instance;
    
    Utility() {}
    
    public synchronized static Utility getInstance()
    {
    	try{
	    		JsiAuth jax=JsiAuth.getInstance();
	    		if(!jax.getCouldWork())
					return null;

		}catch(Exception e){}
        if (instance==null)
        {
            instance = new Utility();
        }
        return instance;
    }

	public String setupStep2(Album al,String filePath2)
	{

		AlbumMgr am=AlbumMgr.getInstance();			
		int alId=am.createWithIdReturned(al);

		String tempFilePath=filePath2+"album/"+String.valueOf(alId); 	
		String tempFilePath2=tempFilePath+"/source";        	
		
		File folderPic=new File(tempFilePath); 

		if(!folderPic.exists())
		{
	 
			 if(!folderPic.mkdir())
			{
				
	  			return "";
	 		}	
		}
		
		return tempFilePath2+"xxx"+String.valueOf(alId);

	}
	
	public static boolean copyFile(File sourceFile,File newFile)
	{
		try{
				long len=sourceFile.length();
				byte[] buffer=new byte[(int)len];
				
				FileInputStream filein=new FileInputStream(sourceFile);
				
				FileOutputStream fileout=new FileOutputStream(newFile,true);
				int ch=0;
				
				while((ch=filein.read(buffer))!=-1)
				{ 
					fileout.write(buffer);
				}
				filein.close();
				fileout.close();			
			
		}catch(Exception e){
				e.getMessage();
		}
		
		return true;		
	}	
	
	public Hashtable get6num(int[] mFee,String[] mFeeName,String[] mFeeUrl)
	{
		int temp=0;
 	 	String tempS="";
  		String tempU="";
  		for(int mi=0;mi<mFee.length;mi++)
  		{ 
  			if((mi+1)==mFee.length)
 
  				 break;
  				for(int my=0;my<mFee.length;my++)
  				{ 
 
  					if((my+1)!=mFee.length)
  					{
						if(mFee[my]>mFee[my+1]) 
						{	
							continue;
						}else{
							temp=mFee[my];
							mFee[my]=mFee[my+1];
							mFee[my+1]=temp;
							
							tempS = mFeeName[my];
							mFeeName[my]=mFeeName[my+1];
							mFeeName[my+1]=tempS;
							
							tempU = mFeeUrl[my];
							mFeeUrl[my]=mFeeUrl[my+1];
							mFeeUrl[my+1]=tempU;
						}
					} 				
  				} 
  		} 

		int[] reportFeeX=new int[6];
		String[] reportFeeXString=new String[6];
		String[] reportFeeXUrl=new String[6]; 

		if(mFee.length>6)
		{
			for(int op=0;op<mFee.length;op++)
	  		{
	  			if(op<=4)	
	  			{
	  				reportFeeX[op]=mFee[op]; 
	  				reportFeeXString[op]=mFeeName [op];
	  				reportFeeXUrl[op]=mFeeUrl[op];
	  			}else{ 
	  				reportFeeX[5]+=mFee[op]; 
	  				reportFeeXString[5]="其他";
	  		  	}
	  		} 
		}else{
			for(int op=0;op<mFee.length;op++)
	  		{
	  				reportFeeX[op]=mFee[op]; 
	  				reportFeeXString[op]=mFeeName [op];
	  				reportFeeXUrl[op]=mFeeUrl[op];
	  		}
		}
		Hashtable ha=new Hashtable();
		
		ha.put((String)"a",(int[])reportFeeX);
		ha.put((String)"b",(String[])reportFeeXString);	
		ha.put((String)"c",(String[])reportFeeXUrl);
		
		return ha;		
	}
	
	
	public boolean setupStep6(int alId,String filePath)
	{
		
		AlbumMgr am=AlbumMgr.getInstance();
		Album a=(Album)am.find(alId);
		
		Hashtable ha= new Hashtable();
		if(a.getAlbumPhotos()==0)
		{ 
			ha=getPrepareHashtable(filePath,a);
		}else{
			ha=getPrepareHashtableContinue(filePath,a);
		}
		
		if(ha==null)
		{
			
			return false;
		}
		
		WebsetupMgr wm=WebsetupMgr.getInstance();
		Websetup  we=(Websetup)wm.find(1);
		
		String urlString=we.getWebsetupWebaddress();
		String a1=urlString+"/manage/_getTransferAlbum2.jsp";
		String a2=urlString+"/manage/_getUpdateTransferAlbum2.jsp";
		ObjectOutputStream oo = null;
		URLConnection conn = null;
		try 
		{
		
		// conn = new URL("http://www.myjskid.com/tp/manage/_getTransferAlbum2.jsp").openConnection();
			if(a.getAlbumPhotos()==0)
			{ 
				conn = new URL(a1).openConnection();
		   	}else{
		   		conn = new URL(a2).openConnection();
		   	}
		
		    conn.setDoOutput(true);
		    OutputStream out2 = conn.getOutputStream();
		    oo = new ObjectOutputStream(out2);
		    
		    oo.writeObject(ha);
		    out2.flush();
		
		    InputStream in = URLConnector.getInputStream(conn, 5000);
		    BufferedReader br = new BufferedReader(new InputStreamReader(in));
		    String line;
		    while ((line=br.readLine())!=null)
		    {
		    	//System.out.println(line.trim());
		    	
		    	/*
		    	try{
		     		//int alXid=Integer.parseInt(line.trim());
					//a.setAlbumXid(alXid);
				}catch(Exception e){e.getMessage();}
				
				*/
			}

		}catch (Exception e){
		 
			//out.println(e.getMessage(); 
			
		}finally{
		    if (oo!=null)
		    {
		        try{
		        	oo.close();
		    	}catch(Exception e){}
		    }
		    oo = null;
		}
		
		return true;  
	}
	
	public boolean setupStep5(int alId)
	{
		
		AlbumMgr am=AlbumMgr.getInstance();
		Album a=(Album)am.find(alId);

		WebsetupMgr wm=WebsetupMgr.getInstance();
		Websetup  we=(Websetup)wm.find(1);
		
		String urlString=we.getWebsetupWebaddress();
		urlString+="/manage/_getTransferAlbum.jsp";

		ObjectOutputStream oo = null;
		URLConnection conn = null;
		int eId=0;
		try 
		{
	    	
	     	conn = new URL(urlString).openConnection();		
	    	conn.setDoOutput(true);
	    	OutputStream out2 = conn.getOutputStream();
	    	oo = new ObjectOutputStream(out2);
	    
			
			oo.writeObject(a);
			out2.flush();
	
		    InputStream in = URLConnector.getInputStream(conn, 5000);
		    BufferedReader br = new BufferedReader(new InputStreamReader(in));
		    String line;
		    while ((line=br.readLine())!=null)
		    {
		    	try{
	    			eId=Integer.parseInt(line.trim());
			    }catch(Exception e){}	
			}
		}catch (Exception e){
	    	e.printStackTrace();   
		}finally{
		    if (oo!=null)
		    {
		    	try{
		        	oo.close();
		    	}catch(Exception e){}
		    }
		    oo = null;
		}  
		
		if(eId==0)
		{
			if(a.getAlbumXid()!=0)
				return true;
			return false;
			
		}else{
			a.setAlbumXid(eId);
			am.save(a);
			
			return true;
		}
	}
	
	public int setupStep4(File[] allPic,String albumId,String filePath2)
	{
		String rgDicString=filePath2+"album/"+albumId+"/org";
		File orgDic=new File(rgDicString);
		
		File[] orgF=orgDic.listFiles();

		int existPic=0;	
		if(orgF  !=null)
		{
			for(int k=0;k<orgF.length;k++)
		
			{ 
				if(!orgF[k].isHidden())
				{	
					existPic++;
				}		
			} 
		}
		
		String rzDicSmallString=filePath2+"album/"+albumId+"/resize/small";
		String rzDicBigString=filePath2+"album/"+albumId+"/resize/big";
		String rzDicSourceString=filePath2+"album/"+albumId+"/source";

		
		int j=0;
		for(int i=0;i<allPic.length;i++)
		{
			if(!allPic[i].isHidden())
			{
				j++;
				
				String orgPath=rzDicSourceString+"/"+allPic[i].getName();
				String smallOut=rzDicSmallString+"/"+String.valueOf(j+existPic)+".jpg";
				String bigOut=rzDicBigString+"/"+String.valueOf(j+existPic)+".jpg";	
				String orgOut=rgDicString+"/"+String.valueOf(j+existPic)+".jpg";	
				
				workResize(orgPath,bigOut,smallOut,orgOut);	
				
				allPic[i].delete();
			} 
		}
		
		return j;
	}
	public File[] setupStep3(String albumId,String filePath2)
	{

		String rgDicString=filePath2+"album/"+albumId+"/org";
		String rzDicSmallString=filePath2+"album/"+albumId+"/resize/small";
		String rzDicBigString=filePath2+"album/"+albumId+"/resize/big";
		
		String rzDicSourceString=filePath2+"album/"+albumId+"/source";
		
		File orgDic=new File(rgDicString);
		File rzDic=new File(filePath2+"album/"+albumId+"/resize");
		File rzDicSmall=new File(rzDicSmallString);
		File rzDicBig=new File(rzDicBigString);
		
		File dicSource=new File(rzDicSourceString);
		
		if(!orgDic.exists())			
		orgDic.mkdir();
		
		if(!rzDic.exists())			
			rzDic.mkdir();
		if(!rzDicSmall.exists())			
			rzDicSmall.mkdir();
		if(!rzDicBig.exists())			
			rzDicBig.mkdir();
		
		return dicSource.listFiles();
	}
	
	

	public String getRemoteClass()
	{
		ObjectOutputStream oo = null;
		URLConnection conn = null;
		
		WebsetupMgr wm=WebsetupMgr.getInstance();
		Websetup  we=(Websetup)wm.find(1);
		
		String urlString=we.getWebsetupWebaddress();
		urlString+="/manage/_getAlbumClass.jsp";

		String classSelect="";

		try 
		{
			conn = new URL(urlString).openConnection();
		
		    conn.setDoOutput(true);
		    OutputStream out2 = conn.getOutputStream();
		    oo = new ObjectOutputStream(out2);
		    
		    oo.writeObject("1");
		    out2.flush();
		    
		    InputStream in = URLConnector.getInputStream(conn, 5000);
		    BufferedReader br = new BufferedReader(new InputStreamReader(in));
		    String line;
	 
	   	 
		    while ((line=br.readLine())!=null)
		    {
		    	classSelect+=line.trim();
			}
		}
		catch (Exception e)
		{
	    	e.printStackTrace();   
		}
		finally
		{
		    if (oo!=null)
		    {
				try{
		        	oo.close();
		    	}catch(Exception e){}
		    }
		    oo = null;
		}  

		return classSelect;
		
	}


	public static String resize(String orgFile,String outFile,int startX,int startY,int fixWidth,int fixHeight,int sizeRate)
	{
		
		System.out.println(orgFile);
		int newWidth=0;
     	int newheight=0;
		 try
        {
           
            File f = new File(orgFile);
            Image src = javax.imageio.ImageIO.read(f);
            
            int width=src.getWidth(null);
            int height=src.getHeight(null);
     		
     		newWidth=fixWidth;
     		newheight=fixHeight;
     		
     		
     		if(fixWidth==0)
     		{
     			newWidth=width/sizeRate;
     		}
     		if(fixHeight==0){
				newheight=height/sizeRate;
     		}	
     
            BufferedImage tag = new BufferedImage(newWidth,newheight,BufferedImage.TYPE_INT_RGB);
            
            
            tag.getGraphics().drawImage(src,startX,startY,width/sizeRate,height/sizeRate,null);
            FileOutputStream out=new FileOutputStream(outFile);
            
//            JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
//            encoder.encode(tag);
            out.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        
        //String rString="var w = window.open(\""+outFile+"\",\"imageWin\",\"width="+(newWidth+30)+",height="+(newheight+30)+",resizable=yes\");";
        String rString="alert('ok');";
        return rString;
        
	}

	private static boolean resizeBig(String orgFile,String outFile)
	{
		 try
        {
           
            File f = new File(orgFile);
            Image src = javax.imageio.ImageIO.read(f);
            
            int width=src.getWidth(null);
            int height=src.getHeight(null);
			
			float rate=0.0f;
			
			int outWidth=0;
			int outHeight=0;
			if(width >height) 
			{
				if(width <=600)
				{
					rate=1;
					outWidth=width;
					outHeight=height;
				}else{
					rate=width/600;	
					outWidth=600;
					outHeight=450;
				}
			}else{
				if(height <=600)
				{
					rate=1;
					outWidth=width;
					outHeight=height;
				}else{
					rate=height/600;
					outWidth=450;
					outHeight=600;	
				}
			}	    		
     		
            BufferedImage tag = new BufferedImage(outWidth,outHeight,BufferedImage.TYPE_INT_RGB);
            
            if(width >height) 
			{
            	tag.getGraphics().drawImage(src,0,0,600,450,null);
            }else{
            	tag.getGraphics().drawImage(src,0,0,450,600,null);
            }	
            FileOutputStream out=new FileOutputStream(outFile);
            
//            JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
//            encoder.encode(tag);
            out.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        
        return true;
	}

	private static boolean resizeSmall(String orgFile,String outFile)
	{
		 try
        {
           
            File f = new File(orgFile);
            Image src = javax.imageio.ImageIO.read(f);
            
            int width=src.getWidth(null);
            int height=src.getHeight(null);
			
			int rate=0;
			
			int outWidth=0;
			int outHeight=0;
			if(width >height) 
			{
				if(width <=126)
				{
					rate=1;
					outWidth=width;
					outHeight=height;
				}else{
					rate=width/126;	
					outWidth=126;
					outHeight=95;
				}
			}else{
				if(height <=126)
				{
					rate=1;
					outWidth=width;
					outHeight=height;
				}else{
					rate=height/126;
					outWidth=95;
					outHeight=126;	
				}
			}	    		
     		
            BufferedImage tag = new BufferedImage(outWidth,outHeight,BufferedImage.TYPE_INT_RGB);
            
            if(width >height) 
			{
            	tag.getGraphics().drawImage(src,0,0,126,95,null);
            }else{
				tag.getGraphics().drawImage(src,0,0,95,126,null);
			}
            	FileOutputStream out=new FileOutputStream(outFile);
            
//            JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
//            encoder.encode(tag);
            out.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        
        return true;
	}

	
	public static boolean workResize(String sourceFile,String bigFile,String smallFile,String orgOut)
	{

		while(resizeBig(sourceFile,bigFile))
		{
			if(resizeSmall(bigFile,smallFile))
				break;
		}
		
		transferSourceFile(sourceFile,orgOut);
	
		return true;
	}

	public static boolean transferSourceFile(String sourceFile,String orgOut)
	{
		try{
			File file=new File(sourceFile); 
	
			if(!file.exists() && !file.canRead())
	  		{ 
	   			System.out.println("file don't exist or file cannot read!!");
				System.exit(1);
			}
			
			long len=file.length();
			byte[] buffer=new byte[(int)len];
	  
			FileInputStream filein=new FileInputStream(file);
			
			File file2=new File(orgOut);
			if(!file2.exists())
			{ 
				file2.createNewFile();
			}
			
			FileOutputStream fileout=new FileOutputStream(file2,true);
			int ch=0;
			
			while((ch=filein.read(buffer))!=-1)
			{ 
				fileout.write(buffer);
			}
			filein.close();
			fileout.close();
			
			file.delete();

		}catch(Exception e){
		
			System.out.println(e.getMessage());	
		}
		
		return true;
	
	}


	public static String getFilename(String fullname) {
		String filename=null;
		fullname=fullname.replace("\\","/");
		StringTokenizer token = new StringTokenizer(fullname, "/");
		while (token.hasMoreTokens()) {
		filename = token.nextToken();
		}
		return filename;
	}

	
	
	public static String getPaghString(String a,int subLength,int allLength)
	{
			
		int totalLength=a.length();
		
		StringBuffer totalString=new StringBuffer();
		for(int i=0;i<totalLength;i=i+subLength)
		{
			subLength=i+subLength;
			
			if(allLength !=0)
			{ 
				
				if(i < totalLength && i<allLength)
				{
					if(subLength>=totalLength)
					{
						totalString.append(a.substring(i));	
					}else{
						totalString.append(a.substring(i,subLength)+"<br>");
					}
					
				}else{
					break;
				}			
			}else{
				if(i < totalLength)
				{
					if(subLength>=totalLength)
					{
						totalString.append(a.substring(i));	
					}else{
						totalString.append(a.substring(i,subLength)+"<br>");
					}
				}else{
					break;		
				}
			}
		
		}
		
		return totalString.toString();
	}
	
	
	public static Hashtable getPrepareHashtable(String path,Album al)
	{
		Hashtable ha=new Hashtable();
		try{
			
			String albumName=String.valueOf(al.getId());
			String albumWebName=String.valueOf(al.getAlbumXid());
			String localStringBig=path+"album/"+albumName+"/resize/big";
			String localStringSmall=path+"album/"+albumName+"/resize/small";
			
			File localBig=new File(localStringBig);
			File localSmall=new File(localStringSmall);
			
			File transBig[]=localBig.listFiles(); 
			File transSmall[]=localSmall.listFiles();
			
			if(transBig==null)
				return null;
			
			AlbumMgr am=AlbumMgr.getInstance();
			al.setAlbumPhotos(transBig.length);
			am.save(al);
			
			for(int i=0;i<transBig.length;i++)
			{
				String bigWeb=albumWebName+"/big/"+transBig[i].getName();
				String smallWeb=albumWebName+"/small/"+transBig[i].getName();
		
				if(!transBig[i].isHidden())
				{
					String fileSize=String.valueOf(transBig[i].length());
					bigWeb+="-"+fileSize;


					FileInputStream fin = new FileInputStream(transBig[i]);
		            ByteArrayOutputStream bout = new ByteArrayOutputStream();
		            int c;
		            byte[] buf = new byte[(int)transBig[i].length()];
		            while ((c=fin.read(buf, 0,(int) transBig[i].length()))>0)
		                bout.write(buf, 0, (int)transBig[i].length());
		            bout.flush();
		            byte[] bytes = bout.toByteArray();
		            
					
					ha.put(bigWeb,bytes);	
					//System.out.println("bigWeb:"+bigWeb);		
				}
				if(!transSmall[i].isHidden())
				{
					String fileSize2=String.valueOf(transSmall[i].length());
					smallWeb+="-"+fileSize2;
					
					
					FileInputStream fin = new FileInputStream(transSmall[i]);
		            ByteArrayOutputStream bout = new ByteArrayOutputStream();
		            int c;
		            byte[] buf = new byte[(int)transSmall[i].length()];
		            while ((c=fin.read(buf, 0,(int)transSmall[i].length()))>0)
		                bout.write(buf, 0, (int)transSmall[i].length());
		            bout.flush();
		            byte[] bytes = bout.toByteArray();
		            
					ha.put(smallWeb,bytes);
				}
			} 
			
		}catch(Exception e){
			
			System.out.println(e.getMessage());	
		}
		
		return ha;
	}
	
	public static Hashtable getPrepareHashtableContinue(String path,Album al)
	{
		Hashtable ha=new Hashtable();
		
		int nowpic=al.getAlbumPhotos();
		try{
			
			String albumName=String.valueOf(al.getId());
			String albumWebName=String.valueOf(al.getAlbumXid());
			String localStringBig=path+"album/"+albumName+"/resize/big";
			String localStringSmall=path+"album/"+albumName+"/resize/small";
			
			File localBig=new File(localStringBig);
			File localSmall=new File(localStringSmall);
			
			File transBig[]=localBig.listFiles(); 
			File transSmall[]=localSmall.listFiles();
			
			if(transBig==null)
				return null;
			
			AlbumMgr am=AlbumMgr.getInstance();
			al.setAlbumPhotos(transBig.length);
			am.save(al);
			
			for(int i=0;i<transBig.length;i++)
			{
				int fNameL=transBig[i].getName().length();	
				String fname=transBig[i].getName().substring(0,fNameL-4);
				int intFname=Integer.parseInt(fname);
				
				if(intFname > nowpic)
				{

System.out.println(intFname+","+nowpic);				
					String bigWeb=albumWebName+"/big/"+transBig[i].getName();
					String smallWeb=albumWebName+"/small/"+transBig[i].getName();
			
					if(!transBig[i].isHidden())
					{
						String fileSize=String.valueOf(transBig[i].length());
						bigWeb+="-"+fileSize;
	
	
						FileInputStream fin = new FileInputStream(transBig[i]);
			            ByteArrayOutputStream bout = new ByteArrayOutputStream();
			            int c;
			            byte[] buf = new byte[(int)transBig[i].length()];
			            while ((c=fin.read(buf, 0,(int) transBig[i].length()))>0)
			                bout.write(buf, 0, (int)transBig[i].length());
			            bout.flush();
			            byte[] bytes = bout.toByteArray();
			            
						
						ha.put(bigWeb,bytes);	
						//System.out.println("bigWeb:"+bigWeb);		
					}
					if(!transSmall[i].isHidden())
					{
						String fileSize2=String.valueOf(transSmall[i].length());
						smallWeb+="-"+fileSize2;
						
						
						FileInputStream fin = new FileInputStream(transSmall[i]);
			            ByteArrayOutputStream bout = new ByteArrayOutputStream();
			            int c;
			            byte[] buf = new byte[(int)transSmall[i].length()];
			            while ((c=fin.read(buf, 0,(int)transSmall[i].length()))>0)
			                bout.write(buf, 0, (int)transSmall[i].length());
			            bout.flush();
			            byte[] bytes = bout.toByteArray();
			            
						ha.put(smallWeb,bytes);
					}
				}			
			} 
			
		}catch(Exception e){
			
			System.out.println(e.getMessage());	
		}
		
		return ha;
	}
	
	
	public String getLastDateInMonth(Date xMonth)
	{
		String reDate="";
		try{
			
			SimpleDateFormat sdfX1=new SimpleDateFormat("yyyy/MM"); 
			SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy/MM/01"); 
			SimpleDateFormat sdfX3=new SimpleDateFormat("yyyy/MM/dd");
	
			int nextMon=xMonth.getMonth()+1;
			int nextYear=xMonth.getYear()+1900; 
			
			if(nextMon==12)
			{ 
				nextMon=1;
				nextYear++;				
			} else{
				nextMon++;
			}
			String nextString="";
	
			if(nextMon<=9)	
			{
				nextString="0"+String.valueOf(nextMon);
			}else{
				nextString=String.valueOf(nextMon);
			}  
			String nextString2=String.valueOf(nextYear);
			Date next2=sdfX2.parse(nextString2+"/"+nextString+"/01");
			
			long nextLong=next2.getTime()-(long)100;	
			
			Date next3=new Date(nextLong);
		
			reDate=sdfX3.format(next3);
	}catch(Exception e){}
		
		return reDate;
	}
}
