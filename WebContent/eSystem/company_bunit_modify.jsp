<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    int bid=Integer.parseInt(request.getParameter("bid"));
    BunitMgr bm=BunitMgr.getInstance();

    BunitHelper bh = new BunitHelper();
    Bunit b=bm.find("id='"+bid+"'");
    int bankId = bh.getBankId(b, true);
    String serviceID = bh.getServiceID(b.getId(), true);
    String storeID = bh.getStoreID(b.getId(), true);
    String virtualID = bh.getVirtualID(b.getId(), true);
    int acodeBunitId = bh.getAcodeBunitId(b.getId(), true); 
    int studentBunitId = bh.getStudentBunitId(b.getId(), true);
    int metaBunitId = bh.getMetaBunitId(b.getId(), true);
%>

<script src="js/string.js"></script>
<script>
function do_check(f)
{
    if (trim(f.name.value).length==0) {
        alert("請輸入名稱");
        f.name.focus();
        return false;
    }
    return true;
}

</script>

<body>

<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;<img src="pic/tag1.png" border=0>&nbsp;修改單位
</div>

    <center>
        <form name="f1" action="company_bunit_modify2.jsp" method="post" onsubmit="return do_check(this)">
        <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    單位名稱：
                </td>
                <td>
                    <input type=text name="name" value="<%=b.getLabel()%>">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    帳單機構全名：
                </td>
                <td>
                    <input type=text name="fullname" value="<%=bh.getAttr(b.getId(), "fullname")%>">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    帳單機構地址：
                </td>
                <td>
                    <input type=text name="address" value="<%=bh.getAttr(b.getId(), "address")%>" size="40">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    帳單機構電話：
                </td>
                <td>
                    <input type=text name="phone" value="<%=bh.getAttr(b.getId(), "phone")%>">
                </td>
            </tr>
            <input type=hidden name="flag" value="<%=b.getFlag()%>">
<!--
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    應用類別:
                </td>
                <td>
                    <input type=radio name="flag" value="1" <%=(b.getFlag()==1)?"checked":""%>>會計管理
                    <input type=radio name="flag" value="0" <%=(b.getFlag()==0)?"checked":""%>>出勤系統
                </td>
            </tr>
-->
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    狀態名稱：
                </td>
                <td>
                    <input type=radio name="status" value=1 <%=(b.getStatus()==1)?"checked":""%>>使用中
                    <input type=radio name="status" value=0 <%=(b.getStatus()==0)?"checked":""%>>停用
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 colspan=2 align=center>
                    代收資訊
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    代收帳戶
                </td>
                <td>
                    <select name="bankId">
                    <option value="0">-- 尚未選擇 --
                <%
                    BankAccount[] banks = JsfPay.getInstance().getAllBankAccount("bunitId="+b.getId());
                    for (int i=0; banks!=null && i<banks.length; i++) {
                        %><option value="<%=banks[i].getId()%>" <%=(banks[i].getId()==bankId)?"selected":""%> ><%=banks[i].getBankAccountName()%><%
                    }
                %>
                    </select>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    虛擬帳號
                </td>
                <td>
                    <input name="virtualID" value="<%=virtualID%>" size=7>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    便利商店代號
                </td>
                <td>
                    <input name="storeID" value="<%=storeID%>" size=7>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    便利代收類型
                </td>
                <td>
                    <select name="serviceID">
                       <option value="">-- 尚未設定 --
                       <option value="669" <%=(serviceID.equals("669"))?"selected":""%>>669 臺新學費
                       <option value="626" <%=(serviceID.equals("626"))?"selected":""%>>626 聯邦(世仁)
                       <option value="62F" <%=(serviceID.equals("62F"))?"selected":""%>>62F 聯邦(牛耳)
                    </select>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 colspan=2 align=center>
                    共用別單位資料
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    會計科目
                </td>
                <td>
                    <select name="acodeBunitId">
                    <option value="0">-- 無 --
                <%
                    ArrayList<Bunit> bunits = BunitMgr.getInstance().retrieveList("flag=" + Bunit.FLAG_BIZ + 
                        " and status=1", "");
                    for (int i=0; i<bunits.size(); i++) {
                        %><option value="<%=bunits.get(i).getId()%>" <%=(bunits.get(i).getId()==acodeBunitId)?"selected":""%> ><%=bunits.get(i).getLabel()%><%
                    }
                %>
                    </select>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    學生資料
                </td>
                <td>
                    <select name="studentBunitId">
                    <option value="0">-- 無 --
                <%
                    for (int i=0; i<bunits.size(); i++) {
                        %><option value="<%=bunits.get(i).getId()%>" <%=(bunits.get(i).getId()==studentBunitId)?"selected":""%> ><%=bunits.get(i).getLabel()%><%
                    }
                %>
                    </select>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    開單資料(折扣)
                </td>
                <td>
                    <select name="metaBunitId">
                    <option value="0">-- 無 --
                <%
                    for (int i=0; i<bunits.size(); i++) {
                        %><option value="<%=bunits.get(i).getId()%>" <%=(bunits.get(i).getId()==metaBunitId)?"selected":""%> ><%=bunits.get(i).getLabel()%><%
                    }
                %>
                    </select>
                </td>
            </tr>

            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=hidden name="bid" value="<%=bid%>">
                <input type=submit value="修改" onClick="return(confirm('確認修改?'))">
                </td>
            </tr>
        </table>

    </td>
    </tr>
    </table>
    </center>

    </form>
</body>
