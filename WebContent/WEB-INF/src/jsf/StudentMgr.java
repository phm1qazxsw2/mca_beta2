package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class StudentMgr extends Manager
{
    private static StudentMgr _instance = null;

    StudentMgr() {}

    public synchronized static StudentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new StudentMgr();
        }
        return _instance;
    }

    public StudentMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "student";
    }

    protected Object makeBean()
    {
        return new Student();
    }

    protected int getBeanId(Object obj)
    {
        return ((Student)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Student item = (Student) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	studentName		 = rs.getString("studentName");
            String	studentShortName		 = rs.getString("studentShortName");
            String	studentNumber		 = rs.getString("studentNumber");
            String	studentNickname		 = rs.getString("studentNickname");
            String	studentIDNumber		 = rs.getString("studentIDNumber");
            int	studentSex		 = rs.getInt("studentSex");
            java.util.Date	studentBirth		 = rs.getTimestamp("studentBirth");
            String	studentFather		 = rs.getString("studentFather");
            String	studentMother		 = rs.getString("studentMother");
            String	studentFatherMobile		 = rs.getString("studentFatherMobile");
            String	studentFatherMobile2		 = rs.getString("studentFatherMobile2");
            String	studentMotherMobile		 = rs.getString("studentMotherMobile");
            String	studentMotherMobile2		 = rs.getString("studentMotherMobile2");
            int	studentMobileDefault		 = rs.getInt("studentMobileDefault");
            String	studentFatherEmail		 = rs.getString("studentFatherEmail");
            String	studentMotherEmail		 = rs.getString("studentMotherEmail");
            int	studentEmailDefault		 = rs.getInt("studentEmailDefault");
            String	studentPhone		 = rs.getString("studentPhone");
            String	studentPhone2		 = rs.getString("studentPhone2");
            String	studentPhone3		 = rs.getString("studentPhone3");
            int	studentPhoneDefault		 = rs.getInt("studentPhoneDefault");
            String	studentZipCode		 = rs.getString("studentZipCode");
            String	studentAddress		 = rs.getString("studentAddress");
            int	studentStatus		 = rs.getInt("studentStatus");
            int	studentDepart		 = rs.getInt("studentDepart");
            int	studentClassId		 = rs.getInt("studentClassId");
            int	studentGroupId		 = rs.getInt("studentGroupId");
            int	studentLevel		 = rs.getInt("studentLevel");
            String	studentBank1		 = rs.getString("studentBank1");
            String	studentAccountNumber1		 = rs.getString("studentAccountNumber1");
            String	studentBank2		 = rs.getString("studentBank2");
            String	studentAccountNumber2		 = rs.getString("studentAccountNumber2");
            String	studentPs		 = rs.getString("studentPs");
            String	studentPicFile		 = rs.getString("studentPicFile");
            int	studentBrother		 = rs.getInt("studentBrother");
            int	studentBigSister		 = rs.getInt("studentBigSister");
            int	studentYoungBrother		 = rs.getInt("studentYoungBrother");
            int	studentYoungSister		 = rs.getInt("studentYoungSister");
            String	studentFathJob		 = rs.getString("studentFathJob");
            int	studebtFatherDegree		 = rs.getInt("studebtFatherDegree");
            String	studentMothJob		 = rs.getString("studentMothJob");
            int	studentMothDegree		 = rs.getInt("studentMothDegree");
            int	studentGohome		 = rs.getInt("studentGohome");
            int	studentSchool		 = rs.getInt("studentSchool");
            String	studentSpecial		 = rs.getString("studentSpecial");
            int	studentPhoneTeacher		 = rs.getInt("studentPhoneTeacher");
            java.util.Date	studentPhoneDate		 = rs.getTimestamp("studentPhoneDate");
            int	studentVisitTeacher		 = rs.getInt("studentVisitTeacher");
            java.util.Date	studentVisitDate		 = rs.getTimestamp("studentVisitDate");
            java.util.Date	studentTryDate		 = rs.getTimestamp("studentTryDate");
            String	studentFatherSkype		 = rs.getString("studentFatherSkype");
            String	studentMotherSkype		 = rs.getString("studentMotherSkype");
            int	studentSkypeDefault		 = rs.getInt("studentSkypeDefault");
            int	studentFixNumber		 = rs.getInt("studentFixNumber");
            java.util.Date	studentStuffDate		 = rs.getTimestamp("studentStuffDate");
            int	studentStuffUserId		 = rs.getInt("studentStuffUserId");
            String	studentStuff1		 = rs.getString("studentStuff1");
            String	studentStuff2		 = rs.getString("studentStuff2");
            String	studentStuff3		 = rs.getString("studentStuff3");
            String	studentStuff4		 = rs.getString("studentStuff4");
            String	studentStuff5		 = rs.getString("studentStuff5");
            String	studentStuff6		 = rs.getString("studentStuff6");
            String	studentStuffPs		 = rs.getString("studentStuffPs");
            String	studentWeb		 = rs.getString("studentWeb");
            String	studentFatherOffice		 = rs.getString("studentFatherOffice");
            String	studentMotherOffice		 = rs.getString("studentMotherOffice");
            int	bunitId		 = rs.getInt("bunitId");
            String	bloodType		 = rs.getString("bloodType");

            item
            .init(id, created, modified
            , studentName, studentShortName, studentNumber
            , studentNickname, studentIDNumber, studentSex
            , studentBirth, studentFather, studentMother
            , studentFatherMobile, studentFatherMobile2, studentMotherMobile
            , studentMotherMobile2, studentMobileDefault, studentFatherEmail
            , studentMotherEmail, studentEmailDefault, studentPhone
            , studentPhone2, studentPhone3, studentPhoneDefault
            , studentZipCode, studentAddress, studentStatus
            , studentDepart, studentClassId, studentGroupId
            , studentLevel, studentBank1, studentAccountNumber1
            , studentBank2, studentAccountNumber2, studentPs
            , studentPicFile, studentBrother, studentBigSister
            , studentYoungBrother, studentYoungSister, studentFathJob
            , studebtFatherDegree, studentMothJob, studentMothDegree
            , studentGohome, studentSchool, studentSpecial
            , studentPhoneTeacher, studentPhoneDate, studentVisitTeacher
            , studentVisitDate, studentTryDate, studentFatherSkype
            , studentMotherSkype, studentSkypeDefault, studentFixNumber
            , studentStuffDate, studentStuffUserId, studentStuff1
            , studentStuff2, studentStuff3, studentStuff4
            , studentStuff5, studentStuff6, studentStuffPs
            , studentWeb, studentFatherOffice, studentMotherOffice
            , bunitId, bloodType);
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
        Student item = (Student) obj;

        String ret = "modified=NOW()"
            + ",studentName='" + ServerTool.escapeString(item.getStudentName()) + "'"
            + ",studentShortName='" + ServerTool.escapeString(item.getStudentShortName()) + "'"
            + ",studentNumber='" + ServerTool.escapeString(item.getStudentNumber()) + "'"
            + ",studentNickname='" + ServerTool.escapeString(item.getStudentNickname()) + "'"
            + ",studentIDNumber='" + ServerTool.escapeString(item.getStudentIDNumber()) + "'"
            + ",studentSex=" + item.getStudentSex()
            + ",studentBirth=" + (((d=item.getStudentBirth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",studentFather='" + ServerTool.escapeString(item.getStudentFather()) + "'"
            + ",studentMother='" + ServerTool.escapeString(item.getStudentMother()) + "'"
            + ",studentFatherMobile='" + ServerTool.escapeString(item.getStudentFatherMobile()) + "'"
            + ",studentFatherMobile2='" + ServerTool.escapeString(item.getStudentFatherMobile2()) + "'"
            + ",studentMotherMobile='" + ServerTool.escapeString(item.getStudentMotherMobile()) + "'"
            + ",studentMotherMobile2='" + ServerTool.escapeString(item.getStudentMotherMobile2()) + "'"
            + ",studentMobileDefault=" + item.getStudentMobileDefault()
            + ",studentFatherEmail='" + ServerTool.escapeString(item.getStudentFatherEmail()) + "'"
            + ",studentMotherEmail='" + ServerTool.escapeString(item.getStudentMotherEmail()) + "'"
            + ",studentEmailDefault=" + item.getStudentEmailDefault()
            + ",studentPhone='" + ServerTool.escapeString(item.getStudentPhone()) + "'"
            + ",studentPhone2='" + ServerTool.escapeString(item.getStudentPhone2()) + "'"
            + ",studentPhone3='" + ServerTool.escapeString(item.getStudentPhone3()) + "'"
            + ",studentPhoneDefault=" + item.getStudentPhoneDefault()
            + ",studentZipCode='" + ServerTool.escapeString(item.getStudentZipCode()) + "'"
            + ",studentAddress='" + ServerTool.escapeString(item.getStudentAddress()) + "'"
            + ",studentStatus=" + item.getStudentStatus()
            + ",studentDepart=" + item.getStudentDepart()
            + ",studentClassId=" + item.getStudentClassId()
            + ",studentGroupId=" + item.getStudentGroupId()
            + ",studentLevel=" + item.getStudentLevel()
            + ",studentBank1='" + ServerTool.escapeString(item.getStudentBank1()) + "'"
            + ",studentAccountNumber1='" + ServerTool.escapeString(item.getStudentAccountNumber1()) + "'"
            + ",studentBank2='" + ServerTool.escapeString(item.getStudentBank2()) + "'"
            + ",studentAccountNumber2='" + ServerTool.escapeString(item.getStudentAccountNumber2()) + "'"
            + ",studentPs='" + ServerTool.escapeString(item.getStudentPs()) + "'"
            + ",studentPicFile='" + ServerTool.escapeString(item.getStudentPicFile()) + "'"
            + ",studentBrother=" + item.getStudentBrother()
            + ",studentBigSister=" + item.getStudentBigSister()
            + ",studentYoungBrother=" + item.getStudentYoungBrother()
            + ",studentYoungSister=" + item.getStudentYoungSister()
            + ",studentFathJob='" + ServerTool.escapeString(item.getStudentFathJob()) + "'"
            + ",studebtFatherDegree=" + item.getStudebtFatherDegree()
            + ",studentMothJob='" + ServerTool.escapeString(item.getStudentMothJob()) + "'"
            + ",studentMothDegree=" + item.getStudentMothDegree()
            + ",studentGohome=" + item.getStudentGohome()
            + ",studentSchool=" + item.getStudentSchool()
            + ",studentSpecial='" + ServerTool.escapeString(item.getStudentSpecial()) + "'"
            + ",studentPhoneTeacher=" + item.getStudentPhoneTeacher()
            + ",studentPhoneDate=" + (((d=item.getStudentPhoneDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",studentVisitTeacher=" + item.getStudentVisitTeacher()
            + ",studentVisitDate=" + (((d=item.getStudentVisitDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",studentTryDate=" + (((d=item.getStudentTryDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",studentFatherSkype='" + ServerTool.escapeString(item.getStudentFatherSkype()) + "'"
            + ",studentMotherSkype='" + ServerTool.escapeString(item.getStudentMotherSkype()) + "'"
            + ",studentSkypeDefault=" + item.getStudentSkypeDefault()
            + ",studentFixNumber=" + item.getStudentFixNumber()
            + ",studentStuffDate=" + (((d=item.getStudentStuffDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",studentStuffUserId=" + item.getStudentStuffUserId()
            + ",studentStuff1='" + ServerTool.escapeString(item.getStudentStuff1()) + "'"
            + ",studentStuff2='" + ServerTool.escapeString(item.getStudentStuff2()) + "'"
            + ",studentStuff3='" + ServerTool.escapeString(item.getStudentStuff3()) + "'"
            + ",studentStuff4='" + ServerTool.escapeString(item.getStudentStuff4()) + "'"
            + ",studentStuff5='" + ServerTool.escapeString(item.getStudentStuff5()) + "'"
            + ",studentStuff6='" + ServerTool.escapeString(item.getStudentStuff6()) + "'"
            + ",studentStuffPs='" + ServerTool.escapeString(item.getStudentStuffPs()) + "'"
            + ",studentWeb='" + ServerTool.escapeString(item.getStudentWeb()) + "'"
            + ",studentFatherOffice='" + ServerTool.escapeString(item.getStudentFatherOffice()) + "'"
            + ",studentMotherOffice='" + ServerTool.escapeString(item.getStudentMotherOffice()) + "'"
            + ",bunitId=" + item.getBunitId()
            + ",bloodType='" + ServerTool.escapeString(item.getBloodType()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, studentName, studentShortName, studentNumber, studentNickname, studentIDNumber, studentSex, studentBirth, studentFather, studentMother, studentFatherMobile, studentFatherMobile2, studentMotherMobile, studentMotherMobile2, studentMobileDefault, studentFatherEmail, studentMotherEmail, studentEmailDefault, studentPhone, studentPhone2, studentPhone3, studentPhoneDefault, studentZipCode, studentAddress, studentStatus, studentDepart, studentClassId, studentGroupId, studentLevel, studentBank1, studentAccountNumber1, studentBank2, studentAccountNumber2, studentPs, studentPicFile, studentBrother, studentBigSister, studentYoungBrother, studentYoungSister, studentFathJob, studebtFatherDegree, studentMothJob, studentMothDegree, studentGohome, studentSchool, studentSpecial, studentPhoneTeacher, studentPhoneDate, studentVisitTeacher, studentVisitDate, studentTryDate, studentFatherSkype, studentMotherSkype, studentSkypeDefault, studentFixNumber, studentStuffDate, studentStuffUserId, studentStuff1, studentStuff2, studentStuff3, studentStuff4, studentStuff5, studentStuff6, studentStuffPs, studentWeb, studentFatherOffice, studentMotherOffice, bunitId, bloodType";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Student item = (Student) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getStudentName()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentShortName()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentNumber()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentNickname()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentIDNumber()) + "'"
            + "," + item.getStudentSex()
            + "," + (((d=item.getStudentBirth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getStudentFather()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentMother()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentFatherMobile()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentFatherMobile2()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentMotherMobile()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentMotherMobile2()) + "'"
            + "," + item.getStudentMobileDefault()
            + ",'" + ServerTool.escapeString(item.getStudentFatherEmail()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentMotherEmail()) + "'"
            + "," + item.getStudentEmailDefault()
            + ",'" + ServerTool.escapeString(item.getStudentPhone()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentPhone2()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentPhone3()) + "'"
            + "," + item.getStudentPhoneDefault()
            + ",'" + ServerTool.escapeString(item.getStudentZipCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentAddress()) + "'"
            + "," + item.getStudentStatus()
            + "," + item.getStudentDepart()
            + "," + item.getStudentClassId()
            + "," + item.getStudentGroupId()
            + "," + item.getStudentLevel()
            + ",'" + ServerTool.escapeString(item.getStudentBank1()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentAccountNumber1()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentBank2()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentAccountNumber2()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentPs()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentPicFile()) + "'"
            + "," + item.getStudentBrother()
            + "," + item.getStudentBigSister()
            + "," + item.getStudentYoungBrother()
            + "," + item.getStudentYoungSister()
            + ",'" + ServerTool.escapeString(item.getStudentFathJob()) + "'"
            + "," + item.getStudebtFatherDegree()
            + ",'" + ServerTool.escapeString(item.getStudentMothJob()) + "'"
            + "," + item.getStudentMothDegree()
            + "," + item.getStudentGohome()
            + "," + item.getStudentSchool()
            + ",'" + ServerTool.escapeString(item.getStudentSpecial()) + "'"
            + "," + item.getStudentPhoneTeacher()
            + "," + (((d=item.getStudentPhoneDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getStudentVisitTeacher()
            + "," + (((d=item.getStudentVisitDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getStudentTryDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getStudentFatherSkype()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentMotherSkype()) + "'"
            + "," + item.getStudentSkypeDefault()
            + "," + item.getStudentFixNumber()
            + "," + (((d=item.getStudentStuffDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getStudentStuffUserId()
            + ",'" + ServerTool.escapeString(item.getStudentStuff1()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentStuff2()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentStuff3()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentStuff4()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentStuff5()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentStuff6()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentStuffPs()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentWeb()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentFatherOffice()) + "'"
            + ",'" + ServerTool.escapeString(item.getStudentMotherOffice()) + "'"
            + "," + item.getBunitId()
            + ",'" + ServerTool.escapeString(item.getBloodType()) + "'"
        ;
        return ret;
    }
}
