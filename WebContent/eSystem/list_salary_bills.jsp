<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<script>
function modifyName(id, oldname)
{
    var newname = "";
    while (newname.length==0) {
        newname = prompt("請輸入新的類型代號", oldname);
        if (newname==null)
            return;
    }
    location.href = "listBills2.jsp?id=" + id + "&n=" + encodeURI(newname) + 
        "&backurl=list_salary_bills.jsp";
}

function modifyPrettyName(id, oldname)
{
    var newname = "";
    while (newname.length==0) {
        newname = prompt("請輸入新的單據名稱", oldname);
        if (newname==null)
            return;
    }
    location.href = "listBills2.jsp?id=" + id + "&pn=" + encodeURI(newname) +
        "&backurl=list_salary_bills.jsp";
}
</script>


<%
    int status=1;

    String ss=request.getParameter("status");
    if(ss !=null)
          status=Integer.parseInt(ss);  


    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM");
    ArrayList<Bill> bills = BillMgr.getInstance().retrieveListX("status="+status+" and billType=" + 
        Bill.TYPE_SALARY + " and privLevel>=" + ud2.getUserRole(), "", _ws2.getBunitSpace("bunitId"));
%>
	
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><%=(status==1)?"使用中":"停用"%>的薪資類型列表：</b></div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>

<div class=es02>
     <%=(status !=1)?"<a href=\"list_salary_bills.jsp?status=1\">":""%>使用中的薪資類型<%=(status !=1)?"</a>":""%> |
     <%=(status !=0)?"<a href=\"list_salary_bills.jsp?status=0\">":""%>停用的薪資類型<%=(status !=0)?"</a>":""%>    
</div>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
    	<td valign=middle>內部作業名稱</td>
        <td valign=middle>薪資條標頭</td>
        <td valign=middle>可編輯權限</td>
        <td valign=middle>上期開單記錄</td>
        <td  valign=middle width=100></td>
    </tr>
<%
    BillRecordMgr brmgr = BillRecordMgr.getInstance();
    Iterator<Bill> iter = bills.iterator();
    while (iter.hasNext())
    {
        Bill b = iter.next();
        ArrayList<BillRecord> brecords = brmgr.retrieveList("billId="+b.getId(), "order by id desc limit 1");
        String str = "";
        if (brecords.size()>0) {
            BillRecord br = brecords.get(0);
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy年MM月");
            str ="月份: "+sdf2.format(br.getMonth())+"<br>"+br.getName();
        }
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>

		<td class=es02><img src="pic/s12A.gif" border=0>&nbsp<%=b.getName()%>

    &nbsp;&nbsp;(<a href="modify_salary_bill.jsp?bid=<%=b.getId()%>"><img src="pic/fix.gif" border=0 width=12>修改</a>)
</td>
		<td class=es02 valign=bottom><%=(b.getPrettyName()!=null)?b.getPrettyName():""%></td>
		<td class=es02 valign=bottom>
        <%
            switch(b.getPrivLevel()){
                case 2:
                    out.println("僅限經營者");
                    break;
                case 3:
                    out.println("經營者 + 會計");
                    break;                    
                case 4:
                    out.println("經營者 + 會計 + 行政");
                    break;                    
            }
        %>
        </td>
		<td class=es02 valign=bottom><%=str%></td>

        <td align=left nowrap class=es02 align=middle>
<%  if(status==1){  %>
    <a href="salaryrecord_add.jsp?billId=<%=b.getId()%>"><img src="pic/addbill2.gif" width=20 border=0>&nbsp;新增薪資</a>
<%  }   %>
</td>
    </tr>

<%
}
%>
<%  if(status==1){  %>

  <tr bgcolor=ffffff class=es02 valign=top>
        <td colspan=5>
            <a href="add_salary_bill.jsp"><img src="pic/s12.gif" border=0>&nbsp;新增薪資類型</a>
        </td>
    </tr>

<%  }   %>
</table>
</td></tr></table> 