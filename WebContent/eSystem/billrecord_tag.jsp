<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<blockquote>
<form name="f1" action="billrecord_tag2.jsp" method="post">
<%
    int brid = Integer.parseInt(request.getParameter("brid"));
    ArrayList<ChargeItemMembr> all_charges = ChargeItemMembrMgr.getInstance().
        retrieveList("chargeitem.billRecordId=" + brid, "");
    Map<String/*tagId+#+chargeItemId*/, Vector<ChargeItemMembr>> tagChargeMap = 
        new SortingMap(all_charges).doSort("getTagChargeKey");
    Map<String/*membrId#chargeItemId*/, Vector<ChargeItemMembr>> chargeMap = 
        new SortingMap(all_charges).doSort("getChargeKey");


    Iterator<String> tagIter = tagChargeMap.keySet().iterator();
    TagStudentMgr tsmgr = TagStudentMgr.getInstance();

    boolean need_handle = false;
    Map<Tag, Vector<ChargeItemMembr>> outMap = new LinkedHashMap<Tag, Vector<ChargeItemMembr>>();
    Map<Tag, Vector<ChargeItemMembr>> inMap = new LinkedHashMap<Tag, Vector<ChargeItemMembr>>();
    while (tagIter.hasNext()) {
        Vector<ChargeItemMembr> charges = tagChargeMap.get(tagIter.next());
        if (charges.get(0).getTagId()==0)
            continue;
        Tag tag = TagMgr.getInstance().find("id=" + charges.get(0).getTagId());
        if (tag==null)
            continue;
        Vector<ChargeItemMembr> out_v = new Vector<ChargeItemMembr>();
        Vector<ChargeItemMembr> in_v = new Vector<ChargeItemMembr>();
        outMap.put(tag, out_v);
        inMap.put(tag, in_v);

        ArrayList<TagStudent> tstudents = tsmgr.retrieveList("tagId=" + charges.get(0).getTagId() +
            " and studentStatus in (3,4)", "");
        Map<Integer/*membrId*/, Vector<TagStudent>> studentMap = new SortingMap(tstudents).doSort("getMembrId");
        for (int i=0; i<charges.size(); i++) {
            ChargeItemMembr ci = charges.get(i);
            if (studentMap.get(new Integer(ci.getMembrId()))==null) {
                // 新的 chargeitemmembr 沒有在 tag 里了
                out_v.add(ci);
                need_handle = true;
            }
            else {
                studentMap.remove(new Integer(ci.getMembrId())); // 移掉，最后剩下的就是要加的
            }
        }
        Iterator<Integer> kiter = studentMap.keySet().iterator();
        while (kiter.hasNext()) {
            Vector<TagStudent> vs = studentMap.get(kiter.next());
            //System.out.println("## need to add : " + vs.get(0).getMembrName());
            ChargeItemMembr ci = new ChargeItemMembr();
            ci.setMembrId(vs.get(0).getMembrId());
            ci.setBillItemId(charges.get(0).getBillItemId());
            ci.setChargeItemId(charges.get(0).getChargeItemId());
            ci.setChargeName_(charges.get(0).getChargeName());
            ci.setMembrName(vs.get(0).getMembrName());
            ci.setChargeAmount(charges.get(0).getChargeAmount());
            //System.out.println("## ci.getChargeKey()=" + ci.getChargeKey());
            if (chargeMap.get(ci.getChargeKey())!=null) // 有可能雖然不是 tag 有記錄，但非 tag 記錄的部分已經有此 charge 了     
                continue;
            in_v.add(ci);
            need_handle = true;
        }
    }
%>
<div class=es02><b>名單異動通知:</b></div><br>
<%
    Iterator<Tag> tagiter = outMap.keySet().iterator();
    while (tagiter.hasNext()) {
        Tag tag = tagiter.next();
        Vector<ChargeItemMembr> out_v = outMap.get(tag); 
        if (out_v==null || out_v.size()==0)
            continue;
        %>
    <div class=es02><b><img src="img/flag2.png" border=0>&nbsp;<%=out_v.get(0).getChargeName()%></b></div>
    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#4A7DBD">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
         <tr bgcolor=ffffff class=es02>
            <td width=100%>
            <img src="pic/minus.gif" border=0 width=15>&nbsp;下面學生不再是標籤 "<%=tag.getName()%>" 的成員，是否移除他們的收費? (打勾為是)<br>
            <%
                    for (int i=0; i<out_v.size(); i++) {
                        ChargeItemMembr ci = out_v.get(i); %>
            &nbsp;&nbsp;&nbsp;&nbsp;<input type=checkbox name="out" value="<%=ci.getChargeKey()%>" checked> <%=ci.getMembrName()%> 
                        (<%=ci.getMyAmount()%> 元)
                        <br>
            <%
                    }
            %>
        </td>
        </tr>
        </table>
    </td>
    </tr>
    </table>
    <br>
<%
    }
    tagiter = inMap.keySet().iterator();
    while (tagiter.hasNext()) {
        Tag tag = tagiter.next();
        Vector<ChargeItemMembr> in_v = inMap.get(tag); 
        if (in_v==null || in_v.size()==0)
            continue;
        %>
    <div class=es02><b><img src="img/flag2.png" border=0>&nbsp;<%=in_v.get(0).getChargeName()%></b></div>
    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#F77510">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
         <tr bgcolor=ffffff class=es02>
            <td width=100%>
            <img src="pic/add.gif" border=0 width=15>&nbsp;下面學生後來加入標籤 "<%=tag.getName()%>"，是否加上他們的收費? (打勾為是)<br>
        <table border=0>
<%
        for (int i=0; i<in_v.size(); i++) {
            ChargeItemMembr ci = in_v.get(i); %>
            <tr class=es02>
                <td width=10></td>        
                <td align=left width=100> 
                    <input type=checkbox name="in" value="<%=ci.getChargeKey()%>#<%=tag.getId()%>" checked> 
                    <%=ci.getMembrName()%> 
                </td>
                <td align=left>
                    <input type=text name="<%=ci.getChargeKey()%>#<%=tag.getId()%>" value="<%=ci.getChargeAmount()%>" size=5>
                </td>
            </tr>
<%
        }
%>
        </table>
        </td>
        </tr>
        </table>
    </td>
    </tr>
    </table>
    <br>
<%
    }
 //   out.println("</div>");
    System.out.println("## outMap.size=" + outMap.size() + " inMap.size=" + inMap.size());
%>
  
<input type=hidden name="brid" value="<%=brid%>">
<% if (need_handle) { %>
       <center><input type=submit value="確認修改"></center>
<% } else { %>
設定成功!
<br>
<br>
<a target=_top href="editBillRecord.jsp?recordId=<%=brid%>">編輯帳單</a>
<% } %>
</form>
</blockquote>