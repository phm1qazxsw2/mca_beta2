package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaStudent
{

    private int   	id;
    private Date   	ExportDate;
    private Date   	ImportDate;
    private Date   	modified;
    private int   	StudentID;
    private String   	Campus;
    private String   	StudentFirstName;
    private String   	StudentSurname;
    private String   	StudentChineseName;
    private String   	BirthDate;
    private String   	PassportNumber;
    private String   	PassportCountry;
    private String   	Sex;
    private String   	HomePhone;
    private String   	FatherFirstName;
    private String   	FatherSurname;
    private String   	FatherChineseName;
    private String   	FatherPhone;
    private String   	FatherCell;
    private String   	FatherEmail;
    private String   	FatherSendEmail;
    private String   	MotherFirstName;
    private String   	MotherSurname;
    private String   	MotherChineseName;
    private String   	MotherPhone;
    private String   	MotherCell;
    private String   	MotherEmail;
    private String   	MotherSendEmail;
    private String   	CountryID;
    private String   	CountyID;
    private String   	CityID;
    private String   	DistrictID;
    private String   	ChineseStreetAddress;
    private String   	EnglishStreetAddress;
    private String   	PostalCode;
    private String   	FreeHandAddress;
    private String   	SensitiveAddress;
    private String   	ApplyForYear;
    private String   	ApplyForGrade;
    private String   	CoopID;
    private String   	Parents;
    private String   	Grade;
    private String   	Category;
    private String   	ArcID;
    private String   	Dorm;
    private int   	Identity;
    private double   	TDisc;
    private double   	MDisc;
    private String   	Emergency;
    private String   	BillTo;
    private String   	BillAttention;
    private String   	BillCountryID;
    private String   	BillCountyID;
    private String   	BillCityID;
    private String   	BillDistrictID;
    private String   	BillChineseStreetAddress;
    private String   	BillEnglishStreetAddress;
    private String   	BillPostalCode;
    private String   	Fax;
    private String   	OfficePhone;
    private String   	StudentCommonName;
    private String   	TmpEll;
    private String   	TmpMilktype;
    private String   	TmpMusic;
    private String   	TmpInstr;
    private String   	TmpMusicRoom;
    private String   	TmpDorm;
    private String   	TmpDormFood;
    private String   	TmpKitchen;
    private String   	TmpLunch;
    private String   	TmpBus;
    private int   	membrId;
    private int   	studId;
    private String   	notes;
    private String   	sponser;


    public McaStudent() {}


    public int   	getId   	() { return id; }
    public Date   	getExportDate   	() { return ExportDate; }
    public Date   	getImportDate   	() { return ImportDate; }
    public Date   	getModified   	() { return modified; }
    public int   	getStudentID   	() { return StudentID; }
    public String   	getCampus   	() { return Campus; }
    public String   	getStudentFirstName   	() { return StudentFirstName; }
    public String   	getStudentSurname   	() { return StudentSurname; }
    public String   	getStudentChineseName   	() { return StudentChineseName; }
    public String   	getBirthDate   	() { return BirthDate; }
    public String   	getPassportNumber   	() { return PassportNumber; }
    public String   	getPassportCountry   	() { return PassportCountry; }
    public String   	getSex   	() { return Sex; }
    public String   	getHomePhone   	() { return HomePhone; }
    public String   	getFatherFirstName   	() { return FatherFirstName; }
    public String   	getFatherSurname   	() { return FatherSurname; }
    public String   	getFatherChineseName   	() { return FatherChineseName; }
    public String   	getFatherPhone   	() { return FatherPhone; }
    public String   	getFatherCell   	() { return FatherCell; }
    public String   	getFatherEmail   	() { return FatherEmail; }
    public String   	getFatherSendEmail   	() { return FatherSendEmail; }
    public String   	getMotherFirstName   	() { return MotherFirstName; }
    public String   	getMotherSurname   	() { return MotherSurname; }
    public String   	getMotherChineseName   	() { return MotherChineseName; }
    public String   	getMotherPhone   	() { return MotherPhone; }
    public String   	getMotherCell   	() { return MotherCell; }
    public String   	getMotherEmail   	() { return MotherEmail; }
    public String   	getMotherSendEmail   	() { return MotherSendEmail; }
    public String   	getCountryID   	() { return CountryID; }
    public String   	getCountyID   	() { return CountyID; }
    public String   	getCityID   	() { return CityID; }
    public String   	getDistrictID   	() { return DistrictID; }
    public String   	getChineseStreetAddress   	() { return ChineseStreetAddress; }
    public String   	getEnglishStreetAddress   	() { return EnglishStreetAddress; }
    public String   	getPostalCode   	() { return PostalCode; }
    public String   	getFreeHandAddress   	() { return FreeHandAddress; }
    public String   	getSensitiveAddress   	() { return SensitiveAddress; }
    public String   	getApplyForYear   	() { return ApplyForYear; }
    public String   	getApplyForGrade   	() { return ApplyForGrade; }
    public String   	getCoopID   	() { return CoopID; }
    public String   	getParents   	() { return Parents; }
    public String   	getGrade   	() { return Grade; }
    public String   	getCategory   	() { return Category; }
    public String   	getArcID   	() { return ArcID; }
    public String   	getDorm   	() { return Dorm; }
    public int   	getIdentity   	() { return Identity; }
    public double   	getTDisc   	() { return TDisc; }
    public double   	getMDisc   	() { return MDisc; }
    public String   	getEmergency   	() { return Emergency; }
    public String   	getBillTo   	() { return BillTo; }
    public String   	getBillAttention   	() { return BillAttention; }
    public String   	getBillCountryID   	() { return BillCountryID; }
    public String   	getBillCountyID   	() { return BillCountyID; }
    public String   	getBillCityID   	() { return BillCityID; }
    public String   	getBillDistrictID   	() { return BillDistrictID; }
    public String   	getBillChineseStreetAddress   	() { return BillChineseStreetAddress; }
    public String   	getBillEnglishStreetAddress   	() { return BillEnglishStreetAddress; }
    public String   	getBillPostalCode   	() { return BillPostalCode; }
    public String   	getFax   	() { return Fax; }
    public String   	getOfficePhone   	() { return OfficePhone; }
    public String   	getStudentCommonName   	() { return StudentCommonName; }
    public String   	getTmpEll   	() { return TmpEll; }
    public String   	getTmpMilktype   	() { return TmpMilktype; }
    public String   	getTmpMusic   	() { return TmpMusic; }
    public String   	getTmpInstr   	() { return TmpInstr; }
    public String   	getTmpMusicRoom   	() { return TmpMusicRoom; }
    public String   	getTmpDorm   	() { return TmpDorm; }
    public String   	getTmpDormFood   	() { return TmpDormFood; }
    public String   	getTmpKitchen   	() { return TmpKitchen; }
    public String   	getTmpLunch   	() { return TmpLunch; }
    public String   	getTmpBus   	() { return TmpBus; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getStudId   	() { return studId; }
    public String   	getNotes   	() { return notes; }
    public String   	getSponser   	() { return sponser; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setExportDate   	(Date ExportDate) { this.ExportDate = ExportDate; }
    public void 	setImportDate   	(Date ImportDate) { this.ImportDate = ImportDate; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setStudentID   	(int StudentID) { this.StudentID = StudentID; }
    public void 	setCampus   	(String Campus) { this.Campus = Campus; }
    public void 	setStudentFirstName   	(String StudentFirstName) { this.StudentFirstName = StudentFirstName; }
    public void 	setStudentSurname   	(String StudentSurname) { this.StudentSurname = StudentSurname; }
    public void 	setStudentChineseName   	(String StudentChineseName) { this.StudentChineseName = StudentChineseName; }
    public void 	setBirthDate   	(String BirthDate) { this.BirthDate = BirthDate; }
    public void 	setPassportNumber   	(String PassportNumber) { this.PassportNumber = PassportNumber; }
    public void 	setPassportCountry   	(String PassportCountry) { this.PassportCountry = PassportCountry; }
    public void 	setSex   	(String Sex) { this.Sex = Sex; }
    public void 	setHomePhone   	(String HomePhone) { this.HomePhone = HomePhone; }
    public void 	setFatherFirstName   	(String FatherFirstName) { this.FatherFirstName = FatherFirstName; }
    public void 	setFatherSurname   	(String FatherSurname) { this.FatherSurname = FatherSurname; }
    public void 	setFatherChineseName   	(String FatherChineseName) { this.FatherChineseName = FatherChineseName; }
    public void 	setFatherPhone   	(String FatherPhone) { this.FatherPhone = FatherPhone; }
    public void 	setFatherCell   	(String FatherCell) { this.FatherCell = FatherCell; }
    public void 	setFatherEmail   	(String FatherEmail) { this.FatherEmail = FatherEmail; }
    public void 	setFatherSendEmail   	(String FatherSendEmail) { this.FatherSendEmail = FatherSendEmail; }
    public void 	setMotherFirstName   	(String MotherFirstName) { this.MotherFirstName = MotherFirstName; }
    public void 	setMotherSurname   	(String MotherSurname) { this.MotherSurname = MotherSurname; }
    public void 	setMotherChineseName   	(String MotherChineseName) { this.MotherChineseName = MotherChineseName; }
    public void 	setMotherPhone   	(String MotherPhone) { this.MotherPhone = MotherPhone; }
    public void 	setMotherCell   	(String MotherCell) { this.MotherCell = MotherCell; }
    public void 	setMotherEmail   	(String MotherEmail) { this.MotherEmail = MotherEmail; }
    public void 	setMotherSendEmail   	(String MotherSendEmail) { this.MotherSendEmail = MotherSendEmail; }
    public void 	setCountryID   	(String CountryID) { this.CountryID = CountryID; }
    public void 	setCountyID   	(String CountyID) { this.CountyID = CountyID; }
    public void 	setCityID   	(String CityID) { this.CityID = CityID; }
    public void 	setDistrictID   	(String DistrictID) { this.DistrictID = DistrictID; }
    public void 	setChineseStreetAddress   	(String ChineseStreetAddress) { this.ChineseStreetAddress = ChineseStreetAddress; }
    public void 	setEnglishStreetAddress   	(String EnglishStreetAddress) { this.EnglishStreetAddress = EnglishStreetAddress; }
    public void 	setPostalCode   	(String PostalCode) { this.PostalCode = PostalCode; }
    public void 	setFreeHandAddress   	(String FreeHandAddress) { this.FreeHandAddress = FreeHandAddress; }
    public void 	setSensitiveAddress   	(String SensitiveAddress) { this.SensitiveAddress = SensitiveAddress; }
    public void 	setApplyForYear   	(String ApplyForYear) { this.ApplyForYear = ApplyForYear; }
    public void 	setApplyForGrade   	(String ApplyForGrade) { this.ApplyForGrade = ApplyForGrade; }
    public void 	setCoopID   	(String CoopID) { this.CoopID = CoopID; }
    public void 	setParents   	(String Parents) { this.Parents = Parents; }
    public void 	setGrade   	(String Grade) { this.Grade = Grade; }
    public void 	setCategory   	(String Category) { this.Category = Category; }
    public void 	setArcID   	(String ArcID) { this.ArcID = ArcID; }
    public void 	setDorm   	(String Dorm) { this.Dorm = Dorm; }
    public void 	setIdentity   	(int Identity) { this.Identity = Identity; }
    public void 	setTDisc   	(double TDisc) { this.TDisc = TDisc; }
    public void 	setMDisc   	(double MDisc) { this.MDisc = MDisc; }
    public void 	setEmergency   	(String Emergency) { this.Emergency = Emergency; }
    public void 	setBillTo   	(String BillTo) { this.BillTo = BillTo; }
    public void 	setBillAttention   	(String BillAttention) { this.BillAttention = BillAttention; }
    public void 	setBillCountryID   	(String BillCountryID) { this.BillCountryID = BillCountryID; }
    public void 	setBillCountyID   	(String BillCountyID) { this.BillCountyID = BillCountyID; }
    public void 	setBillCityID   	(String BillCityID) { this.BillCityID = BillCityID; }
    public void 	setBillDistrictID   	(String BillDistrictID) { this.BillDistrictID = BillDistrictID; }
    public void 	setBillChineseStreetAddress   	(String BillChineseStreetAddress) { this.BillChineseStreetAddress = BillChineseStreetAddress; }
    public void 	setBillEnglishStreetAddress   	(String BillEnglishStreetAddress) { this.BillEnglishStreetAddress = BillEnglishStreetAddress; }
    public void 	setBillPostalCode   	(String BillPostalCode) { this.BillPostalCode = BillPostalCode; }
    public void 	setFax   	(String Fax) { this.Fax = Fax; }
    public void 	setOfficePhone   	(String OfficePhone) { this.OfficePhone = OfficePhone; }
    public void 	setStudentCommonName   	(String StudentCommonName) { this.StudentCommonName = StudentCommonName; }
    public void 	setTmpEll   	(String TmpEll) { this.TmpEll = TmpEll; }
    public void 	setTmpMilktype   	(String TmpMilktype) { this.TmpMilktype = TmpMilktype; }
    public void 	setTmpMusic   	(String TmpMusic) { this.TmpMusic = TmpMusic; }
    public void 	setTmpInstr   	(String TmpInstr) { this.TmpInstr = TmpInstr; }
    public void 	setTmpMusicRoom   	(String TmpMusicRoom) { this.TmpMusicRoom = TmpMusicRoom; }
    public void 	setTmpDorm   	(String TmpDorm) { this.TmpDorm = TmpDorm; }
    public void 	setTmpDormFood   	(String TmpDormFood) { this.TmpDormFood = TmpDormFood; }
    public void 	setTmpKitchen   	(String TmpKitchen) { this.TmpKitchen = TmpKitchen; }
    public void 	setTmpLunch   	(String TmpLunch) { this.TmpLunch = TmpLunch; }
    public void 	setTmpBus   	(String TmpBus) { this.TmpBus = TmpBus; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setStudId   	(int studId) { this.studId = studId; }
    public void 	setNotes   	(String notes) { this.notes = notes; }
    public void 	setSponser   	(String sponser) { this.sponser = sponser; }

    public String getFullName() {
        String f = this.getStudentFirstName();
        String l = this.getStudentSurname();
        StringBuffer sb = new StringBuffer();
        if (l!=null && l.length()>0) {
            sb.append(l.substring(0,1).toUpperCase());
            sb.append(l.substring(1));
        }
        if (f!=null && f.length()>0) {
            if (sb.length()>0)
                sb.append(", ");
            sb.append(f.substring(0,1).toUpperCase());
            sb.append(f.substring(1));
        }
        return sb.toString();
    }

    public String getParentNames()
    {
        String ret = this.getFatherName();
        String mname = this.getMotherName();

        if (mname.length()>0) {
            if (ret.length()>0);
                ret += " and ";
            ret += mname;
        }
        return ret;
    }

    public String getFatherName()
    {
        String f = this.getFatherFirstName();
        String l = this.getFatherSurname();
        StringBuffer sb = new StringBuffer();
        if (l!=null && l.length()>0) {
            sb.append(l.substring(0,1).toUpperCase());
            sb.append(l.substring(1));
        }
        if (f!=null && f.length()>0) {
            if (sb.length()>0)
                sb.append(", ");
            sb.append(f.substring(0,1).toUpperCase());
            sb.append(f.substring(1));
        }
        return sb.toString();
    }

    public String getMotherName()
    {
        String f = this.getMotherFirstName();
        String l = this.getMotherSurname();
        StringBuffer sb = new StringBuffer();
        if (l!=null && l.length()>0) {
            sb.append(l.substring(0,1).toUpperCase());
            sb.append(l.substring(1));
        }
        if (f!=null && f.length()>0) {
            if (sb.length()>0)
                sb.append(", ");
            sb.append(f.substring(0,1).toUpperCase());
            sb.append(f.substring(1));
        }
        return sb.toString();
    }

    private static java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd");
    public Date getMyBirthday()
    {
        try {
            return sdf.parse(getBirthDate());
        }
        catch (Exception e) {        
        }
        return null;
    }


    public final static int IDENTITY_BK = 0;
    public final static int IDENTITY_M0 = 1;
    public final static int IDENTITY_M1 = 2;
    public final static int IDENTITY_M2 = 3;
    public final static int IDENTITY_CW = 4;


}
