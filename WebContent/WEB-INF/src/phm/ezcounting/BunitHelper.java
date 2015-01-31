package phm.ezcounting;

import phm.accounting.*;
import java.util.*;
import java.text.*;
import phm.util.*;
import jsf.*;

public class BunitHelper
{
    int tran_id;
    WebSecurity ws;

    public BunitHelper() 
        throws Exception   
    {
        this(0);
    }
    public BunitHelper(int tran_id)
        throws Exception
    {
        this.tran_id = tran_id;
    }

    public int getDefaultBunitId(User u)
        throws Exception
    {
        ArrayList<Bunit> mybu = getMyBunits(u);
        if (mybu.size()>0) {
            return mybu.get(0).getId();
        }
        return 0;
    }
    
    public boolean hasBunits()
        throws Exception
    {
        prepare();
        return _bunits.size()>0;
    }

    public Bunit getBunit(int bunitId)
        throws Exception
    {
        prepare();
        return bunitMap.get(bunitId);
    }

    public int getStudentBunitId(int bunitId)
        throws Exception
    {
        return getStudentBunitId(bunitId, false);
    }

    public int getStudentBunitId(int bunitId, boolean realvalue)
        throws Exception
    {
        prepare();
        Bunit bu = bunitMap.get(bunitId);
        if (bu==null)
            return 0;
        Binfo bi = binfoMap.get(bu.getId());
        if (bi==null)
            return (realvalue)?0:bu.getId();
        int studentBunitId = bi.getStudentBunitId();
        if (studentBunitId==0)
            return (realvalue)?0:bu.getId();
        return studentBunitId;
    }

    public int getAcodeBunitId(int bunitId)
        throws Exception
    {
        return getAcodeBunitId(bunitId, false);
    }

    public int getAcodeBunitId(int bunitId, boolean realvalue)
        throws Exception
    {
        prepare();
        Bunit bu = bunitMap.get(bunitId);
        if (bu==null)
            return 0;
        Binfo bi = binfoMap.get(bu.getId());
        if (bi==null)
            return (realvalue)?0:bu.getId();
        int acodeBunitId = bi.getAcodeBunitId();
        if (acodeBunitId==0)
            return (realvalue)?0:bu.getId();
        return acodeBunitId;
    }

    public int getMetaBunitId(int bunitId)
        throws Exception
    {
        return getMetaBunitId(bunitId, false);
    }

    public int getMetaBunitId(int bunitId, boolean realvalue)
        throws Exception
    {
        prepare();
        Bunit bu = bunitMap.get(bunitId);
        if (bu==null)
            return 0;
        Binfo bi = binfoMap.get(bu.getId());
        if (bi==null)
            return (realvalue)?0:bu.getId();
        int metaBunitId = bi.getMetaBunitId();
        if (metaBunitId==0)
            return (realvalue)?0:bu.getId();
        return metaBunitId;
    }

    public int getUnpaidBunitId(int bunitId)
        throws Exception
    {
        prepare();
        Bunit bu = bunitMap.get(bunitId);
        if (bu==null)
            return 0;
        Binfo bi = binfoMap.get(bu.getId());
        if (bi==null)
            return 0;
        int unpaidBunitId = bi.getUnpaidBunitId();
        return unpaidBunitId;
    }

    public String getBunitName(int bunitId)
        throws Exception
    {
        prepare();
        Bunit bu = bunitMap.get(bunitId);
        if (bu==null)
            return null;
        return bu.getLabel();
    }

    public String getMetaSpace(String fieldname, int bunitId)
        throws Exception
    {
        bunitId = getMetaBunitId(bunitId);
        if (bunitId>0)
            return fieldname + "=" + bunitId;
        return null;
    }

    public String getAcodeSpace(String fieldname, int bunitId)
        throws Exception
    {
        bunitId = getAcodeBunitId(bunitId);
        if (bunitId>0)
            return fieldname + "=" + bunitId;
        return null;
    }

    public String getStudentSpace(String fieldname, int bunitId)
        throws Exception
    {
        bunitId = getStudentBunitId(bunitId);
        if (bunitId>0)
            return fieldname + "=" + bunitId;
        return null;
    }

    public String getSpace(String fieldname, int bunitId)
    {
        if (bunitId>0)
            return fieldname + "=" + bunitId;
        return null;
    }

    private static ArrayList<Bunit> _bunits = null;
    private static Map<Integer, Bunit> bunitMap = null;
    private static Map<Integer, ArrayList<UserBunit>> userbunitMap = null;
    private static Map<Integer, Binfo> binfoMap = null;

    private void prepare() 
        throws Exception
    {
        if (userbunitMap==null) {
            userbunitMap = new SortingMap(new UserBunitMgr(tran_id).retrieveList("", "")).doSortA("getUserId");
        }
        if (bunitMap==null) {
            _bunits = new BunitMgr(tran_id).retrieveList("flag=" + Bunit.FLAG_BIZ + " and status=1", "");
            bunitMap = new SortingMap(_bunits).doSortSingleton("getId");
        } 
        if (ps==null) {
            ps = new PaySystem2Mgr(tran_id).find("id=1");
        }
        if (binfoMap==null) {
            binfoMap = new SortingMap(new BinfoMgr(tran_id).retrieveList("", "")).doSortSingleton("getBunitId");
        }
    }

    public static void reset()
    {
        _bunits = null;
        bunitMap = null;
        userbunitMap = null;
        ps = null;
        binfoMap = null;
    }

    public boolean checkAuthorized(User u, int buId)
        throws Exception
    {
        ArrayList<Bunit> myunits = getMyBunits(u);
        for (int i=0; i<myunits.size(); i++) {
            if (myunits.get(i).getId()==buId)
                return true;
        }
        return false;
    }

    public ArrayList<Bunit> getMyBunits(User u) 
        throws Exception    
    {
        prepare();
        ArrayList<Bunit> ret = new ArrayList<Bunit>();

        int embededBuId = u.getUserBunitAccounting();
        Bunit embedbu = bunitMap.get(embededBuId);
        if (embedbu!=null)
            ret.add(embedbu);

        ArrayList<UserBunit> myunits = userbunitMap.get(u.getId());
        if (myunits==null) {
            if (ret.size()==0)
                return _bunits; // 沒有定義 userbunit 的像 admin 經營者要 return 全部可選的
        }
        else {
            for (int i=0; myunits!=null && i<myunits.size(); i++) {
                Bunit bu = bunitMap.get(myunits.get(i).getBunitId());
                if (bu==null)
                    continue;
                ret.add(bu);
            }
        }
        return ret;
    }

    Bunit systemBunit()
        throws Exception
    {
        Bunit bu = new Bunit();
        return bu;
    }

    static PaySystem2 ps = null;

    public int getBankId(Bunit bu)
        throws Exception
    {
        return getBankId(bu, false);
    }

    public int getBankId(Bunit bu, boolean quiet)
        throws Exception
    {
        prepare();
        if (bu.getId()==0) { 
            return ps.getPaySystemBankAccountId();
        }
        Binfo bi = binfoMap.get(bu.getId());
        if ((bi==null || bi.getBankId()==0) && !quiet && ps.getPaySystemBankAccountId()>0)
            throw new Exception("代收 入帳銀行(BankId) 尚未設定");
        return ((bi!=null)?bi.getBankId():0);
    }

    public String getVirtualID(int buId)
        throws Exception
    {
        return getVirtualID(buId, false);
    }

    public String getVirtualID(int buId, boolean quiet)
        throws Exception
    {
        prepare();
        if (buId==0) { 
            return ps.getPaySystemFirst5();
        }
        Binfo bi = binfoMap.get(buId);
        if ((bi==null || bi.getVirtualID()==null || bi.getVirtualID().length()==0) && !quiet
                && ps.getPaySystemFirst5()!=null && ps.getPaySystemFirst5().length()>0)
            throw new Exception("代收 虛擬帳號(VirtualID) 尚未設定");
        return ((bi!=null)?bi.getVirtualID():"");
    }

    public String getStoreID(int buId)
        throws Exception
    {
        return getStoreID(buId, false);
    }

    public String getStoreID(int buId, boolean quiet)
        throws Exception
    {
        prepare();
        if (buId==0) { 
            return ps.getPaySystemCompanyStoreNickName();
        }
        Binfo bi = binfoMap.get(buId);
        if ((bi==null || bi.getStoreID()==null || bi.getStoreID().length()==0) && !quiet
                && ps.getPaySystemCompanyStoreNickName()!=null && ps.getPaySystemCompanyStoreNickName().trim().length()>0)
            throw new Exception("代收 便利商店代碼(StoreID) 尚未設定");
        return ((bi!=null)?bi.getStoreID():"");
    }

    public String getServiceID(int buId)
        throws Exception
    {
        return getServiceID(buId, false);
    }

    public String getServiceID(int buId, boolean quiet)
        throws Exception
    {
        prepare();
        if (buId==0) { 
            return ps.getPaySystemBankStoreNickName();
        }
        Binfo bi = binfoMap.get(buId);
        if ((bi==null || bi.getServiceID()==null || bi.getServiceID().length()==0) && !quiet
                && ps.getPaySystemBankStoreNickName()!=null && ps.getPaySystemBankStoreNickName().trim().length()>0)
            throw new Exception("代收 便利商店服務碼(ServiceID) 尚未設定");
        return ((bi!=null)?bi.getServiceID():"");
    }

    public Bunit getBunitFromVirtual(String virtualId)
        throws Exception
    {
        prepare();
        if (_bunits.size()==0) {
            return systemBunit();
        }
        // 先用暴力搜尋，之后有需要再換成聰明點, 東西是放在 Binfo 里的
        Iterator<Integer> iter = binfoMap.keySet().iterator();
        while (iter.hasNext()) {
            Integer buId = iter.next();
            Binfo bi = binfoMap.get(buId);
            if (bi.getVirtualID().equals(virtualId.trim()))
                return bunitMap.get(buId);
        }
        return null;
    }

    public Bunit getBunitFromStoreID(String storeId)
        throws Exception
    {
        prepare();
        if (_bunits.size()==0) {
            return systemBunit();
        }
        // 先用暴力搜尋，之后有需要再換成聰明點, 東西是放在 Binfo 里的
        Iterator<Integer> iter = binfoMap.keySet().iterator();
        while (iter.hasNext()) {
            Integer buId = iter.next();
            Binfo bi = binfoMap.get(buId);
            String sid = bi.getStoreID();
            if (sid==null || sid.trim().length()<3)
                continue;
            if (storeId.indexOf(sid)>=0) // JSM000 vs. JSM
                return bunitMap.get(buId);
        }
        return null;
    }

    String getname(String name)
    {
        if (name==null || name.length()==0)
            return "<font color=red>尚未設定</font>";
        return name;
    }

    public Binfo getBinfo(int buId)
        throws Exception
    {
        BinfoMgr bimgr = new BinfoMgr(tran_id);
        Binfo bi = bimgr.find("bunitId=" + buId);
        if (bi==null) {
            bi = new Binfo();
            bi.setBunitId(buId);
            bimgr.create(bi);
        }
        return bi;
    }

    public String getBankBalancingInfo(Bunit bu)
        throws Exception
    {        
        prepare();
        int buId = bu.getId();
        Binfo bi = binfoMap.get(buId); 
        String bankname = "";
        if (bi!=null && bi.getBankId()>0) {
            BankAccount ba = (BankAccount) BankAccountMgr.getInstance().find(bi.getBankId());
            bankname = ba.getBankAccountName();
        }        
        String virtualID = (bi!=null)?bi.getVirtualID():null;
        String storeID = (bi!=null)?bi.getStoreID():null;
        String serviceID = (bi!=null)?bi.getServiceID():null;
        
        StringBuffer sb = new StringBuffer();
        sb.append("代收帳戶:" + getname(bankname));
        sb.append("\n虛擬帳號:" + getname(virtualID));
        sb.append("\n便利商店代號:" + getname(storeID));
        sb.append("\n銷帳服務代號:" + getname(serviceID));
        return sb.toString();
    }

    public String getSharingInfo(Bunit bu)
        throws Exception
    {        
        prepare();
        int buId = bu.getId();
        Binfo bi = binfoMap.get(buId); 
        
        StringBuffer sb = new StringBuffer();
        int id = getAcodeBunitId(buId, true);
        sb.append("會計科目:" + ((id==0)?"無":("<font color=red>" + getBunitName(id) + "</font>")));
        id = getStudentBunitId(buId, true);
        sb.append("\n學生資料:" + ((id==0)?"無":("<font color=red>" + getBunitName(id) + "</font>")));
        id = getMetaBunitId(buId, true);
        sb.append("\n折扣資料:" + ((id==0)?"無":("<font color=red>" + getBunitName(id) + "</font>")));

        return sb.toString();
    }

    public String getCompanyNameTitle(int bunitId)
        throws Exception
    {
        String ret = getBillCompanyName(bunitId);
        if (ret.length()>0)
            return ret;
        return getBunit(bunitId).getLabel();
    }

    public String getBillCompanyName(int bunitId)
        throws Exception
    {
        prepare();
        if (bunitId==0) {
            return ps.getPaySystemCompanyName();
        }
        return getAttr(bunitId, "fullname");
    }

    public String getBillAddress(int bunitId)
        throws Exception
    {
        prepare();
        if (bunitId==0) {
            return ps.getPaySystemCompanyAddress();
        }
        return getAttr(bunitId, "address");
    }

    public String getBillPhone(int bunitId)
        throws Exception
    {
        prepare();
        if (bunitId==0) {
            return ps.getPaySystemCompanyPhone();
        }
        return getAttr(bunitId, "phone");
    }

    public String getBillNote(int bunitId)
        throws Exception
    {
        prepare();
        if (bunitId==0) {
            return ps.getPaySystemCompanyPhone();
        }
        return getAttr(bunitId, "phone");
    }


    public String getAttr(int bunitId, String attr)
        throws Exception
    {
        Binfo bi = getBinfo(bunitId);
        String ret = null;
        if (attr.equals("fullname"))
            ret = bi.getFullname();
        else if (attr.equals("address"))
            ret = bi.getAddress();
        else if (attr.equals("phone"))
            ret = bi.getPhone();
        else if (attr.equals("web"))
            ret = bi.getWeb();
        else if (attr.equals("billNote"))
            ret = bi.getBillNote();
        else if (attr.equals("smsText"))
            ret = bi.getSmsText();
        return (ret==null)?"":ret;
    }

    public void setAttr(int bunitId, String attr, String value)
        throws Exception
    {
        Binfo bi = getBinfo(bunitId);
        if (attr.equals("fullname"))
            bi.setFullname(value);
        else if (attr.equals("address"))
            bi.setAddress(value);
        else if (attr.equals("phone"))
            bi.setPhone(value);
        else if (attr.equals("web"))
            bi.setWeb(value);
        else if (attr.equals("billNote"))
            bi.setBillNote(value);
        else if (attr.equals("smsText"))
            bi.setSmsText(value);
    }

    public String getBillingInfo(Bunit bu)
        throws Exception
    {        
        prepare();
        int buId = bu.getId();
        
        StringBuffer sb = new StringBuffer();
        sb.append("機構名稱:" + getAttr(buId, "fullname"));
        sb.append("\n機構地址:" + getAttr(buId, "address"));
        sb.append("\n機構電話:" + getAttr(buId, "phone"));

        return sb.toString();
    }
}
