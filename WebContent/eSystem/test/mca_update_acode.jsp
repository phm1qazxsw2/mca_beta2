<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%!
    public static String getAcodeDescription(McaAuthorizer a) 
    {
        StringBuffer sb = new StringBuffer();
        sb.append(a.getAccount_Name());
        if (a.getDescription1().length()>0) {
            sb.append(",");
            sb.append(a.getDescription1());
        }
        if (a.getDescription2().length()>0) {
            sb.append(",");
            sb.append(a.getDescription2());
        }
        return phm.util.TextUtil.escapeJSString(sb.toString());
    }
%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        McaAuthorizerMgr aumgr = McaAuthorizerMgr.getInstance();
        aumgr.setDataSourceName("mssql");

        LiteralStore store = new LiteralStore(tran_id, "literal", null);
        ArrayList<Acode> acodes = new AcodeMgr(tran_id).retrieveList("active=1", "");
        for (int i=0; i<acodes.size(); i++) {
            Acode a = acodes.get(i);
            if (a.getMain().length()>4) {
                if (a.getSub()!=null && a.getSub().length()>0) {
                    String q = "Account_Number='" + a.getMain() + "' and Sub_Account='" + a.getSub() + "'";
                    McaAuthorizer au = aumgr.find(q);
                    if (au==null) {
                        out.println(a.getMain() + "-" + a.getSub() + " null<br>");
                        store.save(a.getName1(), "##");
                        continue;
                    }
                    String fullName = getAcodeDescription(au);
                    store.save(a.getName1(), fullName);
                    out.println(a.getMain() + "-" + a.getSub() + " " + fullName + "<br>");
                }
                else {
                    store.save(a.getName1(), "");
                }
            }
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>done!