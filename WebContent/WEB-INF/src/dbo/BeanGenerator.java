package dbo;

import java.io.*;
import java.util.*;

public class BeanGenerator
{
    public BeanGenerator()
    { }

    public static void generate(LineNumberReader in, File outdir)
        throws IOException
    {
        String prefix = "";
        String suffix = "";
        
        String line;
        while ((line=in.readLine())!=null)
        {
            if (line.length()>0 && line.charAt(0)=='=')
                break;
            prefix += line;
            prefix += "\r\n"; //temp fix on NT.
        }
        
        // retrive the bean name
        String[] strs = line.substring(1).split(",");
        String clsname = strs[0];
        String tblname = null;
        
        if (strs.length>1)
            tblname = strs[1];        
        String joinspace = null;
        if (strs.length>2)      
            joinspace = strs[2];      
        String extclsname = null;       
        if (strs.length>3)
            extclsname = strs[3];
        String fieldlist = null;
        if (strs.length>4)
            fieldlist = strs[4];
        
        File beanfile = new File(outdir, clsname+".java");
        System.out.println("Generating " + beanfile.getAbsolutePath());
        
        PrintWriter pout = 
            new PrintWriter(new OutputStreamWriter(new FileOutputStream(beanfile), "UTF-8"));
        
        pout.println(prefix);
        
        pout.println("import java.util.*;");
        pout.println("import java.sql.*;");
        pout.println("import java.util.Date;");
        // pout.println("import com.axiom.util.*;");
        pout.println("");
        pout.println("");
        
        pout.print("public class " + clsname);
        if (extclsname!=null && extclsname.length()>0)
            pout.print(" extends " + extclsname);
        pout.println("");
        pout.println("{");
       
        ArrayList types = new ArrayList();
        ArrayList names = new ArrayList();
        ArrayList keys = new ArrayList();
        ArrayList ljoins = new ArrayList();

        while ((line=in.readLine())!=null)
        {
            if (line.length()==0)
                continue;
            if (line.charAt(0)=='@')
            {
                String[] parts = line.substring(1).split(",");
                String[] lj_tables = parts[0].split("-");
                StringBuffer sb = new StringBuffer("");
                sb.append("(");
                for (int i=0; i<lj_tables.length; i++) {
                    if (i>0)
                        sb.append(",");
                    sb.append(lj_tables[i]);
                }
                sb.append(")");
                parts[0] = sb.toString();
                ljoins.add(parts);
            }
            else if (line.charAt(0)=='=')
            {
                break;   
            }
            else
            {
                StringTokenizer st = new StringTokenizer(line);
                types.add(st.nextToken());
                String n = st.nextToken();
                names.add(n);
                if (n.indexOf("#")>=0)
                {
                    n = getOnlyName(n);
                    keys.add(n);
                }
            }
        }
        
        while ((line=in.readLine())!=null)
        {
            suffix += line;
            suffix += "\r\n";
        }
        
        // generate the member data
        pout.println("");

        Iterator t_iter = types.iterator();
        Iterator n_iter = names.iterator();
        while (t_iter.hasNext())
        {
            String type = (String) t_iter.next();
            String name = (String) n_iter.next();
            if (name.charAt(0)=='-') // extended, no need to declare
                continue; 
            pout.println("    private " + type + "   \t" + getMemberName(getOnlyName(name)) + ";");
        }

        pout.println("");
        pout.println("");
        pout.println("    public " + clsname + "() {}");
        
        /*
        // generate the init function
        pout.println("");
        pout.println("");
        pout.println("    public void init");
        pout.println("    (");

        t_iter = types.iterator();
        n_iter = names.iterator();
        boolean begin = true;
        while (t_iter.hasNext())
        {
            if (!begin) {
                pout.println(",");
            }
            else
                begin = false;

            String type = (String) t_iter.next();
            String name = getOnlyName((String) n_iter.next());
            pout.print("        " + type + "\t" + name);
        }
        pout.println("    )");
        pout.println("    {");
        t_iter = types.iterator();
        n_iter = names.iterator();
        while (t_iter.hasNext())
        {
            String type = (String) t_iter.next();
            String name = getOnlyName((String) n_iter.next());
            pout.println("        this." + name + " \t = " + name + ";");
        }
        pout.println("    }");
        */

        // generate the getter 
        pout.println("");
        pout.println("");

        t_iter = types.iterator();
        n_iter = names.iterator();
        while (t_iter.hasNext())
        {
            String type = (String) t_iter.next();
            String _name = (String) n_iter.next();
            if (_name.charAt(0)=='-') // extended
                continue;
            String name = getOnlyName(_name);
            String fixname =getMemberName(name);
            String func = (fixname.charAt(0)+"").toUpperCase() + fixname.substring(1);
            pout.println("    public " + type + "   \tget" + func  + "   \t() { return " + fixname + "; }");
        }

        // generate the setter 
        pout.println("");
        pout.println("");


        t_iter = types.iterator();
        n_iter = names.iterator();
        while (t_iter.hasNext())
        {
            String type = (String) t_iter.next();
            String _name = (String) n_iter.next();
            if (_name.charAt(0)=='-') // extended
                continue;
            String name = getOnlyName(_name);
            String fixname =getMemberName(name);
            String func = (fixname.charAt(0)+"").toUpperCase() + fixname.substring(1);
            pout.println("    public void " + "\tset" + func + "   \t(" + type + " " + fixname + ") { this." + fixname + " = " + fixname + "; }");
        }

        pout.println(suffix);

        pout.println("}");
        pout.flush();
        
        if (tblname==null || tblname.length()==0)
            return;

        // generate code for bean manager
        File mgrfile = new File(outdir, clsname+"Mgr.java");
        System.out.println("Generating " + mgrfile.getAbsolutePath());
        
        pout = new PrintWriter(new FileOutputStream(mgrfile));        
        pout.println(prefix);
    
        pout.println("import dbo.*;");
        pout.println("import java.util.Date;");
        pout.println("import java.text.*;");
        pout.println("import java.sql.*;");
        pout.println("");
        pout.println("public class " + clsname + "Mgr extends dbo.Manager<"+clsname+">");
        pout.println("{");
        pout.println("    private static " + clsname + "Mgr _instance = null;");
        pout.println("");
        pout.println("    " + clsname + "Mgr() {}");
        pout.println("");
        pout.println("    public synchronized static " + clsname + "Mgr getInstance()");
        pout.println("    {");
        pout.println("        if (_instance==null) {");
        pout.println("            _instance = new " + clsname + "Mgr();");
        pout.println("        }");
        pout.println("        return _instance;");
        pout.println("    }");
        pout.println("");        
        pout.println("    public "+clsname+"Mgr(int tran_id) throws Exception {");
        pout.println("        super(tran_id);");
        pout.println("    }");
        pout.println("");
        if (!tblname.equals("###")) {
            pout.println("    protected String getTableName()");
            pout.println("    {");
            //pout.println("        return \"" + replace(tblname.toLowerCase(), '-', " join ") + "\";");
            pout.println("        return \"" + replace(tblname, '-', " join ") + "\";");
            pout.println("    }");
        }
        pout.println("");                   
        pout.println("    protected Object makeBean()");
        pout.println("    {");
        pout.println("        return new "+clsname+"();");
        pout.println("    }");
        pout.println("");                   
        //pout.println("    protected int getBeanId(Object obj)");
        //pout.println("    {");
        //pout.println("        return (("+clsname+")obj).get"+idname+"_id();");
        //pout.println("    }");
        
        if (joinspace!=null && joinspace.length()>0)
        {
            pout.println("    protected String JoinSpace()");
            pout.println("    {");
            pout.println("         return \"" + joinspace + "\";");
            pout.println("    }");
            pout.println("");   
        }

        if (fieldlist!=null && fieldlist.length()>0)
        {
            pout.println("    protected String getFieldList()");
            pout.println("    {");
            pout.println("         return \"" + replace(fieldlist, '-', ",") + "\";");
            pout.println("    }");
            pout.println("");   
        }

        if (tblname.indexOf("-")<0 && ljoins.size()==0) // not a join
        {
            pout.println("    protected String getIdentifier(Object obj)");
            pout.println("    {");
            pout.println("        "+clsname+" o = ("+clsname+") obj;");
            pout.print  ("        return ");
            
            
            Iterator k_iter;
            k_iter = keys.iterator();
            t_iter = types.iterator();
            int i = 0;
            while (k_iter.hasNext())
            {
                String k = (String) k_iter.next();
                String t = (String) t_iter.next();
                pout.print("\"" + k + " = "); 
                if (t.equals("String"))
                    pout.print("'");

                pout.print("\" + o.get" );
                pout.print((k.charAt(0)+"").toUpperCase() + k.substring(1) + "()");

                if (t.equals("String"))
                    pout.print("+\"'\"");

                if (k_iter.hasNext())
                    pout.print(" + \" and \" + ");
                i++;
            }
            if (i==0)
                pout.print("null");
            pout.println(";");
            pout.println("    }");
            
    
            pout.println("");                   
        }
        
        pout.println("    protected void fillBean(ResultSet rs, Object obj, Connection con)");
        pout.println("        throws Exception");
        pout.println("    {");
        pout.println("        " + clsname + " item = (" + clsname + ") obj;");
        pout.println("        try {");
        
        
        
        t_iter = types.iterator();
        n_iter = names.iterator();
        while (t_iter.hasNext())
        {
            String type = (String) t_iter.next();
            String name = getOnlyName((String) n_iter.next());
            String fixname = getMemberName(name);
            String typeStr = (type.charAt(0)+"").toUpperCase() + type.substring(1);
            if (type.equals("Date"))
                type = "java.util.Date";
            if (typeStr.equals("Date"))
                typeStr = "Timestamp";
            if (!type.equals("long")) 
            {
                pout.println("            " + type + "\t" + fixname + "\t\t = " + "rs.get" + typeStr + "(\"" + getFieldName(name) + "\");");
            }
            else // use getBytes for long is much faster
            {
                pout.println("            " + type + "\t" + fixname + "\t\t = 0;" + "try { "+fixname+" = Long.parseLong(new String(rs.getBytes(\"" + getFieldName(name) + "\"))); } catch (Exception ee) {}");
            }
            pout.println("            item.set" + (fixname.charAt(0)+"").toUpperCase() + fixname.substring(1) + "(" + fixname + ");");                
        }

        /*
        pout.println("");
        pout.println("            item");
        n_iter = names.iterator();
        for (int i=0; n_iter.hasNext(); i++)
        {
            String name = getOnlyName((String) n_iter.next());
            if (i==0)
                pout.print("            .init(");
            else
                pout.print(", ");
            pout.print(name);
            if ((i%3)==2) {
                pout.println("");
                pout.print("            ");
            }
        }        
        pout.println(");");
        */
        pout.println("        }");
        pout.println("        catch (Exception e)");
        pout.println("        {");
        pout.println("            throw e;");
        pout.println("        }");
        pout.println("    }");
        pout.println("");            
        
        if (tblname.indexOf("-")<0) // not a join
        {        
            pout.println("    protected String getSaveString(Object obj)");
            pout.println("    {");
            pout.println("        SimpleDateFormat df = new SimpleDateFormat(\"yyyy-MM-dd HH:mm:ss\");");
            pout.println("        java.util.Date d;");
            pout.println("        "+clsname+" item = ("+clsname+") obj;");
            pout.println("");        
            // pout.println("        String ret = \"modified=NOW()\"");
            pout.println("        String ret = ");
            
            n_iter = names.iterator();
            t_iter = types.iterator();
            StringBuffer tmp = new StringBuffer();
            boolean is_auto_id = false;
            String auto_key = null;    
            
            for (int i=0; n_iter.hasNext(); i++)
            {
                String name = (String) n_iter.next();
                String type = (String) t_iter.next();
                
                // if (name.equals("id") || name.equals("created") || name.equals("modified"))
                if (name.indexOf("*")>=0)
                {
                    is_auto_id = true;
                    auto_key = getMemberName(getOnlyName(name));
                    continue;
                }
                    
                boolean isString = type.compareTo("String")==0;
                boolean isDate = type.compareTo("Date")==0;
            
                name = getMemberName(getOnlyName(name));
                String func = (name.charAt(0)+"").toUpperCase() + name.substring(1);
                if (tmp.length()>0)
                    tmp.append("            + \"," + name + "=");
                else
                    tmp.append("            \"" + name + "=");
                    
                if (isString)
                {
                    tmp.append("'");
                }
                    
                tmp.append("\" + ");
    
                if (isString)
                    tmp.append("ServerTool.escapeString(");
                else if (isDate)
                    tmp.append("(((d=");
                                
                tmp.append("item.get" + func + "()");
    
                if (isString)
                    tmp.append(")");
                else if (isDate)
                    tmp.append(")!=null)?(\"'\"+df.format(d)+\"'\"):\"NULL\")");
    
                if (isString)
                {
                    tmp.append(" + \"'\"");
                }
                tmp.append("\n");
            }
            if (tmp.length()>0)
                pout.println(tmp.toString());
            else
                pout.println("        \"\"");
            pout.println("        ;");
            pout.println("        return ret;");        
            pout.println("    }");
            pout.println("");        
            pout.println("    protected String getInsertString()");
            pout.println("    {");
            // pout.print("         return \"created, modified");
            pout.print("         return  \"");
            
            n_iter = names.iterator();
            tmp = new StringBuffer();
            for (int i=0; n_iter.hasNext(); i++)
            {
                String name = (String) n_iter.next();
                // if (name.equals("id")||name.equals("created")||name.equals("modified"))
                if (name.indexOf("*")>=0) // auto genereated integer
                    continue;
                if (tmp.length()>0)
                    tmp.append(",");
                tmp.append(getMemberName(getOnlyName(name)));
            }        
            pout.print(tmp.toString());
            pout.println("\";");
            pout.println("    }");
            pout.println("");        
            pout.println("    protected String getCreateString(Object obj)");
            pout.println("    {");
            pout.println("        SimpleDateFormat df = new SimpleDateFormat(\"yyyy-MM-dd HH:mm:ss\");");
            pout.println("        java.util.Date d;");
            pout.println("        "+clsname+" item = ("+clsname+") obj;");        
            pout.println("");
            // pout.println("        String ret = \"NOW(), NOW()\"");
            pout.println("        String ret = ");
            
            n_iter = names.iterator();
            t_iter = types.iterator();
            tmp = new StringBuffer();
            for (int i=0; n_iter.hasNext(); i++)
            {
                String name = (String) n_iter.next();
                String type = (String) t_iter.next();
                // if (name.equals("id")||name.equals("created")||name.equals("modified"))
                if (name.indexOf("*")>=0) // auto generated integer
                    continue;            
                boolean isString = type.compareTo("String")==0;
                boolean isDate = type.compareTo("Date")==0;
                name = getMemberName(getOnlyName(name));
                String func = (name.charAt(0)+"").toUpperCase() + name.substring(1);
                
                if (tmp.length()>0)
                    tmp.append("            + \",");
                else
                    tmp.append("            \"");
    
                if (isString)
                {
                    tmp.append("'");
                }
                
                tmp.append("\" + ");
                
                if (isString)
                    tmp.append("ServerTool.escapeString(");
                else if (isDate)
                    tmp.append("(((d=");
                                
                tmp.append("item.get" + func + "()");
    
                if (isString)
                    tmp.append(")");
                else if (isDate)
                    tmp.append(")!=null)?(\"'\"+df.format(d)+\"'\"):\"NULL\")");
    
                if (isString)
                {
                    tmp.append(" + \"'\"");
                }
                tmp.append("\n");
            }
            
            if (tmp.length()>0)
                pout.println(tmp.toString());
            else
                pout.println("        \"\"");
            pout.println("        ;");
            pout.println("        return ret;");
            pout.println("    }");
    
            if (is_auto_id)
            {
                pout.println("    protected boolean isAutoId()");
                pout.println("    {");
                pout.println("        return true;");
                pout.println("    }");
                pout.println("");
                pout.println("    protected void setAutoId(Object obj, int auto_id)");
                pout.println("    {");
                pout.println("        "+clsname+" o = ("+clsname+") obj;");
                pout.println("        o.set"+(auto_key.charAt(0)+"").toUpperCase() + auto_key.substring(1)+"(auto_id);");
                pout.println("    }");
                
            }
        }
        
        if (ljoins.size()>0)
        {
            pout.println("    protected String getLeftJoins()");
            pout.println("    {");
            pout.println("        String ret = \"\";");
            for (int i=0; i<ljoins.size(); i++)
            {
                pout.print("        ret += ");
                String[] parts = (String[]) ljoins.get(i);
                pout.println("\"LEFT JOIN " + parts[0] + " ON " + parts[1] + " \";");
            }
            pout.println("        return ret;");
            pout.println("    }");
        }
                          
        pout.println("}");

/*
        // generate code for ResultSet retrieval
        System.out.println("");
        System.out.println("");
System.out.println("// =============================== ");
System.out.println("// ===  populate  statement   ==== ");
System.out.println("// ====== (C21Init.java)   ======= ");
System.out.println("// =============================== ");

        n_iter = names.iterator();
        for (int i=0; n_iter.hasNext(); i++)
        {
            String name = (String) n_iter.next();
            if (i==0)
                System.out.print("INSERT INTO <table name> (");
            else
                System.out.print(", ");
            System.out.print(name);
        }
        System.out.println(") VALUES (");

        // generate code for ResultSet retrieval
        System.out.println("");
        System.out.println("");
System.out.println("// =============================== ");
System.out.println("// ====== (C21Init.java)   ======= ");
System.out.println("// =============================== ");

        n_iter = names.iterator();
        for (int i=0; n_iter.hasNext(); i++)
        {
            String name = (String) n_iter.next();
            System.out.println("String " + name + "Str = (String) av.get(\"" + name + "\");");
        }

        System.out.println("");
        System.out.println("");
        System.out.println("String str = ");

        t_iter = types.iterator();
        n_iter = names.iterator();
        for (int i=0; n_iter.hasNext(); i++)
        {
            String type = (String) t_iter.next();
            String name = (String) n_iter.next();
            boolean isString = type.compareTo("String")==0;
            
            if (isString) {
                System.out.print("+ \",'\" + ");
                System.out.print("format(" + name + "Str)");
            }
            else
            {
                System.out.print("+ \",\" + ");
                System.out.print("formatNum(" + name + "Str)");
            }
            if (isString)
                System.out.println("+\"'\"");
            else
                System.out.println("");
        }


        // generate code for updating db
        System.out.println("");
        System.out.println("");
System.out.println("// =============================== ");
System.out.println("// == JdbcListingManager.java (save) === ");
System.out.println("// =============================== ");

        n_iter = names.iterator();
        t_iter = types.iterator();
        for (int i=0; n_iter.hasNext(); i++)
        {
            String name = (String) n_iter.next();
            String type = (String) t_iter.next();
            boolean isString = type.compareTo("String")==0;
            boolean isDate = type.compareTo("Date")==0;

            String func = (name.charAt(0)+"").toUpperCase() + name.substring(1);
            System.out.print("            + \"," + name + "=");
            if (isString)
            {
                System.out.print("'");
            }
            
            System.out.print("\" + ");

            if (isString)
                System.out.print("ServerTool.escapeString(");
            else if (isDate)
                System.out.print("(((d=");
                            
            System.out.print("item.get" + func + "()");

            if (isString)
                System.out.print(")");
            else if (isDate)
                System.out.print(")!=null)?(\"'\"+df.format(d)+\"'\"):\"NULL\")");

            if (isString)
            {
                System.out.print(" + \"'\"");
            }
            System.out.println("");
        }


        // generate code for creating db
        System.out.println("");
        System.out.println("");
System.out.println("// =============================== ");
System.out.println("// == JdbcListingManager.java (create) === ");
System.out.println("// =============================== ");

        n_iter = names.iterator();
        t_iter = types.iterator();
        for (int i=0; n_iter.hasNext(); i++)
        {
            String name = (String) n_iter.next();
            String type = (String) t_iter.next();
            boolean isString = type.compareTo("String")==0;
            boolean isDate = type.compareTo("Date")==0;

            String func = (name.charAt(0)+"").toUpperCase() + name.substring(1);
            System.out.print("            + \",");
            if (isString)
            {
                System.out.print("'");
            }
            
            System.out.print("\" + ");

            if (isString)
                System.out.print("ServerTool.escapeString(");
            else if (isDate)
                System.out.print("(((d=");
                            
            System.out.print("item.get" + func + "()");

            if (isString)
                System.out.print(")");
            else if (isDate)
                System.out.print(")!=null)?(\"'\"+df.format(d)+\"'\"):\"NULL\")");

            if (isString)
            {
                System.out.print(" + \"'\"");
            }
            System.out.println("");
        }


        // generate code to copy bean from parser map
        System.out.println("");
        System.out.println("");
System.out.println("// ====================================== ");
System.out.println("// == MlsGateway.java (updateListing) === ");
System.out.println("// ====================================== ");
        n_iter = names.iterator();
        t_iter = types.iterator();
        for (int i=0; n_iter.hasNext(); i++)
        {
            String name = (String) n_iter.next();
            String type = (String) t_iter.next();

            String func = (name.charAt(0)+"").toUpperCase() + name.substring(1);
            System.out.println("            if ((str=(String)m.get(\"" + name + "\"))!=null && str.length()>0)");
            System.out.print("                item.set" + func + "(");
            System.out.print("format" + type + "(str));");
            System.out.println("");
        }


        // generate update-XXX.jsp
        System.out.println("");
        System.out.println("");
System.out.println("// ================================== ");
System.out.println("// ======== update-XXX.jsp    ======= ");
System.out.println("// ================================== ");
        System.out.println("<%");
        System.out.println("    String forwardTo = ");
        System.out.println("        \"/WEB-INF/jsp/admin[XXX]/detail-page.jsp\";");
        System.out.println("    String error =");
        System.out.println("        \"/WEB-INF/jsp/admin[XXX]/detail-page.jsp\";");
        System.out.println("");
        System.out.println("    request.setAttribute(\"forward\", forwardTo);");
        System.out.println("    request.setAttribute(\"error\", error);");
        System.out.println("%>");
        System.out.println("<jsp:forward page='/update-eventmodify-action.do'/>");

        // generate UpdateXXXAction.java
        System.out.println("");
        System.out.println("");
System.out.println("// ================================== ");
System.out.println("// ======== UpdateXXXAction.java  === ");
System.out.println("// ================================== ");

        n_iter = names.iterator();
        t_iter = types.iterator();
        for (int i=0; n_iter.hasNext(); i++)
        {
            String name = (String) n_iter.next();
            String type = (String) t_iter.next();
            boolean isDate = type.equals("Date");
            boolean isInt = type.equals("int");
            boolean isFloat = type.equals("int");

            String func = (name.charAt(0)+"").toUpperCase() + name.substring(1);
            System.out.print("            if ((str=form.get" + func + "())!=null");
            
            if (isInt||isDate||isFloat)
                System.out.print(" && str.length()>0");

            System.out.println(")");

            System.out.print("                item.set" + func + "(");
            if (isDate)
                System.out.print("df.parse(");
            else if (isInt)
                System.out.print("Integer.parseInt(");
            else if (isFloat)
                System.out.print("Float.parseFloat(");
            
            System.out.print("str)");

            if (isDate||isInt||isFloat)
                System.out.print(")");

            System.out.println(";");
        }

        // generate the beans\form\XXXForm.java
        System.out.println("");
        System.out.println("");
System.out.println("// =============================== ");
System.out.println("// === beans/form/XXXForm.java === ");
System.out.println("// =======   copyFrom    ========= ");
System.out.println("// =============================== ");

        n_iter = names.iterator();
        t_iter = types.iterator();
        for (int i=0; n_iter.hasNext(); i++)
        {
            String name = (String) n_iter.next();
            String type = (String) t_iter.next();
            boolean isNotString = !type.equals("String");
            boolean isDate = type.equals("Date");

            String attrStr = (name.charAt(0)+"").toUpperCase() + name.substring(1);
            System.out.print("        set" + attrStr + "(");
            
            if (isDate)
                System.out.print("df.format(");
            
            System.out.print("i.get");
            System.out.print(attrStr);
            System.out.print("()");
                
            if (isDate)
                System.out.print(")");
            else if (isNotString)
                System.out.print("+\"\"");

            System.out.println(");");
        }

        System.out.println("");
        */
        pout.flush();
    }
    
    private static String getOnlyName(String name)
    {
        StringBuffer ret = new StringBuffer();
        for (int i=0; i<name.length(); i++)
            if (name.charAt(i)!='*' && name.charAt(i)!='#' && name.charAt(i)!='-')
                ret.append(name.charAt(i));
        return ret.toString();
    }
    
    private static String getMemberName(String name)
    {
        String[] test = name.split("<");
        if (test.length>1)
            return test[0];
        return name;
    }

    private static String getFieldName(String name)
    {
        String[] test = name.split("<");
        if (test.length>1)
            return test[1];
        return name;
    }
 
    private static String replace(String str, char c, String pat)
    {
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<str.length(); i++)
        {
            char k = str.charAt(i);
            if (k==c) sb.append(pat);
            else sb.append(k);
        }
        return sb.toString();
    }   

    public static void main(String args[])
    {
        if (args.length!=2)
        {
            System.out.println("Usage java BeanGenerator <.bean file> <out directory>");
            return;
        }
        String filename = args[0];
        
        File outdir = new File(args[1]);
        if (!outdir.exists() || !outdir.isDirectory())
        {
            System.out.println("\"" + args[1] + "\" is not a directory");
            return;            
        }

        try {

            File indir = new File(filename);
            if(indir.isDirectory() && indir.exists())
            {
            	String[] fileNames = indir.list();
            	if(fileNames != null && fileNames.length > 0)
            	{
            		for(String fn:fileNames)
            		{
            			fn = indir.getPath()+"\\"+fn;
            			System.out.println(fn);
            			BufferedReader r = new BufferedReader(new InputStreamReader(new FileInputStream(fn), "UTF-8"));
            			BeanGenerator.generate(new LineNumberReader(r), outdir);
            		}
            	}
            }
            else
            {
                BufferedReader r = new BufferedReader(new 
                    InputStreamReader(new FileInputStream(args[0]), "UTF-8"));
            	BeanGenerator.generate(new LineNumberReader(r), outdir);
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
}