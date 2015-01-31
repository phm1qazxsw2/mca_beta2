<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 int sID=Integer.parseInt(request.getParameter("sid")); 
 String bidS=request.getParameter("bid");

JsfAdmin ja=JsfAdmin.getInstance();
SmallItemMgr sim=SmallItemMgr.getInstance();
SmallItem si=null;

int bid=0;
if(sID !=0){
    si=(SmallItem)sim.find(sID);
    bid=si.getSmallItemBigItemId();
}else{
    bid=Integer.parseInt(bidS);
}

 BigItemMgr bim=BigItemMgr.getInstance();
 BigItem    bi=(BigItem)bim.find(bid);

 int runID=0;
 SmallItem[] allSi=ja.getAllSmallItemByBID(bid);
 if(allSi !=null)
    runID=allSi.length+1;
 else
    runID=1;    

String runIdString=String.valueOf(runID);
int needRun=3-runIdString.length();
for(int i=0;i<needRun;i++)
    runIdString="0"+runIdString;


%>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0 width=14>&nbsp;<%=(sID==0)?"新增雜費會計次科目":"編輯雜費會計次科目-"+si.getSmallItemName()%></b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  	

<form action="modifySmallItem3.jsp" method="post">
<table>
    <tr>
        <td>主科目</td>
	    <td>
            <%=bi.getAcctCode()%>-<%=bi.getBigItemName()%>
        </tD>
    </tr>
	<tr>
		<td>次科目序號</td><td>
		<input type=text name=acctCode size=4 maxlength=3 value=<%=(si!=null &&si.getAcctCode()!=null && si.getAcctCode().length()>0 )?si.getAcctCode():runIdString%>>
        <br>
        說明: 以三碼為限    

		</td>
	</tr>
	<tr>
		<td>次科目名稱</td><td>
		<input type=text name=isiName value=<%=(si!=null)?si.getSmallItemName():""%>>
		</td>
	</tr>

	<tr>
		<td colspan=2>
		<center>
		    <input type=hidden name="sid" value="<%=sID%>">
            <input type=hidden name="bid" value="<%=bid%>">
            <input type=hidden name="backurl" value="<%=request.getParameter("backurl")%>">

			<input type=submit value="<%=(sID==0)?"新增":"修改"%>" onClick="return(confirm('確認<%=(sID==0)?"新增":"修改"%>?'))">
		</center>	
		</td>
	</tr>
</table>
</form>
<br>
<br>
