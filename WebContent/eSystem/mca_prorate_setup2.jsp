<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String ticketId = request.getParameter("tid");
    MembrInfoBillRecord sinfo = MembrInfoBillRecordMgr.getInstance().find("ticketId='" + ticketId + "'");
    McaRecord mfr = McaRecordInfoMgr.getInstance().find("billRecordId=" + sinfo.getBillRecordId() + 
        " and mca_fee.status!=-1");
    McaProrateMgr mpmgr = McaProrateMgr.getInstance();
    McaProrate mp = mpmgr.find("mcaFeeId=" + mfr.getMcaFeeId() + 
        " and membrId=" + sinfo.getMembrId());
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date d = sdf.parse(request.getParameter("prorateDate"));

    if (mp!=null) {
        mp.setProrateDate(d);
        mpmgr.save(mp);
    }
    else {
        mp = new McaProrate();
        mp.setMcaFeeId(mfr.getMcaFeeId());
        mp.setMembrId(sinfo.getMembrId());
        mp.setProrateDate(d);
        mp.setBunitId(sinfo.getBunitId());
        mpmgr.create(mp);
    }
%>
<blockquote>
    done!
    <br>
    <br>
    帳單要等下次 generate bill 才會更新!
</blockquote>
<script>
    parent.do_reload = true;
</script>

