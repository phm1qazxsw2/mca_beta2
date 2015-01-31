<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>
<%

int coId=Integer.parseInt(request.getParameter("ctId"));

CosttradeMgr ctm=CosttradeMgr.getInstance();
Costtrade ct=(Costtrade)ctm.find(coId);

if(ct==null)
{
	out.println("沒有此筆資料");
	return;
}
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>&nbsp;<%=ct.getCosttradeName()%></b>
&nbsp;&nbsp;
<a href="listCosttradeX.jsp?ctId=<%=coId%>">基本資料</a>|
<a href="listCTClientAccount.jsp?ctId=<%=coId%>">匯款帳號</a> |  <b>會計科目設定</b>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<div class=es02 align=right><a href="listCosttrade.jsp"><img src="pic/last.gif" border=0 width=15>&nbsp;回廠商列表</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<br>
<%
    JsfAdmin ja=JsfAdmin.getInstance();
    Costbigitem[]  cbi=ja.getCostbigitemByCTid(coId);

    if(cbi !=null && cbi.length==1 && cbi[0].getBigitemId()==0)
    {
%>    
        <blockquote>
        <div class=es02>    
        目前狀態:適用於全部會計科目.
        <br><br>
                    
        <a href="changeCTItype.jsp?ctId=<%=coId%>&type=1&cbiId=<%=cbi[0].getId()%>&backurl=<%=java.net.URLEncoder.encode("listCTBigItem.jsp?ctId="+coId)%>">
<img src="pic/fix.gif" border=0 width=12>改為個別設定</a>
        </div>
        </blockquote>
<%
    }else{

        Hashtable ha=new Hashtable();
        for(int i=0;cbi !=null && i<cbi.length ; i++)
        {
            ha.put((Integer)cbi[i].getBigitemId(),(Costbigitem)cbi[i]);
        }
%>
<div class=es02>
 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="changeCTItype.jsp?ctId=<%=coId%>&type=2&cbiId=0&backurl=<%=java.net.URLEncoder.encode("listCTBigItem.jsp?ctId="+coId)%>">
<img src="pic/fix.gif" border=0 width=12>改為適用於全部會計科目</a>
</div>
<center>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr align=left valign=middle>
    <form action="modifyCTI.jsp" method="post">
        <td align=middle colspan=2>
            <input type=submit value="修改">
        </td>
    </tr>
    <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
        <td align=middle>會計主科目</td><tD align=middle>會計次科目</td>
    </tr>

<%
        BigItem[] bis=ja.getAllActiveBigItem2();
        
        for(int i=0;bis!=null && i<bis.length;i++)
        {      
        	SmallItem[] si=ja.getAllSmallItemByBID(bis[i].getId());
%>
    <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td width=200>
                <input type="checkbox" name="b<%=bis[i].getId()%>" value="<%=bis[i].getId()%>" <%=(ha.get((Integer)bis[i].getId())!=null)?"checked":""%>>                
                    <b><%=bis[i].getAcctCode()%>-<%=bis[i].getBigItemName()%></b>
            </tD>
            <td width=400>
                    <%  for(int j=0;si!=null && j<si.length;j++){   
                        
                            String isiName=si[j].getSmallItemName();
                    %>
                            <%=isiName%>,
                    <%  }   %>
                
            </td>
        </tr>
<%
        }
%>
    <tr>
        <td align=middle colspan=2>
            <input type=hidden name="ctId" value="<%=coId%>">
            <input type=hidden name="backurl" value="listCTBigItem.jsp?ctId=<%=coId%>">
            <input type=submit value="修改">
        </td>
    </tr>
    </form>
</table>
    </td>
    </tr>
    </table>
</center>
<%  }   %>


    <BR>
    <BR>
<%@ include file="bottom.jsp"%>
