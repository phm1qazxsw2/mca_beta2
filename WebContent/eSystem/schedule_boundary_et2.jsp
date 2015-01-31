<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdffull = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdffull2 = new SimpleDateFormat("MM/dd HH:mm");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");

    String r=request.getParameter("r");
    Date date = sdf.parse(request.getParameter("date"));
    int mid = Integer.parseInt(request.getParameter("mid"));
    Calendar c = Calendar.getInstance();
    c.setTime(date);
    c.add(Calendar.DATE, 1);
    Date d2 = c.getTime();

//System.out.println("### 1 ###  d1="+sdf.format(date)+" - d2="+sdf.format(d2));


    Membr membr = MembrMgr.getInstance().find("id=" + mid);

    SchInfo info = SchInfo.getSchInfo(membr, date, d2);
    Map<Integer, Vector> boundMap = info.getBoundaryVector(date);

/*
    if(boundMap==null || boundMap.size()<=0){

        System.out.println("### 3 ### nothing");
    }
*/

    Iterator<Integer> iter = boundMap.keySet().iterator();
    while (iter.hasNext()) {
        Integer inx = iter.next();
        Vector v= boundMap.get(inx);
        SchDef sd=(SchDef)v.get(0);
        Date xx1=(Date)v.get(1);
        Date xx2=(Date)v.get(2);
System.out.println("## 4");
        Calendar c2=Calendar.getInstance();
        c2.setTime(date);
        c2.add(Calendar.DATE,1);
        Date nextDate=c2.getTime();

        ArrayList<SchEvent> schevents = SchEventMgr.getInstance().retrieveList("startTime>='" + sdf.format(date) + "' and startTime<'" + sdf.format(nextDate) + "' and membrId='"+mid+"' and    schdefId='"+sd.getId()+"'", " order by startTime");


System.out.println("startTime>='" + sdf.format(date) + "' and startTime<'" + sdf.format(nextDate) + "' and membrId='"+mid+"' and    schdefId='"+sd.getId()+"'");

        Vector rVector=new Vector();
        Vector v3=new Vector();
        for(int i=0;schevents !=null && i<schevents.size();i++){
            v3.add((SchEvent)schevents.get(i));
        }
        String[] defaultDate={"00:00","00:00"};
        StringBuffer sb=new StringBuffer();        
        boolean vResult=SchEventInfo.calcEvent(xx1,xx2,v3,rVector);
        boolean canChecked=false;
        sch_content s_c=info.getSchContent(date,sd.getId());
        int offmins=0;
        //if(s_c.offtime !=0)
        //    offmins=s_c.offtime;

        if(vResult){
            sb.append("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;可請假時段: ");
            if(rVector !=null && rVector.size()>0){
                for(int j=0;j<rVector.size();j++){
                    Date[] aaa=(Date[])rVector.get(j);
                    sb.append((j+1)+".<font color=blue>"+sdftime.format(aaa[0])+"-"+sdftime.format(aaa[1])+"</font> ");
                    defaultDate[0]=sdftime.format(aaa[0]);
                    defaultDate[1]=sdftime.format(aaa[1]);
                    canChecked=true;
                }
            }
        }else{
            sb.append("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;沒有可請假時段: ");
        }
        String runRunS="0";
        if(canChecked)
            runRunS="1";

        out.println(sd.getId()+",<b>"+sd.getName()+"</b>&nbsp;("+sdffull2.format(xx1)+"-"+sdftime.format(xx2)+")"+sb.toString()+","+defaultDate[0]+","+defaultDate[1]+","+defaultDate[0]+defaultDate[1]+","+runRunS+","+offmins);
    }
%>
