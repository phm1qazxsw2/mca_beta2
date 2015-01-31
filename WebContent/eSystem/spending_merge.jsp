<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">

<%
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
    String[] ids = request.getParameterValues("id");
    // ids = I2, I7, V2, I4, I9...
    StringBuffer sb = new StringBuffer();
    int vchrId = 0;
    boolean commit = false;
    int tran_id = 0;
    Voucher vchr = null;
    try {
        tran_id = dbo.Manager.startTransaction();
        for (int i=0; i<ids.length; i++) {
            if (ids[i].charAt(0)=='V') {
                if (vchrId!=0)
                    throw new Exception("a");
                vchrId = Integer.parseInt(ids[i].substring(1));
                continue;
            }
            if (sb.length()>0) sb.append(",");
            sb.append(ids[i].substring(1));
        }
        
        VoucherMgr vchrmgr = new VoucherMgr(tran_id);
        VitemMgr vimgr = new VitemMgr(tran_id);

        boolean new_create = false;
        if (vchrId==0) {
            vchr = new Voucher();
            vchrmgr.create(vchr);
            new_create = true;
        }
        else {
            vchr = vchrmgr.find("id=" + vchrId);
        }
        if (sb.length()==0)
            throw new Exception("d");

        ArrayList<Vitem> vitems = vimgr.retrieveList("id in (" + sb.toString() + ")", "order by recordTime asc");
        ArrayList<Vitem> tmp = vimgr.retrieveList("voucherId=" + vchr.getId(), "");
        int prevtype = -1;
        int mon = -1;
        if (tmp.size()>0) {
            prevtype = tmp.get(0).getType();
            mon = tmp.get(0).getRecordTime().getMonth();
        }

        Iterator<Vitem> iter = vitems.iterator();
        while (iter.hasNext()) {
            Vitem vi = iter.next();
            if (vi.getVoucherId()!=0)
                throw new Exception("a");
            vi.setVoucherId(vchr.getId());
            vimgr.save(vi);

            if (prevtype>=0 && prevtype!=vi.getType())
                throw new Exception("b");
            if (mon>=0 && mon!=vi.getRecordTime().getMonth())
                throw new Exception("e");
            prevtype = vi.getType();
            mon = vi.getRecordTime().getMonth();
        }

        if (new_create) {
            Date d = vitems.get(0).getRecordTime();
            JsfTool jt = JsfTool.getInstance();
            String next_id = jt.generateCostcheck(d);
            vchr.setCostbookId(next_id);
            vchrmgr.save(vchr);
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("a")) {
          %><script>alert("不可合倂兩個已經合倂的項目");history.go(-1);</script><%
              return;
        }
        else if (e.getMessage()!=null&&e.getMessage().equals("b")) {
          %><script>alert("收入支出不可合倂");history.go(-1);</script><%
              return;
        }
        else if (e.getMessage()!=null&&e.getMessage().equals("d")) {
          %><script>alert("沒有指定加入合倂的項目");history.go(-1);</script><%
              return;
        }
        else if (e.getMessage()!=null&&e.getMessage().equals("e")) {
          %><script>alert("不能合倂不同月份的項目");history.go(-1);</script><%
              return;
        }
        else {
          %><script>alert("發生錯誤");history.go(-1);</script><%
              return;
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
    
   String backtype=request.getParameter("backtype");

    if(backtype ==null){
        response.sendRedirect(request.getParameter("backurl"));
    }else{
        
        if (commit){ 
            response.sendRedirect("spending_voucher.jsp?id=V"+vchr.getId());            
        }else{  
            response.sendRedirect(request.getParameter("backurl"));
        }
    }
%>
