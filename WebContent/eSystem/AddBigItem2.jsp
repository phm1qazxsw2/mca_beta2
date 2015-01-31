<%@ page language="java" buffer="32kb" import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
    String itemName=request.getParameter("BigItemName"); 
    String acctCode=request.getParameter("acctCode").trim(); 
    String firstCode=request.getParameter("firstCode").trim();  
    int biId=Integer.parseInt(request.getParameter("biId"));
    BigItem bi=new BigItem();
    acctCode=firstCode+acctCode;

    int active=Integer.parseInt(request.getParameter("active"));
    boolean haveSame=false;
    JsfAdmin ja=JsfAdmin.getInstance();
    
    BigItem[] bix=ja.getNowBigItemByCode(acctCode,1);    
    
    if(bix !=null && biId !=0)
    {
        if(bix[0].getId() != biId)
            haveSame=true;
    }
    
    BigItemMgr bim=BigItemMgr.getInstance();
    if(biId>0)
        bi=(BigItem)bim.find(biId);
    
    

    bi.setBigItemName(itemName);
    bi.setAcctCode(acctCode);
    bi.setBigItemActive(active);


    if(!haveSame){
        if(biId ==0)    
            bim.createWithIdReturned(bi);
        else
            bim.save(bi);
    }
%>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0 width=14>&nbsp;<%=(biId==0)?"新增雜費會計主科目":"編輯"+bi.getBigItemName()%></b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  	
<br>
<br>
<blockquote>

        <div class=es02>
            會計主科目:<font color=blue><%=itemName%></font>
            <%
                    if(!haveSame){

                        String backurl=request.getParameter("backurl");
            %>
                        <%=(biId==0)?"新增成功":"編輯完成"%>.
                        <%
                        if(backurl !=null){
                        %>
                        <a href="<%=backurl%>">回選取會計科目</a>        
                        <%
                        }
                        %>

            <%  
                    }else{  
            %>  
                        <br>
                        <br>
                        <b><font color=red>Error:</font></b>本科目編號重複. 
            <%      }   %>

            <br>
            <br>

        </div>
    </blockquote>
 