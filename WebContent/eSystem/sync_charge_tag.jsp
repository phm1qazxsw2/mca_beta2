<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%	
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=502");
    }

    int cid = Integer.parseInt(request.getParameter("cid"));
    ArrayList<ChargeItemMembr> chargedmembrs = ChargeItemMembrMgr.getInstance().
        retrieveList("chargeItemId=" + cid, "");

    Map<Integer, Vector<ChargeItemMembr>> membrchargeMap = new SortingMap(chargedmembrs).doSort("getMembrId");         
    Map<Integer, Vector<ChargeItemMembr>> tagchargeMap = new SortingMap(chargedmembrs).doSort("getTagId");
    /*
     * 沒有連結任何標籤就不檢查了
     */
    if (tagchargeMap.size()==1 && tagchargeMap.get(new Integer(0))!=null) {
        out.println("<br><br><blockquote>此收費沒有連結至任何標籤</blockquote>");      
        return;
    }

    String ids = new RangeMaker().makeRange(chargedmembrs, "getTagId");
    ArrayList<TagMembrStudent> tmstudents = TagMembrStudentMgr.getInstance().
        retrieveList("tagId in (" + ids + ") and studentStatus in (3,4)", "");
    Map<Integer, Vector<TagMembrStudent>> tagstudentMap = new SortingMap(tmstudents).doSort("getTagId");
    ArrayList<Tag> tags = TagMgr.getInstance().retrieveList("id in (" + ids + ")", "");
    Map<Integer, Vector<Tag>> testtagMap = new SortingMap(tags).doSort("getId");

    int defaultAmount =  chargedmembrs.get(0).getChargeAmount();
    String chargeName = chargedmembrs.get(0).getChargeName();
    String param = java.net.URLEncoder.encode(chargedmembrs.get(0).getBillRecordId() +"#"+ chargedmembrs.get(0).getBillItemId() + "#" + chargedmembrs.get(0).getChargeItemId());
    String backurl = java.net.URLEncoder.encode("sync_charge_tag.jsp?cid=" + cid);
%>
<blockquote>
<div class=es02>
<b><%=chargeName%> 與標籤 同步作業　
<%
/*
    Iterator<Tag> iter4 = tags.iterator();
    while (iter4.hasNext()) {
        out.println(iter4.next().getName() + " ");
    }
*/
%>
</b>
</div>
</blockquote>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
    <blockquote>

    <table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=f0f0f0 class=es02>
        <td>姓名</td>
        <td><img src="pic/billx.png" border=0>&nbsp;收費項目</td>
        <td><img src="pic/tagtype2.png" border=0>&nbsp;標籤</td>
        </tr>
<%    
    Iterator<Integer> iter = tagchargeMap.keySet().iterator();
    while (iter.hasNext()) {
        Integer tagId = iter.next();
        int tid = tagId.intValue();
        if (tid==0)
            continue;
        if (testtagMap.get(tagId)==null)
            continue; // 已經被刪了
        Vector<ChargeItemMembr> vc = tagchargeMap.get(tagId);
        Vector<TagMembrStudent> vt = tagstudentMap.get(tagId);
        // 比較 vt 和 vc 是否人是一樣的
        Map<Integer, Vector<TagMembrStudent>> _tmp = new SortingMap(vt).doSort("getMembrId");        
        for (int i=0; vc!=null&&i<vc.size(); i++)
        {
            ChargeItemMembr ci = vc.get(i);
            int mid = ci.getMembrId();
            if (_tmp.get(new Integer(mid))==null) {
%>
        <tr bgcolor=ffffff class=es02>
                <td><%=ci.getMembrName()%></td>
                <td valign=top><br>狀態:已加入</td>
<%
                Iterator<Tag> iter3 = tags.iterator();
%>
            <td valign=top><br>
                    狀態:<font color=blue>沒有任何標籤</font>
<%
                while (iter3.hasNext()) {
                    Tag t = iter3.next();
                    out.println("<br>　　<a href='sync_charge_tag2.jsp?cid="+ci.getChargeItemId()+"&tid="+t.getId()+"&mid="+ci.getMembrId()+"'  onclick=\"if (confirm('確定加入？')) {return true;} else {return false;}\"><img src=pic/add.gif border=0 width=12>&nbsp;加入["+t.getName()+"]</a>");
                }
%>
                </td>
            </tr>  
<%
          }
            else
                _tmp.remove(new Integer(mid));
        }

        if (_tmp.size()>0) { // 比較完之後, tag的人還剩
            // 此時還要確定該人是否有用別的 tag 加入或是沒用 tag 的零散加入
            Iterator<Integer> iter2 = _tmp.keySet().iterator();
            while (iter2.hasNext()) {
                Integer membrId = iter2.next();
                if (membrchargeMap.get(membrId)==null) { // 如果也沒找到

                    TagMembrStudent tm = _tmp.get(membrId).get(0);
        %>
        <tr bgcolor=ffffff class=es02>
            <tD><%=tm.getMembrName()%></td>
            <td valign=top>
            <br>狀態:<font color=blue>尚未加入</font>
<%
                    //out.println("<li>" + tm.getTagName() + "成員:" + tm.getMembrName() + " 沒在收費名單里");
                    out.println("<br>　　<a href='chooser_detail2.jsp?tag="+tm.getTagId() + "&param="+param+"&target="+tm.getMembrId()+"&backurl="+backurl+"' onclick=\"if (confirm('確定收費？')) {return true;} else {return false;}\"><img src=pic/add.gif border=0 width=12>&nbsp;加入收費</a>");
                  
        %>    
        </td>
            <td valign=top>
                <br>狀態:已加入 [<%=tm.getTagName()%>]
                <br>
<%
  out.println("　　<a href='sync_charge_tag3.jsp?cid="+cid + "&mid="+tm.getMembrId() + "&tid="+tm.getTagId() + "' onclick=\"if (confirm('確定從 "+tm.getTagName()+" 移除？')) {return true;} else {return false;}\"><img src='pic/minus.gif' border=0 width=12>&nbsp;從 "+tm.getTagName()+" 移除</a><br><br>");
%>
            </td>
        </tr>
<%
                }

            }
        }
    }

    // 處理 tagId = 0 的收費對象
    Vector<ChargeItemMembr> vc = tagchargeMap.get(new Integer(0));
    Map<Integer, Vector<TagMembrStudent>> _tmp2 = new SortingMap(tmstudents).doSort("getMembrId");
    for (int i=0; vc!=null&&i<vc.size()&&tags.size()>0; i++) {
        ChargeItemMembr ci = vc.get(i);
        if (_tmp2.get(new Integer(ci.getMembrId()))==null) {
%>
        <tr bgcolor=ffffff class=es02>
            <Td>
                <%=ci.getMembrName()%>
            </td>
            <td valign=top>
                <br>
                狀態:已加入
            </td>
            <td valign=top>
                <br>
                狀態:<font color=blue>不屬於任何標籤</font>
<%
            Iterator<Tag> iter3 = tags.iterator();
            while (iter3.hasNext()) {
                Tag t = iter3.next();
        
              out.println("<br>　　<a href='sync_charge_tag2.jsp?cid="+ci.getChargeItemId()+"&tid="+t.getId()+"&mid="+ci.getMembrId()+"'  onclick=\"if (confirm('確定加入["+t.getName()+"]？')) {return true;} else {return false;}\"><img src='pic/add.gif' border=0 width=12>&nbsp;加入["+t.getName()+"]</a>");

            }
%>
            </td>
        </tR>
<%
        }
    }
%>
    </table>
    </td>
    </tR>
    </table>        
    </blockquote>
</blockquote>