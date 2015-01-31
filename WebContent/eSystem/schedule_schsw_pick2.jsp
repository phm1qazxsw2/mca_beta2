<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String swstr = request.getParameter("sw");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    Date month = sdf.parse(request.getParameter("month"));
    Calendar c = Calendar.getInstance();
    c.setTime(month);
    String[] data = swstr.split(",");
    int membrId1 = Integer.parseInt(request.getParameter("membrId1"));
    int membrId2 = Integer.parseInt(request.getParameter("membrId2"));

    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        SchswMgr swmgr = new SchswMgr(tran_id);
        SchswRecordMgr srmgr = new SchswRecordMgr(tran_id);

        Schsw sw = new Schsw();
        sw.setRecordTime(new Date());
        sw.setUserId(ud2.getId());
        sw.setNote(request.getParameter("note"));
        sw.setReqMembrId(membrId1);
        swmgr.create(sw);

        for (int i=0; i<data.length; i++) {

            String[] tokens = data[i].split("_");
            boolean greenToRed = (Integer.parseInt(tokens[0])==0);
            int schdefId = Integer.parseInt(tokens[1]);
            int dayOfMonth = Integer.parseInt(tokens[2]);
            
            SchswRecord r = new SchswRecord();
            r.setSchswId(sw.getId());
            c.set(Calendar.DAY_OF_MONTH, dayOfMonth);
            r.setOccurDate(c.getTime());
            r.setSchdefId(schdefId);
            if (greenToRed) {
                r.setType(SchswRecord.TYPE_OFF);
                r.setMembrId(membrId1);
                srmgr.create(r);
                r.setType(SchswRecord.TYPE_ON);
                r.setMembrId(membrId2);
                srmgr.create(r);
            }
            else {
                r.setType(SchswRecord.TYPE_OFF);
                r.setMembrId(membrId2);
                srmgr.create(r);
                r.setType(SchswRecord.TYPE_ON);
                r.setMembrId(membrId1);
                srmgr.create(r);
            }
        }
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null && e.getMessage().indexOf("Duplicate")>=0) {
          %><script>alert('請選擇不同天或同一天的不同班對換');history.go(-1);</script><%
              return;
        }
        else if (e.getMessage()!=null) {
          %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
              return;
        } else { 
            e.printStackTrace();
          %><script>alert("發生問題，修改沒有存入");history.go(-1);</script><%
              return;
        }          
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
<blockquote>
    新增換班記錄成功!
</blockquote>

<script>
    parent.do_reload = true;
</script>
