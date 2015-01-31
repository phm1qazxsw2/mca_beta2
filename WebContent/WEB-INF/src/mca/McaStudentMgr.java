package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaStudentMgr extends dbo.Manager<McaStudent>
{
    private static McaStudentMgr _instance = null;

    McaStudentMgr() {}

    public synchronized static McaStudentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaStudentMgr();
        }
        return _instance;
    }

    public McaStudentMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_student";
    }

    protected Object makeBean()
    {
        return new McaStudent();
    }

    protected String getIdentifier(Object obj)
    {
        McaStudent o = (McaStudent) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaStudent item = (McaStudent) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	ExportDate		 = rs.getTimestamp("ExportDate");
            item.setExportDate(ExportDate);
            java.util.Date	ImportDate		 = rs.getTimestamp("ImportDate");
            item.setImportDate(ImportDate);
            java.util.Date	modified		 = rs.getTimestamp("modified");
            item.setModified(modified);
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
            String	notes		 = rs.getString("notes");
            item.setNotes(notes);
            String	sponser		 = rs.getString("sponser");
            item.setSponser(sponser);
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
        McaStudent item = (McaStudent) obj;

        String ret = 
            "ExportDate=" + (((d=item.getExportDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",ImportDate=" + (((d=item.getImportDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",modified=" + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",StudentID=" + item.getStudentID()
            + ",Campus='" + ServerTool.escapeString(item.getCampus()) + "'"
            + ",StudentFirstName='" + ServerTool.escapeString(item.getStudentFirstName()) + "'"
            + ",StudentSurname='" + ServerTool.escapeString(item.getStudentSurname()) + "'"
            + ",StudentChineseName='" + ServerTool.escapeString(item.getStudentChineseName()) + "'"
            + ",BirthDate='" + ServerTool.escapeString(item.getBirthDate()) + "'"
            + ",PassportNumber='" + ServerTool.escapeString(item.getPassportNumber()) + "'"
            + ",PassportCountry='" + ServerTool.escapeString(item.getPassportCountry()) + "'"
            + ",Sex='" + ServerTool.escapeString(item.getSex()) + "'"
            + ",HomePhone='" + ServerTool.escapeString(item.getHomePhone()) + "'"
            + ",FatherFirstName='" + ServerTool.escapeString(item.getFatherFirstName()) + "'"
            + ",FatherSurname='" + ServerTool.escapeString(item.getFatherSurname()) + "'"
            + ",FatherChineseName='" + ServerTool.escapeString(item.getFatherChineseName()) + "'"
            + ",FatherPhone='" + ServerTool.escapeString(item.getFatherPhone()) + "'"
            + ",FatherCell='" + ServerTool.escapeString(item.getFatherCell()) + "'"
            + ",FatherEmail='" + ServerTool.escapeString(item.getFatherEmail()) + "'"
            + ",FatherSendEmail='" + ServerTool.escapeString(item.getFatherSendEmail()) + "'"
            + ",MotherFirstName='" + ServerTool.escapeString(item.getMotherFirstName()) + "'"
            + ",MotherSurname='" + ServerTool.escapeString(item.getMotherSurname()) + "'"
            + ",MotherChineseName='" + ServerTool.escapeString(item.getMotherChineseName()) + "'"
            + ",MotherPhone='" + ServerTool.escapeString(item.getMotherPhone()) + "'"
            + ",MotherCell='" + ServerTool.escapeString(item.getMotherCell()) + "'"
            + ",MotherEmail='" + ServerTool.escapeString(item.getMotherEmail()) + "'"
            + ",MotherSendEmail='" + ServerTool.escapeString(item.getMotherSendEmail()) + "'"
            + ",CountryID='" + ServerTool.escapeString(item.getCountryID()) + "'"
            + ",CountyID='" + ServerTool.escapeString(item.getCountyID()) + "'"
            + ",CityID='" + ServerTool.escapeString(item.getCityID()) + "'"
            + ",DistrictID='" + ServerTool.escapeString(item.getDistrictID()) + "'"
            + ",ChineseStreetAddress='" + ServerTool.escapeString(item.getChineseStreetAddress()) + "'"
            + ",EnglishStreetAddress='" + ServerTool.escapeString(item.getEnglishStreetAddress()) + "'"
            + ",PostalCode='" + ServerTool.escapeString(item.getPostalCode()) + "'"
            + ",FreeHandAddress='" + ServerTool.escapeString(item.getFreeHandAddress()) + "'"
            + ",SensitiveAddress='" + ServerTool.escapeString(item.getSensitiveAddress()) + "'"
            + ",ApplyForYear='" + ServerTool.escapeString(item.getApplyForYear()) + "'"
            + ",ApplyForGrade='" + ServerTool.escapeString(item.getApplyForGrade()) + "'"
            + ",CoopID='" + ServerTool.escapeString(item.getCoopID()) + "'"
            + ",Parents='" + ServerTool.escapeString(item.getParents()) + "'"
            + ",Grade='" + ServerTool.escapeString(item.getGrade()) + "'"
            + ",Category='" + ServerTool.escapeString(item.getCategory()) + "'"
            + ",ArcID='" + ServerTool.escapeString(item.getArcID()) + "'"
            + ",Dorm='" + ServerTool.escapeString(item.getDorm()) + "'"
            + ",Identity=" + item.getIdentity()
            + ",TDisc=" + item.getTDisc()
            + ",MDisc=" + item.getMDisc()
            + ",Emergency='" + ServerTool.escapeString(item.getEmergency()) + "'"
            + ",BillTo='" + ServerTool.escapeString(item.getBillTo()) + "'"
            + ",BillAttention='" + ServerTool.escapeString(item.getBillAttention()) + "'"
            + ",BillCountryID='" + ServerTool.escapeString(item.getBillCountryID()) + "'"
            + ",BillCountyID='" + ServerTool.escapeString(item.getBillCountyID()) + "'"
            + ",BillCityID='" + ServerTool.escapeString(item.getBillCityID()) + "'"
            + ",BillDistrictID='" + ServerTool.escapeString(item.getBillDistrictID()) + "'"
            + ",BillChineseStreetAddress='" + ServerTool.escapeString(item.getBillChineseStreetAddress()) + "'"
            + ",BillEnglishStreetAddress='" + ServerTool.escapeString(item.getBillEnglishStreetAddress()) + "'"
            + ",BillPostalCode='" + ServerTool.escapeString(item.getBillPostalCode()) + "'"
            + ",Fax='" + ServerTool.escapeString(item.getFax()) + "'"
            + ",OfficePhone='" + ServerTool.escapeString(item.getOfficePhone()) + "'"
            + ",StudentCommonName='" + ServerTool.escapeString(item.getStudentCommonName()) + "'"
            + ",TmpEll='" + ServerTool.escapeString(item.getTmpEll()) + "'"
            + ",TmpMilktype='" + ServerTool.escapeString(item.getTmpMilktype()) + "'"
            + ",TmpMusic='" + ServerTool.escapeString(item.getTmpMusic()) + "'"
            + ",TmpInstr='" + ServerTool.escapeString(item.getTmpInstr()) + "'"
            + ",TmpMusicRoom='" + ServerTool.escapeString(item.getTmpMusicRoom()) + "'"
            + ",TmpDorm='" + ServerTool.escapeString(item.getTmpDorm()) + "'"
            + ",TmpDormFood='" + ServerTool.escapeString(item.getTmpDormFood()) + "'"
            + ",TmpKitchen='" + ServerTool.escapeString(item.getTmpKitchen()) + "'"
            + ",TmpLunch='" + ServerTool.escapeString(item.getTmpLunch()) + "'"
            + ",TmpBus='" + ServerTool.escapeString(item.getTmpBus()) + "'"
            + ",membrId=" + item.getMembrId()
            + ",studId=" + item.getStudId()
            + ",notes='" + ServerTool.escapeString(item.getNotes()) + "'"
            + ",sponser='" + ServerTool.escapeString(item.getSponser()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "ExportDate,ImportDate,modified,StudentID,Campus,StudentFirstName,StudentSurname,StudentChineseName,BirthDate,PassportNumber,PassportCountry,Sex,HomePhone,FatherFirstName,FatherSurname,FatherChineseName,FatherPhone,FatherCell,FatherEmail,FatherSendEmail,MotherFirstName,MotherSurname,MotherChineseName,MotherPhone,MotherCell,MotherEmail,MotherSendEmail,CountryID,CountyID,CityID,DistrictID,ChineseStreetAddress,EnglishStreetAddress,PostalCode,FreeHandAddress,SensitiveAddress,ApplyForYear,ApplyForGrade,CoopID,Parents,Grade,Category,ArcID,Dorm,Identity,TDisc,MDisc,Emergency,BillTo,BillAttention,BillCountryID,BillCountyID,BillCityID,BillDistrictID,BillChineseStreetAddress,BillEnglishStreetAddress,BillPostalCode,Fax,OfficePhone,StudentCommonName,TmpEll,TmpMilktype,TmpMusic,TmpInstr,TmpMusicRoom,TmpDorm,TmpDormFood,TmpKitchen,TmpLunch,TmpBus,membrId,studId,notes,sponser";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaStudent item = (McaStudent) obj;

        String ret = 
            "" + (((d=item.getExportDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getImportDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getStudentID()
            + ",'" + ServerTool.escapeString(item.getCampus()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentFirstName()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentSurname()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentChineseName()) + "'"
            + ",'" + ServerTool.escapeString(item.getBirthDate()) + "'"
            + ",'" + ServerTool.escapeString(item.getPassportNumber()) + "'"
            + ",'" + ServerTool.escapeString(item.getPassportCountry()) + "'"
            + ",'" + ServerTool.escapeString(item.getSex()) + "'"
            + ",'" + ServerTool.escapeString(item.getHomePhone()) + "'"
            + ",'" + ServerTool.escapeString(item.getFatherFirstName()) + "'"
            + ",'" + ServerTool.escapeString(item.getFatherSurname()) + "'"
            + ",'" + ServerTool.escapeString(item.getFatherChineseName()) + "'"
            + ",'" + ServerTool.escapeString(item.getFatherPhone()) + "'"
            + ",'" + ServerTool.escapeString(item.getFatherCell()) + "'"
            + ",'" + ServerTool.escapeString(item.getFatherEmail()) + "'"
            + ",'" + ServerTool.escapeString(item.getFatherSendEmail()) + "'"
            + ",'" + ServerTool.escapeString(item.getMotherFirstName()) + "'"
            + ",'" + ServerTool.escapeString(item.getMotherSurname()) + "'"
            + ",'" + ServerTool.escapeString(item.getMotherChineseName()) + "'"
            + ",'" + ServerTool.escapeString(item.getMotherPhone()) + "'"
            + ",'" + ServerTool.escapeString(item.getMotherCell()) + "'"
            + ",'" + ServerTool.escapeString(item.getMotherEmail()) + "'"
            + ",'" + ServerTool.escapeString(item.getMotherSendEmail()) + "'"
            + ",'" + ServerTool.escapeString(item.getCountryID()) + "'"
            + ",'" + ServerTool.escapeString(item.getCountyID()) + "'"
            + ",'" + ServerTool.escapeString(item.getCityID()) + "'"
            + ",'" + ServerTool.escapeString(item.getDistrictID()) + "'"
            + ",'" + ServerTool.escapeString(item.getChineseStreetAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getEnglishStreetAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getPostalCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getFreeHandAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getSensitiveAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getApplyForYear()) + "'"
            + ",'" + ServerTool.escapeString(item.getApplyForGrade()) + "'"
            + ",'" + ServerTool.escapeString(item.getCoopID()) + "'"
            + ",'" + ServerTool.escapeString(item.getParents()) + "'"
            + ",'" + ServerTool.escapeString(item.getGrade()) + "'"
            + ",'" + ServerTool.escapeString(item.getCategory()) + "'"
            + ",'" + ServerTool.escapeString(item.getArcID()) + "'"
            + ",'" + ServerTool.escapeString(item.getDorm()) + "'"
            + "," + item.getIdentity()
            + "," + item.getTDisc()
            + "," + item.getMDisc()
            + ",'" + ServerTool.escapeString(item.getEmergency()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillTo()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillAttention()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillCountryID()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillCountyID()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillCityID()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillDistrictID()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillChineseStreetAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillEnglishStreetAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillPostalCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getFax()) + "'"
            + ",'" + ServerTool.escapeString(item.getOfficePhone()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentCommonName()) + "'"
            + ",'" + ServerTool.escapeString(item.getTmpEll()) + "'"
            + ",'" + ServerTool.escapeString(item.getTmpMilktype()) + "'"
            + ",'" + ServerTool.escapeString(item.getTmpMusic()) + "'"
            + ",'" + ServerTool.escapeString(item.getTmpInstr()) + "'"
            + ",'" + ServerTool.escapeString(item.getTmpMusicRoom()) + "'"
            + ",'" + ServerTool.escapeString(item.getTmpDorm()) + "'"
            + ",'" + ServerTool.escapeString(item.getTmpDormFood()) + "'"
            + ",'" + ServerTool.escapeString(item.getTmpKitchen()) + "'"
            + ",'" + ServerTool.escapeString(item.getTmpLunch()) + "'"
            + ",'" + ServerTool.escapeString(item.getTmpBus()) + "'"
            + "," + item.getMembrId()
            + "," + item.getStudId()
            + ",'" + ServerTool.escapeString(item.getNotes()) + "'"
            + ",'" + ServerTool.escapeString(item.getSponser()) + "'"

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        McaStudent o = (McaStudent) obj;
        o.setId(auto_id);
    }
}
