<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

if(!AuthAdmin.authPage(ud2,3))
{
%>    
    <br>
    <br>
    <blockquote>
        <div class=es02>
            權限不足.
        </div>
    </blockquote>  

<%
    return;
}

int soId=Integer.parseInt(request.getParameter("soId"));

SalaryOutMgr som=SalaryOutMgr.getInstance();
SalaryOut so=(SalaryOut)som.find(soId);

SalaryAdmin sa=SalaryAdmin.getInstance();
String outWord=sa.doBankout(so); 	
String[] aa=outWord.split("xxx");

if(aa[0].equals("1")) 
{ 
%>
    <br>
    <br>
    <blockquote>        
        <div class=es02><font color=red>Error:</font><%=aa[1]%></div>
    </blockquote>
<%
        	return;	
} 

try{
	String filePath = request.getRealPath("/")+"eSystem/salaryOut/"+String.valueOf(so.getSalaryOutBanknumber())+".txt"; 
	
	File txtFile=new File(filePath);
 
	
	if(!txtFile.exists()) 
	{
		txtFile.createNewFile(); 
	}
	
	BufferedWriter fout=new BufferedWriter(new FileWriter(filePath,false));
						
	fout.write(outWord);
 
	fout.close();
	
}catch(Exception e)	{

	out.println(e.getMessage());
} 


so.setSalaryOutStatus(1);

som.save(so); 

%> 

<br>
<br>

<blockquote>

<div class=es02>    
檔案已產生!<br><br>


<font size=2 color=red>注意:</font>此為機密資訊,下載後請妥善保存.
<br>
<br>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

		<table width="100%" border=0 cellpadding=4 cellspacing=1>
			<tr bgcolor="ffffff" class=es02>
                <td bgcolor="#f0f0f0">下載注意</td>
                <td>1. 請關閉瀏覽器的攔截視窗.<BR>
                    2. 跳出視窗後,在瀏覽器的功能列,使用<font color=blue>網頁</font> -> <font color=blue>另存新檔</font> 下載.    
            </td>
            </tr>
            <tr bgcolor=ffffff>
                <td colspan=2 align=middle>
                    <a href="salaryOut/<%=String.valueOf(so.getSalaryOutBanknumber())%>.txt" target="_blank">下載檔案</a>
                </td>
            </tr>
        </table>
        </tD>
        </tr>
        </table>
</div>
</blockquote>