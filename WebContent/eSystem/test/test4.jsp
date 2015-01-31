<%@ page language="java" 
    import="phm.ezcounting.*,java.util.*,java.text.*"
    contentType="text/html;charset=UTF-8"%>
<%
    CardMembrMgr cmm=CardMembrMgr.getInstance();

    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");    
    Date d=sdf.parse("2008/11/10");
  
    CardMembr cm=(CardMembr)cmm.find("id="+1);

    cm.setCardId("10");
//    cm.setCreated(d);
    cmm.save(cm);

/*
    ArrayList<CardMembr> cma=cmm.retrieveList("","");
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");    
    Date d=sdf.parse("2008/11/21");
    for(int i=0;i<cma.size();i++){
        CardMembr cm=(CardMembr)cma.get(i);
        cm.setCreated(d);
        cmm.save(cm);
    }
*/
/*
    BillRecord br = (BillRecord) ObjectService.find("phm.ezcounting.BillRecord", "id=16");
    System.out.println(br.getName());
    jsf.Student st = (jsf.Student) ObjectService.find("jsf.Student", "id=3");
    out.println("studentName=" + st.getStudentName());

    out.println("<br>");
    BillRecordMgr bmgr = BillRecordMgr.getInstance();
    ArrayList<BillRecord> rs = bmgr.retrieveList("","");
    Iterator<BillRecord> iter = rs.iterator();
    while (iter.hasNext())
        System.out.println(iter.next().getName());
    out.println("## rs.length=" + rs.size());
    BillRecord b = bmgr.find("id=16");
    System.out.println("## b=" + b);
  
*/
  //BillRecord b = BillRecordMgr.getInstance().test();
%>
done