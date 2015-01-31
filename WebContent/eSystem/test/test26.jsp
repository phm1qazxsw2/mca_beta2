<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%!
    String drawAreaSelect(String code, ArrayList<Area> areas, String fieldName)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<select name="+fieldName+">");
        sb.append("<option value=''>");
        for (int i=0; i<areas.size(); i++) {
            Area a = areas.get(i);
            String str = "";
            if (a.getEName().length()>0) {
                str = a.getEName();
                if (a.getCName().length()>0) {
                    str += " (" + a.getCName() + ")";
                }
            }
            sb.append("<option value='"+a.getCode()+"' "+((a.getCode().equals(code))?"selected":"")+">" + str);
        }
        sb.append("</select>");
        return sb.toString();
    }
%>
<%
    ArrayList<McaStudent> students = McaStudentMgr.getInstance().retrieveList("", "");
    AreaMgr amgr = AreaMgr.getInstance();
    McaStudentMgr msmgr = McaStudentMgr.getInstance();
    for (int i=0; i<students.size(); i++) {
        McaStudent s = students.get(i);
        String country = s.getPassportCountry();
        try {
            int tmp = Integer.parseInt(country.trim());
            Area a = amgr.find("level=0 and code=" + tmp);
            s.setPassportCountry(a.getEName());
            msmgr.save(s);
            // System.out.println(s.getStudentFirstName() + ":" + a.getEName());
        }
        catch (Exception e) {

        }
    }
%>