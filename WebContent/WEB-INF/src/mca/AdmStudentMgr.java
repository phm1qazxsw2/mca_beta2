package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AdmStudentMgr extends dbo.Manager<AdmStudent>
{
    private static AdmStudentMgr _instance = null;

    AdmStudentMgr() {}

    public synchronized static AdmStudentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AdmStudentMgr();
        }
        return _instance;
    }

    public AdmStudentMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "ImportFromAdmissions";
    }

    protected Object makeBean()
    {
        return new AdmStudent();
    }

    protected String getIdentifier(Object obj)
    {
        AdmStudent o = (AdmStudent) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        AdmStudent item = (AdmStudent) obj;
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
        AdmStudent item = (AdmStudent) obj;

        String ret = 
            "ExportDate=" + (((d=item.getExportDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",ImportDate=" + (((d=item.getImportDate())!=null)?("'"+df.format(d)+"'"):"NULL")
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

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "ExportDate,ImportDate,StudentID,Campus,StudentFirstName,StudentSurname,StudentChineseName,BirthDate,PassportNumber,PassportCountry,Sex,HomePhone,FatherFirstName,FatherSurname,FatherChineseName,FatherPhone,FatherCell,FatherEmail,FatherSendEmail,MotherFirstName,MotherSurname,MotherChineseName,MotherPhone,MotherCell,MotherEmail,MotherSendEmail,CountryID,CountyID,CityID,DistrictID,ChineseStreetAddress,EnglishStreetAddress,PostalCode,FreeHandAddress,SensitiveAddress,ApplyForYear,ApplyForGrade";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        AdmStudent item = (AdmStudent) obj;

        String ret = 
            "" + (((d=item.getExportDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getImportDate())!=null)?("'"+df.format(d)+"'"):"NULL")
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

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        AdmStudent o = (AdmStudent) obj;
        o.setId(auto_id);
    }
}
