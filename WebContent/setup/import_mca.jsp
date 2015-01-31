<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.lang.reflect.*,phm.importing.*,mca.*" 
    contentType="text/html;charset=UTF-8"%>
<%          
    String data = request.getParameter("data");
    int oldS = 0;
    int newS = 0;

    McaStudent ms = new McaStudent();
    Class c = ms.getClass();
    Method[] methods = c.getDeclaredMethods();
    Map<String, Method> methodMap = new SortingMap(methods).doSortSingleton("getName");


    boolean commit = false;
    int tran_id = dbo.Manager.startTransaction();
    try {     
        McaStudentMgr msmgr = new McaStudentMgr(tran_id);
        McaService mcasvc = new McaService(tran_id);

        String[] lines = data.split("\n");
        Map<Integer, String> headerMap = new HashMap<Integer, String>();
        Object[] params = new Object[1];

        for (int i=0; i<lines.length; i++) {
            if (lines[i].trim().length()==0)
                continue;
            String[] tokens = lines[i].split("\t");
            if (i==1) 
                continue;
            else if (i==0) {
                for (int j=0; j<tokens.length; j++)
                    headerMap.put(j, tokens[j]);
            }
            else {
                ms = new McaStudent();
                for (int j=0; j<tokens.length; j++) {
                    String colname = headerMap.get(j).trim();
                    if (colname==null || colname.length()==0)
                        continue;
                    // out.println("[" + colname + "]="+tokens[j] + "<br>");
                    if (colname.equals("StudentID")) {
                        int sid = Integer.parseInt(tokens[j]);
                        if (msmgr.numOfRows("StudentID=" + sid)>0)
                            throw new Exception("StudentID not unique!");
                        ms.setStudentID(sid);
                    }
                    else if (colname.equals("TDisc")) {
                        double tdisc = Double.parseDouble(tokens[j]);
                        ms.setTDisc(tdisc);
                    }
                    else if (colname.equals("MDisc")) {
                        double tdisc = Double.parseDouble(tokens[j]);
                        ms.setMDisc(tdisc);
                    }
                    else {
                        String methodName = "set" + colname;
                        Method m = methodMap.get(methodName);
                        if (colname.equals("StudentFirstName") || colname.equals("StudentSurname"))
                            tokens[j] = tokens[j].toLowerCase();
                        params[0] = tokens[j];
                        Object ret = m.invoke(ms, params);
                    }
                }
                msmgr.create(ms);
                ArrayList<McaStudent> tmp = new ArrayList<McaStudent>();
                tmp.add(ms);
                mcasvc.updateStudents(tmp);
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