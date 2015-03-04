package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaFee
{

    private int   	id;
    private int   	status;
    private String   	title;
    private Date   	month;
    private Date   	billDate;
    private int   	feeType;
    private int   	checkFeeId;
    private int   	checkFallFeeId;
    private Date   	regPrepayDeadline;
    private int   	regPenalty;
    private int   	lateFee;
    private int   	RegA;
    private int   	RegB;
    private int   	RegC;
    private int   	RegD;
    private int   	TuitionK5A;
    private int   	TuitionK5B;
    private int   	TuitionK5C;
    private int   	TuitionK5D;
    private int   	Tuition69A;
    private int   	Tuition69B;
    private int   	Tuition69C;
    private int   	Tuition69D;
    private int   	Tuition1012A;
    private int   	Tuition1012B;
    private int   	Tuition1012C;
    private int   	Tuition1012D;
    private int   	TP_TuitionK5A;
    private int   	TP_TuitionK5B;
    private int   	TP_TuitionK5C;
    private int   	TP_TuitionK5D;
    private int   	TP_Tuition69A;
    private int   	TP_Tuition69B;
    private int   	TP_Tuition69C;
    private int   	TP_Tuition69D;
    private int   	TP_Tuition1012A;
    private int   	TP_Tuition1012B;
    private int   	TP_Tuition1012C;
    private int   	TP_Tuition1012D;
    private int   	K_TuitionK5A;
    private int   	K_TuitionK5B;
    private int   	K_TuitionK5C;
    private int   	K_TuitionK5D;
    private int   	K_Tuition69A;
    private int   	K_Tuition69B;
    private int   	K_Tuition69C;
    private int   	K_Tuition69D;
    private int   	K_Tuition1012A;
    private int   	K_Tuition1012B;
    private int   	K_Tuition1012C;
    private int   	K_Tuition1012D;
    private int   	BuildingA;
    private int   	BuildingB;
    private int   	BuildingC;
    private int   	BuildingD;
    private int   	DormProgramA;
    private int   	DormProgramB;
    private int   	DormProgramC;
    private int   	DormProgramD;
    private int   	DormDepositA;
    private int   	DormDepositB;
    private int   	DormDepositC;
    private int   	DormDepositD;
    private int   	DormFacilityA;
    private int   	DormFacilityB;
    private int   	DormFacilityC;
    private int   	DormFacilityD;
    private int   	DormFoodA;
    private int   	DormFoodB;
    private int   	DormFoodC;
    private int   	DormFoodD;
    private int   	ELLModerateA;
    private int   	ELLModerateB;
    private int   	ELLModerateC;
    private int   	ELLModerateD;
    private int   	ELLSignificantA;
    private int   	ELLSignificantB;
    private int   	ELLSignificantC;
    private int   	ELLSignificantD;
    private int   	MusicPrivateA;
    private int   	MusicPrivateB;
    private int   	MusicPrivateC;
    private int   	MusicPrivateD;
    private int   	MusicSemiPrivateA;
    private int   	MusicSemiPrivateB;
    private int   	MusicSemiPrivateC;
    private int   	MusicSemiPrivateD;
    private int   	MusicSemiGroupA;
    private int   	MusicSemiGroupB;
    private int   	MusicSemiGroupC;
    private int   	MusicSemiGroupD;
    private int   	TestingA;
    private int   	TestingB;
    private int   	TestingC;
    private int   	TestingD;
    private int   	Milk;
    private int   	TchLunch1;
    private int   	TchLunch2;
    private int   	TchLunch3;
    private int   	TchLunch4;
    private int   	TchLunch5;
    private int   	TchLunch6;
    private int   	TchLunch7;
    private int   	KaoLunch1;
    private int   	KaoLunch2;
    private int   	Instrument;
    private int   	MusicRoom;
    private int   	FamilyDiscountA;
    private int   	FamilyDiscountB;
    private int   	Bus;
    private Date   	startDay;
    private Date   	endDay;
    private Date   	prorateDay;
    private String   	excludeDays;
    private String   	includeDays;
    private int   	EntranceA;
    private int   	EntranceB;
    private int   	EntranceC;
    private int   	EntranceD;


    public McaFee() {}


    public int   	getId   	() { return id; }
    public int   	getStatus   	() { return status; }
    public String   	getTitle   	() { return title; }
    public Date   	getMonth   	() { return month; }
    public Date   	getBillDate   	() { return billDate; }
    public int   	getFeeType   	() { return feeType; }
    public int   	getCheckFeeId   	() { return checkFeeId; }
    public int   	getCheckFallFeeId   	() { return checkFallFeeId; }
    public Date   	getRegPrepayDeadline   	() { return regPrepayDeadline; }
    public int   	getRegPenalty   	() { return regPenalty; }
    public int   	getLateFee   	() { return lateFee; }
    public int   	getRegA   	() { return RegA; }
    public int   	getRegB   	() { return RegB; }
    public int   	getRegC   	() { return RegC; }
    public int   	getRegD   	() { return RegD; }
    public int   	getTuitionK5A   	() { return TuitionK5A; }
    public int   	getTuitionK5B   	() { return TuitionK5B; }
    public int   	getTuitionK5C   	() { return TuitionK5C; }
    public int   	getTuitionK5D   	() { return TuitionK5D; }
    public int   	getTuition69A   	() { return Tuition69A; }
    public int   	getTuition69B   	() { return Tuition69B; }
    public int   	getTuition69C   	() { return Tuition69C; }
    public int   	getTuition69D   	() { return Tuition69D; }
    public int   	getTuition1012A   	() { return Tuition1012A; }
    public int   	getTuition1012B   	() { return Tuition1012B; }
    public int   	getTuition1012C   	() { return Tuition1012C; }
    public int   	getTuition1012D   	() { return Tuition1012D; }
    public int   	getTP_TuitionK5A   	() { return TP_TuitionK5A; }
    public int   	getTP_TuitionK5B   	() { return TP_TuitionK5B; }
    public int   	getTP_TuitionK5C   	() { return TP_TuitionK5C; }
    public int   	getTP_TuitionK5D   	() { return TP_TuitionK5D; }
    public int   	getTP_Tuition69A   	() { return TP_Tuition69A; }
    public int   	getTP_Tuition69B   	() { return TP_Tuition69B; }
    public int   	getTP_Tuition69C   	() { return TP_Tuition69C; }
    public int   	getTP_Tuition69D   	() { return TP_Tuition69D; }
    public int   	getTP_Tuition1012A   	() { return TP_Tuition1012A; }
    public int   	getTP_Tuition1012B   	() { return TP_Tuition1012B; }
    public int   	getTP_Tuition1012C   	() { return TP_Tuition1012C; }
    public int   	getTP_Tuition1012D   	() { return TP_Tuition1012D; }
    public int   	getK_TuitionK5A   	() { return K_TuitionK5A; }
    public int   	getK_TuitionK5B   	() { return K_TuitionK5B; }
    public int   	getK_TuitionK5C   	() { return K_TuitionK5C; }
    public int   	getK_TuitionK5D   	() { return K_TuitionK5D; }
    public int   	getK_Tuition69A   	() { return K_Tuition69A; }
    public int   	getK_Tuition69B   	() { return K_Tuition69B; }
    public int   	getK_Tuition69C   	() { return K_Tuition69C; }
    public int   	getK_Tuition69D   	() { return K_Tuition69D; }
    public int   	getK_Tuition1012A   	() { return K_Tuition1012A; }
    public int   	getK_Tuition1012B   	() { return K_Tuition1012B; }
    public int   	getK_Tuition1012C   	() { return K_Tuition1012C; }
    public int   	getK_Tuition1012D   	() { return K_Tuition1012D; }
    public int   	getBuildingA   	() { return BuildingA; }
    public int   	getBuildingB   	() { return BuildingB; }
    public int   	getBuildingC   	() { return BuildingC; }
    public int   	getBuildingD   	() { return BuildingD; }
    public int   	getDormProgramA   	() { return DormProgramA; }
    public int   	getDormProgramB   	() { return DormProgramB; }
    public int   	getDormProgramC   	() { return DormProgramC; }
    public int   	getDormProgramD   	() { return DormProgramD; }
    public int   	getDormDepositA   	() { return DormDepositA; }
    public int   	getDormDepositB   	() { return DormDepositB; }
    public int   	getDormDepositC   	() { return DormDepositC; }
    public int   	getDormDepositD   	() { return DormDepositD; }
    public int   	getDormFacilityA   	() { return DormFacilityA; }
    public int   	getDormFacilityB   	() { return DormFacilityB; }
    public int   	getDormFacilityC   	() { return DormFacilityC; }
    public int   	getDormFacilityD   	() { return DormFacilityD; }
    public int   	getDormFoodA   	() { return DormFoodA; }
    public int   	getDormFoodB   	() { return DormFoodB; }
    public int   	getDormFoodC   	() { return DormFoodC; }
    public int   	getDormFoodD   	() { return DormFoodD; }
    public int   	getELLModerateA   	() { return ELLModerateA; }
    public int   	getELLModerateB   	() { return ELLModerateB; }
    public int   	getELLModerateC   	() { return ELLModerateC; }
    public int   	getELLModerateD   	() { return ELLModerateD; }
    public int   	getELLSignificantA   	() { return ELLSignificantA; }
    public int   	getELLSignificantB   	() { return ELLSignificantB; }
    public int   	getELLSignificantC   	() { return ELLSignificantC; }
    public int   	getELLSignificantD   	() { return ELLSignificantD; }
    public int   	getMusicPrivateA   	() { return MusicPrivateA; }
    public int   	getMusicPrivateB   	() { return MusicPrivateB; }
    public int   	getMusicPrivateC   	() { return MusicPrivateC; }
    public int   	getMusicPrivateD   	() { return MusicPrivateD; }
    public int   	getMusicSemiPrivateA   	() { return MusicSemiPrivateA; }
    public int   	getMusicSemiPrivateB   	() { return MusicSemiPrivateB; }
    public int   	getMusicSemiPrivateC   	() { return MusicSemiPrivateC; }
    public int   	getMusicSemiPrivateD   	() { return MusicSemiPrivateD; }
    public int   	getMusicSemiGroupA   	() { return MusicSemiGroupA; }
    public int   	getMusicSemiGroupB   	() { return MusicSemiGroupB; }
    public int   	getMusicSemiGroupC   	() { return MusicSemiGroupC; }
    public int   	getMusicSemiGroupD   	() { return MusicSemiGroupD; }
    public int   	getTestingA   	() { return TestingA; }
    public int   	getTestingB   	() { return TestingB; }
    public int   	getTestingC   	() { return TestingC; }
    public int   	getTestingD   	() { return TestingD; }
    public int   	getMilk   	() { return Milk; }
    public int   	getTchLunch1   	() { return TchLunch1; }
    public int   	getTchLunch2   	() { return TchLunch2; }
    public int   	getTchLunch3   	() { return TchLunch3; }
    public int   	getTchLunch4   	() { return TchLunch4; }
    public int   	getTchLunch5   	() { return TchLunch5; }
    public int   	getTchLunch6   	() { return TchLunch6; }
    public int   	getTchLunch7   	() { return TchLunch7; }
    public int   	getKaoLunch1   	() { return KaoLunch1; }
    public int   	getKaoLunch2   	() { return KaoLunch2; }
    public int   	getInstrument   	() { return Instrument; }
    public int   	getMusicRoom   	() { return MusicRoom; }
    public int   	getFamilyDiscountA   	() { return FamilyDiscountA; }
    public int   	getFamilyDiscountB   	() { return FamilyDiscountB; }
    public int   	getBus   	() { return Bus; }
    public Date   	getStartDay   	() { return startDay; }
    public Date   	getEndDay   	() { return endDay; }
    public Date   	getProrateDay   	() { return prorateDay; }
    public String   	getExcludeDays   	() { return excludeDays; }
    public String   	getIncludeDays   	() { return includeDays; }
    public int   	getEntranceA   	() { return EntranceA; }
    public int   	getEntranceB   	() { return EntranceB; }
    public int   	getEntranceC   	() { return EntranceC; }
    public int   	getEntranceD   	() { return EntranceD; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setTitle   	(String title) { this.title = title; }
    public void 	setMonth   	(Date month) { this.month = month; }
    public void 	setBillDate   	(Date billDate) { this.billDate = billDate; }
    public void 	setFeeType   	(int feeType) { this.feeType = feeType; }
    public void 	setCheckFeeId   	(int checkFeeId) { this.checkFeeId = checkFeeId; }
    public void 	setCheckFallFeeId   	(int checkFallFeeId) { this.checkFallFeeId = checkFallFeeId; }
    public void 	setRegPrepayDeadline   	(Date regPrepayDeadline) { this.regPrepayDeadline = regPrepayDeadline; }
    public void 	setRegPenalty   	(int regPenalty) { this.regPenalty = regPenalty; }
    public void 	setLateFee   	(int lateFee) { this.lateFee = lateFee; }
    public void 	setRegA   	(int RegA) { this.RegA = RegA; }
    public void 	setRegB   	(int RegB) { this.RegB = RegB; }
    public void 	setRegC   	(int RegC) { this.RegC = RegC; }
    public void 	setRegD   	(int RegD) { this.RegD = RegD; }
    public void 	setTuitionK5A   	(int TuitionK5A) { this.TuitionK5A = TuitionK5A; }
    public void 	setTuitionK5B   	(int TuitionK5B) { this.TuitionK5B = TuitionK5B; }
    public void 	setTuitionK5C   	(int TuitionK5C) { this.TuitionK5C = TuitionK5C; }
    public void 	setTuitionK5D   	(int TuitionK5D) { this.TuitionK5D = TuitionK5D; }
    public void 	setTuition69A   	(int Tuition69A) { this.Tuition69A = Tuition69A; }
    public void 	setTuition69B   	(int Tuition69B) { this.Tuition69B = Tuition69B; }
    public void 	setTuition69C   	(int Tuition69C) { this.Tuition69C = Tuition69C; }
    public void 	setTuition69D   	(int Tuition69D) { this.Tuition69D = Tuition69D; }
    public void 	setTuition1012A   	(int Tuition1012A) { this.Tuition1012A = Tuition1012A; }
    public void 	setTuition1012B   	(int Tuition1012B) { this.Tuition1012B = Tuition1012B; }
    public void 	setTuition1012C   	(int Tuition1012C) { this.Tuition1012C = Tuition1012C; }
    public void 	setTuition1012D   	(int Tuition1012D) { this.Tuition1012D = Tuition1012D; }
    public void 	setTP_TuitionK5A   	(int TP_TuitionK5A) { this.TP_TuitionK5A = TP_TuitionK5A; }
    public void 	setTP_TuitionK5B   	(int TP_TuitionK5B) { this.TP_TuitionK5B = TP_TuitionK5B; }
    public void 	setTP_TuitionK5C   	(int TP_TuitionK5C) { this.TP_TuitionK5C = TP_TuitionK5C; }
    public void 	setTP_TuitionK5D   	(int TP_TuitionK5D) { this.TP_TuitionK5D = TP_TuitionK5D; }
    public void 	setTP_Tuition69A   	(int TP_Tuition69A) { this.TP_Tuition69A = TP_Tuition69A; }
    public void 	setTP_Tuition69B   	(int TP_Tuition69B) { this.TP_Tuition69B = TP_Tuition69B; }
    public void 	setTP_Tuition69C   	(int TP_Tuition69C) { this.TP_Tuition69C = TP_Tuition69C; }
    public void 	setTP_Tuition69D   	(int TP_Tuition69D) { this.TP_Tuition69D = TP_Tuition69D; }
    public void 	setTP_Tuition1012A   	(int TP_Tuition1012A) { this.TP_Tuition1012A = TP_Tuition1012A; }
    public void 	setTP_Tuition1012B   	(int TP_Tuition1012B) { this.TP_Tuition1012B = TP_Tuition1012B; }
    public void 	setTP_Tuition1012C   	(int TP_Tuition1012C) { this.TP_Tuition1012C = TP_Tuition1012C; }
    public void 	setTP_Tuition1012D   	(int TP_Tuition1012D) { this.TP_Tuition1012D = TP_Tuition1012D; }
    public void 	setK_TuitionK5A   	(int K_TuitionK5A) { this.K_TuitionK5A = K_TuitionK5A; }
    public void 	setK_TuitionK5B   	(int K_TuitionK5B) { this.K_TuitionK5B = K_TuitionK5B; }
    public void 	setK_TuitionK5C   	(int K_TuitionK5C) { this.K_TuitionK5C = K_TuitionK5C; }
    public void 	setK_TuitionK5D   	(int K_TuitionK5D) { this.K_TuitionK5D = K_TuitionK5D; }
    public void 	setK_Tuition69A   	(int K_Tuition69A) { this.K_Tuition69A = K_Tuition69A; }
    public void 	setK_Tuition69B   	(int K_Tuition69B) { this.K_Tuition69B = K_Tuition69B; }
    public void 	setK_Tuition69C   	(int K_Tuition69C) { this.K_Tuition69C = K_Tuition69C; }
    public void 	setK_Tuition69D   	(int K_Tuition69D) { this.K_Tuition69D = K_Tuition69D; }
    public void 	setK_Tuition1012A   	(int K_Tuition1012A) { this.K_Tuition1012A = K_Tuition1012A; }
    public void 	setK_Tuition1012B   	(int K_Tuition1012B) { this.K_Tuition1012B = K_Tuition1012B; }
    public void 	setK_Tuition1012C   	(int K_Tuition1012C) { this.K_Tuition1012C = K_Tuition1012C; }
    public void 	setK_Tuition1012D   	(int K_Tuition1012D) { this.K_Tuition1012D = K_Tuition1012D; }
    public void 	setBuildingA   	(int BuildingA) { this.BuildingA = BuildingA; }
    public void 	setBuildingB   	(int BuildingB) { this.BuildingB = BuildingB; }
    public void 	setBuildingC   	(int BuildingC) { this.BuildingC = BuildingC; }
    public void 	setBuildingD   	(int BuildingD) { this.BuildingD = BuildingD; }
    public void 	setDormProgramA   	(int DormProgramA) { this.DormProgramA = DormProgramA; }
    public void 	setDormProgramB   	(int DormProgramB) { this.DormProgramB = DormProgramB; }
    public void 	setDormProgramC   	(int DormProgramC) { this.DormProgramC = DormProgramC; }
    public void 	setDormProgramD   	(int DormProgramD) { this.DormProgramD = DormProgramD; }
    public void 	setDormDepositA   	(int DormDepositA) { this.DormDepositA = DormDepositA; }
    public void 	setDormDepositB   	(int DormDepositB) { this.DormDepositB = DormDepositB; }
    public void 	setDormDepositC   	(int DormDepositC) { this.DormDepositC = DormDepositC; }
    public void 	setDormDepositD   	(int DormDepositD) { this.DormDepositD = DormDepositD; }
    public void 	setDormFacilityA   	(int DormFacilityA) { this.DormFacilityA = DormFacilityA; }
    public void 	setDormFacilityB   	(int DormFacilityB) { this.DormFacilityB = DormFacilityB; }
    public void 	setDormFacilityC   	(int DormFacilityC) { this.DormFacilityC = DormFacilityC; }
    public void 	setDormFacilityD   	(int DormFacilityD) { this.DormFacilityD = DormFacilityD; }
    public void 	setDormFoodA   	(int DormFoodA) { this.DormFoodA = DormFoodA; }
    public void 	setDormFoodB   	(int DormFoodB) { this.DormFoodB = DormFoodB; }
    public void 	setDormFoodC   	(int DormFoodC) { this.DormFoodC = DormFoodC; }
    public void 	setDormFoodD   	(int DormFoodD) { this.DormFoodD = DormFoodD; }
    public void 	setELLModerateA   	(int ELLModerateA) { this.ELLModerateA = ELLModerateA; }
    public void 	setELLModerateB   	(int ELLModerateB) { this.ELLModerateB = ELLModerateB; }
    public void 	setELLModerateC   	(int ELLModerateC) { this.ELLModerateC = ELLModerateC; }
    public void 	setELLModerateD   	(int ELLModerateD) { this.ELLModerateD = ELLModerateD; }
    public void 	setELLSignificantA   	(int ELLSignificantA) { this.ELLSignificantA = ELLSignificantA; }
    public void 	setELLSignificantB   	(int ELLSignificantB) { this.ELLSignificantB = ELLSignificantB; }
    public void 	setELLSignificantC   	(int ELLSignificantC) { this.ELLSignificantC = ELLSignificantC; }
    public void 	setELLSignificantD   	(int ELLSignificantD) { this.ELLSignificantD = ELLSignificantD; }
    public void 	setMusicPrivateA   	(int MusicPrivateA) { this.MusicPrivateA = MusicPrivateA; }
    public void 	setMusicPrivateB   	(int MusicPrivateB) { this.MusicPrivateB = MusicPrivateB; }
    public void 	setMusicPrivateC   	(int MusicPrivateC) { this.MusicPrivateC = MusicPrivateC; }
    public void 	setMusicPrivateD   	(int MusicPrivateD) { this.MusicPrivateD = MusicPrivateD; }
    public void 	setMusicSemiPrivateA   	(int MusicSemiPrivateA) { this.MusicSemiPrivateA = MusicSemiPrivateA; }
    public void 	setMusicSemiPrivateB   	(int MusicSemiPrivateB) { this.MusicSemiPrivateB = MusicSemiPrivateB; }
    public void 	setMusicSemiPrivateC   	(int MusicSemiPrivateC) { this.MusicSemiPrivateC = MusicSemiPrivateC; }
    public void 	setMusicSemiPrivateD   	(int MusicSemiPrivateD) { this.MusicSemiPrivateD = MusicSemiPrivateD; }
    public void 	setMusicSemiGroupA   	(int MusicSemiGroupA) { this.MusicSemiGroupA = MusicSemiGroupA; }
    public void 	setMusicSemiGroupB   	(int MusicSemiGroupB) { this.MusicSemiGroupB = MusicSemiGroupB; }
    public void 	setMusicSemiGroupC   	(int MusicSemiGroupC) { this.MusicSemiGroupC = MusicSemiGroupC; }
    public void 	setMusicSemiGroupD   	(int MusicSemiGroupD) { this.MusicSemiGroupD = MusicSemiGroupD; }
    public void 	setTestingA   	(int TestingA) { this.TestingA = TestingA; }
    public void 	setTestingB   	(int TestingB) { this.TestingB = TestingB; }
    public void 	setTestingC   	(int TestingC) { this.TestingC = TestingC; }
    public void 	setTestingD   	(int TestingD) { this.TestingD = TestingD; }
    public void 	setMilk   	(int Milk) { this.Milk = Milk; }
    public void 	setTchLunch1   	(int TchLunch1) { this.TchLunch1 = TchLunch1; }
    public void 	setTchLunch2   	(int TchLunch2) { this.TchLunch2 = TchLunch2; }
    public void 	setTchLunch3   	(int TchLunch3) { this.TchLunch3 = TchLunch3; }
    public void 	setTchLunch4   	(int TchLunch4) { this.TchLunch4 = TchLunch4; }
    public void 	setTchLunch5   	(int TchLunch5) { this.TchLunch5 = TchLunch5; }
    public void 	setTchLunch6   	(int TchLunch6) { this.TchLunch6 = TchLunch6; }
    public void 	setTchLunch7   	(int TchLunch7) { this.TchLunch7 = TchLunch7; }
    public void 	setKaoLunch1   	(int KaoLunch1) { this.KaoLunch1 = KaoLunch1; }
    public void 	setKaoLunch2   	(int KaoLunch2) { this.KaoLunch2 = KaoLunch2; }
    public void 	setInstrument   	(int Instrument) { this.Instrument = Instrument; }
    public void 	setMusicRoom   	(int MusicRoom) { this.MusicRoom = MusicRoom; }
    public void 	setFamilyDiscountA   	(int FamilyDiscountA) { this.FamilyDiscountA = FamilyDiscountA; }
    public void 	setFamilyDiscountB   	(int FamilyDiscountB) { this.FamilyDiscountB = FamilyDiscountB; }
    public void 	setBus   	(int Bus) { this.Bus = Bus; }
    public void 	setStartDay   	(Date startDay) { this.startDay = startDay; }
    public void 	setEndDay   	(Date endDay) { this.endDay = endDay; }
    public void 	setProrateDay   	(Date prorateDay) { this.prorateDay = prorateDay; }
    public void 	setExcludeDays   	(String excludeDays) { this.excludeDays = excludeDays; }
    public void 	setIncludeDays   	(String includeDays) { this.includeDays = includeDays; }
    public void 	setEntranceA   	(int EntranceA) { this.EntranceA = EntranceA; }
    public void 	setEntranceB   	(int EntranceB) { this.EntranceB = EntranceB; }
    public void 	setEntranceC   	(int EntranceC) { this.EntranceC = EntranceC; }
    public void 	setEntranceD   	(int EntranceD) { this.EntranceD = EntranceD; }
    public static final int FALL		= 1;
    public static final int SPRING		= 2;
    public static final int REGISTRATION_ONLY	= 3;

    public static final int STATUS_ACTIVE = 0;
    public static final int STATUS_DELETED = -1;


}
