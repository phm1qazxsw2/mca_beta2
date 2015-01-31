<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int biId=Integer.parseInt(request.getParameter("bi"));
    int type=Integer.parseInt(request.getParameter("type"));

    BigItemMgr bim=BigItemMgr.getInstance();

    BigItem bi=null;

    if(biId>0)
        bi=(BigItem)bim.find(biId);

    String firstCode="";
    String lastCode="";

    if(bi !=null && bi.getAcctCode() !=null && bi.getAcctCode().length()>=4)
    {
        firstCode=bi.getAcctCode().substring(0,1);
        lastCode=bi.getAcctCode().substring(1,4);        
    }
%>
<script>
    function checkCode(thisForm){
        
      if(thisForm.acctCode.value.length !=3){
            alert('後三碼限定為三位數字');
            thisForm.acctCode.focus();
            return false;
        }
        return true;    
    }
</script>

<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0 width=14>&nbsp;<%=(bi==null)?"新增雜費會計主科目":"編輯"+bi.getBigItemName()%></b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  	
<center>

<form action="AddBigItem2.jsp" name=xs id=xs method="post" onsubmit="return checkCode(this)">

<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>
            主科目編號:
        </td>
        <td bgcolor=ffffff>
            <table class=es02>
                <tr border=0 class=es02>        
                <td>第一碼</td>
                <td>
            <%
            if(type==1){
            %>
                <select name="firstCode">
                    <option value="5" <%=(firstCode.equals("5"))?"selected":""%>>5 營業成本</option>
                    <option value="6" <%=(firstCode.equals("6"))?"selected":""%>>6 營業費用</option>
                </select>
            <%  }else if(type==2){  %>
                <select name="firstCode">
                    <option value="4" <%=(firstCode.equals("4"))?"selected":""%>>4 營業收入</option>
                    <option value="7" <%=(firstCode.equals("7"))?"selected":""%>>7 非營業收入</option>
                </select>
            <%  }   %>
                </td>
                <td>
                    後三碼
                </td>
                <td>
            <input type=text name="acctCode" value="<%=lastCode%>" size=6 maxlength=3>
                </td>
            </tr>
            </table>
        </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>        
        主科目名稱:
        </td>
        <td bgcolor=ffffff>
        <input type=text name="BigItemName" value="<%=(bi==null)?"":bi.getBigItemName()%>">
        </td>
    </tr>
<%
    if(bi!=null){
%>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>        
        狀態:
        </td>
        <td bgcolor=ffffff>
            <input type=radio name="active" value="1" <%=(bi!=null && bi.getBigItemActive()==1)?"checked":""%>>使用中
            <input type=radio name="active" value="0" <%=(bi!=null && bi.getBigItemActive()==0)?"checked":""%>>停用
        </td>
    </tr>
<%  }else{  %>
    <input type=hidden name="active" value="1">
<%  }   %>

    <tr>
        <td colspan=2 align=middle>
            <input type=hidden name="biId" value="<%=biId%>">
            <input type=hidden name="backurl" value="<%=request.getParameter("backurl")%>">

            <input type=submit value="<%=(biId==0)?"新增":"修改"%>">
        </td>
    </tr>
    </table>
    </td>
    </tr>
    </table>

</form> 	
</center>