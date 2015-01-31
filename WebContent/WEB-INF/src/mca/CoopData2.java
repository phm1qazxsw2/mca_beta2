package mca;

import java.util.*;
import java.text.*;
import phm.ezcounting.*;

public class CoopData2
{
    int tran_id;
    String[] tokens;

    public CoopData2(int tran_id, String line)
    {
        tokens = line.split("\t");
        this.tran_id = tran_id;
    }

    //代收類別	繳款管道	銷帳編號	實繳金額	繳費日期	繳款時間	學校代號	公司代號	代收機構代號	代收門市店號	扣繳狀況	入帳日期	條碼一	條碼二	條碼三	傳送日期
    //185302	Host	1853021203354	40067	20110208	150810	185302					20110208				20110208
    private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMMdd");
    public Date getPayDate()
        throws Exception
    {
        Date d = sdf1.parse(tokens[4]); // 20110208
        return d;
    }

    public int getPayMoney()
    {
        return Integer.parseInt(tokens[3]);
    }

    public McaStudent getMcaStudent()
        throws Exception
    {
        String studentIDstr = tokens[2].substring(8);  // 1853021203354, old:1000383831303354
        int studentID = 0;
        int coopNo = 0;
        ArrayList<McaStudent> sts = null;
        if (studentIDstr.indexOf("a")>0) {
            studentIDstr = studentIDstr.substring(0, studentIDstr.length()-1);
            studentID = Integer.parseInt(studentIDstr);
            sts = new McaStudentMgr(tran_id).retrieveList("StudentID=" + studentID,"");
        }
        else if (studentIDstr.indexOf("b")>0) {
            studentIDstr = studentIDstr.substring(0, studentIDstr.length()-1);
            coopNo = Integer.parseInt(studentIDstr);
            sts = new McaStudentMgr(tran_id).retrieveList("CoopID='" + coopNo,"'");
        }
        else {
            studentID = Integer.parseInt(studentIDstr);
            ArrayList<McaStudent> sts1 = new McaStudentMgr(tran_id).retrieveList("StudentID=" + studentID,"");
            ArrayList<McaStudent> sts2 = new McaStudentMgr(tran_id).retrieveList("CoopID='" + studentID + "'", "");
            if (sts2.size()==0) {
                String tmp = PaymentPrinter.makePrecise(studentID+"", 7, false, '0');
                sts2 = new McaStudentMgr(tran_id).retrieveList("CoopID='" + tmp + "'", "");
            }

            if (sts1.size()>0 && sts2.size()>0) {
                throw new Exception("[" + studentID + "] exists in both StudentID and CoopID");
            }
            else if (sts1.size()==0 && sts2.size()>0)
                sts = sts2;
            else if (sts1.size()>0 && sts2.size()==0)
                sts = sts1;
        }

        if (sts==null || sts.size()==0)
            throw new Exception("Student of ID ["+studentIDstr+"] not found");

        if (sts.size()==1)
            return sts.get(0);
        else { // size > 1            
            Bunit bunit = new BunitHelper(tran_id).getBunitFromStoreID(getCoopStoreId());
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

    public String getCoopStoreId()
    {
        return tokens[6];
    }

    public int getVia() {
        if (tokens[1].charAt(0)=='C') // CTCB
            return BillPay.VIA_CREDITCARD;
        return BillPay.VIA_ATM;
    }
}