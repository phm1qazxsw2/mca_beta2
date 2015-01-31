<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    Date end = sdf.parse(request.getParameter("e"));
    Date start = sdf.parse(request.getParameter("s"));
    Calendar cal = Calendar.getInstance();
    cal.setTime(end);
    cal.add(Calendar.DATE, 1);
    Date nextEndDay = cal.getTime();

    String q = "registerDate>='" + sdf.format(start) + "' and registerDate<'" + sdf.format(nextEndDay) + "'";
    q += " and vchr_holder.type=" + VchrHolder.TYPE_INSTANCE;

    String title = "入帳區間 " + sdf.format(start) + "-" + sdf.format(nextEndDay);

    String srctype = request.getParameter("t");
    if (srctype!=null && srctype.trim().length()>0) {
        q += " and vchr_thread.srcType in (" + srctype.trim() + ")";
        title += "#類型:" + VchrThread.getSrcTypeName(srctype, ',');
    }
    else {
        title += "#類型: 全部";
    }
        
    /*
    String b = request.getParameter("b");
    if (b!=null&&b.length()>0) {
        q += " and bunitId=" + b;
        Bunit bu = BunitMgr.getInstance().find("id=" + b);
        title += "#部門:" + bu.getLabel();
    }
    else {
        title += "#部門: 全部";
    }
    */

    String p = request.getParameter("p");
        
    boolean full_mode = request.getParameter("f").equals("true");
    if (full_mode) 
        title += "#顯示原始借貸";
    boolean show_main_only = request.getParameter("m").equals("main");
System.out.println("## show_main_only=" + show_main_only);
    title += (show_main_only)?"#只顯示主科目":"#顯示次科目";

    //String spec = (show_main_only)?"group by acode.main order by acode.main":"group by acode.id order by acode.main,acode.sub";
    String spec = (show_main_only)?"group by acode.main order by acode.main":"group by fullkey order by fullkey";
%>
