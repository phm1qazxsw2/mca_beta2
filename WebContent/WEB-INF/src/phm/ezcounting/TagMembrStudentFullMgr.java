package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TagMembrStudentFullMgr extends dbo.Manager<TagMembrStudentFull>
{
    private static TagMembrStudentFullMgr _instance = null;

    TagMembrStudentFullMgr() {}

    public synchronized static TagMembrStudentFullMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TagMembrStudentFullMgr();
        }
        return _instance;
    }

    public TagMembrStudentFullMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membr join student";
    }

    protected Object makeBean()
    {
        return new TagMembrStudentFull();
    }

    protected String JoinSpace()
    {
         return "membr.type=1 and membr.surrogateId=student.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TagMembrStudentFull item = (TagMembrStudentFull) obj;
        try {
            int	id		 = rs.getInt("student.id");
            item.setId(id);
            String	studentName		 = rs.getString("studentName");
            item.setStudentName(studentName);
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
            int	membrId		 = rs.getInt("membr.id");
            item.setMembrId(membrId);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (tagmembr) ON membrId=membr.id ";
        return ret;
    }
}
