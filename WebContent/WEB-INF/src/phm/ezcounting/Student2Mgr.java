package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class Student2Mgr extends dbo.Manager<Student2>
{
    private static Student2Mgr _instance = null;

    Student2Mgr() {}

    public synchronized static Student2Mgr getInstance()
    {
        if (_instance==null) {
            _instance = new Student2Mgr();
        }
        return _instance;
    }

    public Student2Mgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "student";
    }

    protected Object makeBean()
    {
        return new Student2();
    }

    protected String getIdentifier(Object obj)
    {
        Student2 o = (Student2) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Student2 item = (Student2) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            java.util.Date	modified		 = rs.getTimestamp("modified");
            item.setModified(modified);
            String	studentName		 = rs.getString("studentName");
            item.setStudentName(studentName);
            String	studentShortName		 = rs.getString("studentShortName");
            item.setStudentShortName(studentShortName);
            String	studentNumber		 = rs.getString("studentNumber");
            item.setStudentNumber(studentNumber);
            String	studentNickname		 = rs.getString("studentNickname");
            item.setStudentNickname(studentNickname);
            String	studentIDNumber		 = rs.getString("studentIDNumber");
            item.setStudentIDNumber(studentIDNumber);
            int	studentSex		 = rs.getInt("studentSex");
            item.setStudentSex(studentSex);
            java.util.Date	studentBirth		 = rs.getTimestamp("studentBirth");
            item.setStudentBirth(studentBirth);
            String	studentFather		 = rs.getString("studentFather");
            item.setStudentFather(studentFather);
            String	studentMother		 = rs.getString("studentMother");
            item.setStudentMother(studentMother);
            String	studentFatherMobile		 = rs.getString("studentFatherMobile");
            item.setStudentFatherMobile(studentFatherMobile);
            String	studentFatherMobile2		 = rs.getString("studentFatherMobile2");
            item.setStudentFatherMobile2(studentFatherMobile2);
            String	studentMotherMobile		 = rs.getString("studentMotherMobile");
            item.setStudentMotherMobile(studentMotherMobile);
            String	studentMotherMobile2		 = rs.getString("studentMotherMobile2");
            item.setStudentMotherMobile2(studentMotherMobile2);
            int	studentMobileDefault		 = rs.getInt("studentMobileDefault");
            item.setStudentMobileDefault(studentMobileDefault);
            String	studentFatherEmail		 = rs.getString("studentFatherEmail");
            item.setStudentFatherEmail(studentFatherEmail);
            String	studentMotherEmail		 = rs.getString("studentMotherEmail");
            item.setStudentMotherEmail(studentMotherEmail);
            int	studentEmailDefault		 = rs.getInt("studentEmailDefault");
            item.setStudentEmailDefault(studentEmailDefault);
            String	studentPhone		 = rs.getString("studentPhone");
            item.setStudentPhone(studentPhone);
            String	studentPhone2		 = rs.getString("studentPhone2");
            item.setStudentPhone2(studentPhone2);
            String	studentPhone3		 = rs.getString("studentPhone3");
            item.setStudentPhone3(studentPhone3);
            int	studentPhoneDefault		 = rs.getInt("studentPhoneDefault");
            item.setStudentPhoneDefault(studentPhoneDefault);
            String	studentZipCode		 = rs.getString("studentZipCode");
            item.setStudentZipCode(studentZipCode);
            String	studentAddress		 = rs.getString("studentAddress");
            item.setStudentAddress(studentAddress);
            int	studentStatus		 = rs.getInt("studentStatus");
            item.setStudentStatus(studentStatus);
            int	studentDepart		 = rs.getInt("studentDepart");
            item.setStudentDepart(studentDepart);
            int	studentClassId		 = rs.getInt("studentClassId");
            item.setStudentClassId(studentClassId);
            int	studentGroupId		 = rs.getInt("studentGroupId");
            item.setStudentGroupId(studentGroupId);
            int	studentLevel		 = rs.getInt("studentLevel");
            item.setStudentLevel(studentLevel);
            String	studentBank1		 = rs.getString("studentBank1");
            item.setStudentBank1(studentBank1);
            String	studentAccountNumber1		 = rs.getString("studentAccountNumber1");
            item.setStudentAccountNumber1(studentAccountNumber1);
            String	studentBank2		 = rs.getString("studentBank2");
            item.setStudentBank2(studentBank2);
            String	studentAccountNumber2		 = rs.getString("studentAccountNumber2");
            item.setStudentAccountNumber2(studentAccountNumber2);
            String	studentPs		 = rs.getString("studentPs");
            item.setStudentPs(studentPs);
            String	studentPicFile		 = rs.getString("studentPicFile");
            item.setStudentPicFile(studentPicFile);
            int	studentBrother		 = rs.getInt("studentBrother");
            item.setStudentBrother(studentBrother);
            int	studentBigSister		 = rs.getInt("studentBigSister");
            item.setStudentBigSister(studentBigSister);
            int	studentYoungBrother		 = rs.getInt("studentYoungBrother");
            item.setStudentYoungBrother(studentYoungBrother);
            int	studentYoungSister		 = rs.getInt("studentYoungSister");
            item.setStudentYoungSister(studentYoungSister);
            String	studentFathJob		 = rs.getString("studentFathJob");
            item.setStudentFathJob(studentFathJob);
            int	studebtFatherDegree		 = rs.getInt("studebtFatherDegree");
            item.setStudebtFatherDegree(studebtFatherDegree);
            String	studentMothJob		 = rs.getString("studentMothJob");
            item.setStudentMothJob(studentMothJob);
            int	studentMothDegree		 = rs.getInt("studentMothDegree");
            item.setStudentMothDegree(studentMothDegree);
            int	studentGohome		 = rs.getInt("studentGohome");
            item.setStudentGohome(studentGohome);
            int	studentSchool		 = rs.getInt("studentSchool");
            item.setStudentSchool(studentSchool);
            String	studentSpecial		 = rs.getString("studentSpecial");
            item.setStudentSpecial(studentSpecial);
            int	studentPhoneTeacher		 = rs.getInt("studentPhoneTeacher");
            item.setStudentPhoneTeacher(studentPhoneTeacher);
            java.util.Date	studentPhoneDate		 = rs.getTimestamp("studentPhoneDate");
            item.setStudentPhoneDate(studentPhoneDate);
            int	studentVisitTeacher		 = rs.getInt("studentVisitTeacher");
            item.setStudentVisitTeacher(studentVisitTeacher);
            java.util.Date	studentVisitDate		 = rs.getTimestamp("studentVisitDate");
            item.setStudentVisitDate(studentVisitDate);
            java.util.Date	studentTryDate		 = rs.getTimestamp("studentTryDate");
            item.setStudentTryDate(studentTryDate);
            String	studentFatherSkype		 = rs.getString("studentFatherSkype");
            item.setStudentFatherSkype(studentFatherSkype);
            String	studentMotherSkype		 = rs.getString("studentMotherSkype");
            item.setStudentMotherSkype(studentMotherSkype);
            int	studentSkypeDefault		 = rs.getInt("studentSkypeDefault");
            item.setStudentSkypeDefault(studentSkypeDefault);
            int	studentFixNumber		 = rs.getInt("studentFixNumber");
            item.setStudentFixNumber(studentFixNumber);
            java.util.Date	studentStuffDate		 = rs.getTimestamp("studentStuffDate");
            item.setStudentStuffDate(studentStuffDate);
            int	studentStuffUserId		 = rs.getInt("studentStuffUserId");
            item.setStudentStuffUserId(studentStuffUserId);
            String	studentStuff1		 = rs.getString("studentStuff1");
            item.setStudentStuff1(studentStuff1);
            String	studentStuff2		 = rs.getString("studentStuff2");
            item.setStudentStuff2(studentStuff2);
            String	studentStuff3		 = rs.getString("studentStuff3");
            item.setStudentStuff3(studentStuff3);
            String	studentStuff4		 = rs.getString("studentStuff4");
            item.setStudentStuff4(studentStuff4);
            String	studentStuff5		 = rs.getString("studentStuff5");
            item.setStudentStuff5(studentStuff5);
            String	studentStuff6		 = rs.getString("studentStuff6");
            item.setStudentStuff6(studentStuff6);
            String	studentStuffPs		 = rs.getString("studentStuffPs");
            item.setStudentStuffPs(studentStuffPs);
            String	studentWeb		 = rs.getString("studentWeb");
            item.setStudentWeb(studentWeb);
            String	studentFatherOffice		 = rs.getString("studentFatherOffice");
            item.setStudentFatherOffice(studentFatherOffice);
            String	studentMotherOffice		 = rs.getString("studentMotherOffice");
            item.setStudentMotherOffice(studentMotherOffice);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
            String	bloodType		 = rs.getString("bloodType");
            item.setBloodType(bloodType);
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
        Student2 item = (Student2) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",modified=" + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
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
         return  "created,modified,studentName,studentShortName,studentNumber,studentNickname,studentIDNumber,studentSex,studentBirth,studentFather,studentMother,studentFatherMobile,studentFatherMobile2,studentMotherMobile,studentMotherMobile2,studentMobileDefault,studentFatherEmail,studentMotherEmail,studentEmailDefault,studentPhone,studentPhone2,studentPhone3,studentPhoneDefault,studentZipCode,studentAddress,studentStatus,studentDepart,studentClassId,studentGroupId,studentLevel,studentBank1,studentAccountNumber1,studentBank2,studentAccountNumber2,studentPs,studentPicFile,studentBrother,studentBigSister,studentYoungBrother,studentYoungSister,studentFathJob,studebtFatherDegree,studentMothJob,studentMothDegree,studentGohome,studentSchool,studentSpecial,studentPhoneTeacher,studentPhoneDate,studentVisitTeacher,studentVisitDate,studentTryDate,studentFatherSkype,studentMotherSkype,studentSkypeDefault,studentFixNumber,studentStuffDate,studentStuffUserId,studentStuff1,studentStuff2,studentStuff3,studentStuff4,studentStuff5,studentStuff6,studentStuffPs,studentWeb,studentFatherOffice,studentMotherOffice,bunitId,bloodType";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Student2 item = (Student2) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
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
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Student2 o = (Student2) obj;
        o.setId(auto_id);
    }
}
