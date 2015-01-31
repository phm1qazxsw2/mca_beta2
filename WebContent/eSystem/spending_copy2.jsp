<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>
<%
    String[] ids = request.getParameterValues("id");
    StringBuffer sb = new StringBuffer();
    for (int i=0; i<ids.length; i++) {
        if (i>0) sb.append(",");
        sb.append(ids[i]);
    }
    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        VoucherMgr vchrmgr = new VoucherMgr(tran_id);
        VitemMgr vimgr = new VitemMgr(tran_id);

        ArrayList<Vitem> vitems = vimgr.retrieveList("id in (" + sb.toString() + ")", "");
        Voucher vchr = null;
        if (vitems.size()>1) {
            vchr = new Voucher();
            vchrmgr.create(vchr);
        }

        Iterator<Vitem> iter = vitems.iterator();
        Vitem new_vi = null;
        Date voucherDate = null;
        while (iter.hasNext()) {
            Vitem vi = iter.next();
            int id = vi.getId();
            Date recordTime = sdf.parse(request.getParameter(id + "_recordTime"));
            if (voucherDate==null)
                voucherDate = recordTime;
            String title = request.getParameter(id + "_title");
            int total = Integer.parseInt(request.getParameter(id + "_total"));
            String note = request.getParameter(id+ "_note");
            int attachtype = Integer.parseInt(request.getParameter(id+"_attachtype"));

            new_vi = new Vitem();
            new_vi.setCreateTime(new Date());
            new_vi.setRecordTime(recordTime);
            new_vi.setTitle(title);
            new_vi.setTotal(total);
            new_vi.setUserId(ud2.getId());
            new_vi.setType(vi.getType());
            new_vi.setAcctcode(vi.getAcctcode());
            new_vi.setAttachtype(attachtype);
            if (vchr!=null)
                new_vi.setVoucherId(vchr.getId());
            new_vi.setBunitId(_ws2.getSessionBunitId());
            vimgr.create(new_vi);
        }

        if (vitems.size()>1) {
            JsfTool jt = JsfTool.getInstance();
            String next_id = jt.generateCostcheck(voucherDate);
            vchr.setCostbookId(next_id);
            vchrmgr.save(vchr);
        }

        dbo.Manager.commit(tran_id);
        commit = true;
        String gotourl = "spending_voucher.jsp?id=";
        if (vchr!=null)
            gotourl += "V" + vchr.getId();
        else
            gotourl += "I" + new_vi.getId();

        response.sendRedirect(gotourl);
    }
    catch (Exception e) {
          e.printStackTrace();
          %><script>alert("發生錯誤");history.go(-1);</script><%
              return;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>

