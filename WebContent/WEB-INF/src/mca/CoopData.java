package mca;

import java.util.*;
import java.text.*;
import phm.ezcounting.*;

public class CoopData
{
    int tran_id;
    String[] tokens;

    public CoopData(int tran_id, String line)
    {
        tokens = line.split(" ");
        this.tran_id = tran_id;
        for (int i=0; i<tokens.length; i++) {
            System.out.println(i + ":" + tokens[i] + "#");
        }
    }

    //1852765196507 0971001 CSBN  00000000000  00000014000  00000237407 1450 0006709 
    private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyMMdd");
    public Date getPayDate()
        throws Exception
    {
        Date d = sdf1.parse(tokens[1]); // yyyMMdd 民國年
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        c.set(Calendar.YEAR, (c.get(Calendar.YEAR)+1911));
        return c.getTime();
    }

    public int getPayMoney()
    {
        return Integer.parseInt(tokens[6]);
    }

    public McaStudent getMcaStudent()
        throws Exception
    {
        int coopId = Integer.parseInt(tokens[10]);
        ArrayList<McaStudent> sts = new McaStudentMgr(tran_id).retrieveList("CoopID='" + coopId + "'","");
        if (sts.size()==0) {
            String coopIdStr = PaymentPrinter.makePrecise(coopId+"", 7, false, '0');
            sts = new McaStudentMgr(tran_id).retrieveList("CoopID='" + coopIdStr + "'","");
        }
        if (sts.size()==0)
            return null;

        if (sts.size()==1)
            return sts.get(0);
        else { // size > 1            
            Bunit bunit = new BunitHelper(tran_id).getBunitFromVirtual(this.getCoopAccountId());
            ArrayList<TagMembr> tms = new McaService(tran_id).getCurrentCampusMembrs(bunit.getId());
            Map<Integer, TagMembr> tmsMap = new SortingMap(tms).doSortSingleton("getMembrId");
            for (int i=0; i<sts.size(); i++) {
                McaStudent s = sts.get(i);
                if (tmsMap.get(s.getMembrId())!=null)
                    return s;
            }
        }

        /*
        McaStudent ret = new McaStudentMgr(tran_id).find("CoopID='" + coopId + "'");
        if (ret==null) {
            String coopIdStr = PaymentPrinter.makePrecise(coopId+"", 7, false, '0');
            ret = new McaStudentMgr(tran_id).find("CoopID='" + coopIdStr + "'");
        }
        */
        return null;
    }

    public String getCoopAccountId()
    {
        return tokens[0].substring(7);
    }
}