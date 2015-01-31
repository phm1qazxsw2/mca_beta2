package mca;

import phm.accounting.*;
import phm.ezcounting.*;
import literalstore.*;
import java.util.*;
import java.text.*;
import phm.util.*;
import jsf.*;
import dbo.*;

public class McaImEx
{
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static boolean stop = false;
    private static Thread thread = null;

    public static void startImportThread()
        throws Exception
    {
        PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
        
        if (ps.getPagetype()!=7) // 不是馬禮遜的就不理
            return;

        if (thread!=null) {
            System.out.println("## import thread already running!");
            return;
        }
        thread = new Thread(new Handler());
        thread.start();
    }

    public static void shutdown()
    {
        stop = true;
        thread = null;
    }

    private static SimpleDateFormat bday_sdf1 = new SimpleDateFormat("MM/dd/yyyy");
    private static SimpleDateFormat bday_sdf2 = new SimpleDateFormat("yyyy/MM/dd");
    public static int importNewStudent()
        throws Exception
    {
        boolean commit = false;
        int tran_id = 0;
        try { 
            tran_id = Manager.startTransaction();  
            McaStudentMgr msmgr = new McaStudentMgr(tran_id);
            McaService mcasvc = new McaService(tran_id);

            Map<String, Bunit> bunitMap = new SortingMap(new BunitMgr(tran_id).retrieveList("flag=" + 
                Bunit.FLAG_BIZ, "")).doSortSingleton("getLabel");

            AdmStudentMgr amgr = AdmStudentMgr.getInstance(); // 這個目前沒辦法在同一 transaction 里
            amgr.setDataSourceName("billing");
            ArrayList<AdmStudent> students = amgr.retrieveList("ImportDate is NULL", "");
            Date now = new Date();
            Calendar c = Calendar.getInstance();
            c.add(Calendar.MONTH, -1);
            Date monthago = c.getTime();

            for (int i=0; i<students.size();i++) {
                AdmStudent a = students.get(i);
                McaStudent ms = msmgr.find("StudentID=" + a.getStudentID());
                boolean created = false;
                if (ms==null) {
                    ms = new McaStudent();
                    ms.setStudentID(a.getStudentID());
                    created = true;
                }
                ms.setApplyForYear(a.getApplyForYear());
                String campus = a.getCampus();
                if (campus==null)
                    campus = "Taichung";                    
                if (campus.equals("Taipei"))
                    campus = "Bethany";
                Bunit bu = bunitMap.get(campus);
                ms.setCampus(campus);
                ms.setGrade(a.getApplyForGrade());
                ms.setStudentFirstName(a.getStudentFirstName());
                ms.setStudentSurname(a.getStudentSurname());
                ms.setStudentChineseName(a.getStudentChineseName());
                try {
                    Date bd = bday_sdf1.parse(a.getBirthDate());                  
                    ms.setBirthDate(bday_sdf2.format(bd));
                }
                catch (Exception e) {}
                ms.setPassportNumber(a.getPassportNumber());
                ms.setPassportCountry(a.getPassportCountry());
                ms.setSex(a.getSex());
                ms.setHomePhone(a.getHomePhone());
                ms.setFatherFirstName(a.getFatherFirstName());
                ms.setFatherSurname(a.getFatherSurname());
                ms.setFatherChineseName(a.getFatherChineseName());
                ms.setFatherPhone(a.getFatherPhone());
                ms.setFatherCell(a.getFatherCell());
                ms.setFatherEmail(a.getFatherEmail());
                ms.setFatherSendEmail(a.getFatherSendEmail());
                ms.setMotherFirstName(a.getMotherFirstName());
                ms.setMotherSurname(a.getMotherSurname());
                ms.setMotherChineseName(a.getMotherChineseName());
                ms.setMotherPhone(a.getMotherPhone());
                ms.setMotherCell(a.getMotherCell());
                ms.setMotherEmail(a.getMotherEmail());
                ms.setMotherSendEmail(a.getMotherSendEmail());
                ms.setCountryID(a.getCountryID());
                ms.setCountyID(a.getCountyID());
                ms.setCityID(a.getCityID());
                ms.setDistrictID(a.getDistrictID());
                ms.setChineseStreetAddress(a.getChineseStreetAddress());
                ms.setEnglishStreetAddress(a.getEnglishStreetAddress());
                ms.setPostalCode(a.getPostalCode());

                if (created)
                    msmgr.create(ms);
                else
                    msmgr.save(ms);

                ArrayList<McaStudent> tmp = new ArrayList<McaStudent>();
                tmp.add(ms);
                mcasvc.updateStudents(tmp);
            }

            amgr.executeSQL("update ImportFromAdmissions set ImportDate='" + sdf.format(now) + "'" +
                " where ImportDate is NULL");
            amgr.executeSQL("delete from ImportFromAdmissions where ImportDate<'" + sdf.format(monthago) + "'");

            commit = true;
            Manager.commit(tran_id);

            return students.size();
        }
        finally {
            if (!commit)
                try { Manager.rollback(tran_id); } catch (Exception e2) {}  
        }
    }

    static Date getLastExport(int tran_id)
        throws Exception
    {
        McaExportMgr xmgr = new McaExportMgr(tran_id);
        ArrayList<McaExport> exports = xmgr.retrieveList("", "");
        if (exports.size()==0) {
            McaExport mx = new McaExport();
            mx.setExportTime(new Date());
            xmgr.create(mx);
            return sdf.parse("2009-05-05 00:00:00");
        }
        else {
            Date ret = exports.get(0).getExportTime();
            exports.get(0).setExportTime(new Date());
            xmgr.save(exports.get(0));
            return ret;
        }
    }

    public static String doCapital(String str)
    {
        if (str==null || str.length()==0)
            return "";
        return str.substring(0,1).toUpperCase() + str.substring(1);
    }

    public static void exportModifiedStudent(McaStudent ms)
        throws Exception
    {
        boolean commit = false;
        int tran_id = 0;
        try { 
long base = new Date().getTime();
            tran_id = Manager.startTransaction();  
            McaStudentMgr msmgr = new McaStudentMgr(tran_id);
            McaService mcasvc = new McaService(tran_id);
System.out.println("#a=" + (new Date().getTime()-base));
            Map<Integer, Bunit> bunitMap = new SortingMap(new BunitMgr(tran_id).retrieveList("flag=" + 
                Bunit.FLAG_BIZ, "")).doSortSingleton("getId");

            ChanceryStudentMgr csmgr = ChanceryStudentMgr.getInstance(); // 這個目前沒辦法在同一 transaction 里
            csmgr.setDataSourceName("billing");

System.out.println("#b=" + (new Date().getTime()-base));
            Date now = new Date();
            //Date lastExport = getLastExport(tran_id);

            //ArrayList<McaStudent> students = msmgr.retrieveList("modified>'" + sdf.format(lastExport) + "'", "");
            //String membrIds = new RangeMaker().makeRange(students, "getMembrId");
            //Map<Integer, Membr> membrMap = new SortingMap(new MembrMgr(tran_id).retrieveList("id in (" + 
            //    membrIds + ")", "")).doSortSingleton("getId");

            //for (int i=0; i<students.size();i++) {
                //McaStudent ms = students.get(i);
                ChanceryStudent c = new ChanceryStudent();
                c.setExportDate(now);
                c.setStudentID(ms.getStudentID());
                
                //Membr membr = membrMap.get(ms.getMembrId());
                //Bunit bu = bunitMap.get(membr.getBunitId());
                //String campus = bu.getLabel();
                //if (campus.equals("Bethany"))
                //    campus = "Taipei";
                //c.setCampus(campus);

                c.setStudentFirstName(ms.getStudentFirstName());
                c.setStudentSurname(ms.getStudentSurname());
                c.setStudentChineseName(ms.getStudentChineseName());
                c.setBirthDate(ms.getBirthDate());
                c.setPassportNumber(ms.getPassportNumber());
                c.setPassportCountry(ms.getPassportCountry());
                c.setSex(ms.getSex());
                c.setHomePhone(ms.getHomePhone());
                c.setFatherFirstName(ms.getFatherFirstName());
                c.setFatherSurname(ms.getFatherSurname());
                c.setFatherChineseName(ms.getFatherChineseName());
//System.out.println("## c.getFatherChineseName=" + c.getFatherChineseName());
                c.setFatherPhone(ms.getFatherPhone());
                c.setFatherCell(ms.getFatherCell());
                c.setFatherEmail(ms.getFatherEmail());
                c.setFatherSendEmail(ms.getFatherSendEmail());
                c.setMotherFirstName(ms.getMotherFirstName());
                c.setMotherSurname(ms.getMotherSurname());
                c.setMotherChineseName(ms.getMotherChineseName());
                c.setMotherPhone(ms.getMotherPhone());
                c.setMotherCell(ms.getMotherCell());
                c.setMotherEmail(ms.getMotherEmail());
                c.setMotherSendEmail(ms.getMotherSendEmail());
                c.setCountryID(ms.getCountryID());
                c.setCountyID(ms.getCountyID());
                c.setCityID(ms.getCityID());
                c.setDistrictID(ms.getDistrictID());
                c.setChineseStreetAddress(ms.getChineseStreetAddress());
                c.setEnglishStreetAddress(ms.getEnglishStreetAddress());
                c.setPostalCode(ms.getPostalCode());
                
System.out.println("#c=" + (new Date().getTime()-base));
                csmgr.create(c);
System.out.println("#d=" + (new Date().getTime()-base));
            //}

            commit = true;
            Manager.commit(tran_id);

            //return students.size();
        }
        finally {
            if (!commit)
                try { Manager.rollback(tran_id); } catch (Exception e2) {}  
        }
    }

    static class Handler extends Thread {
        public void run()
        {
            System.out.println("## admission import thread started");
            while(!stop){
                try
                {
                    Thread.sleep(60*1000); // sleep 1 min
                    int imported = McaImEx.importNewStudent();
                    if (imported>0)
                        System.out.println("## import " + imported + " students from admission");
                }
                catch (Exception e)
                {
                }
            }
            System.out.println("## admission import thread quits..");
        }
    }
}
