package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaStudentInfoMgr extends dbo.Manager<McaStudentInfo>
{
    private static McaStudentInfoMgr _instance = null;

    McaStudentInfoMgr() {}

    public synchronized static McaStudentInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaStudentInfoMgr();
        }
        return _instance;
    }

    public McaStudentInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_student join student";
    }

    protected Object makeBean()
    {
        return new McaStudentInfo();
    }

    protected String JoinSpace()
    {
         return "studId=student.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaStudentInfo item = (McaStudentInfo) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	ExportDate		 = rs.getTimestamp("ExportDate");
            item.setExportDate(ExportDate);
            java.util.Date	ImportDate		 = rs.getTimestamp("ImportDate");
            item.setImportDate(ImportDate);
            int	StudentID		 = rs.getInt("StudentID");
            item.setStudentID(StudentID);
            String	Campus		 = rs.getString("Campus");
            item.setCampus(Campus);
            String	StudentFirstName		 = rs.getString("StudentFirstName");
            item.setStudentFirstName(StudentFirstName);
            String	StudentSurname		 = rs.getString("StudentSurname");
            item.setStudentSurname(StudentSurname);
            String	StudentChineseName		 = rs.getString("StudentChineseName");
            item.setStudentChineseName(StudentChineseName);
            String	BirthDate		 = rs.getString("BirthDate");
            item.setBirthDate(BirthDate);
            String	PassportNumber		 = rs.getString("PassportNumber");
            item.setPassportNumber(PassportNumber);
            String	PassportCountry		 = rs.getString("PassportCountry");
            item.setPassportCountry(PassportCountry);
            String	Sex		 = rs.getString("Sex");
            item.setSex(Sex);
            String	HomePhone		 = rs.getString("HomePhone");
            item.setHomePhone(HomePhone);
            String	FatherFirstName		 = rs.getString("FatherFirstName");
            item.setFatherFirstName(FatherFirstName);
            String	FatherSurname		 = rs.getString("FatherSurname");
            item.setFatherSurname(FatherSurname);
            String	FatherChineseName		 = rs.getString("FatherChineseName");
            item.setFatherChineseName(FatherChineseName);
            String	FatherPhone		 = rs.getString("FatherPhone");
            item.setFatherPhone(FatherPhone);
            String	FatherCell		 = rs.getString("FatherCell");
            item.setFatherCell(FatherCell);
            String	FatherEmail		 = rs.getString("FatherEmail");
            item.setFatherEmail(FatherEmail);
            String	FatherSendEmail		 = rs.getString("FatherSendEmail");
            item.setFatherSendEmail(FatherSendEmail);
            String	MotherFirstName		 = rs.getString("MotherFirstName");
            item.setMotherFirstName(MotherFirstName);
            String	MotherSurname		 = rs.getString("MotherSurname");
            item.setMotherSurname(MotherSurname);
            String	MotherChineseName		 = rs.getString("MotherChineseName");
            item.setMotherChineseName(MotherChineseName);
            String	MotherPhone		 = rs.getString("MotherPhone");
            item.setMotherPhone(MotherPhone);
            String	MotherCell		 = rs.getString("MotherCell");
            item.setMotherCell(MotherCell);
            String	MotherEmail		 = rs.getString("MotherEmail");
            item.setMotherEmail(MotherEmail);
            String	MotherSendEmail		 = rs.getString("MotherSendEmail");
            item.setMotherSendEmail(MotherSendEmail);
            String	CountryID		 = rs.getString("CountryID");
            item.setCountryID(CountryID);
            String	CountyID		 = rs.getString("CountyID");
            item.setCountyID(CountyID);
            String	CityID		 = rs.getString("CityID");
            item.setCityID(CityID);
            String	DistrictID		 = rs.getString("DistrictID");
            item.setDistrictID(DistrictID);
            String	ChineseStreetAddress		 = rs.getString("ChineseStreetAddress");
            item.setChineseStreetAddress(ChineseStreetAddress);
            String	EnglishStreetAddress		 = rs.getString("EnglishStreetAddress");
            item.setEnglishStreetAddress(EnglishStreetAddress);
            String	PostalCode		 = rs.getString("PostalCode");
            item.setPostalCode(PostalCode);
            String	FreeHandAddress		 = rs.getString("FreeHandAddress");
            item.setFreeHandAddress(FreeHandAddress);
            String	SensitiveAddress		 = rs.getString("SensitiveAddress");
            item.setSensitiveAddress(SensitiveAddress);
            String	ApplyForYear		 = rs.getString("ApplyForYear");
            item.setApplyForYear(ApplyForYear);
            String	ApplyForGrade		 = rs.getString("ApplyForGrade");
            item.setApplyForGrade(ApplyForGrade);
            String	CoopID		 = rs.getString("CoopID");
            item.setCoopID(CoopID);
            String	Parents		 = rs.getString("Parents");
            item.setParents(Parents);
            String	Grade		 = rs.getString("Grade");
            item.setGrade(Grade);
            String	Category		 = rs.getString("Category");
            item.setCategory(Category);
            String	ArcID		 = rs.getString("ArcID");
            item.setArcID(ArcID);
            String	Dorm		 = rs.getString("Dorm");
            item.setDorm(Dorm);
            int	Identity		 = rs.getInt("Identity");
            item.setIdentity(Identity);
            double	TDisc		 = rs.getDouble("TDisc");
            item.setTDisc(TDisc);
            double	MDisc		 = rs.getDouble("MDisc");
            item.setMDisc(MDisc);
            String	Emergency		 = rs.getString("Emergency");
            item.setEmergency(Emergency);
            String	BillTo		 = rs.getString("BillTo");
            item.setBillTo(BillTo);
            String	BillAttention		 = rs.getString("BillAttention");
            item.setBillAttention(BillAttention);
            String	BillCountryID		 = rs.getString("BillCountryID");
            item.setBillCountryID(BillCountryID);
            String	BillCountyID		 = rs.getString("BillCountyID");
            item.setBillCountyID(BillCountyID);
            String	BillCityID		 = rs.getString("BillCityID");
            item.setBillCityID(BillCityID);
            String	BillDistrictID		 = rs.getString("BillDistrictID");
            item.setBillDistrictID(BillDistrictID);
            String	BillChineseStreetAddress		 = rs.getString("BillChineseStreetAddress");
            item.setBillChineseStreetAddress(BillChineseStreetAddress);
            String	BillEnglishStreetAddress		 = rs.getString("BillEnglishStreetAddress");
            item.setBillEnglishStreetAddress(BillEnglishStreetAddress);
            String	BillPostalCode		 = rs.getString("BillPostalCode");
            item.setBillPostalCode(BillPostalCode);
            String	Fax		 = rs.getString("Fax");
            item.setFax(Fax);
            String	OfficePhone		 = rs.getString("OfficePhone");
            item.setOfficePhone(OfficePhone);
            String	StudentCommonName		 = rs.getString("StudentCommonName");
            item.setStudentCommonName(StudentCommonName);
            String	TmpEll		 = rs.getString("TmpEll");
            item.setTmpEll(TmpEll);
            String	TmpMilktype		 = rs.getString("TmpMilktype");
            item.setTmpMilktype(TmpMilktype);
            String	TmpMusic		 = rs.getString("TmpMusic");
            item.setTmpMusic(TmpMusic);
            String	TmpInstr		 = rs.getString("TmpInstr");
            item.setTmpInstr(TmpInstr);
            String	TmpMusicRoom		 = rs.getString("TmpMusicRoom");
            item.setTmpMusicRoom(TmpMusicRoom);
            String	TmpDorm		 = rs.getString("TmpDorm");
            item.setTmpDorm(TmpDorm);
            String	TmpDormFood		 = rs.getString("TmpDormFood");
            item.setTmpDormFood(TmpDormFood);
            String	TmpKitchen		 = rs.getString("TmpKitchen");
            item.setTmpKitchen(TmpKitchen);
            String	TmpLunch		 = rs.getString("TmpLunch");
            item.setTmpLunch(TmpLunch);
            String	TmpBus		 = rs.getString("TmpBus");
            item.setTmpBus(TmpBus);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	studId		 = rs.getInt("studId");
            item.setStudId(studId);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
