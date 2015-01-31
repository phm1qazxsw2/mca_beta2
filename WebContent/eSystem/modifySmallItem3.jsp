<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
String itemName=request.getParameter("isiName"); 
String acctCode=request.getParameter("acctCode"); 
int sid=Integer.parseInt(request.getParameter("sid"));
int bid=Integer.parseInt(request.getParameter("bid"));

BigItemMgr bim=BigItemMgr.getInstance();
BigItem bi=(BigItem)bim.find(bid);
SmallItemMgr sim=SmallItemMgr.getInstance();
JsfAdmin ad=JsfAdmin.getInstance();
SmallItem si=new SmallItem();
if(sid !=0)
    si=ad.getSmallItemById(sid);

if(sid ==0)
    si.setSmallItemActive(1);

si.setAcctCode(acctCode);
si.setSmallItemName(itemName);
si.setSmallItemBigItemId(bid);


if(sid==0)
    sim.createWithIdReturned(si);
else
    sim.save(si);


String backurl=request.getParameter("backurl");

%>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0 width=14>&nbsp;<%=(sid==0)?"新增雜費會計次科目":"編輯雜費會計次科目-"+si.getSmallItemName()%></b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  	

    <br>
    <br>
    <blockquote>
        <div class=es02>
            會計主科目:<font color=blue><%=itemName%></font><%=(sid==0)?"新增成功":"編輯完成"%>.
            <br>
            <br>
<%
            if(backurl !=null)
            {
%>
            <a href="<%=backurl%>&code=<%=bi.getAcctCode()%><%=si.getAcctCode()%>" target="_top">繼續登入雜費</a>
<%
            }
%>
        </div>
    </blockquote>
 