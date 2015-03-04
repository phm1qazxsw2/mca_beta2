package mca;

import phm.accounting.*;
import phm.ezcounting.*;
import literalstore.*;
import java.util.*;
import java.text.*;
import phm.util.*;
import jsf.*;

public class McaService
{
    int tran_id;
    Map<String, Bunit> bunitMap = null;

    public McaService() 
        throws Exception   
    {
        this(0);
    }
    public McaService(int tran_id)
        throws Exception
    {
        this.tran_id = tran_id;
    }

    private void fillStudentInfo(Student2 st, Membr membr, McaStudent ms)
        throws Exception
    {
        st.setStudentName(ms.getFullName());
        st.setStudentShortName(ms.getStudentCommonName());
        st.setStudentSex((ms.getSex().equals("M"))?1:0);
        st.setStudentFatherMobile(ms.getFatherCell());
        st.setStudentMotherMobile(ms.getMotherCell());
        st.setStudentFather(ms.getFatherName());
        st.setStudentMother(ms.getMotherName());
        st.setStudentBirth(ms.getMyBirthday());
        st.setStudentFatherEmail(ms.getFatherEmail());
        st.setStudentMotherEmail(ms.getMotherEmail());       
        st.setStudentEmailDefault(1);
        st.setStudentPhone(ms.getHomePhone());
        st.setStudentNickname(ms.getSponser());
        st.setStudentIDNumber(ms.getCoopID());
        
        if (bunitMap==null) {
            bunitMap = new SortingMap(new BunitMgr(tran_id).retrieveList("flag=" + Bunit.FLAG_BIZ, ""))
                .doSortSingleton("getLabel");
        }
        Bunit bu = bunitMap.get(ms.getCampus());
        membr.setBunitId(bu.getId());
        membr.setName(ms.getFullName());
        membr.setBirth(st.getStudentBirth());
    }

    public void updateStudents(ArrayList<McaStudent> mstuds)
        throws Exception
    {
        String membrIds = new RangeMaker().makeRange(mstuds, "getMembrId");
        String stuIds = new RangeMaker().makeRange(mstuds, "getStudId");
        MembrMgr mmgr = new MembrMgr(tran_id);
        Student2Mgr smgr = new Student2Mgr(tran_id);
        McaStudentMgr msmgr = new McaStudentMgr(tran_id);

        Map<Integer, Membr> membrMap = new SortingMap(mmgr.retrieveList("id in (" + membrIds + ")", "")).doSortSingleton("getId");
        Map<Integer, Student2> stuMap = new SortingMap(smgr.retrieveList("id in (" + stuIds + ")", "")).doSortSingleton("getId");

        prepareBunitMap();
        for (int i=0; i<mstuds.size(); i++) {
            McaStudent ms = mstuds.get(i);
            if (ms.getMembrId()==0) {
                Student2 st = new Student2();
                Membr membr = new Membr();
                fillStudentInfo(st, membr, ms);
                st.setBunitId(membr.getBunitId()); // set in fillStudentInfo
                st.setStudentStatus(1);
                smgr.create(st);

                membr.setSurrogateId(st.getId());
                membr.setActive(1);
                membr.setType(Membr.TYPE_STUDENT);
                mmgr.create(membr);

                ms.setMembrId(membr.getId());
                ms.setStudId(st.getId());
                msmgr.save(ms);
            }
            else {
                Membr membr = membrMap.get(ms.getMembrId());
                Student2 st = stuMap.get(membr.getSurrogateId());
                fillStudentInfo(st, membr, ms);
                smgr.save(st);
                mmgr.save(membr);
            }
        }
    }

    public final static String CAMPUS_BETHANY   = "Bethany";
    public final static String CAMPUS_TAICHUNG  = "Taichung";
    public final static String CAMPUS_KAOHSIUNG = "Kaohsiung";
    public final static String CAMPUS_CHIAYI    = "Chiayi";
    public final static String[] CAMPUSES = { CAMPUS_BETHANY, CAMPUS_TAICHUNG, CAMPUS_KAOHSIUNG, CAMPUS_CHIAYI };
    public final static int[] campus_code = { McaService.PROG_TUITION_BETHANY, McaService.PROG_TUITION_TAICHUNG, 
            McaService.PROG_TUITION_KAOHSIUNG, McaService.PROG_TUITION_CHIAYI };

    public final static String[] BILL_ACCOUNTS = {
        "馬禮遜學校學費專戶－台北",
        "馬禮遜學校學費專戶－台中",
        "馬禮遜學校學費專戶－高雄",
        "馬禮遜學校學費專戶－高雄" };

    public final static String[] BILL_ACCOUNT_IDS = {
        "185301",
        "185302",
        "185303",
        "185303" };

    public final static String[] BILL_NOTES = {
        "MORRISON ACADEMT-BETHANY CAMPUS\n台北伯大尼美國學校收據",
        "MORRISON ACADEMT\n馬禮遜學校學費收據",
        "MORRISON ACADEMT-KAOHSIUNG CAMPUS\n高雄馬禮遜學校學費收據",
        "MORRISON ACADEMT-CHIAYI CAMPUS\n嘉義馬禮遜學校學費收據" };

    
    public final static String[] BILL_ITEMS = {
        "Registration",
        "Tuition",
        "D-Tuition", 
        "Building Fee", 
        "ELL Fee", 
        "Milk", 
        "Music", 
        "Instrument", 
        "Music Room",
        "Bus", 
        "Lunch", 
        "Late Fee", 
        "Family Discount", 
        "Financial Aid", 
        "Mission Discount", 
        "Allowance", 
        "Dorm Program", 
        "Dorm Facility", 
        "Dorm Food", 
        "Dorm Room Deposit", 
        "Testing",
        "Special Needs Fee",
        "Interest",
        "## Late Fee",
        "## Interest",
		"Dorm Deposit Return",
        "Entrance"
    };

    public final static String[] SYSTEM_BILL_ITEMS = {
        "Registration",
        "Tuition",
        "D-Tuition", 
        "Building Fee", 
        "ELL Fee", 
        "Milk", 
        "Music", 
        "Instrument", 
        "Music Room",
        "Bus", 
        "Lunch", 
        "Late Fee", 
        "Family Discount", 
        // "Financial Aid", 
        "Mission Discount", 
        "Allowance", 
        "Dorm Program", 
        "Dorm Facility", 
        "Dorm Food", 
        "Dorm Room Deposit", 
        "Interest",
        "## Late Fee",
        "## Interest",
		"Dorm Deposit Return",
        "Entrance"
    };
    
	/*
    public final static String[] BILL_ITEMS_INTEREST_BASE = {
        "Tuition",
        "D-Tuition", 
        "Building Fee", 
        "ELL Fee", 
        "Family Discount", 
        "Financial Aid", 
        "Mission Discount", 
        "Allowance", 
        "Dorm Program", 
        "Dorm Facility", 
        "Dorm Food", 
        "Special Needs Fee"
    };
	*/

    static Map<String, String> __tmp_system_charge = null;
    public static boolean isSystemCharge(String name)
    {
        if (__tmp_system_charge==null) {
            __tmp_system_charge = new HashMap();
            for (int i=0; i<SYSTEM_BILL_ITEMS.length; i++) {
                __tmp_system_charge.put(SYSTEM_BILL_ITEMS[i], SYSTEM_BILL_ITEMS[i]);
            }
        }
        return (__tmp_system_charge.get(name)!=null);
    };

    public final static int PROG_TUITION_BETHANY    = 1;
    public final static int PROG_TUITION_TAICHUNG   = 2;
    public final static int PROG_TUITION_KAOHSIUNG  = 3;
    public final static int PROG_TUITION_CHIAYI     = 4;
    public final static int PROG_ESL_MODERATE       = 10;
    public final static int PROG_ESL_SIGNIFICANT    = 11;
    public final static int PROG_MILK               = 20;
    public final static int PROG_MUSIC_PRIVATE      = 30;
    public final static int PROG_MUSIC_SEMI         = 31;
    public final static int PROG_MUSIC_GROUP        = 32;
    public final static int PROG_MUSIC_INSTRUMENT   = 33;
    public final static int PROG_MUSIC_RENTROOM     = 34;
    public final static int PROG_MUSIC_PRIVATE_DOUBLE = 35;
    public final static int PROG_MUSIC_RENTROOM_DOUBLE  = 36;
    public final static int PROG_BUS                = 40;
    public final static int PROG_LUNCH_TCH_1        = 50;
    public final static int PROG_LUNCH_TCH_2        = 51;
    public final static int PROG_LUNCH_TCH_3        = 52;
    public final static int PROG_LUNCH_TCH_4        = 53;
    public final static int PROG_LUNCH_TCH_5        = 54;
    public final static int PROG_LUNCH_TCH_6        = 55;
    public final static int PROG_LUNCH_TCH_7        = 56;
    public final static int PROG_LUNCH_KAO_1        = 60;
    public final static int PROG_LUNCH_KAO_2        = 61;
    public final static int PROG_DORM_PROGRAM       = 70;
    //public final static int PROG_DORM_FACILITY      = 71;
    //public final static int PROG_DORM_FOOD          = 73;
    //public final static int PROG_DORM_KITCHEN       = 74;
    public final static int PROG_SAME_PARENT        = 80;
    public final static int PROG_TESTING            = 81;
    public final static int PROG_IDENTITY_M0        = 91;
    public final static int PROG_IDENTITY_M1        = 92;
    public final static int PROG_IDENTITY_M2        = 93;
    public final static int PROG_IDENTITY_CW        = 94;
    public final static int PROG_GRADE_K            = 100;
    public final static int PROG_GRADE_1            = 101;
    public final static int PROG_GRADE_2            = 102;
    public final static int PROG_GRADE_3            = 103;
    public final static int PROG_GRADE_4            = 104;
    public final static int PROG_GRADE_5            = 105;
    public final static int PROG_GRADE_6            = 106;
    public final static int PROG_GRADE_7            = 107;
    public final static int PROG_GRADE_8            = 108;
    public final static int PROG_GRADE_9            = 109;
    public final static int PROG_GRADE_10           = 110;
    public final static int PROG_GRADE_11           = 111;
    public final static int PROG_GRADE_12           = 112;
    public final static int PROG_FAMILY             = 120;

    void prepareBunitMap()
        throws Exception
    {
        if (bunitMap==null) {
            bunitMap = new SortingMap(new BunitMgr(tran_id).retrieveList("flag=" + Bunit.FLAG_BIZ, ""))
                .doSortSingleton("getLabel");            
        }
    }
    
    int _getBunitId(String campus)
        throws Exception
    {
        prepareBunitMap();
        Bunit b = bunitMap.get(campus);
        return b.getId();
    }

    public String getCampus(int bunitId)
        throws Exception
    {
        Bunit bu = new BunitMgr(tran_id).find("id=" + bunitId);
        return bu.getLabel();
    }
    
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    void makeBillAndBillItems(String campus)
        throws Exception
    {
        //###### initialize bill&billitems ##########
        BillMgr bmgr = new BillMgr(tran_id);
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        for (int i=0; i<CAMPUSES.length; i++) {
            if (!CAMPUSES[i].equals(campus))
                continue;
            Bill b = bmgr.find(getBillFindId(CAMPUSES[i]));
            if (b==null) {
                b = new Bill();
                b.setName("_" + CAMPUSES[i]);
                b.setPrettyName(CAMPUSES[i]);
                b.setStatus(Bill.STATUS_ACTIVE);
                b.setBalanceWay(Bill.FIFO);
                b.setBillType(Bill.TYPE_BILLING);
                b.setPrivLevel(Bill.PRIV_FINANCE);
                b.setComName("合作金庫銀行");
                b.setComAddr(BILL_ACCOUNTS[i]);
                b.setRegInfo(BILL_ACCOUNT_IDS[i]);
                b.setPayNote(BILL_NOTES[i]);
                b.setBunitId(_getBunitId(CAMPUSES[i]));
                bmgr.create(b);
            }

            for (int j=0; j<BILL_ITEMS.length; j++) {
                BillItem bi = bimgr.find("billId=" + b.getId() + " and name='" + BILL_ITEMS[j] + "' and status=1");
                if (bi==null) {
                    bi = new BillItem();
                    bi.setBillId(b.getId());
                    bi.setName(BILL_ITEMS[j]);
                    bi.setStatus(BillItem.STATUS_ACTIVE);
                    bi.setCopyStatus(BillItem.COPY_NO);
                    bi.setPos(j);
                    bimgr.create(bi);
                }
            }
        }
        // ###########################################
    }

    void makeBillRecords(McaFee fee, String campus)
        throws Exception
    {
        BillRecordMgr brmgr = new BillRecordMgr(tran_id);
        McaRecordMgr mrmgr = new McaRecordMgr(tran_id);
        McaFeeRecordMgr mfrmgr = new McaFeeRecordMgr(tran_id);
        ArrayList<Bill> bills = new BillMgr(tran_id).retrieveList("name like '_"+campus+"%'", "");
        for (int i=0; i<bills.size(); i++) {
            Bill b = bills.get(i);
            if (mfrmgr.numOfRows("mcaFeeId=" + fee.getId() + " and billrecord.billId=" + b.getId())>0)
                continue;
            BillRecord br = new BillRecord();
            br.setBillId(b.getId());
            br.setName(b.getPrettyName() + " " + fee.getTitle());
            br.setMonth(fee.getMonth());
            br.setBillDate(fee.getBillDate());
            brmgr.create(br);

            McaRecord mr = new McaRecord();
            mr.setBillRecordId(br.getId());
            mr.setMcaFeeId(fee.getId());
            mrmgr.create(mr);
        }
    }
    
    String getBillFindId(String campus)
    {
        return "name='_" + campus.replace("'", "''") + "'";
    }

    String getBillRecordFindId(int billId, McaFee fee)
    {
        return "billId=" + billId + " and mcaFeeId=" + fee.getId();
    }

    ChargeItem getChargeItem(String campus, McaFee fee, String billitemName)
        throws Exception
    {
        Bill b = new BillMgr(tran_id).find(getBillFindId(campus));
        BillRecord br = new McaFeeRecordMgr(tran_id).find(getBillRecordFindId(b.getId(), fee));
        BillItem bi = new BillItemMgr(tran_id).find("billId=" + b.getId() + " and name='" + billitemName + "' and status=1");
        if (bi==null) {
            bi = new BillItem();
            bi.setBillId(b.getId());
            bi.setName(billitemName);
            bi.setStatus(BillItem.STATUS_ACTIVE);
            bi.setCopyStatus(BillItem.COPY_NO);
            bi.setPos(30);
            new BillItemMgr(tran_id).create(bi);
        }
        ChargeItem ret = new ChargeItemMgr(tran_id).find("billRecordId=" + br.getId() + 
            " and billItemId=" + bi.getId());
        if (ret==null) {
            ret = EzCountingService.getInstance().makeChargeItem(tran_id, br.getId(), bi.getId());
        }
        return ret;
    }

    Map<Integer, McaStudent> studentMap = null;
    McaFee cur_fee = null;
    public void setupMembrsInfoCurrentFee(String membrIds)
        throws Exception
    {
        ArrayList<Bunit> bunits = new BunitMgr(tran_id).retrieveList("flag=" + Bunit.FLAG_BIZ, "");
        Tag tag = getCurrentCampusTag(bunits.get(0).getId());
        CitemTagMgr ctmgr = new CitemTagMgr(tran_id);
        CitemTag citag = ctmgr.find("tagId=" + tag.getId());
        int feeId = citag.getChargeItemId();
        McaFee fee = new McaFeeMgr(tran_id).find("id=" + feeId);
        setupMembrsInfo(fee, membrIds);
    }

    public void setupMembrsInfo(McaFee fee, String membrIds)
        throws Exception
    {
        prepareMembrTags(fee, membrIds);
    }

    public String getParent(int membrId)
    {
        McaStudent s = studentMap.get(membrId);
        return s.getParentNames();
    }

    public String getCoopID(int membrId)
    {
        McaStudent s = studentMap.get(membrId);
        return s.getCoopID();
    }

    public String getNewCoopID(int membrId)
    {
        McaStudent s = studentMap.get(membrId);
        return "1" + cur_fee.getFeeType() + PaymentPrinter.makePrecise(s.getStudentID()+"", 5, false, '0');
    }

    public String getLunch(int membrId)
        throws Exception
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        if (myProgMap.get(PROG_LUNCH_TCH_1)!=null) return "Tue&Thu";
        else if (myProgMap.get(PROG_LUNCH_TCH_2)!=null) return "Daily";
        else if (myProgMap.get(PROG_LUNCH_TCH_3)!=null) return "Tue&Thu";
        else if (myProgMap.get(PROG_LUNCH_TCH_4)!=null) return "Daily";
        else if (myProgMap.get(PROG_LUNCH_TCH_5)!=null) return "Daily";
        else if (myProgMap.get(PROG_LUNCH_TCH_6)!=null) return "Daily";
        else if (myProgMap.get(PROG_LUNCH_TCH_7)!=null) return "Tue&Thu";
        else if (myProgMap.get(PROG_LUNCH_KAO_1)!=null) return "Large";
        else if (myProgMap.get(PROG_LUNCH_KAO_2)!=null) return "Moderate";       
        return "";
    }

    public String getMilk(int membrId)
        throws Exception
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        ArrayList<TagMembrInfo> t = myProgMap.get(PROG_MILK);
        if (t==null)
            return "";
        String name = t.get(0).getTagName();
        int c = name.indexOf("#");
        if (c>0)
            name = name.substring(c+1);
        return name;
    }
    
    public String getDorm(int membrId)
        throws Exception
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        ArrayList<TagMembrInfo> t = myProgMap.get(PROG_DORM_PROGRAM);
        if (t==null)
            return "";
        return t.get(0).getTagName();
    }

    public String getPassportCountry(String countryCode)
        throws Exception
    {
        if (areaMap==null) {
            areaMap = new SortingMap(AreaMgr.getInstance().retrieveList("", "")).doSortSingleton("getMyKey");
        }
        Area a = areaMap.get("0#" + countryCode);
        if (a==null)
            return "";
        return a.getEName();
    }

    public String getBus(int membrId)
        throws Exception
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        ArrayList<TagMembrInfo> t = myProgMap.get(PROG_BUS);
        if (t==null)
            return "";
        String name = t.get(0).getTagName();
        int c = name.indexOf("#");
        if (c>0)
            name = name.substring(c+1);
        return name;
    }    

    public String getMusic(int membrId)
        throws Exception
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        String ret = "";
        if (myProgMap.get(PROG_MUSIC_PRIVATE)!=null) ret = "Prv";
        else if (myProgMap.get(PROG_MUSIC_SEMI)!=null) ret = "SemiPrv";
        else if (myProgMap.get(PROG_MUSIC_GROUP)!=null) ret = "Grp";
        else if (myProgMap.get(PROG_MUSIC_PRIVATE_DOUBLE)!=null) ret = "2*Prv";
        

        if (myProgMap.get(PROG_MUSIC_INSTRUMENT)!=null) ret += "+Inst";
        if (myProgMap.get(PROG_MUSIC_RENTROOM)!=null) ret += "+Rm";
        
        return ret;
    }

    public String getGrade(int membrId)
        throws Exception
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        if (myProgMap==null)
            return "";
        if (myProgMap.get(PROG_GRADE_K)!=null) return "K";
        else if (myProgMap.get(PROG_GRADE_1)!=null) return "1";
        else if (myProgMap.get(PROG_GRADE_2)!=null) return "2";
        else if (myProgMap.get(PROG_GRADE_3)!=null) return "3";
        else if (myProgMap.get(PROG_GRADE_4)!=null) return "4";
        else if (myProgMap.get(PROG_GRADE_5)!=null) return "5";
        else if (myProgMap.get(PROG_GRADE_6)!=null) return "6";
        else if (myProgMap.get(PROG_GRADE_7)!=null) return "7";
        else if (myProgMap.get(PROG_GRADE_8)!=null) return "8";
        else if (myProgMap.get(PROG_GRADE_9)!=null) return "9";
        else if (myProgMap.get(PROG_GRADE_10)!=null) return "10";
        else if (myProgMap.get(PROG_GRADE_11)!=null) return "11";
        else if (myProgMap.get(PROG_GRADE_12)!=null) return "12";
        
        return "";
    }

    ArrayList<TagMembrInfo> getMembrsForProg(int progId)
        throws Exception
    {
        ArrayList<TagMembrInfo> ret = progtagmembrMap.get(progId);
        if (ret==null)
            return new ArrayList<TagMembrInfo>();
        return ret;
    }

    boolean isM1(int membrId)
    {
        McaStudent ms = studentMap.get(membrId);
        if (ms.getTDisc()>0)
            return true;
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        return myProgMap.get(PROG_IDENTITY_M1)!=null;
    }
        

    int getRegistrationAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
            reason.append("M1/M2");
            return fee.getRegD();
        }
        else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
            reason.append("M0");
            return fee.getRegC();
        }
        else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
            reason.append("CW");
            return fee.getRegB();
        }
        reason.append("Regular");
        return fee.getRegA();
    }

    // 這裡只 return regular 的金額是因為 discount 的部分要放在 mission discount
    int getTuitionAmount(McaFee fee, int membrId, StringBuffer reason, int progId)
    {
        int ret = 0;
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
		if (fee.getId()>76) {
			
			//2014-03-09 需求：原 k-5,6-9,10-12 改成 k-5,6-8,9-12, 
			//2014-4以后秋季学费账单以后才生效（after 现在feeId=76是2014-2015Registration)

			if (myProgMap.get(PROG_GRADE_K)!=null || myProgMap.get(PROG_GRADE_1)!=null ||
				   myProgMap.get(PROG_GRADE_2)!=null || myProgMap.get(PROG_GRADE_3)!=null || 
					 myProgMap.get(PROG_GRADE_4)!=null || myProgMap.get(PROG_GRADE_5)!=null) 
			{
				if (fee.getId()<=67) {
					reason.append("K-5");
					ret = fee.getTuitionK5A();
				}
				else if (progId==PROG_TUITION_BETHANY) {
					reason.append("TP K-5");
					ret = fee.getTP_TuitionK5A();
				}
				else if (progId==PROG_TUITION_KAOHSIUNG || progId==PROG_TUITION_CHIAYI)
				{
					reason.append("K K-5");
					ret = fee.getK_TuitionK5A();
				}
				else {
					reason.append("TC K-5");
					ret = fee.getTuitionK5A();
				}
			}
			else if (myProgMap.get(PROG_GRADE_6)!=null || myProgMap.get(PROG_GRADE_7)!=null ||
				   myProgMap.get(PROG_GRADE_8)!=null)
			{
				if (fee.getId()<=67) {
					reason.append("6-8");
					ret = fee.getTuition69A();
				}
				else if (progId==PROG_TUITION_BETHANY) {
					reason.append("TP 6-8");
					ret = fee.getTP_Tuition69A();
				}
				else if (progId==PROG_TUITION_KAOHSIUNG || progId==PROG_TUITION_CHIAYI)
				{
					reason.append("K 6-8");
					ret = fee.getK_Tuition69A();
				}
				else {
					reason.append("TC 6-8");
					ret = fee.getTuition69A();
				}
			}
			else {
				if (fee.getId()<=67) {
					reason.append("9-12");
					ret = fee.getTuition1012A();
				}
				else if (progId==PROG_TUITION_BETHANY) {
					reason.append("TP 9-12");
					ret = fee.getTP_Tuition1012A();
				}
				else if (progId==PROG_TUITION_KAOHSIUNG || progId==PROG_TUITION_CHIAYI)
				{
					reason.append("K 9-12");
					ret = fee.getK_Tuition1012A();
				}
				else {
					reason.append("TC 9-12");
					ret = fee.getTuition1012A();
				}
			}
		}
		else {
/*
// debug info:
if (membrId==2816) {
	System.out.println("membrId=2816, progId=" + progId);
	for (Integer tmp:myProgMap.keySet()) {
		System.out.println("my grad = " + tmp.intValue());
	}
}
*/
			if (myProgMap.get(PROG_GRADE_K)!=null || myProgMap.get(PROG_GRADE_1)!=null ||
				   myProgMap.get(PROG_GRADE_2)!=null || myProgMap.get(PROG_GRADE_3)!=null || 
					 myProgMap.get(PROG_GRADE_4)!=null || myProgMap.get(PROG_GRADE_5)!=null) 
			{
				if (fee.getId()<=67) {
					reason.append("K-5");
					ret = fee.getTuitionK5A();
				}
				else if (progId==PROG_TUITION_BETHANY) {
					reason.append("TP K-5");
					ret = fee.getTP_TuitionK5A();
				}
				else if (progId==PROG_TUITION_KAOHSIUNG || progId==PROG_TUITION_CHIAYI)
				{
					reason.append("K K-5");
					ret = fee.getK_TuitionK5A();
				}
				else {
					reason.append("TC K-5");
					ret = fee.getTuitionK5A();
				}
			}
			else if (myProgMap.get(PROG_GRADE_6)!=null || myProgMap.get(PROG_GRADE_7)!=null ||
				   myProgMap.get(PROG_GRADE_8)!=null || myProgMap.get(PROG_GRADE_9)!=null)
			{
				if (fee.getId()<=67) {
					reason.append("6-9");
					ret = fee.getTuition69A();
				}
				else if (progId==PROG_TUITION_BETHANY) {
					reason.append("TP 6-9");
					ret = fee.getTP_Tuition69A();
				}
				else if (progId==PROG_TUITION_KAOHSIUNG || progId==PROG_TUITION_CHIAYI)
				{
					reason.append("K 6-9");
					ret = fee.getK_Tuition69A();
				}
				else {
					reason.append("TC 6-9");
					ret = fee.getTuition69A();
				}
			}
			else {
				if (fee.getId()<=67) {
					reason.append("10-12");
					ret = fee.getTuition1012A();
				}
				else if (progId==PROG_TUITION_BETHANY) {
					reason.append("TP 10-12");
					ret = fee.getTP_Tuition1012A();
				}
				else if (progId==PROG_TUITION_KAOHSIUNG || progId==PROG_TUITION_CHIAYI)
				{
					reason.append("K 10-12");
					ret = fee.getK_Tuition1012A();
				}
				else {
					reason.append("TC 10-12");
					ret = fee.getTuition1012A();
				}
			}
		}
        return checkFixProrate(membrId, ret, reason);
    }

    int getMissionDiscount(McaFee fee, int membrId, StringBuffer reason, String campus)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);

        int ret = 0;

		if (fee.getId()>76) {
			
			//2014-03-09 需求：原 k-5,6-9,10-12 改成 k-5,6-8,9-12, 
			//2014-4以后秋季学费账单以后才生效（after 现在feeId=76是2014-2015Registration)

			if (myProgMap.get(PROG_GRADE_K)!=null || myProgMap.get(PROG_GRADE_1)!=null ||
				   myProgMap.get(PROG_GRADE_2)!=null || myProgMap.get(PROG_GRADE_3)!=null || 
					 myProgMap.get(PROG_GRADE_4)!=null || myProgMap.get(PROG_GRADE_5)!=null) 
			{
				//## 2009/3/12 by peter, M1 must check first
				if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
					reason.append("K-5 M1/M2");
					if (fee.getId()<=67) {
						ret = fee.getTuitionK5D() - fee.getTuitionK5A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_TuitionK5D() - fee.getTP_TuitionK5A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuitionK5D() - fee.getTuitionK5A();
					}
					else {
						ret = fee.getK_TuitionK5D() - fee.getK_TuitionK5A();
					}
				}
				else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
					reason.append("K-5 M0");
					if (fee.getId()<=67) {
						ret = fee.getTuitionK5C() - fee.getTuitionK5A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_TuitionK5C() - fee.getTP_TuitionK5A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuitionK5C() - fee.getTuitionK5A();
					}
					else {
						ret = fee.getK_TuitionK5C() - fee.getK_TuitionK5A();
					}
					
				}
				else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
					reason.append("K-5 CW");
					if (fee.getId()<=67) {
						ret = fee.getTuitionK5B() - fee.getTuitionK5A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_TuitionK5B() - fee.getTP_TuitionK5A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuitionK5B() - fee.getTuitionK5A();
					}
					else {
						ret = fee.getK_TuitionK5B() - fee.getK_TuitionK5A();
					}
				}
			}
			else if (myProgMap.get(PROG_GRADE_6)!=null || myProgMap.get(PROG_GRADE_7)!=null ||
				   myProgMap.get(PROG_GRADE_8)!=null)
			{
				if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
					reason.append("6-8 M1/M2");
					if (fee.getId()<=67) {
						ret = fee.getTuition69D() - fee.getTuition69A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition69D() - fee.getTP_Tuition69A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition69D() - fee.getTuition69A();
					}
					else {
						ret = fee.getK_Tuition69D() - fee.getK_Tuition69A();
					}
				}
				else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
					reason.append("6-8 CW");
					if (fee.getId()<=67) {
						ret = fee.getTuition69B() - fee.getTuition69A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition69B() - fee.getTP_Tuition69A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition69B() - fee.getTuition69A();
					}
					else {
						ret = fee.getK_Tuition69B() - fee.getK_Tuition69A();
					}
					
				}
				else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
					reason.append("6-8 M0");
					if (fee.getId()<=67) {
						ret = fee.getTuition69C() - fee.getTuition69A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition69C() - fee.getTP_Tuition69A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition69C() - fee.getTuition69A();
					}
					else {
						ret = fee.getK_Tuition69C() - fee.getK_Tuition69A();
					}
				}
			}
			else {
				if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
					reason.append("9-12 M1/M2");
					if (fee.getId()<=67) {
						ret = fee.getTuition1012D() - fee.getTuition1012A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition1012D() - fee.getTP_Tuition1012A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition1012D() - fee.getTuition1012A();
					}
					else {
						ret = fee.getK_Tuition1012D() - fee.getK_Tuition1012A();
					}
				}
				else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
					reason.append("9-12 CW");
					if (fee.getId()<=67) {
						ret = fee.getTuition1012B() - fee.getTuition1012A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition1012B() - fee.getTP_Tuition1012A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition1012B() - fee.getTuition1012A();
					}
					else {
						ret = fee.getK_Tuition1012B() - fee.getK_Tuition1012A();
					}
				}
				else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
					reason.append("9-12 M0");
					if (fee.getId()<=67) {
						ret = fee.getTuition1012C() - fee.getTuition1012A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition1012C() - fee.getTP_Tuition1012A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition1012C() - fee.getTuition1012A();
					}
					else {
						ret = fee.getK_Tuition1012C() - fee.getK_Tuition1012A();
					}
				}
			}
		}
		else {

			if (myProgMap.get(PROG_GRADE_K)!=null || myProgMap.get(PROG_GRADE_1)!=null ||
				   myProgMap.get(PROG_GRADE_2)!=null || myProgMap.get(PROG_GRADE_3)!=null || 
					 myProgMap.get(PROG_GRADE_4)!=null || myProgMap.get(PROG_GRADE_5)!=null) 
			{
				//## 2009/3/12 by peter, M1 must check first
				if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
					reason.append("K-5 M1/M2");
					if (fee.getId()<=67) {
						ret = fee.getTuitionK5D() - fee.getTuitionK5A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_TuitionK5D() - fee.getTP_TuitionK5A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuitionK5D() - fee.getTuitionK5A();
					}
					else {
						ret = fee.getK_TuitionK5D() - fee.getK_TuitionK5A();
					}
				}
				else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
					reason.append("K-5 M0");
					if (fee.getId()<=67) {
						ret = fee.getTuitionK5C() - fee.getTuitionK5A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_TuitionK5C() - fee.getTP_TuitionK5A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuitionK5C() - fee.getTuitionK5A();
					}
					else {
						ret = fee.getK_TuitionK5C() - fee.getK_TuitionK5A();
					}
					
				}
				else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
					reason.append("K-5 CW");
					if (fee.getId()<=67) {
						ret = fee.getTuitionK5B() - fee.getTuitionK5A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_TuitionK5B() - fee.getTP_TuitionK5A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuitionK5B() - fee.getTuitionK5A();
					}
					else {
						ret = fee.getK_TuitionK5B() - fee.getK_TuitionK5A();
					}
				}
			}
			else if (myProgMap.get(PROG_GRADE_6)!=null || myProgMap.get(PROG_GRADE_7)!=null ||
				   myProgMap.get(PROG_GRADE_8)!=null || myProgMap.get(PROG_GRADE_9)!=null)
			{
				if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
					reason.append("6-9 M1/M2");
					if (fee.getId()<=67) {
						ret = fee.getTuition69D() - fee.getTuition69A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition69D() - fee.getTP_Tuition69A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition69D() - fee.getTuition69A();
					}
					else {
						ret = fee.getK_Tuition69D() - fee.getK_Tuition69A();
					}
					
				}
				else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
					reason.append("6-9 CW");
					if (fee.getId()<=67) {
						ret = fee.getTuition69B() - fee.getTuition69A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition69B() - fee.getTP_Tuition69A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition69B() - fee.getTuition69A();
					}
					else {
						ret = fee.getK_Tuition69B() - fee.getK_Tuition69A();
					}
					
				}
				else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
					reason.append("6-9 M0");
					if (fee.getId()<=67) {
						ret = fee.getTuition69C() - fee.getTuition69A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition69C() - fee.getTP_Tuition69A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition69C() - fee.getTuition69A();
					}
					else {
						ret = fee.getK_Tuition69C() - fee.getK_Tuition69A();
					}
				}
			}
			else {
				if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
					reason.append("10-12 M1/M2");
					if (fee.getId()<=67) {
						ret = fee.getTuition1012D() - fee.getTuition1012A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition1012D() - fee.getTP_Tuition1012A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition1012D() - fee.getTuition1012A();
					}
					else {
						ret = fee.getK_Tuition1012D() - fee.getK_Tuition1012A();
					}
				}
				else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
					reason.append("10-12 CW");
					if (fee.getId()<=67) {
						ret = fee.getTuition1012B() - fee.getTuition1012A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition1012B() - fee.getTP_Tuition1012A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition1012B() - fee.getTuition1012A();
					}
					else {
						ret = fee.getK_Tuition1012B() - fee.getK_Tuition1012A();
					}
				}
				else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
					reason.append("10-12 M0");
					if (fee.getId()<=67) {
						ret = fee.getTuition1012C() - fee.getTuition1012A();
					}
					else if (campus.equals("Bethany")) {
						ret = fee.getTP_Tuition1012C() - fee.getTP_Tuition1012A();
					}
					else if (campus.equals("Taichung")) {
						ret = fee.getTuition1012C() - fee.getTuition1012A();
					}
					else {
						ret = fee.getK_Tuition1012C() - fee.getK_Tuition1012A();
					}
				}
			}
		}
        return checkFixProrate(membrId, ret, reason);
    }

    void createFeeRegistration(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[0]; // Registration
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                StringBuffer reason = new StringBuffer();
                c.setAmount(getRegistrationAmount(fee, mid, reason));
                c.setNote(reason.toString());
                // cmgr.create(c);
                charges.add(c);
            }
        }
    }

    void createFeeRegistrationWithCheck(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[0]; // Registration
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
            // 要 check 前面是否已繳註冊費了
            ArrayList<McaFeeRecord> prev_brs = new McaFeeRecordMgr(tran_id).retrieveList("mca_fee.id=" + fee.getCheckFeeId(), "");
            String brIds = new RangeMaker().makeRange(prev_brs, "getId");
            ArrayList<MembrInfoBillRecord> prev_bills = new MembrInfoBillRecordMgr(tran_id).retrieveList("billRecordId in (" + brIds + ")", "");
            Map<Integer, MembrInfoBillRecord> prevbillMap = new SortingMap(prev_bills).doSortSingleton("getMembrId");
            String ticketIds = new RangeMaker().makeRange(prev_bills, "getTicketIdAsString");
            Map<String, ArrayList<BillPaidInfo>> billpaidMap = new SortingMap(new BillPaidInfoMgr(tran_id).retrieveList(
                "billpaid.ticketId in (" + ticketIds + ")", "")).doSortA("getTicketId");

            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                MembrInfoBillRecord prev_bill = prevbillMap.get(mid);
                int amount = 0;
                StringBuffer reason = new StringBuffer();
                if (prev_bill!=null && fee.getRegPrepayDeadline()!=null 
                        && prev_bill.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID) 
                {
				    Calendar cal = Calendar.getInstance();
                    //cal.setTime(fee.getRegPrepayDeadline());
					cal.setTime(prev_bill.getMyBillDate()); // 2011/5/16 改成用该学生的 billdate 判断，不用统一的 regprepaydeadline
					cal.add(Calendar.DATE, 1);
                    Date DayAfterDeadline = cal.getTime();

                    ArrayList<BillPaidInfo> paids = billpaidMap.get(prev_bill.getTicketId());
                    for (int k=0; paids!=null&&k<paids.size(); k++) {
                        if (paids.get(k).getPaidTime().compareTo(DayAfterDeadline)>=0) {
                            amount = fee.getRegPenalty();
                            reason.append(" late payment on " + sdf.format(paids.get(k).getPaidTime()) + ", penalty:" + fee.getRegPenalty());
                            break;
                        }
                    }
                }
                else {
                    amount = getRegistrationAmount(fee, mid, reason) + fee.getRegPenalty();
                    reason.append(" no prepay, penalty:" + fee.getRegPenalty());
                }
                if (amount==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(amount);
                c.setNote(reason.toString());
                // cmgr.create(c);
                charges.add(c);
            }
        }
    }

    void createFeeTuition(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[1]; // Tuition
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                StringBuffer reason = new StringBuffer();
                int amount = getTuitionAmount(fee, mid, reason, progId);
                if (fee.getId()>=84 && amount==0) { // 2015-02-26 之後改
                	continue;
                }
                c.setAmount(amount);
                c.setNote(reason.toString());
                // cmgr.create(c);
                charges.add(c);
            }
        }
    }

    void createFeeMissionDiscount(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[14]; // Mission Discount
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int mdiscount = getMissionDiscount(fee, mid, reason, CAMPUSES[i]);
                if (mdiscount==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(mdiscount);
                c.setNote(reason.toString());
                // cmgr.create(c);
                charges.add(c);
            }
        }
    }

    int getBuildingFeeAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        int ret = 0;
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
            reason.append("M1/M2");
            ret = fee.getBuildingD();
        }
        else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
            reason.append("CW");
            ret = fee.getBuildingB();
        }
        else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
            reason.append("M0");
            ret = fee.getBuildingC();
        }
        else {
            reason.append("Regular");
            ret = fee.getBuildingA();
        }
        return checkFixProrate(membrId, ret, reason);
    }

    void createBuildingFee(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[3]; // Building Fee
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);
            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                StringBuffer reason = new StringBuffer();
                int amount = getBuildingFeeAmount(fee, mid, reason);
                if (fee.getId()>=84 && amount==0) // 2015-02-26 之後改
                	continue;
                c.setAmount(amount);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }

    int getEslAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        if (myProgMap.get(PROG_ESL_MODERATE)!=null) {
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
                reason.append("Moderate M1/M2");
                ret = fee.getELLModerateD();
            }
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
                reason.append("Moderate CW");
                ret = fee.getELLModerateB();
            }
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
                reason.append("Moderate M0");
                ret = fee.getELLModerateC();
            }
            else {
                reason.append("Moderate Regular");
                ret = fee.getELLModerateA();
            }
        }
        else if (myProgMap.get(PROG_ESL_SIGNIFICANT)!=null) {
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
                reason.append("Significant M1/M2");
                ret = fee.getELLSignificantD();
            }
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
                reason.append("Significant CW");
                ret = fee.getELLSignificantB();
            }
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
                reason.append("Significant M0");
                ret = fee.getELLSignificantC();
            }
            else {
                reason.append("Significant Regular");
                ret = fee.getELLSignificantA();
            }
        }
        return checkOptionalProrate(membrId, ret, reason);
    }

    void createESLCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[4]; // ESL
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);
            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int esl = getEslAmount(fee, mid, reason);
                if (esl==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(esl);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }

    int getMilkAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        ArrayList<TagMembrInfo> tags = myProgMap.get(PROG_MILK);
        if (tags!=null) {
            reason.append(tags.get(0).getTagName());
            ret = fee.getMilk();
        }

        return checkOptionalProrate(membrId, ret, reason);
    }

    void createMilkCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[5]; // Milk
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int milk = getMilkAmount(fee, mid, reason);
                if (milk==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(milk);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }


    int getMusicAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        if (myProgMap.get(PROG_MUSIC_PRIVATE_DOUBLE)!=null) {
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
                reason.append("Private*2 M1/M2");
                ret += fee.getMusicPrivateD()*2;
            }
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
                reason.append("Private*2 CW");
                ret += fee.getMusicPrivateB()*2;
            }
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
                reason.append("Private*2 M0");
                ret += fee.getMusicPrivateC()*2;
            }
            else {
                reason.append("Private*2 Regular");
                ret += fee.getMusicPrivateA()*2;
            }
        }
        
        if (myProgMap.get(PROG_MUSIC_PRIVATE)!=null) {
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
                reason.append("Private M1/M2");
                ret += fee.getMusicPrivateD();
            }
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
                reason.append("Private CW");
                ret += fee.getMusicPrivateB();
            }
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
                reason.append("Private M0");
                ret += fee.getMusicPrivateC();
            }
            else {
                reason.append("Private Regular");
                ret += fee.getMusicPrivateA();
            }
        }
        
        if (myProgMap.get(PROG_MUSIC_SEMI)!=null) {
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
                reason.append("Semi-Private M1/M2");
                ret += fee.getMusicSemiPrivateD();
            }
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
                reason.append("Semi-Private CW");
                ret += fee.getMusicSemiPrivateB();
            }
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
                reason.append("Semi-Private M0");
                ret += fee.getMusicSemiPrivateC();
            }
            else {
                reason.append("Semi-Private Regular");
                ret += fee.getMusicSemiPrivateA();
            }
        }
        
        if (myProgMap.get(PROG_MUSIC_GROUP)!=null) {
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
                reason.append("Group M1/M2");
                ret += fee.getMusicSemiGroupD();
            }
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
                reason.append("Group CW");
                ret += fee.getMusicSemiGroupB();
            }
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
                reason.append("Group M0");
                ret += fee.getMusicSemiGroupC();
            }
            else {
                reason.append("Group Regular");
                ret += fee.getMusicSemiGroupA();
            }
        }        
        return checkOptionalProrate(membrId, ret, reason);
    }

    void createMusicCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[6]; // Music
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int music = getMusicAmount(fee, mid, reason);
                if (music==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(music);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }

    int getInstrumentAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        if (myProgMap.get(PROG_MUSIC_INSTRUMENT)!=null) {
            ret = fee.getInstrument();
        }
        return checkOptionalProrate(membrId, ret, reason);
    }

    void createInstrumentCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[7]; // Instrument
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);
            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int instr = getInstrumentAmount(fee, mid, reason);
                if (instr==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(instr);
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }

    int getMusicRoomAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        if (myProgMap.get(PROG_MUSIC_RENTROOM_DOUBLE)!=null) {
            reason.append("double");
            ret = fee.getMusicRoom()*2;
        }
        else if (myProgMap.get(PROG_MUSIC_RENTROOM)!=null) {
            reason.append("single");
            ret = fee.getMusicRoom();
        }
        return checkOptionalProrate(membrId, ret, reason);
    }

    void createMusicRoomCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[8]; // MusicRoom
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int musicroom = getMusicRoomAmount(fee, mid, reason);
                if (musicroom==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(musicroom);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }

    int getDormProgramAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        if (myProgMap.get(PROG_DORM_PROGRAM)!=null) {
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
                reason.append("M1/M2");
                ret = fee.getDormProgramD();
            }
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
                reason.append("CW");
                ret = fee.getDormProgramB();
            }
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
                reason.append("M0");
                ret = fee.getDormProgramC();
            }
            else {
                reason.append("Regular");
                ret = fee.getDormProgramA();
            }
        }

        return checkFixProrate(membrId, ret, reason);
    }

    void createDormProgramCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[16]; // DormProgram
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int dormprogram = getDormProgramAmount(fee, mid, reason);
                if (dormprogram==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(dormprogram);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }


    int getDormFacilityAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        // if (myProgMap.get(PROG_DORM_FACILITY)!=null) {
        if (myProgMap.get(PROG_DORM_PROGRAM)!=null) { // ### 2009/3/6 by peter per ChiaHou's request
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
                reason.append("M1/M2");
                ret = fee.getDormFacilityD();
            }
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
                reason.append("CW");
                ret = fee.getDormFacilityB();
            }
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
                reason.append("M0");
                ret = fee.getDormFacilityC();
            }
            else {
                reason.append("Regular");
                ret = fee.getDormFacilityA();
            }
        }

        return checkFixProrate(membrId, ret, reason);
    }

    void createDormFacilityCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[17]; // DormFacility
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int dormfacility = getDormFacilityAmount(fee, mid, reason);
                if (dormfacility==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(dormfacility);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }



    int getDormFoodAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        if (myProgMap.get(PROG_DORM_PROGRAM)!=null) { // ChiaHou's request
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
                reason.append("M1/M2");
                ret = fee.getDormFoodD();
            }
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
                reason.append("CW");
                ret = fee.getDormFoodB();
            }
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
                reason.append("M0");
                ret = fee.getDormFoodC();
            }
            else {
                reason.append("Regular");
                ret = fee.getDormFoodA();
            }
        }

        return checkFixProrate(membrId, ret, reason);
    }

    void createDormFoodCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[18]; // DormFood
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int dormfood = getDormFoodAmount(fee, mid, reason);
                if (dormfood==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(dormfood);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }


    int getLunchAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        if (myProgMap.get(PROG_LUNCH_TCH_1)!=null) {
            reason.append("Tch K-2 Tue&Thu");
            ret = fee.getTchLunch1();
        }
        else if (myProgMap.get(PROG_LUNCH_TCH_2)!=null) {
            reason.append("Taichung K-2 Daily");
            ret = fee.getTchLunch2();
        }
        else if (myProgMap.get(PROG_LUNCH_TCH_3)!=null) {
            reason.append("Taichung 3-5 Tue&Thu");
            ret = fee.getTchLunch3();
        }
        else if (myProgMap.get(PROG_LUNCH_TCH_4)!=null) {
            reason.append("Taichung 3-5 Daily");
            ret = fee.getTchLunch4();
        }
        else if (myProgMap.get(PROG_LUNCH_TCH_5)!=null) {
            reason.append("Taichung 9-12 Daily");
            ret = fee.getTchLunch5();
        }
        else if (myProgMap.get(PROG_LUNCH_TCH_6)!=null) {
            reason.append("Taichung 6-12 Daily");
            ret = fee.getTchLunch6();
        }
        else if (myProgMap.get(PROG_LUNCH_TCH_7)!=null) {
            reason.append("Taichung 6-12 Tue&Thu");
            ret = fee.getTchLunch7();
        }
        else if (myProgMap.get(PROG_LUNCH_KAO_1)!=null) {
            reason.append("Kaohsiung Large#");
            ret = fee.getKaoLunch1();
        }
        else if (myProgMap.get(PROG_LUNCH_KAO_2)!=null) {
            reason.append("Kaohsiung Moderate#");
            ret = fee.getKaoLunch2();
        }

        return checkOptionalProrate(membrId, ret, reason);
    }

    void createLunchCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[10]; // Lunch
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        if (campus.equals("Taichung")) { //## 2009/4/3, only do 某一 campus 的
            ChargeItem citem = getChargeItem("Taichung", fee, billitemName);
            ArrayList<TagMembrInfo> tms = getMembrsForProg(PROG_TUITION_TAICHUNG);
            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int lunch = getLunchAmount(fee, mid, reason);
                if (lunch==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(lunch);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
        else if (campus.equals("Kaohsiung")) {
            ChargeItem citem = getChargeItem("Kaohsiung", fee, billitemName);
            ArrayList<TagMembrInfo> tms = getMembrsForProg(PROG_TUITION_KAOHSIUNG);
            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int lunch = getLunchAmount(fee, mid, reason);
                if (lunch==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(lunch);
                c.setNote(reason.toString());
                // cmgr.create(c);
                charges.add(c);
            }
        }
    }

    int getDormDepositAmount(McaFee fee, int membrId)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        
        // 2015-02-26 Chiahou 要求 DormDeposit 也分成 A,B,C,D 四种
        if (fee.getId()>=84 && (myProgMap.get(PROG_DORM_PROGRAM)!=null)) {
        	if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null)
        		return fee.getDormDepositD();
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null)
            	return fee.getDormDepositC();
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null)
            	return fee.getDormDepositB();
            else
                return fee.getDormDepositA();
        }
        // 之前的还是旧的算法
        else if (myProgMap.get(PROG_DORM_PROGRAM)!=null) {
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null)
                return 0;
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null)
                return 0;
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null)
                return 0;
            else
                return fee.getDormProgramA();
        }
        return 0;
    }

    private Map<Integer, ChargeItemMembr> fallFeeDepositMap = null;
    int getFallFeeDeposit(McaFee fee, int membrId)
        throws Exception
    {
        if (fallFeeDepositMap==null) {
            McaFee fall = new McaFeeMgr(tran_id).find("id=" + fee.getCheckFallFeeId());
            try {
                String citemIds = "";
                citemIds += getChargeItem(CAMPUS_BETHANY, fall, BILL_ITEMS[19]).getId();
                citemIds += ",";
                citemIds += getChargeItem(CAMPUS_TAICHUNG, fall, BILL_ITEMS[19]).getId();
                citemIds += ",";
                citemIds += getChargeItem(CAMPUS_KAOHSIUNG, fall, BILL_ITEMS[19]).getId();
                citemIds += ",";
                citemIds += getChargeItem(CAMPUS_CHIAYI, fall, BILL_ITEMS[19]).getId();

                fallFeeDepositMap = new SortingMap(new ChargeItemMembrMgr(tran_id).
                    retrieveList("charge.chargeItemId in (" + citemIds + ")", "")).doSortSingleton("getMembrId");
            }
            catch (Exception e) {
                fallFeeDepositMap = new HashMap<Integer, ChargeItemMembr>();
            }
        }

        ChargeItemMembr ci = fallFeeDepositMap.get(membrId);
        if (ci==null)
            return 0;
        return ci.getMyAmount();
    }

    void createDormDepositCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = (fee.getFeeType()==McaFee.FALL) 
								? BILL_ITEMS[19]  // DormProgram Deposit
		                        : BILL_ITEMS[25]; // DormProgram Deposit Return
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                int deposit = 0;
                // 2015-02-26 Chiahou 要求 DormDeposit 分成 A,B,C,D 四种, 
                // 還有 DormRoomReturn 直接讀新增的 DormDeposit 欄位，不要分 Fall/Spring 了
                if (fee.getId()>=84) {
                	deposit = getDormDepositAmount(fee, mid);                	
                }
                else {
	                if (fee.getFeeType()==McaFee.FALL) {
	                    deposit = getDormDepositAmount(fee, mid);
	                } 
	                else if (fee.getFeeType()==McaFee.SPRING) {
	                    deposit = getFallFeeDeposit(fee, mid);
	                    deposit = 0 - deposit;
	                }
                }
                if (deposit==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(deposit);
                if (deposit<0)
                    c.setNote("Return");
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }

    private Map<Integer, ArrayList<McaStudentInfo>> familyMap = null;
    public Map<Integer, ArrayList<McaStudentInfo>> prepareFamilyMap() 
        throws Exception
    {
        if (familyMap!=null)
            return familyMap;

        ArrayList<McaStudentInfo> msts = McaStudentInfoMgr.getInstance().retrieveList("studentStatus in (3,4)", "");
        Map<String, ArrayList<McaStudentInfo>> samefatherMap = new SortingMap(msts).doSortA("getFatherName");
        Map<String, ArrayList<McaStudentInfo>> samemotherMap = new SortingMap(msts).doSortA("getMotherName");
        Iterator<String> iter = samefatherMap.keySet().iterator();
        familyMap = new HashMap<Integer, ArrayList<McaStudentInfo>>();
        while (iter.hasNext()) {
            String name = iter.next();
            if (name.trim().length()==0)
                continue;
            ArrayList<McaStudentInfo> myfamily = samefatherMap.get(name);
            if (myfamily!=null && myfamily.size()>1) {
                for (int i=0; i<myfamily.size(); i++) {
                    McaStudentInfo ms = myfamily.get(i);
                    familyMap.put(ms.getMembrId(), myfamily);
                }
            }
        }
        iter = samemotherMap.keySet().iterator();
        while (iter.hasNext()) {
            String name = iter.next();
            if (name.trim().length()==0)
                continue;
            ArrayList<McaStudentInfo> myfamily = samemotherMap.get(name);
            if (myfamily!=null && myfamily.size()>1) {
                for (int i=0; i<myfamily.size(); i++) {
                    McaStudentInfo ms = myfamily.get(i);
                    ArrayList<McaStudentInfo> org = familyMap.get(ms.getMembrId());
                    if (org!=null && (org.size()>=myfamily.size())) {
                        continue;
                    }
                    familyMap.put(ms.getMembrId(), myfamily);
                }
            }
        }
        return familyMap;
    }

    private Map<Integer, MembrInfoBillRecord> membrbillMap = null;
    private Map<Integer, McaProrate>  familydiscountprorateMap = null;
    int getFamilyDiscountAmount(McaFee fee, int membrId, StringBuffer reason)
        throws Exception
    {
        prepareFamilyMap();
        
        if (membrbillMap==null) {
            McaFee fall = new McaFeeMgr(tran_id).find("id=" + fee.getCheckFallFeeId());
            try {
                ArrayList<McaFeeRecord> records = new McaFeeRecordMgr(tran_id).retrieveList("mca_fee.id=" + fall.getId(), "");
                String billRecordIds = new RangeMaker().makeRange(records, "getId");
                ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).retrieveList("billRecordId in (" + billRecordIds + ")", "");
                membrbillMap = new SortingMap(bills).doSortSingleton("getMembrId");

                ArrayList<McaProrate> prorates = new McaProrateMgr(tran_id).retrieveList("mcaFeeId=" + fall.getId(), "");
                familydiscountprorateMap = new SortingMap(prorates).doSortSingleton("getMembrId");
            }
            catch (Exception e) {
                membrbillMap = new HashMap<Integer, MembrInfoBillRecord>();
            }
        }

        ArrayList<McaStudentInfo> families = familyMap.get(membrId);
        if (families==null || families.size()<2)
            return 0;
        
        McaStudentInfo me = (McaStudentInfo) new SortingMap(families).doSortSingleton("getMembrId").get(membrId);
        // int mygrade = getGradeProgId(me.getGrade());
        int mygrade = getGradeProgId(getGrade(me.getMembrId()));
        McaStudent elder = null;

if (membrId==2297)
System.out.println("## 1");
        for (int i=0; i<families.size(); i++) {
            McaStudent ms = families.get(i);
if (membrId==2297)
System.out.println("## 1.5 who=" + ms.getStudentFirstName() + " " + ms.getStudentSurname());

            if (ms.getId()==me.getId()) // 自己
                continue;
            // 只要有人比自己大
            int othergrade = getGradeProgId(getGrade(ms.getMembrId()));
            if (othergrade>mygrade) {
if (membrId==2297)
System.out.println("## 2 other grade: " + getGradeProgId(getGrade(ms.getMembrId())) + 
    " mygrade=" + mygrade + " who=" + ms.getStudentFirstName() + " " + ms.getStudentSurname());
                elder = ms;
                break;
            }
            else if ((othergrade==mygrade) && (ms.getMembrId()<membrId)) { // 一樣大就號碼小的
                elder = ms;
                break;
            }

        }

        if (elder==null)
            return 0;        

        //又兩人 fall 都有繳費
        MembrInfoBillRecord bill_1 = membrbillMap.get(elder.getMembrId());
        MembrInfoBillRecord bill_2 = membrbillMap.get(me.getMembrId());

        if (membrId==2297)
        	System.out.println("## 3 bill_1=" + bill_1 + " bill_2=" + bill_2);
        
        // 2009/11/2 珈后说有开帐单就好了
        if (bill_1==null || bill_2==null)
            return 0;
        
        // 2011/12/27 added by peter (有 prorate 就不算)
        if (familydiscountprorateMap.get(elder.getMembrId())!=null ||
                familydiscountprorateMap.get(me.getMembrId())!=null) 
        {
        	if (membrId==2297)
            	System.out.println("## 3.5");
            return 0;
        }

        /*
        if (bill_1==null || bill_2==null || 
            (bill_1.getReceivable()>0 && bill_1.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID) || 
            (bill_2.getReceivable()>0 && bill_2.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID))
            return 0;
        */

if (membrId==2297)
System.out.println("## 4");

        String info = "Elder:" + elder.getFullName() + " Fall#" + bill_1.getTicketId() + ",#" + bill_2.getTicketId();
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);

        int ret = 0;
        if (myProgMap.get(PROG_IDENTITY_CW)!=null || 
            myProgMap.get(PROG_IDENTITY_M0)!=null ||
            isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) 
        {
            reason.append("Same Parent CW/M0/M1/M2," + info);
            ret = fee.getFamilyDiscountB();
        }
        else {
            reason.append("Same Parent Regular," + info);
            ret = fee.getFamilyDiscountA();
        }
        return checkFixProrate(membrId, ret, reason);
    }

    void createFamilyDiscount(McaFee fee, ArrayList<Charge> charges, String campus, boolean keepSame)
        throws Exception
    {
        String billitemName = BILL_ITEMS[12]; // FamilyDiscount
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);
            if (keepSame) {
                ArrayList<Charge> tmpcharges = cmgr.retrieveList("chargeItemId=" + citem.getId(), "");
                for (int j=0; j<tmpcharges.size(); j++) {
                    charges.add(tmpcharges.get(j));
                }
                return;
            }

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int discount = getFamilyDiscountAmount(fee, mid, reason);
                if (discount==0)
                    continue;
                discount = 0 - Math.abs(discount);
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(discount);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }


    int getBusAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        if (myProgMap.get(PROG_BUS)!=null)
            ret = fee.getBus();
        return checkOptionalProrate(membrId, ret, reason);
    }

    void createBusCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[9]; // Bus
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        if (!campus.equals("Kaohsiung")) //## 2009/4/3, only do 某一 campus 的
            return;

        ChargeItem citem = getChargeItem("Kaohsiung", fee, billitemName);
        ArrayList<TagMembrInfo> tms = getMembrsForProg(PROG_TUITION_KAOHSIUNG);
        BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
       
        for (int j=0; j<tms.size(); j++) {
            int mid = tms.get(j).getMembrId();
            StringBuffer reason = new StringBuffer();
            int bus = getBusAmount(fee, mid, reason);
            if (bus==0)
                continue;
            Charge c = new Charge();
            c.setChargeItemId(citem.getId());
            c.setMembrId(mid);
            c.setAmount(bus);
            c.setNote(reason.toString());
            //cmgr.create(c);
            charges.add(c);
        }
    }

    // 19 months 
    long month19 = (long)((long)19 * (long)30 * (long)84400 * (long)1000);
    Map<Integer, ArrayList<MembrInfoBillRecord>> oldbillMap = null;
    Map<Integer, McaFee> feeMap = null;
    Map<Integer, McaRecordInfo> feerecordMap = null;
    int getEntranceAmount(McaFee fee, int membrId, StringBuffer reason)
        throws Exception
    {
        if (oldbillMap == null) {
            ArrayList<MembrInfoBillRecord> oldbills = new MembrInfoBillRecordMgr(tran_id).
                retrieveList("billrecord.month<'" + sdf.format(fee.getMonth()) + "'", 
                // "order by ticketId asc");
                "order by billrecord.billDate asc");
            oldbillMap = new SortingMap(oldbills).doSortA("getMembrId");
            feeMap = new SortingMap(new McaFeeMgr(tran_id).retrieveList("status=" + McaFee.STATUS_ACTIVE,"")).doSortSingleton("getId");
            feerecordMap = new SortingMap(new McaRecordInfoMgr(tran_id).retrieveList("mca_fee.status=" + McaFee.STATUS_ACTIVE,"")).
                doSortSingleton("getBillRecordId");
        }
        ArrayList<MembrInfoBillRecord> bills = oldbillMap.get(membrId);
        MembrInfoBillRecord bill = null;
        for (int i=0; bills!=null && i<bills.size(); i++) {
            // 如果是 registration 的 bill 就不管, 只管 Fall 和 Spring
            McaRecordInfo mr = feerecordMap.get(bills.get(i).getBillRecordId());
            McaFee tmpfee = feeMap.get(mr.getMcaFeeId());
            if (tmpfee.getFeeType()==McaFee.REGISTRATION_ONLY)
                continue;
            bill = bills.get(i);
            if ((fee.getMonth().getTime() - bill.getBillMonth().getTime())<month19)
                return 0;
        }        
        
        int ret = 0;
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null) {
            reason.append("M1/M2");
            ret = fee.getEntranceD();
        }
        else if (myProgMap.get(PROG_IDENTITY_M0)!=null) {
            reason.append("M0");
            ret = fee.getEntranceC();
        }
        else if (myProgMap.get(PROG_IDENTITY_CW)!=null) {
            reason.append("CW");
            ret = fee.getEntranceB();
        }
        else {
            reason.append("Regular");
            ret = fee.getEntranceA();
        }
        if (bill!=null)
            reason.append(" last bill:" + bill.getTicketId());
        else
            reason.append(" no bill before");
        return ret;
    }

    void createEntranceCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[26]; // Entrance
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int entrance = getEntranceAmount(fee, mid, reason);
                if (entrance==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(entrance);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }




    int getTestingAmount(McaFee fee, int membrId, StringBuffer reason)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        int ret = 0;
        if (myProgMap.get(PROG_TESTING)!=null) {
            if (isM1(membrId) || myProgMap.get(PROG_IDENTITY_M2)!=null)
                ret = fee.getTestingD();
            else if (myProgMap.get(PROG_IDENTITY_CW)!=null)
                ret = fee.getTestingB();
            else if (myProgMap.get(PROG_IDENTITY_M0)!=null)
                ret = fee.getTestingC();
            else
                ret = fee.getTestingA();
        }

        return ret;
    }

    void createTestingCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[20]; // Testing
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
           
            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                StringBuffer reason = new StringBuffer();
                int testing = getTestingAmount(fee, mid, reason);
                if (testing==0)
                    continue;
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(testing);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }

    Map<Integer, BillItem> __billitemMap = null;
    Map<Integer, ChargeItem> __chargeitemMap = null;
    Map<Integer, ArrayList<ChargeItem>> __recordcitemMap2 = null;
    void prepareChargeBillMap()
        throws Exception
    {
        __billitemMap = new SortingMap(new BillItemMgr(tran_id).retrieveList("", "")).doSortSingleton("getId");
        ArrayList<ChargeItem> citems = new ChargeItemMgr(tran_id).retrieveList("", "");
        __chargeitemMap = new SortingMap(citems).doSortSingleton("getId");
        __recordcitemMap2 = new SortingMap(citems).doSortA("getBillRecordId");
    }

    int getAllowanceAmount(McaFee fee, int membrId, ArrayList<Charge> mycharges, McaStudent student, StringBuffer reason)
        throws Exception
    {
        if (student.getTDisc()==(double)0)
            return 0;
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);

        if (__billitemMap==null)
            prepareChargeBillMap();

        // Allowance = 
        //    Registration(0) + Tuition(1) + Building(3) + ELL(4) + Special Needs(21) + Dorm Program(16) + Dorm Facility(17)
        //    - D-Tuition(2) - Family Discount(12) - Mission Discount(14) - Entrance(26)
        //  ### 刮號的數字是在 BILL_ITEMS 的順位
        
        int amount = 0;
        for (int i=0; mycharges!=null && i<mycharges.size(); i++) {
            Charge c = mycharges.get(i);
            ChargeItem ci = __chargeitemMap.get(c.getChargeItemId());
            BillItem bi = __billitemMap.get(ci.getBillItemId());
            String bi_name = bi.getName();
            if (bi_name.equals(BILL_ITEMS[0])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            } else if (bi_name.equals(BILL_ITEMS[1])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            } else if (bi_name.equals(BILL_ITEMS[3])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            } else if (bi_name.equals(BILL_ITEMS[4])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            } else if (bi_name.equals(BILL_ITEMS[21])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            } else if (bi_name.equals(BILL_ITEMS[16])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            } else if (bi_name.equals(BILL_ITEMS[17])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            } else if (bi_name.equals(BILL_ITEMS[2])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            } else if (bi_name.equals(BILL_ITEMS[12])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            } else if (bi_name.equals(BILL_ITEMS[14])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            } else if (bi_name.equals(BILL_ITEMS[26])) {
                reason.append(((c.getAmount()>0)?"+":"-")+Math.abs(c.getAmount()));
                amount += c.getAmount();
            }
        }
        
        double ret = amount * student.getTDisc();
        reason.append("=" + amount + "*" + student.getTDisc() + "=" + ret);
        return checkFixProrate(membrId, (int) ret, reason);
    }

    void createAllowanceCharge(McaFee fee, ArrayList<Charge> charges, String campus)
        throws Exception
    {
        String billitemName = BILL_ITEMS[15]; // Allowance
        Map<Integer, ArrayList<Charge>> chargeMap = new SortingMap(charges).doSortA("getMembrId");
        Map<Integer, McaStudent> studentMap = new SortingMap(new McaStudentMgr(tran_id).retrieveList("", "")).doSortSingleton("getMembrId");

        for (int i=0; i<CAMPUSES.length; i++) {

            if (!CAMPUSES[i].equals(campus)) //## 2009/4/3, only do 某一 campus 的
                continue;

            ChargeItem citem = getChargeItem(CAMPUSES[i], fee, billitemName);

            int progId = 0;
            if (CAMPUSES[i].equals("Bethany")) progId = PROG_TUITION_BETHANY;
            else if (CAMPUSES[i].equals("Taichung")) progId = PROG_TUITION_TAICHUNG;
            else if (CAMPUSES[i].equals("Kaohsiung")) progId = PROG_TUITION_KAOHSIUNG;
            else if (CAMPUSES[i].equals("Chiayi")) progId = PROG_TUITION_CHIAYI;

            ArrayList<TagMembrInfo> tms = getMembrsForProg(progId);

            for (int j=0; j<tms.size(); j++) {
                int mid = tms.get(j).getMembrId();
                ArrayList<Charge> mycharges = chargeMap.get(mid);
                McaStudent student = studentMap.get(mid);
                StringBuffer reason = new StringBuffer();
                int allowance = getAllowanceAmount(fee, mid, mycharges, student, reason);
                if (allowance==0)
                    continue;
                allowance = 0 - Math.abs(allowance);
                Charge c = new Charge();
                c.setChargeItemId(citem.getId());
                c.setMembrId(mid);
                c.setAmount(allowance);
                c.setNote(reason.toString());
                //cmgr.create(c);
                charges.add(c);
            }
        }
    }

    Map<Integer, Membr> membrMap = null;
    Map<Integer, Map<Integer, ArrayList<TagMembrInfo>>> tagmembrMap = null;
    Map<Integer, ArrayList<TagMembrInfo>> progtagmembrMap = null;
    Map<Integer, ArrayList<Membr>> bunitmembrMap = null;
    void prepareMembrTags(McaFee fee)
        throws Exception
    {
        prepareMembrTags(fee, null);
    }

    void prepareMembrTags(McaFee fee, String membrIds)
        throws Exception
    {
        cur_fee = fee;
        String q = (membrIds!=null)?("id in (" + membrIds + ")"):"";
        McaTagHelper th = new McaTagHelper(tran_id);
        ArrayList<Membr> membrs = new MembrMgr(tran_id).retrieveList(q, "");
        bunitmembrMap = new SortingMap(membrs).doSortA("getBunitId");
        membrMap = new SortingMap(membrs).doSortSingleton("getId");
        if (membrIds==null)
            membrIds = new RangeMaker().makeRange(membrs, "getId");

        // 2009/3/8 只抓對應這一個 McaFee 的 tags
        ArrayList<Tag> fee_tags = th.getFeeTags(fee);

        String tagIds = new RangeMaker().makeRange(fee_tags, "getId");
        q = "tagmembr.membrId in (" + membrIds + ") and tagmembr.tagId in (" + tagIds + ")";
        ArrayList<TagMembrInfo> tagmembrs = new TagMembrInfoMgr(tran_id).retrieveList(q, "");
        Map<Integer, ArrayList<TagMembrInfo>> tmp = new SortingMap(tagmembrs).doSortA("getMembrId");
        tagmembrMap = new LinkedHashMap<Integer, Map<Integer,ArrayList<TagMembrInfo>>>();
        Iterator<Integer> iter = tmp.keySet().iterator();
        while (iter.hasNext()) {
            Integer mid = iter.next();
            ArrayList<TagMembrInfo> mytags = tmp.get(mid);
            tagmembrMap.put(mid, new SortingMap(mytags).doSortA("getProgId"));
        }
        progtagmembrMap = new SortingMap(tagmembrs).doSortA("getProgId");
        McaStudentMgr msmgr = new McaStudentMgr(tran_id);
        studentMap = new SortingMap(msmgr.retrieveList("membrId in (" + membrIds + ")", "")).doSortSingleton("getMembrId");
        prepareBunitMap();
    }

    void makeMembrBillRecords(McaFee fee)
        throws Exception
    {
        ArrayList<McaFeeRecord> records = new McaFeeRecordMgr(tran_id).retrieveList("mcaFeeId=" + fee.getId(), "");
        Map<Integer, McaFeeRecord> billrecordMap = new SortingMap(records).doSortSingleton("getId");
        String billRecordIds = new RangeMaker().makeRange(records, "getId");
        ArrayList<ChargeItemMembr> citems = new ChargeItemMembrMgr(tran_id).retrieveList("chargeitem.billRecordId in (" +
            billRecordIds + ")", "");
        Map<Integer, ArrayList<ChargeItemMembr>> citemsMap = new SortingMap(citems).doSortA("getMembrId");
        
        Iterator<Integer> iter = citemsMap.keySet().iterator();
        MembrBillRecordMgr sbmgr = new MembrBillRecordMgr(tran_id);
        EzCountingService ezsvc = EzCountingService.getInstance();
        while (iter.hasNext()) {
            Integer mid = iter.next();
            ArrayList<ChargeItemMembr> charges = citemsMap.get(mid);
            int total = 0;
            for (int i=0; i<charges.size(); i++)
                total += charges.get(i).getMyAmount();
            if (total<0) {
                for (int i=0; i<charges.size(); i++) {
                    ChargeItemMembr ci = charges.get(i);
                    System.out.println(ci.getChargeName() + ":" + ci.getMyAmount());
                }
                System.out.println("## membrId=" + mid.intValue());
                throw new Exception("total amount < 0");
            }
            BillRecord br = billrecordMap.get(charges.get(0).getBillRecordId());
            MembrBillRecord mbr = ezsvc.makeMembrBillRecord(sbmgr, mid.intValue(), br);
            mbr.setReceivable(total);
            sbmgr.save(mbr);
        }
    }

    public ArrayList<Discount> getAdjustDiscounts(McaFee fee, int bunitId)
        throws Exception
    {
        BunitHelper bh = new BunitHelper(tran_id);
        ArrayList<McaFeeRecord> mr = new McaFeeRecordMgr(tran_id).retrieveListX
            ("mcaFeeId=" + fee.getId(), "", bh.getSpace("bunitId", bunitId));
        String billRecordIds = new RangeMaker().makeRange(mr, "getId");
        ArrayList<ChargeItem> citems = new ChargeItemMgr(tran_id).retrieveList("billRecordId in (" + billRecordIds + ")", "");
        String citemIds = new RangeMaker().makeRange(citems, "getId");
        return new DiscountMgr(tran_id).retrieveList("chargeItemId in (" + citemIds + ")", "");
    }

    public ArrayList<Charge> getGeneratedCharges(McaFee fee, int bunitId)
        throws Exception
    {
        BunitHelper bh = new BunitHelper(tran_id);
        ArrayList<McaFeeRecord> mr = new McaFeeRecordMgr(tran_id).retrieveListX
            ("mcaFeeId=" + fee.getId(), "", bh.getSpace("bunitId", bunitId));
        String billRecordIds = new RangeMaker().makeRange(mr, "getId");
        ArrayList<ChargeItem> citems = new ChargeItemMgr(tran_id).retrieveList("billRecordId in (" + billRecordIds + ")", "");
        String citemIds = new RangeMaker().makeRange(citems, "getId");
        // return new ChargeMgr(tran_id).retrieveList("chargeItemId in (" + citemIds + ")", "");

        // 有些 charge 可能帐单已经被删除了
        ArrayList<Charge> tmp = new ChargeMgr(tran_id).retrieveList("chargeItemId in (" + citemIds + ")", "");
        ArrayList<ChargeItemMembr> cim = new ChargeItemMembrMgr(tran_id).retrieveList("chargeItemId in (" + citemIds + ") and membrbillrecord.ticketId is not NULL", "");
        Map<String, ChargeItemMembr> testMap = new SortingMap(cim).doSortSingleton("getChargeKey");
        
        ArrayList<Charge> ret = new ArrayList<Charge>();
        for (int i=0; i<tmp.size(); i++) {
            if (testMap.get(tmp.get(i).getChargeKey())!=null)
                ret.add(tmp.get(i));
            else {
                new ChargeMgr(tran_id).executeSQL("delete from charge where " + 
                    "chargeItemId=" + tmp.get(i).getChargeItemId() + " and membrId=" +
                    tmp.get(i).getMembrId());
                System.out.println("bill for charge " + tmp.get(i).getChargeKey() + " not found, remove old!");
            }
        }
        return ret;
    }


    Map<String, MembrBillRecord> _membrbillrecordMap = null;
    Map<Integer, BillRecord> _billrecordMap = null;
    void prepareMembrBillRecord(McaFee fee)
        throws Exception
    {
        prepareChargeBillMap();
        ArrayList<McaRecord> mr = new McaRecordMgr(tran_id).retrieveList("mcaFeeId=" + fee.getId(), "");
        String billRecordIds = new RangeMaker().makeRange(mr, "getBillRecordId");
        _membrbillrecordMap = new SortingMap(new MembrBillRecordMgr(tran_id).retrieveList("billRecordId in (" + 
            billRecordIds + ")", "")).doSortSingleton("getBillKey");
        _billrecordMap = new SortingMap(new BillRecordMgr(tran_id).retrieveList("id in (" + billRecordIds + ")", "")).
            doSortSingleton("getId");
    }

    MembrBillRecord getMembrBillRecord(Charge c)
        throws Exception
    {
        ChargeItem ci = __chargeitemMap.get(c.getChargeItemId());
        MembrBillRecord mbr = _membrbillrecordMap.get(c.getMembrId()+"#"+ci.getBillRecordId());

        if (mbr!=null)
            return mbr;

        MembrBillRecordMgr sbmgr = new MembrBillRecordMgr(tran_id);
        EzCountingService ezsvc = EzCountingService.getInstance();
        BillRecord br = _billrecordMap.get(ci.getBillRecordId());
        mbr = ezsvc.makeMembrBillRecord(sbmgr, c.getMembrId(), br);
        _membrbillrecordMap.put(mbr.getBillKey(), mbr);
        return mbr;
    }

    
    private Map<Integer, Integer> proratedaysMap = null;
    private McaFee myfee = null;
    private int school_days, optional_days;
    void prepareProrateInfo(McaFee fee)
        throws Exception
    {
        prepareIncludeExclude(fee.getIncludeDays(), fee.getExcludeDays());
        ArrayList<McaProrate> mps = new McaProrateMgr(tran_id).retrieveList("mcaFeeId=" + fee.getId(), "");
        proratedaysMap = new HashMap<Integer, Integer>();
        for (int i=0; i<mps.size(); i++) {
            int mydays = getSchoolDays(mps.get(i).getProrateDate(), fee.getEndDay());
            proratedaysMap.put(mps.get(i).getMembrId(), new Integer(mydays));
        }        
        myfee = fee;
        school_days = getSchoolDays(fee.getStartDay(), fee.getEndDay());
        optional_days = getSchoolDays(fee.getProrateDay(), fee.getEndDay());
    }

    int checkFixProrate(int membrId, int amount, StringBuffer reason)
    {
        Integer my_shooldays = proratedaysMap.get(membrId);
        if (my_shooldays==null)
            return amount;
        if (school_days==0)
            return amount;
        if (amount==0)
            return 0;
        if (my_shooldays.intValue()>optional_days)
            return amount;

        int ret = (int) ((((double)my_shooldays.intValue()) / ((double)school_days)) * ((double)amount));
        if (reason.length()>0)
            reason.append(",");
        reason.append("prorate:(" + amount + "-" + (amount-ret) + "="+ret+")");
        return ret;
    }

    int checkOptionalProrate(int membrId, int amount, StringBuffer reason)
    {
        Integer my_shooldays = proratedaysMap.get(membrId);
        if (my_shooldays==null)
            return amount;
        if (school_days==0)
            return amount;
        if (amount==0)
            return 0;
        double ratio = (((double)my_shooldays.intValue()) / ((double)school_days));
        if (ratio>1)
            return amount;
        int ret = (int) (ratio * ((double)amount));
        if (reason.length()>0)
            reason.append(",");
        reason.append("prorate:(" + amount + "-" + (amount-ret) + "="+ret+")");
        return ret;
    }

    public void generateBills(McaFee fee, int bunitId, ArrayList<Charge> conflict_list, 
        ArrayList<Charge> create_list, ArrayList<Charge> modified_list, ArrayList<Charge> delete_list,
        StringBuffer sb)
        throws Exception
    {
        // 帳單類型
    	
    	System.out.println("#in generate bills#");

        String campus = getCampus(bunitId);

        makeBillAndBillItems(campus);

        // billrecords
        makeBillRecords(fee, campus);

        prepareMembrTags(fee);

        ArrayList<Charge> charges = new ArrayList<Charge>();

        prepareProrateInfo(fee);

        ArrayList<McaFee> fees = McaFeeMgr.getInstance().retrieveList("status=" + McaFee.STATUS_ACTIVE,"order by id desc");
        boolean isNewestFee = (fee.getId()==fees.get(0).getId());

        if (fee.getFeeType()==McaFee.REGISTRATION_ONLY) {
            createFeeRegistration(fee, charges, campus);
        }
        else {
            if (fee.getFeeType()==McaFee.FALL)
                createFeeRegistrationWithCheck(fee, charges, campus);
            createFeeTuition(fee, charges, campus);
            createFeeMissionDiscount(fee, charges, campus);
            createBuildingFee(fee, charges, campus);
            createESLCharge(fee, charges, campus);
            createMilkCharge(fee, charges, campus);
            createMusicCharge(fee, charges, campus);
            createInstrumentCharge(fee, charges, campus);
            createMusicRoomCharge(fee, charges, campus);
            createDormProgramCharge(fee, charges, campus);
            createDormFacilityCharge(fee, charges, campus);
            createDormFoodCharge(fee, charges, campus);
            createLunchCharge(fee, charges, campus);
            createDormDepositCharge(fee, charges, campus);
            boolean keepSame = (!isNewestFee);
            if (fee.getFeeType()==McaFee.SPRING) // only re-do family discount if it's newest, otherwise would change old fees after 升级
                createFamilyDiscount(fee, charges, campus, keepSame);
            createBusCharge(fee, charges, campus);
            createTestingCharge(fee, charges, campus);
            if (fee.getId()>39 && (fee.getFeeType()==McaFee.SPRING || fee.getFeeType()==McaFee.FALL))
                createEntranceCharge(fee, charges, campus);
            createAllowanceCharge(fee, charges, campus);
        }

        ArrayList<Charge> existing_charges = getGeneratedCharges(fee, bunitId);
        ArrayList<Discount> discounts = getAdjustDiscounts(fee, bunitId);
        Map<String, Charge> newchargeMap = new SortingMap(charges).doSortSingleton("getChargeKey");
        Map<String, Charge> oldchargeMap = new SortingMap(existing_charges).doSortSingleton("getChargeKey");
        Map<String, ArrayList<Discount>> discountMap = new SortingMap(discounts).doSortA("getChargeKey");
        
        DetailDrawer dd = new DetailDrawer(fee, sb, bunitId, new BunitHelper(tran_id));
        for (int i=0; i<charges.size(); i++) {
            Charge newcharge = charges.get(i);
if (newcharge.getMembrId()==2128)
System.out.println("## 1");
            Charge oldcharge = oldchargeMap.get(newcharge.getChargeKey());
            if (oldcharge!=null) {
if (newcharge.getMembrId()==2128)
System.out.println("## 2" + oldcharge.getChargeItemId() + ":" + oldcharge.getAmount() + "|" + newcharge.getAmount()) ;
                if (oldcharge.getAmount()!=newcharge.getAmount()) {
if (newcharge.getMembrId()==2128)
System.out.println("## 3");
                    if (oldcharge.getUserId()==0) {
if (newcharge.getMembrId()==2128)
System.out.println("## 4");					
                        dd.drawModify(oldcharge, newcharge);
                        oldcharge.setAmount(newcharge.getAmount());
                        oldcharge.setNote(newcharge.getNote());
                        modified_list.add(oldcharge);
                    }
                    else {
if (newcharge.getMembrId()==2128)
System.out.println("## 5");
                        conflict_list.add(newcharge);
                        dd.drawConflict(oldcharge, newcharge);
                    }
                }
            }
            else {
if (newcharge.getMembrId()==2128)
System.out.println("## 6");
                create_list.add(newcharge); 
                dd.drawCreated(newcharge);
            }
        }
        for (int i=0; i<existing_charges.size(); i++) {
            Charge oldcharge = existing_charges.get(i);
            Charge newcharge = newchargeMap.get(existing_charges.get(i).getChargeKey());
            if (newcharge==null) {
                if (oldcharge.getUserId()==0) {
                    delete_list.add(oldcharge);
                    dd.drawDeleted(oldcharge);
                }
            }
        }
        dd.finish();

        prepareMembrBillRecord(fee);
        Map<String, MembrBillRecord> redoMap = new HashMap<String, MembrBillRecord>();
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        MembrBillRecordMgr sbmgr = new MembrBillRecordMgr(tran_id);
        ArrayList<MembrBillRecord> modified_bills = new ArrayList<MembrBillRecord>();
        
        for (int i=0; i<create_list.size(); i++) {
            Charge c = create_list.get(i);
            cmgr.create(c);
            MembrBillRecord mbr = getMembrBillRecord(c);
            modified_bills.add(mbr);
            redoMap.put(mbr.getBillKey(), mbr);
        }
        for (int i=0; i<modified_list.size(); i++) {
            Charge c = modified_list.get(i);
            cmgr.save(c);
            MembrBillRecord mbr = getMembrBillRecord(c);
            modified_bills.add(mbr);
            redoMap.put(mbr.getBillKey(), mbr);
        }
        for (int i=0; i<delete_list.size(); i++) {
            Charge c = delete_list.get(i);
            Object[] objs = { c };
            cmgr.remove(objs);
            MembrBillRecord mbr = getMembrBillRecord(c);
            modified_bills.add(mbr);
            redoMap.put(mbr.getBillKey(), mbr);
        }

        long now = new Date().getTime();
        String ticketIds = new RangeMaker().makeRange(modified_bills, "getTicketIdAsString");
        sbmgr.executeSQL("update membrbillrecord set printDate=0, forcemodify=" + now + 
            " where ticketId in (" + ticketIds + ")");

        
        BunitHelper bh = new BunitHelper(tran_id);
        EzCountingService ezsvc = EzCountingService.getInstance();
        Date nextFreezeDay = ezsvc.getFreezeNextDay(bh.getSpace("bunitId", bunitId));        
        User ud2 = (User) UserMgr.getInstance().find(1);

        Iterator<String> iter = redoMap.keySet().iterator();
        while (iter.hasNext()) {
            MembrBillRecord mbr = redoMap.get(iter.next());
            ArrayList<ChargeItem> citems = __recordcitemMap2.get(mbr.getBillRecordId());
            int membrId = mbr.getMembrId();
            int total = 0;
            boolean keep = false;
            for (int i=0; i<citems.size(); i++) {
                Charge c = newchargeMap.get(membrId+"#"+citems.get(i).getId());
                if (c==null) {
                    // 要檢查如果有人工輸入的舊 charge 要留著
                    c = oldchargeMap.get(membrId+"#"+citems.get(i).getId()); 
                    if (c==null || c.getUserId()==0) {
                        continue;
                    }
                }
                if (c.getAmount()!=ChargeItemMembr.ZERO) {
                    if (c.getAmount()!=0)
                        total += c.getAmount();
                    else
                        total += citems.get(i).getChargeAmount();
                }
                if (c!=null) {
                    keep = true;
                    discounts = discountMap.get(c.getMembrId()+"#"+c.getChargeItemId());
                    for (int j=0; discounts!=null && j<discounts.size(); j++) {
                        total -= discounts.get(j).getAmount();
					}
                }
            }
            /*
            if (mbr.getPrintDate()>0) {
System.out.println("## ticketId=" + mbr.getTicketId());
                throw new Exception("bill is locked, cannot change");
            }
            if (mbr.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID)
                throw new Exception("bill is paid, cannot change");
            */
            if (total<0) {
                System.out.println("## error, charge details below:");
                System.out.println("## total=" + total);
                int xx = 0;
                int chargeItemId = 0;
                int mid = 0;
                for (int i=0; i<citems.size(); i++) {
                    Charge c = newchargeMap.get(membrId+"#"+citems.get(i).getId());
                    if (c==null) {
                        continue;
					}
                    chargeItemId = c.getChargeItemId();
                    mid = c.getMembrId();
                    System.out.println("cid=" + c.getChargeItemId() + " mid=" + c.getMembrId() + " amt=" + c.getAmount() + ":" + c.getNote());
                    discounts = discountMap.get(c.getMembrId()+"#"+c.getChargeItemId());
                    for (int j=0; discounts!=null && j<discounts.size(); j++) {
                        xx -= discounts.get(j).getAmount();
                        System.out.println("discount amt=" + (0-discounts.get(j).getAmount()));
                    }
                    xx += c.getAmount();
                }
                ChargeItem ci = new ChargeItemMgr(tran_id).find("id=" + chargeItemId);
				if (ci!=null) {
					MembrBillRecord b = new MembrBillRecordMgr(tran_id).find("billRecordId=" + 
						ci.getBillRecordId() + " and membrId=" + mid);
					throw new Exception("total amount cannot be negative [" + xx + "] ticketId=[" + b.getTicketId() + "]");
				}
            }
            else if (!keep) {
                String ticketId = mbr.getTicketId();
                ezsvc.deleteMembrBillRecord(tran_id, ticketId, ud2, nextFreezeDay);
                // 如果里面沒項目只是要刪 memmbrbillrecord, 那就會到這
                new MembrBillRecordMgr(tran_id).executeSQL("delete from membrbillrecord where ticketId='" + ticketId + "'");
                continue;
            }

            mbr.setReceivable(total);
            if ((total==mbr.getReceived() && mbr.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID) || (total==0)) {
                mbr.setPaidStatus(MembrBillRecord.STATUS_FULLY_PAID);
            }
            else if (total>mbr.getReceived()) {
                if (mbr.getReceived()==0)
                    mbr.setPaidStatus(MembrBillRecord.STATUS_NOT_PAID);
                else if (mbr.getPaidStatus()!=MembrBillRecord.STATUS_PARTLY_PAID)
                    mbr.setPaidStatus(MembrBillRecord.STATUS_PARTLY_PAID);
            }
            else if (total<mbr.getReceived()) {
System.out.println("total=" + total);
                throw new Exception("This change will cause pervious paying amount more than bill total,\n" +
                    "please reduce the paid amount (in the bill, do \"轉至學生帳戶\") before the change.\n" +
                    "ticketId = [" + mbr.getTicketId() + "]");
            }

            sbmgr.save(mbr);
        }
    }

    private static Map<String, Area> areaMap = null;
    public static String formatAddr(String countryID, String countyID, String cityID, String districtID, 
        String street, String postCode)
        throws Exception
    {
        if (areaMap==null) {
            areaMap = new SortingMap(AreaMgr.getInstance().retrieveList("", "")).doSortSingleton("getMyKey");
        }
        Area country = areaMap.get("0#" + countryID);
        Area county = areaMap.get("1#" + countyID);
        Area city = areaMap.get("2#" + cityID);
        Area district = areaMap.get("3#" + districtID);

        //if (street==null || street.length()==0 || (city==null && county==null))
        //    return ""; // 不完全就不要
        
        StringBuffer sb = new StringBuffer();
        if (postCode!=null)
            sb.append(postCode + " ");
        if (county!=null && county.getCName()!=null)
            sb.append(county.getCName());
        if (city!=null)
            sb.append(city.getCName());
        if (district!=null)
            sb.append(district.getCName());
        if (street!=null)
            sb.append(street);
        return sb.toString();
    }


    public static String formatEngAddr(String countryID, String countyID, String cityID, String districtID, 
        String street, String postCode)
        throws Exception
    {
        if (areaMap==null) {
            areaMap = new SortingMap(AreaMgr.getInstance().retrieveList("", "")).doSortSingleton("getMyKey");
        }
        Area country = areaMap.get("0#" + countryID);
        Area county = areaMap.get("1#" + countyID);
        Area city = areaMap.get("2#" + cityID);
        Area district = areaMap.get("3#" + districtID);

        //if (street==null || street.length()==0 || (city==null && county==null))
        //    return ""; // 不完全就不要
        
        StringBuffer sb = new StringBuffer();
        if (postCode!=null)
            sb.append(postCode + " ");
        if (street!=null)
            sb.append(street);
        if (district!=null)
            sb.append("," + district.getEName());
        if (city!=null)
            sb.append("," + city.getEName());
        if (county!=null)
            sb.append("," + county.getEName());

        return sb.toString();
    }

    boolean isIn(int membrId, int progId)
    {
        Map<Integer, ArrayList<TagMembrInfo>> myProgMap = tagmembrMap.get(membrId);
        if (myProgMap.get(progId)!=null)
            return true;
        return false;
    }

    public void upgradeMCA(McaFee fee)
        throws Exception
    {
        // Upgrade will do : Graduate 12th grade, moving others 1 up with Kaohsiung/Taipei 
        //                   9th grade switching to Taichung campus
       
        McaTagHelper th = new McaTagHelper(tran_id);
        ArrayList<Tag> feetags = th.getFeeTags(fee);
        String tagIds = new RangeMaker().makeRange(feetags, "getId");
        Map<Integer, ArrayList<TagMembr>> tmsMap = new SortingMap(new TagMembrMgr(tran_id).
            retrieveList("tagId in (" + tagIds + ")", "")).doSortA("getTagId");
        Map<String, Tag> tagprogbunitMap = new SortingMap(feetags).doSortSingleton("getBunitProgKey");
        Map<String, Bunit> bunitMap = new SortingMap(new BunitMgr(tran_id).retrieveList
                ("flag=" + Bunit.FLAG_BIZ, "")).doSortSingleton("getLabel");
        Map<Integer, ArrayList<Tag>> tagprogMap = new SortingMap(feetags).doSortA("getProgId");
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);

        prepareMembrTags(fee);

        // ell,music 去掉 9轉10 的
        PArrayList<Tag> sometags = new PArrayList<Tag>(tagprogMap.get(PROG_ESL_MODERATE));
        sometags.concate(tagprogMap.get(PROG_ESL_SIGNIFICANT));
        sometags.concate(tagprogMap.get(PROG_MUSIC_PRIVATE));
        sometags.concate(tagprogMap.get(PROG_MUSIC_SEMI));
        sometags.concate(tagprogMap.get(PROG_MUSIC_GROUP));
        sometags.concate(tagprogMap.get(PROG_MUSIC_INSTRUMENT));
        sometags.concate(tagprogMap.get(PROG_MUSIC_RENTROOM));
        sometags.concate(tagprogMap.get(PROG_MUSIC_PRIVATE_DOUBLE));
        sometags.concate(tagprogMap.get(PROG_MUSIC_RENTROOM_DOUBLE));
        for (int i=0; i<sometags.size(); i++) {
            Tag t = sometags.get(i);
            ArrayList<TagMembr> tms = tmsMap.get(t.getId());
            for (int j=0; tms!=null&&j<tms.size(); j++) {
                if (isIn(tms.get(j).getMembrId(), PROG_GRADE_9)) {
                    Object[] objs = { tms.get(j) };
                    tmmgr.remove(objs);
                }
            }
        }

        // taichung 2 轉 3 K-2 Tue&Thu 轉 3-5 Tue&Thu
        Tag tch_lunch_tag1 = tagprogMap.get(PROG_LUNCH_TCH_1).get(0);
        Tag tch_lunch_tag3 = tagprogMap.get(PROG_LUNCH_TCH_3).get(0);
        ArrayList<TagMembr> tms = tmsMap.get(tch_lunch_tag1.getId());
        for (int i=0; tms!=null&&i<tms.size(); i++) {
            if (isIn(tms.get(i).getMembrId(), PROG_GRADE_2)) {
                TagMembr tm = new TagMembr();
                tm.setTagId(tch_lunch_tag3.getId());
                tm.setMembrId(tms.get(i).getMembrId());
                tm.setBindTime(new Date());
                tmmgr.create(tm);
                Object[] objs = { tms.get(i) };
                tmmgr.remove(objs);
            }
        }

        // taichung 2 轉 3 K-2 Daily 轉 3-5 Daily
        Tag tch_lunch_tag2 = tagprogMap.get(PROG_LUNCH_TCH_2).get(0);
        Tag tch_lunch_tag4 = tagprogMap.get(PROG_LUNCH_TCH_4).get(0);
        tms = tmsMap.get(tch_lunch_tag2.getId());
        for (int i=0; tms!=null&&i<tms.size(); i++) {
            if (isIn(tms.get(i).getMembrId(), PROG_GRADE_2)) {
                TagMembr tm = new TagMembr();
                tm.setTagId(tch_lunch_tag4.getId());
                tm.setMembrId(tms.get(i).getMembrId());
                tm.setBindTime(new Date());
                tmmgr.create(tm);
                Object[] objs = { tms.get(i) };
                tmmgr.remove(objs);
            }
        }
    
		// 2013-3 月珈后要求台北高雄9年级不转台中了, id<=66 还是要
		if (fee.getId()<=67) {
			//## 將 Benthany or Kaoshiung 9年級轉到臺中 first,
			//## step1 先去掉所有 Benthany or Kaoshiung 9年級的 tagmembr, 因為那些都是連到原校的
			//## step2 加入臺中 tag 及 九年級 tag
			int buId_taichung = bunitMap.get("Taichung").getId();
			int buId_kaohsiung = bunitMap.get("Kaohsiung").getId();
			int buId_bethany = bunitMap.get("Bethany").getId();
			Tag taichung = tagprogbunitMap.get(buId_taichung+"#"+PROG_TUITION_TAICHUNG);
			Tag taichung9 = tagprogbunitMap.get(buId_taichung+"#"+PROG_GRADE_9);
			Tag bethany9 = tagprogbunitMap.get(buId_bethany+"#"+PROG_GRADE_9);
			Tag kaihsiung9 = tagprogbunitMap.get(buId_kaohsiung+"#"+PROG_GRADE_9);

			Map<Integer, ArrayList<Tag>> campusTags = new SortingMap(feetags).doSortA("getBunitId");
			sometags = new PArrayList<Tag>(campusTags.get(buId_bethany));
			sometags.concate(campusTags.get(buId_kaohsiung));
			for (int i=0; i<sometags.size(); i++) {
				Tag t = sometags.get(i);
				tms = tmsMap.get(t.getId());
				for (int j=0; tms!=null&&j<tms.size(); j++) {
					if (isIn(tms.get(j).getMembrId(), PROG_GRADE_9)) {
						if (tmmgr.numOfRows("membrId=" + tms.get(j).getMembrId() + " and tagId=" + taichung.getId())==0) {
							TagMembr tm = new TagMembr();
							tm.setMembrId(tms.get(j).getMembrId());
							tm.setTagId(taichung.getId());
							tm.setBindTime(new Date());
							tmmgr.create(tm);
							tm.setTagId(taichung9.getId());
							tmmgr.create(tm);
						}
						Object[] objs = { tms.get(j) };
						tmmgr.remove(objs);
					}
				}
			}
		}

        // 12 年級畢業 所有 tag 都去掉, student 設成 status 99 (離校)
        ArrayList<Tag> g12 = tagprogMap.get(PROG_GRADE_12);
        for (int i=0; i<g12.size(); i++) {
            Tag t = g12.get(i);
            tms = tmsMap.get(t.getId());
            if (tms==null)
                continue;
            String membrIds = new RangeMaker().makeRange(tms, "getMembrId");
            ArrayList<McaStudent> tmp = new McaStudentMgr(tran_id).retrieveList("membrId in (" + membrIds + ")", "");
            String studentIds = new RangeMaker().makeRange(tmp, "getStudId");
            new Student2Mgr(tran_id).executeSQL("update student set studentStatus=99 where id in (" + studentIds + ")");
            tmmgr.executeSQL("delete from tagmembr where tagId in (" + tagIds + ") and membrId in (" + membrIds + ")");
        }

        // 把前面 create/delete 的重讀一次
        tmsMap = new SortingMap(new TagMembrMgr(tran_id).
            retrieveList("tagId in (" + tagIds + ")", "")).doSortA("getTagId");

        // 每一級的都要清空然后將下一級的複製過來       
        for (int g=PROG_GRADE_12; g>=PROG_GRADE_K; g--) {
            ArrayList<Tag> gradeTags = tagprogMap.get(g); // 所有校區的
            String tmpIds = new RangeMaker().makeRange(gradeTags, "getId");
            //## step1, 先把該級的 tagmembr 刪掉           
            tmmgr.executeSQL("delete from tagmembr where tagId in (" + tmpIds + ")");
            if (g==PROG_GRADE_K)
                break;
            for (int i=0; i<gradeTags.size(); i++) {
                //## step2, 先低一級的 membr 加到這一級
                Tag t1 = gradeTags.get(i);
                Tag t2 = tagprogbunitMap.get(t1.getBunitId()+"#"+(g-1)); // 如果是臺北G12, 就要找臺北G11
                tms = tmsMap.get(t2.getId());

                for (int j=0; tms!=null&&j<tms.size(); j++) {
                    TagMembr tm = new TagMembr();
                    tm.setTagId(t1.getId());
                    tm.setMembrId(tms.get(j).getMembrId());
                    tm.setBindTime(new Date());
                    tmmgr.create(tm);                    
                }
            }
        }

        syncupMcaStudentWithTags(fee);
    }

    public void syncupMcaStudentWithTags(McaFee fee)
        throws Exception
    {
        McaTagHelper th = new McaTagHelper(tran_id);
        ArrayList<Tag> feetags = th.getFeeTags(fee);
        Map<Integer, ArrayList<Tag>> campusTags = new SortingMap(feetags).doSortA("getBunitId");

        String tagIds = new RangeMaker().makeRange(feetags, "getId");
        Map<Integer, ArrayList<TagMembr>> tmsMap = new SortingMap(new TagMembrMgr(tran_id).
            retrieveList("tagId in (" + tagIds + ")", "")).doSortA("getTagId");

        McaStudentMgr msmgr = new McaStudentMgr(tran_id);
        MembrMgr mmgr = new MembrMgr(tran_id);
        Student2Mgr smgr = new Student2Mgr(tran_id);

        prepareMembrTags(fee);

        Iterator<String> iter = bunitMap.keySet().iterator();
        while (iter.hasNext()) {
            Bunit bu = bunitMap.get(iter.next());
            ArrayList<Tag> ctags = campusTags.get(bu.getId());
            for (int i=0; i<ctags.size(); i++) {
                ArrayList<TagMembr> tms = tmsMap.get(ctags.get(i).getId());
                for (int j=0; tms!=null&&j<tms.size(); j++) {
                    McaStudent ms = studentMap.get(tms.get(j).getMembrId());
                    Membr membr = membrMap.get(ms.getMembrId());
                    ms.setCampus(bu.getLabel());
                    membr.setBunitId(bu.getId());
                    smgr.executeSQL("update student set bunitId=" + bu.getId() + 
                        ",studentStatus=4 where id=" + ms.getStudId()); // 再設回 就讀 if it's already 畢業了
                    for (int g=PROG_GRADE_K; g<=PROG_GRADE_12; g++) {
                        if (isIn(ms.getMembrId(), g)) {
                            ms.setGrade(getGradeName(g));
                            break;
                        }
                    }
                    msmgr.save(ms);
                    mmgr.save(membr);
                }
            }
        }
    }

    public String getGradeName(int progId)
    {
        int grade = progId - PROG_GRADE_K;
        if (grade==0)
            return "K";
        return grade + "";
    }

    public int getGradeProgId(String name)
    {
        if (name==null || name.equals("K") || name.length()==0)
            return PROG_GRADE_K;
        int grade = Integer.parseInt(name);
        return PROG_GRADE_1 + (grade-1);
    }

    public McaFee getActiveFee()
        throws Exception
    {
        McaFeeMgr fmgr = new McaFeeMgr(tran_id);
        ArrayList<McaFee> fees = fmgr.retrieveList("status=" + McaFee.STATUS_ACTIVE, "order by id desc limit 1");
        return fees.get(0);
    }

    Map<Date, String> includesMap = null;
    Map<Date, String> excludesMap = null;
    void prepareIncludeExclude(String includes, String excludes)
        throws Exception
    {        
        String[] tokens = null;
        if (excludes!=null && excludes.trim().length()>0) {
            if (excludes.indexOf(",")>0)
                tokens = excludes.split(",");
            else
                tokens = excludes.split("\n");
        }
        excludesMap = new HashMap<Date, String>();
        for (int i=0; tokens!=null&&i<tokens.length; i++) {
            excludesMap.put(sdf.parse(tokens[i]), "");
        }

        tokens = null;
        if (includes!=null && includes.trim().length()>0) {
            if (includes.indexOf(",")>0)
                tokens = includes.split(",");
            else
                tokens = includes.split("\n");
        }
        includesMap = new HashMap<Date, String>();
        for (int i=0; tokens!=null&&i<tokens.length; i++) {
            includesMap.put(sdf.parse(tokens[i]), "");
        }
    }

    public int getSchoolDays(Date start, Date end)
    {
        if (start==null || end==null)
            return 0;
        Calendar c = Calendar.getInstance();
        c.setTime(start);
        int days = 0;
        while (true) {
            int w = c.get(Calendar.DAY_OF_WEEK);
            Date d = c.getTime();
            if (d.compareTo(end)>0)
                break;
            c.add(Calendar.DATE, 1);
            if (w==7 || w==1) { // 跳過星期六日
                if (includesMap.get(d)==null)
                    continue;
            }
            else if (excludesMap.get(d)!=null)
                continue;
            days ++;
        }

        return days;
    }

    public String getSemesterDaysInfo(McaFee fee)
        throws Exception
    {
        Date start = fee.getStartDay();
        Date end = fee.getEndDay();
        if (start==null || end==null) {
            return "N/A";
        }

        prepareIncludeExclude(fee.getIncludeDays(), fee.getExcludeDays());
        int days = getSchoolDays(start, end);
        return "Start:" + sdf.format(start) + "\n End:" + sdf.format(end) + "\n Total:" + days + " days";
    }

	/* 退休，全用 getBaseWithoutLatefee
    // caculate amount without interest
    public int getBaseAmountWithLateFee(String ticketId)
        throws Exception
    {
        // 這里有問題，沒考慮 discounts, 到時要改成和 McaInterest 一樣
        ArrayList<ChargeItemMembr> citems = new ChargeItemMembrMgr(tran_id).retrieveList("ticketId='" + ticketId + "'", "");
        int base = 0;
        for (int i=0; i<citems.size(); i++) {
            if (citems.get(i).getChargeName_().equals(BILL_ITEMS[22])) // Interest
                continue;
            if (citems.get(i).getChargeName_().equals(BILL_ITEMS[23])) // ## Latefee
                continue;
            if (citems.get(i).getChargeName_().equals(BILL_ITEMS[24])) // ## Interest
                continue;
            base += citems.get(i).getMyAmount();
        }
        return base;
    }
	*/

    public static int getInterestAmount(int amt, int[] series)
    {
        int a = amt/5;
        series[0] = a;
        series[1] = (int) (a + (amt-a)*0.01);
        series[2] = (int) (a + (amt-2*a)*0.01);
        series[3] = (int) (a + (amt-3*a)*0.01);
        series[4] = (int) (a + (amt-4*a)*0.01);
        int total = 0;
        for (int i=0; i<5; i++)
            total += series[i];
        return total - amt;
    }
 
    public int setupDeferred(MembrInfoBillRecord bill, int type, int userId, boolean updateVoucher)
        throws Exception
    {
        McaDeferredMgr mdmgr = new McaDeferredMgr(tran_id);
        McaDeferred md = mdmgr.find("ticketId='" + bill.getTicketId() + "'");
        int ret = 0;
        if (md==null) {
            md = new McaDeferred();
            md.setTicketId(bill.getTicketId());
            md.setType(type);
            md.setBunitId(bill.getBunitId());
            mdmgr.create(md);
        }
        else {
            ret = md.getType();
            md.setType(type);
            mdmgr.save(md);
        }

        ArrayList<ChargeItemMembr> citems = new ChargeItemMembrMgr(tran_id).retrieveList("chargeitem.billRecordId="
            + bill.getBillRecordId() + " and charge.membrId=" + bill.getMembrId(), "");
        Map<String, ChargeItemMembr> citemMap = new SortingMap(citems).doSortSingleton("getChargeName_");

        // Deal with Late Fee
        ChargeItemMembr latefee = citemMap.get(BILL_ITEMS[11]);
        ChargeItemMembr latefee2 = citemMap.get(BILL_ITEMS[23]);
        EzCountingService ezsvc = EzCountingService.getInstance();
        BunitHelper bh = new BunitHelper(tran_id);
        Date nextFreezeDay = ezsvc.getFreezeNextDay(bh.getSpace("bunitId", bill.getBunitId()));
        Bunit bu = new BunitMgr(tran_id).find("id=" + bill.getBunitId());
        String campus = bu.getLabel();
        BillRecord br = new BillRecordMgr(tran_id).find("id=" + bill.getBillRecordId());
        McaRecord mr = new McaRecordInfoMgr(tran_id).find("billRecordId=" + bill.getBillRecordId()
            + " and mca_fee.status!=-1");
        McaFee fee = new McaFeeMgr(tran_id).find("id=" + mr.getMcaFeeId());

        if (type>0 && fee.getLateFee()>0) {
            // need late fee
            if (latefee==null && latefee2==null) {
                ChargeItem lf = getChargeItem(campus, fee, BILL_ITEMS[11]);
                Charge c = ezsvc.addChargeMembr(tran_id, lf, bill.getMembrId(), br, userId, nextFreezeDay);
                ChargeItemMembr ci = new ChargeItemMembrMgr(tran_id).find("chargeItemId=" + lf.getId() + 
                    " and charge.membrId=" + bill.getMembrId());
                ezsvc.setChargeItemMembrAmount(tran_id, ci, fee.getLateFee(), userId, nextFreezeDay);
            }
        }
        else {
            // cannot have late fee
            if (latefee!=null) {
                User u = (User) UserMgr.getInstance().find(userId);
                ezsvc.deleteCharge(tran_id, latefee, u, nextFreezeDay);
            }
        }

        // Deal with Interest
        ChargeItemMembr interest = citemMap.get(BILL_ITEMS[22]);
        if (type==McaDeferred.TYPE_MONTHLY) {
            // need to have Interest
            // int base = getBaseAmountWithLateFee(bill.getTicketId()); 這個 function 不用了
			McaInterest mi = new McaInterest(tran_id);
			mi.setup(bill);
			int base = mi.getBaseWithoutLatefee(bill);
			// monthly 的 interest 要加上 latefee 的
		    base += fee.getLateFee();
            if (interest==null) {
                ChargeItem intr = getChargeItem(campus, fee, BILL_ITEMS[22]);
                Charge c = ezsvc.addChargeMembr(tran_id, intr, bill.getMembrId(), br, userId, nextFreezeDay);
                int[] series = new int[5];
                int interest_amount = getInterestAmount(base, series);
                ChargeItemMembr ci = new ChargeItemMembrMgr(tran_id).find("chargeItemId=" + intr.getId() + 
                    " and charge.membrId=" + bill.getMembrId());
                ezsvc.setChargeItemMembrAmount(tran_id, ci, interest_amount, userId, nextFreezeDay);
            }
            else { 
                // see if interest change because of receivable change
                int cur_amount = interest.getMyAmount();
                int[] serials = new int[5];
                int interest_amount = getInterestAmount(base, serials);
                int diff = interest_amount - cur_amount;
                if (diff!=0) {
                    ezsvc.setChargeItemMembrAmount(tran_id, interest, interest_amount, userId, nextFreezeDay);
                }
            }
        }
        else {
            // don't need interest
            if (interest!=null) {
                User u = (User) UserMgr.getInstance().find(userId);
                ezsvc.deleteCharge(tran_id, interest, u, nextFreezeDay);
            }
        }

        if (updateVoucher && bill.getThreadId()>0) {
            String reason = (type==0)?"Deferred:N/A":(type==1)?"Deferred:Standard":"Deferred:Monthly";
            VoucherService vsvc = new VoucherService(tran_id, bill.getBunitId());
            vsvc.genVoucherForBill(bill, userId, reason);
        }

        return ret;
    }

    public int getBaseWithoutLatefee(ArrayList<ChargeItemMembr> charges, Map<String, ArrayList<Discount>> discountMap)
        throws Exception
    {
        int ret = 0;
        for (int i=0; i<charges.size(); i++) {
            ChargeItemMembr ci = charges.get(i);
            if (ci.getCopyStatus()==BillItem.COPY_NO) { // 不是 interest base 
                continue;
            }
            ret += ci.getMyAmount();
            ArrayList<Discount> discounts = discountMap.get(ci.getChargeKey());
            if (discounts!=null)
                for (int j=0; j<discounts.size(); j++)
                    ret -= discounts.get(j).getAmount();
        }
        return ret;
    }

    public void breakingBillFees(MembrInfoBillRecord sinfo, 
        Map<String, ArrayList<ChargeItemMembr>> chargeMap,
        Map<String, ArrayList<Discount>> discountMap,
        int[] fees, Map<Date, String> standardMap, Map<Date, String> monthlyMap)
        throws Exception
    {
        int latefee = 0;
        int interest = 0;
        int latefee2 = 0;
        int interest2 = 0;

        int base = 0;
        
        ArrayList<ChargeItemMembr> charges = chargeMap.get(sinfo.getTicketId());
        for (int i=0; i<charges.size(); i++) {
            ChargeItemMembr ci = charges.get(i);
            if (ci.getChargeName_().equals(BILL_ITEMS[11]))
                latefee += ci.getMyAmount();
            else if (ci.getChargeName_().equals(BILL_ITEMS[22]))
                interest += ci.getMyAmount();
            else if (ci.getChargeName_().equals(BILL_ITEMS[23]))
                latefee2 += ci.getMyAmount();
            else if (ci.getChargeName_().equals(BILL_ITEMS[24]))
                interest2 += ci.getMyAmount();
        }

        // int base_without_latefee = sinfo.getReceivable() - latefee - interest - latefee2 - interest2;
        int base_without_latefee = getBaseWithoutLatefee(charges, discountMap);
        int a = base_without_latefee/4;
        fees[0] = base_without_latefee;
        fees[1] = latefee;
        fees[2] = interest;

        int[] series = new int[5];
        int base_with_latefee = (base_without_latefee+latefee);
        getInterestAmount(base_with_latefee, series);

        DecimalFormat mnf = new DecimalFormat("###,###,##0");

        Date standard_plan_change_date = sdf.parse("2010-10-01");
        Date today = new Date();
    
        Calendar c = Calendar.getInstance();
        c.setTime(sinfo.getMyBillDate());
        standardMap.put(c.getTime(), mnf.format(a*2+latefee));
        monthlyMap.put(c.getTime(), mnf.format(series[0]));
        c.add(Calendar.MONTH, 1);
        c.set(Calendar.DAY_OF_MONTH, 1);
        if (today.compareTo(standard_plan_change_date)>0)
            standardMap.put(c.getTime(), mnf.format(a));
        else
            standardMap.put(c.getTime(), "");
        monthlyMap.put(c.getTime(), mnf.format(series[1]));
        c.add(Calendar.MONTH, 1);
        standardMap.put(c.getTime(), mnf.format(a));
        monthlyMap.put(c.getTime(), mnf.format(series[2]));
        c.add(Calendar.MONTH, 1);
        if (today.compareTo(standard_plan_change_date)>0)
            standardMap.put(c.getTime(), "");
        else
            standardMap.put(c.getTime(), mnf.format(a));
        monthlyMap.put(c.getTime(), mnf.format(series[3]));
        c.add(Calendar.MONTH, 1);
        standardMap.put(c.getTime(), "");
        monthlyMap.put(c.getTime(), mnf.format(series[4]));
    }

    public static String getAcodeSubQueryString(Bunit bu)
    {
        // 台北101 台中108  嘉義103  高雄104
        if (bu.getLabel().equals("Bethany"))
            return "Sub_Account='101'";
        else if (bu.getLabel().equals("Taichung"))
            return "Sub_Account='108'";
        else if (bu.getLabel().equals("Chiayi"))
            return "Sub_Account='103'";
        else if (bu.getLabel().equals("Kaohsiung"))
            return "Sub_Account='104'";
        return "";
    }

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

    public static Acode getMcaAcode(int tran_id, int bunitId, String acctcode)
        throws Exception
    {
        String[] tokens = acctcode.split("-");

        McaAuthorizerMgr aumgr = McaAuthorizerMgr.getInstance();
        aumgr.setDataSourceName("mssql");
        String q = "Account_Number='" + tokens[0] + "' and Sub_Account='" + tokens[1] + "'";
        McaAuthorizer au = aumgr.find(q);
        if (au==null)
            return null;
        String maincodeName = au.getAccount_Name();
        String fullName = getAcodeDescription(au);

        /*
        String fullName = acctcode;
        */
        VoucherService vsvc = new VoucherService(tran_id, bunitId);
        Acode root = vsvc.getAcode(tokens[0], null, "", false);
        Acode ret = vsvc.getAcode(tokens[0], tokens[1], fullName, false);

        LiteralStore store = new LiteralStore(tran_id, "literal", null);
        String desc = store.restore(ret.getName1());
        if (!desc.equals(fullName)) {
            store.save(ret.getName1(), fullName);
        }

        return ret;
    }

// 收據的編號為BR BS BD KR KS KD TR TS TD 
// (B是台北, K是高雄和嘉義, T是台中, R是台幣, S是美金, D是台幣奉獻收據
/*
收學費款的話,收據抬頭那邊寫學生名字 Acct no 為出納可以選,兩個選擇#116201應收學費 或#214101預收學費
一般收款的話, 收據抬頭讓出納自己打, 會計科目則連結到會計科目的資料庫, 用選的
Description若是收學費款的話, 就填帳單的title, 不過還是要讓出納有編輯的權限
般收款的話, 就先帶出會計科目的名稱, 一樣要讓出納有編輯的權限

收據分 一般臺幣、一般美金、捐贈臺幣
一般臺幣：XR (X：B是台北, K是高雄和嘉義, T是台中)
*/
    public McaReceipt getReceipt(Costpay2 cp, boolean isDonation, String payerName)
        throws Exception
    {
        McaReceiptMgr mrmgr = McaReceiptMgr.getInstance();
        McaReceipt mr = mrmgr.find("costpayId=" + cp.getId()); 
        if (mr==null) { // need to create
            Map<Integer, Bunit> buMap = new SortingMap(new BunitMgr(tran_id).retrieveList
                ("flag=" + Bunit.FLAG_BIZ, "")).doSortSingleton("getId");
            Bunit bu = buMap.get(cp.getBunitId());
            String prefix = null;
            if (bu.getLabel().equals("Bethany")) {
                prefix = "B";
            }
            else if (bu.getLabel().equals("Taichung")) {
                prefix = "T";
            }
            else if (bu.getLabel().equals("Kaohsiung") || bu.getLabel().equals("Chiayi")) {
                prefix = "K";
            }

            boolean USD = (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CASH || cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CHECK)
            || (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_BANK && cp.getExRateId()>0);

            if (USD) { // 美金
                prefix += "S";
            }
            else {
                if (isDonation) { // 捐獻
                    prefix += "D";
                }
                else {
                    prefix += "R";
                }
            }
            ArrayList<McaReceipt> receipts = mrmgr.retrieveList("pkey like '" + prefix + "%'", 
                "order by pkey desc limit 1");
            int num = 1;
            if (receipts.size()>0) {
                num = Integer.parseInt(receipts.get(0).getPkey().substring(2));
                num ++;
            }
            String pkey = prefix + PaymentPrinter.makePrecise(num+"", 6, false, '0');
            mr = new McaReceipt();
            mr.setPkey(pkey);
            mr.setCostpayId(cp.getId());
            mrmgr.create(mr);

            cp.setPayerName(payerName);
            cp.setReceiptNo(pkey);
            new Costpay2Mgr(tran_id).save(cp);
        }
        return mr;
    }

    Tag getCurrentCampusTag(int bunitId)
        throws Exception
    {
        Map<Integer, Bunit> buMap = new SortingMap(new BunitMgr(tran_id).retrieveList("flag=" + Bunit.FLAG_BIZ, ""))
                .doSortSingleton("getId");
        Bunit bu = buMap.get(bunitId);
        Tag tag = null;
        TagMgr tmgr = new TagMgr(tran_id);
        if (bu.getLabel().equals("Bethany")) {
            tag = tmgr.find("progId=" + PROG_TUITION_BETHANY + " and status=" + Tag.STATUS_CURRENT);
        }
        else if (bu.getLabel().equals("Taichung")) {
            tag = tmgr.find("progId=" + PROG_TUITION_TAICHUNG + " and status=" + Tag.STATUS_CURRENT);
        }
        else if (bu.getLabel().equals("Kaohsiung")) {
            tag = tmgr.find("progId=" + PROG_TUITION_KAOHSIUNG + " and status=" + Tag.STATUS_CURRENT);
        }
        else if (bu.getLabel().equals("Chiayi")) {
            tag = tmgr.find("progId=" + PROG_TUITION_CHIAYI + " and status=" + Tag.STATUS_CURRENT);
        }
        return tag;
    }

    public ArrayList<Tag> getCurrentTags(int bunitId)
        throws Exception
    {
        Tag tag = getCurrentCampusTag(bunitId);
        CitemTagMgr ctmgr = new CitemTagMgr(tran_id);
        CitemTag citag = ctmgr.find("tagId=" + tag.getId());
        int feeId = citag.getChargeItemId();
        McaFee fee = new McaFeeMgr(tran_id).find("id=" + feeId);
        BunitHelper bh = new BunitHelper(tran_id);
        String space = bh.getSpace("bunitId", bunitId);
        return new McaTagHelper(tran_id).getFeeTags(fee, space);
    }

    public void leaveCurrentCampus(McaStudent ms, int bunitId)
        throws Exception
    {
        ArrayList<Tag> tags = getCurrentTags(bunitId);
        String tagIds = new RangeMaker().makeRange(tags, "getId");

        // 要檢查下離開的這個學期的收費是否已繳，如果已繳就不可離校，要先轉至學生帳戶
        Tag tag = getCurrentCampusTag(bunitId);
        CitemTagMgr ctmgr = new CitemTagMgr(tran_id);
        CitemTag citag = ctmgr.find("tagId=" + tag.getId());
        int feeId = citag.getChargeItemId();
        ArrayList<McaRecord> mrs = new McaRecordMgr(tran_id).retrieveList("mcaFeeId=" + feeId, "");
        String billRecordIds = new RangeMaker().makeRange(mrs, "getBillRecordId");
        MembrBillRecord bill = new MembrBillRecordMgr(tran_id).find("membrId=" + ms.getMembrId() + 
            " and billRecordId in (" + billRecordIds + ")");
        if (bill!=null) {
            if (new BillPaidMgr(tran_id).numOfRows("ticketId='" + bill.getTicketId() + "' and amount>0")>0)
                throw new Exception("This student already has paying record(s) in current fee, cannot proceed.");
            new MembrBillRecordMgr(tran_id).executeSQL("delete from membrbillrecord where ticketId='" + bill.getTicketId() + "'");
        }

        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        tmmgr.executeSQL("delete from tagmembr where tagId in (" + tagIds + ") and membrId=" + ms.getMembrId());

        Student2Mgr stmgr = new Student2Mgr(tran_id);
        Student2 st = stmgr.find("id=" + ms.getStudId());
        st.setStudentStatus(99);
        stmgr.save(st);    
    }

    public void addCurrentCampus(McaStudent ms, int bunitId)
        throws Exception
    {
        Tag tag = getCurrentCampusTag(bunitId);
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        if (tmmgr.numOfRows("tagId=" + tag.getId() + " and membrId=" + ms.getMembrId())>0)
            return;
        TagMembr tm = new TagMembr();
        tm.setTagId(tag.getId());
        tm.setMembrId(ms.getMembrId());
        tmmgr.create(tm);

        Student2Mgr stmgr = new Student2Mgr(tran_id);
        Student2 st = stmgr.find("id=" + ms.getStudId());
        st.setStudentStatus(4);
        stmgr.save(st);
    }

    public ArrayList<TagMembr> getCurrentCampusMembrs(int bunitId)
        throws Exception
    {
        Tag tag = getCurrentCampusTag(bunitId);
        return new TagMembrMgr(tran_id).retrieveList("tagId=" + tag.getId(), ""); 
    }

    class DetailDrawer
    {
        StringBuffer sb;
        Map<String, ChargeItemMembr> chargeMap;
        Map<Integer, BillItem> bitemMap;
        Map<Integer, ChargeItem> citemMap;
        Map<Integer, Membr> membrMap;
        DecimalFormat mnf = new DecimalFormat("###,###,##0");

        DetailDrawer(McaFee fee, StringBuffer sb, int bunitId, BunitHelper bh)
            throws Exception
        {
            ArrayList<McaFeeRecord> mr = new McaFeeRecordMgr(tran_id).retrieveListX
                ("mcaFeeId=" + fee.getId(), "", bh.getSpace("bunitId", bunitId));
            String billRecordIds = new RangeMaker().makeRange(mr, "getId");
            ArrayList<ChargeItem> citems = new ChargeItemMgr(tran_id).retrieveList("billRecordId in (" + billRecordIds + ")", "");
            String citemIds = new RangeMaker().makeRange(citems, "getId");
            String bitemIds = new RangeMaker().makeRange(citems, "getBillItemId");

            this.membrMap = new SortingMap(new MembrMgr(tran_id).retrieveList("", "")).doSortSingleton("getId");
            this.bitemMap = new SortingMap(new BillItemMgr(tran_id).retrieveList("id in (" + bitemIds + ")", "")).doSortSingleton("getId");
            this.citemMap = new SortingMap(citems).doSortSingleton("getId");
            this.chargeMap = new SortingMap(new ChargeItemMembrMgr(tran_id).retrieveList("chargeItemId in (" + 
                citemIds + ")", "")).doSortSingleton("getChargeKey");
            this.sb = sb;
            this.sb.append("<link rel=\"stylesheet\" href=\"../eSystem/ft02.css\" type=\"text/css\">");
            this.sb.append("<table width=\"390\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr align=left valign=top><td bgcolor=\"#e9e3de\">");
            this.sb.append("<table width=\"100%\" border=0 cellpadding=4 cellspacing=1>");
            this.sb.append("<tr class=es02 bgcolor=f0f0f0><td nowrap>Student Name</td>");
            this.sb.append("<td nowrap>Charge Name</td><td nowrap>Org.Value</td>");
            this.sb.append("<td nowrap>New Value</td><td></td><td>Note</td></tr>");
        }

        void drawModify(Charge oldc, Charge newc)
            throws Exception
        {
            ChargeItemMembr cim = chargeMap.get(oldc.getChargeKey());
            sb.append("<tr class=es02 bgcolor=ffffff><td nowrap>");
            sb.append(cim.getMembrName());
            sb.append("</td><td nowrap>");
            sb.append(cim.getChargeName());
            sb.append("</td><td nowrap>");
            sb.append(mnf.format(oldc.getAmount()));
            sb.append("</td><td nowrap>");
            sb.append(mnf.format(newc.getAmount()));
            sb.append("</td><td align=left> &nbsp;modified</td><td align=left nowrap>&nbsp;");
            sb.append("<td align=right>");
            sb.append(newc.getNote());
            sb.append("</td></tr>");
        }

        void drawCreated(Charge newc)
            throws Exception
        {
            ChargeItem ci = citemMap.get(newc.getChargeItemId());
            BillItem bi = bitemMap.get(ci.getBillItemId());
            Membr m = membrMap.get(newc.getMembrId());

            sb.append("<tr class=es02 bgcolor=ffffff><td nowrap>");
            sb.append(m.getName());
            sb.append("</td><td nowrap>");
            sb.append(bi.getName());
            sb.append("</td><td>");
            sb.append("</td><td nowrap align=right>");
            sb.append(mnf.format(newc.getAmount()));
            sb.append("</td><td align=left> &nbsp;new</td><td align=left nowrap>&nbsp;");
            sb.append(newc.getNote());
            sb.append("</td></tr>");        
        }

        void drawConflict(Charge oldc, Charge newc)
            throws Exception
        {
            ChargeItemMembr cim = chargeMap.get(oldc.getChargeKey());
            sb.append(cim.getChargeName() + " conflict org:" + oldc.getAmount() + " new:" + newc.getAmount() + "<br>\n");
            sb.append("<tr class=es02 bgcolor=ffffff><td nowrap>");
            sb.append(cim.getMembrName());
            sb.append("</td><td nowrap>");
            sb.append(cim.getChargeName());
            sb.append("</td><td nowrap align=right>");
            sb.append(mnf.format(oldc.getAmount()));
            sb.append("</td><td nowrap align=right>");
            sb.append(mnf.format(newc.getAmount()));
            sb.append("</td><td align=left> &nbsp;conflict</td><td align=left nowrap>&nbsp;");
            sb.append(newc.getNote());
            sb.append("</td></tr>");
        }

        void drawDeleted(Charge oldc)
            throws Exception
        {
            ChargeItemMembr cim = chargeMap.get(oldc.getChargeKey());
            sb.append("<tr class=es02 bgcolor=ffffff><td nowrap>");
            sb.append(cim.getMembrName());
            sb.append("</td><td nowrap>");
            sb.append(cim.getChargeName());
            sb.append("</td><td nowrap align=right>");
            sb.append(mnf.format(oldc.getAmount()));
            sb.append("</td><td>");
            sb.append("");
            sb.append("</td><td align=left> &nbsp;deleted</td><td align=left nowrap>&nbsp;");
            sb.append(oldc.getNote());
            sb.append("</td></tr>");
        }

        void finish()
        {
            sb.append("</table></td></tr></table>");
        }
    }
}


