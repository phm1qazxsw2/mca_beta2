package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaFeeMgr extends dbo.Manager<McaFee>
{
    private static McaFeeMgr _instance = null;

    McaFeeMgr() {}

    public synchronized static McaFeeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaFeeMgr();
        }
        return _instance;
    }

    public McaFeeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_fee";
    }

    protected Object makeBean()
    {
        return new McaFee();
    }

    protected String getIdentifier(Object obj)
    {
        McaFee o = (McaFee) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaFee item = (McaFee) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
            String	title		 = rs.getString("title");
            item.setTitle(title);
            java.util.Date	month		 = rs.getTimestamp("month");
            item.setMonth(month);
            java.util.Date	billDate		 = rs.getTimestamp("billDate");
            item.setBillDate(billDate);
            int	feeType		 = rs.getInt("feeType");
            item.setFeeType(feeType);
            int	checkFeeId		 = rs.getInt("checkFeeId");
            item.setCheckFeeId(checkFeeId);
            int	checkFallFeeId		 = rs.getInt("checkFallFeeId");
            item.setCheckFallFeeId(checkFallFeeId);
            java.util.Date	regPrepayDeadline		 = rs.getTimestamp("regPrepayDeadline");
            item.setRegPrepayDeadline(regPrepayDeadline);
            int	regPenalty		 = rs.getInt("regPenalty");
            item.setRegPenalty(regPenalty);
            int	lateFee		 = rs.getInt("lateFee");
            item.setLateFee(lateFee);
            int	RegA		 = rs.getInt("RegA");
            item.setRegA(RegA);
            int	RegB		 = rs.getInt("RegB");
            item.setRegB(RegB);
            int	RegC		 = rs.getInt("RegC");
            item.setRegC(RegC);
            int	RegD		 = rs.getInt("RegD");
            item.setRegD(RegD);
            int	TuitionK5A		 = rs.getInt("TuitionK5A");
            item.setTuitionK5A(TuitionK5A);
            int	TuitionK5B		 = rs.getInt("TuitionK5B");
            item.setTuitionK5B(TuitionK5B);
            int	TuitionK5C		 = rs.getInt("TuitionK5C");
            item.setTuitionK5C(TuitionK5C);
            int	TuitionK5D		 = rs.getInt("TuitionK5D");
            item.setTuitionK5D(TuitionK5D);
            int	Tuition69A		 = rs.getInt("Tuition69A");
            item.setTuition69A(Tuition69A);
            int	Tuition69B		 = rs.getInt("Tuition69B");
            item.setTuition69B(Tuition69B);
            int	Tuition69C		 = rs.getInt("Tuition69C");
            item.setTuition69C(Tuition69C);
            int	Tuition69D		 = rs.getInt("Tuition69D");
            item.setTuition69D(Tuition69D);
            int	Tuition1012A		 = rs.getInt("Tuition1012A");
            item.setTuition1012A(Tuition1012A);
            int	Tuition1012B		 = rs.getInt("Tuition1012B");
            item.setTuition1012B(Tuition1012B);
            int	Tuition1012C		 = rs.getInt("Tuition1012C");
            item.setTuition1012C(Tuition1012C);
            int	Tuition1012D		 = rs.getInt("Tuition1012D");
            item.setTuition1012D(Tuition1012D);
            int	TP_TuitionK5A		 = rs.getInt("TP_TuitionK5A");
            item.setTP_TuitionK5A(TP_TuitionK5A);
            int	TP_TuitionK5B		 = rs.getInt("TP_TuitionK5B");
            item.setTP_TuitionK5B(TP_TuitionK5B);
            int	TP_TuitionK5C		 = rs.getInt("TP_TuitionK5C");
            item.setTP_TuitionK5C(TP_TuitionK5C);
            int	TP_TuitionK5D		 = rs.getInt("TP_TuitionK5D");
            item.setTP_TuitionK5D(TP_TuitionK5D);
            int	TP_Tuition69A		 = rs.getInt("TP_Tuition69A");
            item.setTP_Tuition69A(TP_Tuition69A);
            int	TP_Tuition69B		 = rs.getInt("TP_Tuition69B");
            item.setTP_Tuition69B(TP_Tuition69B);
            int	TP_Tuition69C		 = rs.getInt("TP_Tuition69C");
            item.setTP_Tuition69C(TP_Tuition69C);
            int	TP_Tuition69D		 = rs.getInt("TP_Tuition69D");
            item.setTP_Tuition69D(TP_Tuition69D);
            int	TP_Tuition1012A		 = rs.getInt("TP_Tuition1012A");
            item.setTP_Tuition1012A(TP_Tuition1012A);
            int	TP_Tuition1012B		 = rs.getInt("TP_Tuition1012B");
            item.setTP_Tuition1012B(TP_Tuition1012B);
            int	TP_Tuition1012C		 = rs.getInt("TP_Tuition1012C");
            item.setTP_Tuition1012C(TP_Tuition1012C);
            int	TP_Tuition1012D		 = rs.getInt("TP_Tuition1012D");
            item.setTP_Tuition1012D(TP_Tuition1012D);
            int	K_TuitionK5A		 = rs.getInt("K_TuitionK5A");
            item.setK_TuitionK5A(K_TuitionK5A);
            int	K_TuitionK5B		 = rs.getInt("K_TuitionK5B");
            item.setK_TuitionK5B(K_TuitionK5B);
            int	K_TuitionK5C		 = rs.getInt("K_TuitionK5C");
            item.setK_TuitionK5C(K_TuitionK5C);
            int	K_TuitionK5D		 = rs.getInt("K_TuitionK5D");
            item.setK_TuitionK5D(K_TuitionK5D);
            int	K_Tuition69A		 = rs.getInt("K_Tuition69A");
            item.setK_Tuition69A(K_Tuition69A);
            int	K_Tuition69B		 = rs.getInt("K_Tuition69B");
            item.setK_Tuition69B(K_Tuition69B);
            int	K_Tuition69C		 = rs.getInt("K_Tuition69C");
            item.setK_Tuition69C(K_Tuition69C);
            int	K_Tuition69D		 = rs.getInt("K_Tuition69D");
            item.setK_Tuition69D(K_Tuition69D);
            int	K_Tuition1012A		 = rs.getInt("K_Tuition1012A");
            item.setK_Tuition1012A(K_Tuition1012A);
            int	K_Tuition1012B		 = rs.getInt("K_Tuition1012B");
            item.setK_Tuition1012B(K_Tuition1012B);
            int	K_Tuition1012C		 = rs.getInt("K_Tuition1012C");
            item.setK_Tuition1012C(K_Tuition1012C);
            int	K_Tuition1012D		 = rs.getInt("K_Tuition1012D");
            item.setK_Tuition1012D(K_Tuition1012D);
            int	BuildingA		 = rs.getInt("BuildingA");
            item.setBuildingA(BuildingA);
            int	BuildingB		 = rs.getInt("BuildingB");
            item.setBuildingB(BuildingB);
            int	BuildingC		 = rs.getInt("BuildingC");
            item.setBuildingC(BuildingC);
            int	BuildingD		 = rs.getInt("BuildingD");
            item.setBuildingD(BuildingD);
            int	DormProgramA		 = rs.getInt("DormProgramA");
            item.setDormProgramA(DormProgramA);
            int	DormProgramB		 = rs.getInt("DormProgramB");
            item.setDormProgramB(DormProgramB);
            int	DormProgramC		 = rs.getInt("DormProgramC");
            item.setDormProgramC(DormProgramC);
            int	DormProgramD		 = rs.getInt("DormProgramD");
            item.setDormProgramD(DormProgramD);
            int	DormDepositA		 = rs.getInt("DormDepositA");
            item.setDormDepositA(DormDepositA);
            int	DormDepositB		 = rs.getInt("DormDepositB");
            item.setDormDepositB(DormDepositB);
            int	DormDepositC		 = rs.getInt("DormDepositC");
            item.setDormDepositC(DormDepositC);
            int	DormDepositD		 = rs.getInt("DormDepositD");
            item.setDormDepositD(DormDepositD);
            int	DormFacilityA		 = rs.getInt("DormFacilityA");
            item.setDormFacilityA(DormFacilityA);
            int	DormFacilityB		 = rs.getInt("DormFacilityB");
            item.setDormFacilityB(DormFacilityB);
            int	DormFacilityC		 = rs.getInt("DormFacilityC");
            item.setDormFacilityC(DormFacilityC);
            int	DormFacilityD		 = rs.getInt("DormFacilityD");
            item.setDormFacilityD(DormFacilityD);
            int	DormFoodA		 = rs.getInt("DormFoodA");
            item.setDormFoodA(DormFoodA);
            int	DormFoodB		 = rs.getInt("DormFoodB");
            item.setDormFoodB(DormFoodB);
            int	DormFoodC		 = rs.getInt("DormFoodC");
            item.setDormFoodC(DormFoodC);
            int	DormFoodD		 = rs.getInt("DormFoodD");
            item.setDormFoodD(DormFoodD);
            int	ELLModerateA		 = rs.getInt("ELLModerateA");
            item.setELLModerateA(ELLModerateA);
            int	ELLModerateB		 = rs.getInt("ELLModerateB");
            item.setELLModerateB(ELLModerateB);
            int	ELLModerateC		 = rs.getInt("ELLModerateC");
            item.setELLModerateC(ELLModerateC);
            int	ELLModerateD		 = rs.getInt("ELLModerateD");
            item.setELLModerateD(ELLModerateD);
            int	ELLSignificantA		 = rs.getInt("ELLSignificantA");
            item.setELLSignificantA(ELLSignificantA);
            int	ELLSignificantB		 = rs.getInt("ELLSignificantB");
            item.setELLSignificantB(ELLSignificantB);
            int	ELLSignificantC		 = rs.getInt("ELLSignificantC");
            item.setELLSignificantC(ELLSignificantC);
            int	ELLSignificantD		 = rs.getInt("ELLSignificantD");
            item.setELLSignificantD(ELLSignificantD);
            int	MusicPrivateA		 = rs.getInt("MusicPrivateA");
            item.setMusicPrivateA(MusicPrivateA);
            int	MusicPrivateB		 = rs.getInt("MusicPrivateB");
            item.setMusicPrivateB(MusicPrivateB);
            int	MusicPrivateC		 = rs.getInt("MusicPrivateC");
            item.setMusicPrivateC(MusicPrivateC);
            int	MusicPrivateD		 = rs.getInt("MusicPrivateD");
            item.setMusicPrivateD(MusicPrivateD);
            int	MusicSemiPrivateA		 = rs.getInt("MusicSemiPrivateA");
            item.setMusicSemiPrivateA(MusicSemiPrivateA);
            int	MusicSemiPrivateB		 = rs.getInt("MusicSemiPrivateB");
            item.setMusicSemiPrivateB(MusicSemiPrivateB);
            int	MusicSemiPrivateC		 = rs.getInt("MusicSemiPrivateC");
            item.setMusicSemiPrivateC(MusicSemiPrivateC);
            int	MusicSemiPrivateD		 = rs.getInt("MusicSemiPrivateD");
            item.setMusicSemiPrivateD(MusicSemiPrivateD);
            int	MusicSemiGroupA		 = rs.getInt("MusicSemiGroupA");
            item.setMusicSemiGroupA(MusicSemiGroupA);
            int	MusicSemiGroupB		 = rs.getInt("MusicSemiGroupB");
            item.setMusicSemiGroupB(MusicSemiGroupB);
            int	MusicSemiGroupC		 = rs.getInt("MusicSemiGroupC");
            item.setMusicSemiGroupC(MusicSemiGroupC);
            int	MusicSemiGroupD		 = rs.getInt("MusicSemiGroupD");
            item.setMusicSemiGroupD(MusicSemiGroupD);
            int	TestingA		 = rs.getInt("TestingA");
            item.setTestingA(TestingA);
            int	TestingB		 = rs.getInt("TestingB");
            item.setTestingB(TestingB);
            int	TestingC		 = rs.getInt("TestingC");
            item.setTestingC(TestingC);
            int	TestingD		 = rs.getInt("TestingD");
            item.setTestingD(TestingD);
            int	Milk		 = rs.getInt("Milk");
            item.setMilk(Milk);
            int	TchLunch1		 = rs.getInt("TchLunch1");
            item.setTchLunch1(TchLunch1);
            int	TchLunch2		 = rs.getInt("TchLunch2");
            item.setTchLunch2(TchLunch2);
            int	TchLunch3		 = rs.getInt("TchLunch3");
            item.setTchLunch3(TchLunch3);
            int	TchLunch4		 = rs.getInt("TchLunch4");
            item.setTchLunch4(TchLunch4);
            int	TchLunch5		 = rs.getInt("TchLunch5");
            item.setTchLunch5(TchLunch5);
            int	TchLunch6		 = rs.getInt("TchLunch6");
            item.setTchLunch6(TchLunch6);
            int	TchLunch7		 = rs.getInt("TchLunch7");
            item.setTchLunch7(TchLunch7);
            int	KaoLunch1		 = rs.getInt("KaoLunch1");
            item.setKaoLunch1(KaoLunch1);
            int	KaoLunch2		 = rs.getInt("KaoLunch2");
            item.setKaoLunch2(KaoLunch2);
            int	Instrument		 = rs.getInt("Instrument");
            item.setInstrument(Instrument);
            int	MusicRoom		 = rs.getInt("MusicRoom");
            item.setMusicRoom(MusicRoom);
            int	FamilyDiscountA		 = rs.getInt("FamilyDiscountA");
            item.setFamilyDiscountA(FamilyDiscountA);
            int	FamilyDiscountB		 = rs.getInt("FamilyDiscountB");
            item.setFamilyDiscountB(FamilyDiscountB);
            int	Bus		 = rs.getInt("Bus");
            item.setBus(Bus);
            java.util.Date	startDay		 = rs.getTimestamp("startDay");
            item.setStartDay(startDay);
            java.util.Date	endDay		 = rs.getTimestamp("endDay");
            item.setEndDay(endDay);
            java.util.Date	prorateDay		 = rs.getTimestamp("prorateDay");
            item.setProrateDay(prorateDay);
            String	excludeDays		 = rs.getString("excludeDays");
            item.setExcludeDays(excludeDays);
            String	includeDays		 = rs.getString("includeDays");
            item.setIncludeDays(includeDays);
            int	EntranceA		 = rs.getInt("EntranceA");
            item.setEntranceA(EntranceA);
            int	EntranceB		 = rs.getInt("EntranceB");
            item.setEntranceB(EntranceB);
            int	EntranceC		 = rs.getInt("EntranceC");
            item.setEntranceC(EntranceC);
            int	EntranceD		 = rs.getInt("EntranceD");
            item.setEntranceD(EntranceD);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getSaveString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaFee item = (McaFee) obj;

        String ret = 
            "status=" + item.getStatus()
            + ",title='" + ServerTool.escapeString(item.getTitle()) + "'"
            + ",month=" + (((d=item.getMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",billDate=" + (((d=item.getBillDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",feeType=" + item.getFeeType()
            + ",checkFeeId=" + item.getCheckFeeId()
            + ",checkFallFeeId=" + item.getCheckFallFeeId()
            + ",regPrepayDeadline=" + (((d=item.getRegPrepayDeadline())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",regPenalty=" + item.getRegPenalty()
            + ",lateFee=" + item.getLateFee()
            + ",RegA=" + item.getRegA()
            + ",RegB=" + item.getRegB()
            + ",RegC=" + item.getRegC()
            + ",RegD=" + item.getRegD()
            + ",TuitionK5A=" + item.getTuitionK5A()
            + ",TuitionK5B=" + item.getTuitionK5B()
            + ",TuitionK5C=" + item.getTuitionK5C()
            + ",TuitionK5D=" + item.getTuitionK5D()
            + ",Tuition69A=" + item.getTuition69A()
            + ",Tuition69B=" + item.getTuition69B()
            + ",Tuition69C=" + item.getTuition69C()
            + ",Tuition69D=" + item.getTuition69D()
            + ",Tuition1012A=" + item.getTuition1012A()
            + ",Tuition1012B=" + item.getTuition1012B()
            + ",Tuition1012C=" + item.getTuition1012C()
            + ",Tuition1012D=" + item.getTuition1012D()
            + ",TP_TuitionK5A=" + item.getTP_TuitionK5A()
            + ",TP_TuitionK5B=" + item.getTP_TuitionK5B()
            + ",TP_TuitionK5C=" + item.getTP_TuitionK5C()
            + ",TP_TuitionK5D=" + item.getTP_TuitionK5D()
            + ",TP_Tuition69A=" + item.getTP_Tuition69A()
            + ",TP_Tuition69B=" + item.getTP_Tuition69B()
            + ",TP_Tuition69C=" + item.getTP_Tuition69C()
            + ",TP_Tuition69D=" + item.getTP_Tuition69D()
            + ",TP_Tuition1012A=" + item.getTP_Tuition1012A()
            + ",TP_Tuition1012B=" + item.getTP_Tuition1012B()
            + ",TP_Tuition1012C=" + item.getTP_Tuition1012C()
            + ",TP_Tuition1012D=" + item.getTP_Tuition1012D()
            + ",K_TuitionK5A=" + item.getK_TuitionK5A()
            + ",K_TuitionK5B=" + item.getK_TuitionK5B()
            + ",K_TuitionK5C=" + item.getK_TuitionK5C()
            + ",K_TuitionK5D=" + item.getK_TuitionK5D()
            + ",K_Tuition69A=" + item.getK_Tuition69A()
            + ",K_Tuition69B=" + item.getK_Tuition69B()
            + ",K_Tuition69C=" + item.getK_Tuition69C()
            + ",K_Tuition69D=" + item.getK_Tuition69D()
            + ",K_Tuition1012A=" + item.getK_Tuition1012A()
            + ",K_Tuition1012B=" + item.getK_Tuition1012B()
            + ",K_Tuition1012C=" + item.getK_Tuition1012C()
            + ",K_Tuition1012D=" + item.getK_Tuition1012D()
            + ",BuildingA=" + item.getBuildingA()
            + ",BuildingB=" + item.getBuildingB()
            + ",BuildingC=" + item.getBuildingC()
            + ",BuildingD=" + item.getBuildingD()
            + ",DormProgramA=" + item.getDormProgramA()
            + ",DormProgramB=" + item.getDormProgramB()
            + ",DormProgramC=" + item.getDormProgramC()
            + ",DormProgramD=" + item.getDormProgramD()
            + ",DormDepositA=" + item.getDormDepositA()
            + ",DormDepositB=" + item.getDormDepositB()
            + ",DormDepositC=" + item.getDormDepositC()
            + ",DormDepositD=" + item.getDormDepositD()
            + ",DormFacilityA=" + item.getDormFacilityA()
            + ",DormFacilityB=" + item.getDormFacilityB()
            + ",DormFacilityC=" + item.getDormFacilityC()
            + ",DormFacilityD=" + item.getDormFacilityD()
            + ",DormFoodA=" + item.getDormFoodA()
            + ",DormFoodB=" + item.getDormFoodB()
            + ",DormFoodC=" + item.getDormFoodC()
            + ",DormFoodD=" + item.getDormFoodD()
            + ",ELLModerateA=" + item.getELLModerateA()
            + ",ELLModerateB=" + item.getELLModerateB()
            + ",ELLModerateC=" + item.getELLModerateC()
            + ",ELLModerateD=" + item.getELLModerateD()
            + ",ELLSignificantA=" + item.getELLSignificantA()
            + ",ELLSignificantB=" + item.getELLSignificantB()
            + ",ELLSignificantC=" + item.getELLSignificantC()
            + ",ELLSignificantD=" + item.getELLSignificantD()
            + ",MusicPrivateA=" + item.getMusicPrivateA()
            + ",MusicPrivateB=" + item.getMusicPrivateB()
            + ",MusicPrivateC=" + item.getMusicPrivateC()
            + ",MusicPrivateD=" + item.getMusicPrivateD()
            + ",MusicSemiPrivateA=" + item.getMusicSemiPrivateA()
            + ",MusicSemiPrivateB=" + item.getMusicSemiPrivateB()
            + ",MusicSemiPrivateC=" + item.getMusicSemiPrivateC()
            + ",MusicSemiPrivateD=" + item.getMusicSemiPrivateD()
            + ",MusicSemiGroupA=" + item.getMusicSemiGroupA()
            + ",MusicSemiGroupB=" + item.getMusicSemiGroupB()
            + ",MusicSemiGroupC=" + item.getMusicSemiGroupC()
            + ",MusicSemiGroupD=" + item.getMusicSemiGroupD()
            + ",TestingA=" + item.getTestingA()
            + ",TestingB=" + item.getTestingB()
            + ",TestingC=" + item.getTestingC()
            + ",TestingD=" + item.getTestingD()
            + ",Milk=" + item.getMilk()
            + ",TchLunch1=" + item.getTchLunch1()
            + ",TchLunch2=" + item.getTchLunch2()
            + ",TchLunch3=" + item.getTchLunch3()
            + ",TchLunch4=" + item.getTchLunch4()
            + ",TchLunch5=" + item.getTchLunch5()
            + ",TchLunch6=" + item.getTchLunch6()
            + ",TchLunch7=" + item.getTchLunch7()
            + ",KaoLunch1=" + item.getKaoLunch1()
            + ",KaoLunch2=" + item.getKaoLunch2()
            + ",Instrument=" + item.getInstrument()
            + ",MusicRoom=" + item.getMusicRoom()
            + ",FamilyDiscountA=" + item.getFamilyDiscountA()
            + ",FamilyDiscountB=" + item.getFamilyDiscountB()
            + ",Bus=" + item.getBus()
            + ",startDay=" + (((d=item.getStartDay())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",endDay=" + (((d=item.getEndDay())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",prorateDay=" + (((d=item.getProrateDay())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",excludeDays='" + ServerTool.escapeString(item.getExcludeDays()) + "'"
            + ",includeDays='" + ServerTool.escapeString(item.getIncludeDays()) + "'"
            + ",EntranceA=" + item.getEntranceA()
            + ",EntranceB=" + item.getEntranceB()
            + ",EntranceC=" + item.getEntranceC()
            + ",EntranceD=" + item.getEntranceD()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "status,title,month,billDate,feeType,checkFeeId,checkFallFeeId,regPrepayDeadline,regPenalty,lateFee,RegA,RegB,RegC,RegD,TuitionK5A,TuitionK5B,TuitionK5C,TuitionK5D,Tuition69A,Tuition69B,Tuition69C,Tuition69D,Tuition1012A,Tuition1012B,Tuition1012C,Tuition1012D,TP_TuitionK5A,TP_TuitionK5B,TP_TuitionK5C,TP_TuitionK5D,TP_Tuition69A,TP_Tuition69B,TP_Tuition69C,TP_Tuition69D,TP_Tuition1012A,TP_Tuition1012B,TP_Tuition1012C,TP_Tuition1012D,K_TuitionK5A,K_TuitionK5B,K_TuitionK5C,K_TuitionK5D,K_Tuition69A,K_Tuition69B,K_Tuition69C,K_Tuition69D,K_Tuition1012A,K_Tuition1012B,K_Tuition1012C,K_Tuition1012D,BuildingA,BuildingB,BuildingC,BuildingD,DormProgramA,DormProgramB,DormProgramC,DormProgramD,DormDepositA,DormDepositB,DormDepositC,DormDepositD,DormFacilityA,DormFacilityB,DormFacilityC,DormFacilityD,DormFoodA,DormFoodB,DormFoodC,DormFoodD,ELLModerateA,ELLModerateB,ELLModerateC,ELLModerateD,ELLSignificantA,ELLSignificantB,ELLSignificantC,ELLSignificantD,MusicPrivateA,MusicPrivateB,MusicPrivateC,MusicPrivateD,MusicSemiPrivateA,MusicSemiPrivateB,MusicSemiPrivateC,MusicSemiPrivateD,MusicSemiGroupA,MusicSemiGroupB,MusicSemiGroupC,MusicSemiGroupD,TestingA,TestingB,TestingC,TestingD,Milk,TchLunch1,TchLunch2,TchLunch3,TchLunch4,TchLunch5,TchLunch6,TchLunch7,KaoLunch1,KaoLunch2,Instrument,MusicRoom,FamilyDiscountA,FamilyDiscountB,Bus,startDay,endDay,prorateDay,excludeDays,includeDays,EntranceA,EntranceB,EntranceC,EntranceD";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaFee item = (McaFee) obj;

        String ret = 
            "" + item.getStatus()
            + ",'" + ServerTool.escapeString(item.getTitle()) + "'"
            + "," + (((d=item.getMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getBillDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getFeeType()
            + "," + item.getCheckFeeId()
            + "," + item.getCheckFallFeeId()
            + "," + (((d=item.getRegPrepayDeadline())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getRegPenalty()
            + "," + item.getLateFee()
            + "," + item.getRegA()
            + "," + item.getRegB()
            + "," + item.getRegC()
            + "," + item.getRegD()
            + "," + item.getTuitionK5A()
            + "," + item.getTuitionK5B()
            + "," + item.getTuitionK5C()
            + "," + item.getTuitionK5D()
            + "," + item.getTuition69A()
            + "," + item.getTuition69B()
            + "," + item.getTuition69C()
            + "," + item.getTuition69D()
            + "," + item.getTuition1012A()
            + "," + item.getTuition1012B()
            + "," + item.getTuition1012C()
            + "," + item.getTuition1012D()
            + "," + item.getTP_TuitionK5A()
            + "," + item.getTP_TuitionK5B()
            + "," + item.getTP_TuitionK5C()
            + "," + item.getTP_TuitionK5D()
            + "," + item.getTP_Tuition69A()
            + "," + item.getTP_Tuition69B()
            + "," + item.getTP_Tuition69C()
            + "," + item.getTP_Tuition69D()
            + "," + item.getTP_Tuition1012A()
            + "," + item.getTP_Tuition1012B()
            + "," + item.getTP_Tuition1012C()
            + "," + item.getTP_Tuition1012D()
            + "," + item.getK_TuitionK5A()
            + "," + item.getK_TuitionK5B()
            + "," + item.getK_TuitionK5C()
            + "," + item.getK_TuitionK5D()
            + "," + item.getK_Tuition69A()
            + "," + item.getK_Tuition69B()
            + "," + item.getK_Tuition69C()
            + "," + item.getK_Tuition69D()
            + "," + item.getK_Tuition1012A()
            + "," + item.getK_Tuition1012B()
            + "," + item.getK_Tuition1012C()
            + "," + item.getK_Tuition1012D()
            + "," + item.getBuildingA()
            + "," + item.getBuildingB()
            + "," + item.getBuildingC()
            + "," + item.getBuildingD()
            + "," + item.getDormProgramA()
            + "," + item.getDormProgramB()
            + "," + item.getDormProgramC()
            + "," + item.getDormProgramD()
            + "," + item.getDormDepositA()
            + "," + item.getDormDepositB()
            + "," + item.getDormDepositC()
            + "," + item.getDormDepositD()
            + "," + item.getDormFacilityA()
            + "," + item.getDormFacilityB()
            + "," + item.getDormFacilityC()
            + "," + item.getDormFacilityD()
            + "," + item.getDormFoodA()
            + "," + item.getDormFoodB()
            + "," + item.getDormFoodC()
            + "," + item.getDormFoodD()
            + "," + item.getELLModerateA()
            + "," + item.getELLModerateB()
            + "," + item.getELLModerateC()
            + "," + item.getELLModerateD()
            + "," + item.getELLSignificantA()
            + "," + item.getELLSignificantB()
            + "," + item.getELLSignificantC()
            + "," + item.getELLSignificantD()
            + "," + item.getMusicPrivateA()
            + "," + item.getMusicPrivateB()
            + "," + item.getMusicPrivateC()
            + "," + item.getMusicPrivateD()
            + "," + item.getMusicSemiPrivateA()
            + "," + item.getMusicSemiPrivateB()
            + "," + item.getMusicSemiPrivateC()
            + "," + item.getMusicSemiPrivateD()
            + "," + item.getMusicSemiGroupA()
            + "," + item.getMusicSemiGroupB()
            + "," + item.getMusicSemiGroupC()
            + "," + item.getMusicSemiGroupD()
            + "," + item.getTestingA()
            + "," + item.getTestingB()
            + "," + item.getTestingC()
            + "," + item.getTestingD()
            + "," + item.getMilk()
            + "," + item.getTchLunch1()
            + "," + item.getTchLunch2()
            + "," + item.getTchLunch3()
            + "," + item.getTchLunch4()
            + "," + item.getTchLunch5()
            + "," + item.getTchLunch6()
            + "," + item.getTchLunch7()
            + "," + item.getKaoLunch1()
            + "," + item.getKaoLunch2()
            + "," + item.getInstrument()
            + "," + item.getMusicRoom()
            + "," + item.getFamilyDiscountA()
            + "," + item.getFamilyDiscountB()
            + "," + item.getBus()
            + "," + (((d=item.getStartDay())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getEndDay())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getProrateDay())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getExcludeDays()) + "'"
            + ",'" + ServerTool.escapeString(item.getIncludeDays()) + "'"
            + "," + item.getEntranceA()
            + "," + item.getEntranceB()
            + "," + item.getEntranceC()
            + "," + item.getEntranceD()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        McaFee o = (McaFee) obj;
        o.setId(auto_id);
    }
}
