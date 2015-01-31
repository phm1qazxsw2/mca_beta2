<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdffull = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdffull2 = new SimpleDateFormat("MM/dd HH:mm");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");

    String r=request.getParameter("r");
    Date date = sdf.parse(request.getParameter("date"));
    Date date2 = sdf.parse(request.getParameter("date2"));
    int mid = Integer.parseInt(request.getParameter("mid"));

    Membr membr = MembrMgr.getInstance().find("id=" + mid);
    SchInfo info = SchInfo.getSchInfo(membr, date, date2);

    long oneday=(long)(1000*60*60*24);
    long duringLong2=date2.getTime()-date.getTime();
    if(duringLong2 <0)
        return;

    int duringDate=(int)(duringLong2/oneday);
    duringDate++;

    for(int k=0;k<duringDate;k++){

        Calendar c = Calendar.getInstance();
        c.setTime(date);
        c.add(Calendar.DATE,k);
        Date rundate = c.getTime();

        Map<Integer, Vector> boundMap = info.getBoundaryVector(rundate);        
        Iterator<Integer> iter = boundMap.keySet().iterator();
        while (iter.hasNext()) {
            Integer inx = iter.next();
            Vector v= boundMap.get(inx);
            SchDef sd=(SchDef)v.get(0);
            Date xx1=(Date)v.get(1);
            Date xx2=(Date)v.get(2);

            Calendar c2=Calendar.getInstance();
            c2.setTime(rundate);
            c2.add(Calendar.DATE,1);
            Date nextDate=c2.getTime();

            ArrayList<SchEvent> schevents = SchEventMgr.getInstance().retrieveList("startTime>='" + sdf.format(rundate) + "' and startTime<'" + sdf.format(nextDate) + "' and membrId='"+mid+"' and    schdefId='"+sd.getId()+"'", " order by startTime");



            Vector rVector=new Vector();
            Vector v3=new Vector();
            for(int i=0;i<schevents.size();i++){

                SchEvent se=(SchEvent)schevents.get(i);
                System.out.println(sd.getName()+","+sdffull.format(se.getStartTime())+","+sdffull.format(se.getEndTime()));

                v3.add((SchEvent)schevents.get(i));
            }
            String[] defaultDate={"00:00","00:00"};
            StringBuffer sb=new StringBuffer();        
            boolean vResult=SchEventInfo.calcEvent(xx1,xx2,v3,rVector);
            boolean canChecked=false;

            sch_content s_c=info.getSchContent(date,sd.getId());
            int offmins=0;
            //int offmins=s_c.offtime;
            
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

            out.println(sd.getId()+"#"+sdf.format(xx1)+",<b>"+sd.getName()+"</b>&nbsp;("+sdffull2.format(xx1)+"-"+sdftime.format(xx2)+")"+sb.toString()+","+defaultDate[0]+","+defaultDate[1]+","+defaultDate[0]+defaultDate[1]+","+runRunS+","+offmins);
        }
    }
%>
