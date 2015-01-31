<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%><%

try
{
    String typeS=request.getParameter("type");
    String accountIdS=request.getParameter("accountId");

    int type=Integer.parseInt(typeS);
    int accountId=Integer.parseInt(accountIdS);
    if(type==1)
    {
        String filePath2 = request.getRealPath("./")+"accountAlbum/"+accountIdS;
        File FileDic2 = new File(filePath2);
        File files2[]=FileDic2.listFiles();
        File xF2=null; 
        if(files2 !=null)
        { 
            for(int j2=0;j2<files2.length;j2++)
            { 
                if(!files2[j2].isHidden())
                xF2 =files2[j2] ;
            } 
        }

        if(xF2 !=null && xF2.exists())
        {			
%>
			<img src="accountAlbum/<%=accountIdS%>/<%=xF2.getName()%>" width=150 border=0>
<%			
        }
        else {
%>
            <img src="pic/nocontent.gif" border=0>  
<%
        }
    }
    else {	
        String filePath2 = request.getRealPath("./")+"bankAlbum/"+accountIdS;
        File FileDic2 = new File(filePath2);
        File files2[]=FileDic2.listFiles();
        File xF2=null; 

        if(files2 !=null)
        { 
            for(int j2=0;j2<files2.length;j2++)
            { 
                if(!files2[j2].isHidden())
                    xF2 =files2[j2] ;
            } 
        }

        if(xF2 !=null && xF2.exists())
        {			
%>
			<img src="bankAlbum/<%=accountIdS%>/<%=xF2.getName()%>" width=150 border=0>
<%	
        }
        else{
%>
            <img src="pic/nocontent.gif" border=0>
<%
            }
		}

	}
    catch(Exception ex)
	{
		
	}
%>