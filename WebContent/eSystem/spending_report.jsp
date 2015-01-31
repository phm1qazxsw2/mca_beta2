<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.*,java.io.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=10;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu10.jsp"%>
<%
    //##v2
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");

    Calendar c = Calendar.getInstance();
    c.add(Calendar.MONTH, -1);
    Date start = c.getTime();
    try { start = sdf.parse(request.getParameter("start")); } catch (Exception e) {}

    c.setTime(start);
    c.add(Calendar.MONTH, 1);
    Date end = c.getTime();
    try { end = sdf.parse(request.getParameter("end")); } catch (Exception e) {}

%>
<br>
<br>
<blockquote>
<form action="spending_report.jsp">
<input type=text name="start" value="<%=sdf2.format(start)%>" size=7>
<input type=text name="end" value="<%=sdf2.format(end)%>" size=7>
<input type=submit>
</form>
<%
    
    Reporting r = new Reporting(_ws.getSessionBunitId(), start, end);
        
    out.println("雜費收入=" + r.getIncomeTotal() + "<br>");
    out.println("雜費已收=" + r.getIncomeReceived() + "<br>");
    out.println("雜費支出=" + r.getSpendingTotal() + "<br>");
    out.println("雜費已付=" + r.getSpendingPaid() + "<br>");
    out.println("學費收入=" + r.getRevenueTotal() + "<br>");
    out.println("學費已收=" + r.getRevenueReceived() + "<br>");
    out.println("薪資支出=" + r.getSalaryTotal() + "<br>");
    out.println("薪資已付=" + r.getSalaryPaid() + "<br>");

//##### start 收入

    Map<IncomeSmallItem, Integer> revenueDetails = r.getRevenueDetails();
    out.println("<br>## 學費收入 ###<br>");
    Iterator<IncomeSmallItem> iter =  revenueDetails.keySet().iterator();
    while (iter.hasNext()) {
        IncomeSmallItem isi = iter.next();
        Integer v = revenueDetails.get(isi);
        out.println(isi.getIncomeSmallItemName() + ":" + v.intValue() + "<br>");
    }

    out.println("<br>## 雜費收入 ###<br>");
    Map<String/*acctcode*/, Vector<Vitem>> vitemMap = r.getIncomeDetails();
    Object[] objs1 = BigItemMgr.getInstance().retrieve("", "");
    Object[] objs2 = SmallItemMgr.getInstance().retrieve("", "");
    Map<String, Vector<BigItem>> bigitemMap 
            = new SortingMap().doSort(objs1, new ArrayList<BigItem>(), "getAcctCode");
    Map<Integer, Vector<SmallItem>> smallitemMap 
            = new SortingMap().doSort(objs2, new ArrayList<SmallItem>(), "getSmallItemBigItemId");
    for (int i=0; objs1!=null && i<objs1.length; i++) {
        BigItem b = (BigItem) objs1[i];
        Vector<Vitem> vv = vitemMap.get(b.getAcctCode());
        vitemMap.remove(b.getAcctCode());
        int n = 0;
        for (int k=0; vv!=null && k<vv.size(); k++)
            n += vv.get(k).getTotal();
        if (n>0)
            out.println("c"+ b.getAcctCode() + " " + b.getBigItemName() + ":" + n + "<br>");

        Vector<SmallItem> vs = smallitemMap.get(new Integer(b.getId()));
        for (int j=0; vs!=null&&j<vs.size(); j++) {
            String acctCode = b.getAcctCode();
            SmallItem si = vs.get(j);
            acctCode += si.getAcctCode();
            vv = vitemMap.get(acctCode);
            vitemMap.remove(acctCode); // 移掉這項
            n = 0;
            for (int k=0; vv!=null && k<vv.size(); k++)
                n += vv.get(k).getTotal();
            if (n>0)
                out.println(acctCode + " " + b.getBigItemName() + "-" + si.getSmallItemName() + ":" + n + "<br>");
        }
    }
    Iterator<String> iter2 = vitemMap.keySet().iterator();
    while (iter2.hasNext()) {
        String acctCode = iter2.next();
        BigItem b = null;
        Vector<BigItem> vb = bigitemMap.get(acctCode);
        if (vb!=null)
            b = vb.get(0);
        Vector<Vitem> vv = vitemMap.get(acctCode);
        int n = 0;
        for (int k=0; k<vv.size(); k++)
            n += vv.get(k).getTotal();
        if (n>0)
            out.println(acctCode + " " + ((b!=null)?b.getBigItemName():"") + "-其它:" + n + "<br>");
    }

    out.println("<br>## 薪資支出 ###<br>");
    Map<String, Integer> salaryDetails = r.getSalaryDetails();
    Iterator<String> iter3 = salaryDetails.keySet().iterator();
    while (iter3.hasNext()) {
        String name = iter3.next();
        Integer v = salaryDetails.get(name);
        out.println(name + ":" + v.intValue() + "<br>");
    }

System.out.println("## xx");
    out.println("<br>## 雜費支出 ###<br>");
    Map<String/*acctcode*/, Vector<Vitem>> vitemMap2 = r.getCostDetails();
    for (int i=0; objs1!=null && i<objs1.length; i++) {
        BigItem b = (BigItem) objs1[i];
        Vector<Vitem> vv = vitemMap2.get(b.getAcctCode());
        vitemMap2.remove(b.getAcctCode());
        int n = 0;
        for (int k=0; vv!=null && k<vv.size(); k++)
            n += vv.get(k).getTotal();
        if (n>0)
            out.println("c"+ b.getAcctCode() + " " + b.getBigItemName() + ":" + n + "<br>");

        Vector<SmallItem> vs = smallitemMap.get(new Integer(b.getId()));
        for (int j=0; vs!=null&&j<vs.size(); j++) {
            String acctCode = b.getAcctCode();
            SmallItem si = vs.get(j);
            acctCode += si.getAcctCode();
            vv = vitemMap2.get(acctCode);
            vitemMap2.remove(acctCode); // 移掉這項
            n = 0;
            for (int k=0; vv!=null && k<vv.size(); k++)
                n += vv.get(k).getTotal();
            if (n>0)
                out.println("a"+acctCode + " " + b.getBigItemName() + "-" + si.getSmallItemName() + ":" + n + "<br>");
        }
    }

    iter2 = vitemMap2.keySet().iterator();
    while (iter2.hasNext()) {
        String acctCode = iter2.next();
        BigItem b = null;
        Vector<BigItem> vb = bigitemMap.get(acctCode);
        if (vb!=null)
            b = vb.get(0);
        Vector<Vitem> vv = vitemMap2.get(acctCode);
        int n = 0;
        for (int k=0; k<vv.size(); k++) {
            n += vv.get(k).getTotal();
            System.out.println("          " + vv.get(k).getTitle());
        }
        if (n>0)
            out.println(acctCode + " " + ((b!=null)?b.getBigItemName():"") + "-其它: " + n + "<br>");
    }
%>
</blockquote>