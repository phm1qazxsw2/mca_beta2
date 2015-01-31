<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    class FeeChecker
    {
        Map<Integer, ArrayList<CitemTag>> feetagMap = null;
        Map<Integer, ArrayList<TagMembr>> membrtagMap = null;
        int membrId;

        FeeChecker(ArrayList<McaFee> fees, int membrId) 
            throws Exception
        {
            String feeIds = new RangeMaker().makeRange(fees, "getId");
            ArrayList<CitemTag> citemtags = CitemTagMgr.getInstance().retrieveList("chargeItemId in (" + feeIds + ")", "");
            feetagMap = new SortingMap(citemtags).doSortA("getChargeItemId");
            this.membrId = membrId;
            ArrayList<TagMembr> tms = TagMembrMgr.getInstance().retrieveList("membrId=" + membrId, "");
            membrtagMap = new SortingMap(tms).doSortA("getTagId");
        }

        boolean hasRecord(int feeId)
            throws Exception
        {
            ArrayList<CitemTag> citemtags = feetagMap.get(feeId);
            for (int i=0; i<citemtags.size(); i++) {
                int tagId = citemtags.get(i).getTagId();
                if (membrtagMap.get(tagId)!=null)
                    return true;
            }
            return false;
        }
    }
%>
<%
    Membr m = MembrMgr.getInstance().find("id=" + request.getParameter("mid"));
    ArrayList<McaFee> fees = McaFeeMgr.getInstance().retrieveList("status=" + McaFee.STATUS_ACTIVE, "order by id desc");
    FeeChecker fc = new FeeChecker(fees, m.getId());
%>
<script>
function do_check(f)
{
    var s = f.feeId;
    if (s.options[s.selectedIndex].value==0) {
        alert("Please select a fee");
        return false;
    }
    else if (s.options[s.selectedIndex].value==-1) {
        alert("Please select a fee the student is not in");
        return false;
    }
    return true;
}
</script>

<blockquote>
<form action="mca_addsingle2.jsp" method=get onsubmit="return do_check(this)">
<input type=hidden name="mid" value="<%=m.getId()%>">
Please select a fee to add to
<br>
<select name="feeId">
<option value="0"> ---- select one below ----
<%
    for (int i=0; i<fees.size(); i++) {
        McaFee fee = fees.get(i);
        boolean alreadyIn = fc.hasRecord(fee.getId());
    %><option value="<%=(alreadyIn)?-1:fee.getId()%>"><%=fee.getTitle()%><%=(alreadyIn)?"(已加入)":""%><%
    }
%>
</select>
<br>
<input type=submit value="&nbsp;Next&nbsp;">
</form>
</blockquote>
