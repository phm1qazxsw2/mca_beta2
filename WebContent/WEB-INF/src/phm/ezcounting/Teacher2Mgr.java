package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class Teacher2Mgr extends dbo.Manager<Teacher2>
{
    private static Teacher2Mgr _instance = null;

    Teacher2Mgr() {}

    public synchronized static Teacher2Mgr getInstance()
    {
        if (_instance==null) {
            _instance = new Teacher2Mgr();
        }
        return _instance;
    }

    public Teacher2Mgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "teacher";
    }

    protected Object makeBean()
    {
        return new Teacher2();
    }

    protected String getIdentifier(Object obj)
    {
        Teacher2 o = (Teacher2) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Teacher2 item = (Teacher2) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            java.util.Date	modified		 = rs.getTimestamp("modified");
            item.setModified(modified);
            String	teacherFirstName		 = rs.getString("teacherFirstName");
            item.setTeacherFirstName(teacherFirstName);
            String	teacherLastName		 = rs.getString("teacherLastName");
            item.setTeacherLastName(teacherLastName);
            int	teacherSex		 = rs.getInt("teacherSex");
            item.setTeacherSex(teacherSex);
            int	teacherUserId		 = rs.getInt("teacherUserId");
            item.setTeacherUserId(teacherUserId);
            String	teacherNickname		 = rs.getString("teacherNickname");
            item.setTeacherNickname(teacherNickname);
            String	teacherEmail		 = rs.getString("teacherEmail");
            item.setTeacherEmail(teacherEmail);
            String	teacherIdNumber		 = rs.getString("teacherIdNumber");
            item.setTeacherIdNumber(teacherIdNumber);
            java.util.Date	teacherBirth		 = rs.getTimestamp("teacherBirth");
            item.setTeacherBirth(teacherBirth);
            String	teacherSchool		 = rs.getString("teacherSchool");
            item.setTeacherSchool(teacherSchool);
            String	teacherFather		 = rs.getString("teacherFather");
            item.setTeacherFather(teacherFather);
            String	teacherMother		 = rs.getString("teacherMother");
            item.setTeacherMother(teacherMother);
            String	teacherMobile		 = rs.getString("teacherMobile");
            item.setTeacherMobile(teacherMobile);
            String	teacherMobile2		 = rs.getString("teacherMobile2");
            item.setTeacherMobile2(teacherMobile2);
            String	teacherMobile3		 = rs.getString("teacherMobile3");
            item.setTeacherMobile3(teacherMobile3);
            String	teacherPhone		 = rs.getString("teacherPhone");
            item.setTeacherPhone(teacherPhone);
            String	teacherPhone2		 = rs.getString("teacherPhone2");
            item.setTeacherPhone2(teacherPhone2);
            String	teacherPhone3		 = rs.getString("teacherPhone3");
            item.setTeacherPhone3(teacherPhone3);
            String	teacherZipCode		 = rs.getString("teacherZipCode");
            item.setTeacherZipCode(teacherZipCode);
            String	teacherAddress		 = rs.getString("teacherAddress");
            item.setTeacherAddress(teacherAddress);
            java.util.Date	teacherComeDate		 = rs.getTimestamp("teacherComeDate");
            item.setTeacherComeDate(teacherComeDate);
            int	teacherStatus		 = rs.getInt("teacherStatus");
            item.setTeacherStatus(teacherStatus);
            int	teacherLevel		 = rs.getInt("teacherLevel");
            item.setTeacherLevel(teacherLevel);
            int	teacherDepart		 = rs.getInt("teacherDepart");
            item.setTeacherDepart(teacherDepart);
            int	teacherPosition		 = rs.getInt("teacherPosition");
            item.setTeacherPosition(teacherPosition);
            int	teacherClasses		 = rs.getInt("teacherClasses");
            item.setTeacherClasses(teacherClasses);
            String	teacherBank1		 = rs.getString("teacherBank1");
            item.setTeacherBank1(teacherBank1);
            String	teacherAccountNumber1		 = rs.getString("teacherAccountNumber1");
            item.setTeacherAccountNumber1(teacherAccountNumber1);
            String	teacherAccountName1		 = rs.getString("teacherAccountName1");
            item.setTeacherAccountName1(teacherAccountName1);
            int	teacherAccountDefaut		 = rs.getInt("teacherAccountDefaut");
            item.setTeacherAccountDefaut(teacherAccountDefaut);
            String	teacherBank2		 = rs.getString("teacherBank2");
            item.setTeacherBank2(teacherBank2);
            String	teacherAccountNumber2		 = rs.getString("teacherAccountNumber2");
            item.setTeacherAccountNumber2(teacherAccountNumber2);
            String	teacherAccountName2		 = rs.getString("teacherAccountName2");
            item.setTeacherAccountName2(teacherAccountName2);
            String	teacherPs		 = rs.getString("teacherPs");
            item.setTeacherPs(teacherPs);
            int	teacherActive		 = rs.getInt("teacherActive");
            item.setTeacherActive(teacherActive);
            int	teacherAccountPayWay		 = rs.getInt("teacherAccountPayWay");
            item.setTeacherAccountPayWay(teacherAccountPayWay);
            int	teacherParttime		 = rs.getInt("teacherParttime");
            item.setTeacherParttime(teacherParttime);
            int	teacherHealthType		 = rs.getInt("teacherHealthType");
            item.setTeacherHealthType(teacherHealthType);
            int	teacherHealthMoney		 = rs.getInt("teacherHealthMoney");
            item.setTeacherHealthMoney(teacherHealthMoney);
            int	teacherHealthPeople		 = rs.getInt("teacherHealthPeople");
            item.setTeacherHealthPeople(teacherHealthPeople);
            int	teacherLaborMoney		 = rs.getInt("teacherLaborMoney");
            item.setTeacherLaborMoney(teacherLaborMoney);
            int	teacherRetireMoney		 = rs.getInt("teacherRetireMoney");
            item.setTeacherRetireMoney(teacherRetireMoney);
            int	teacherRetirePercent		 = rs.getInt("teacherRetirePercent");
            item.setTeacherRetirePercent(teacherRetirePercent);
            int	teacherBunitId		 = rs.getInt("teacherBunitId");
            item.setTeacherBunitId(teacherBunitId);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
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
        Teacher2 item = (Teacher2) obj;

        String ret = 
            "id=" + item.getId()
            + ",created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",modified=" + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",teacherFirstName='" + ServerTool.escapeString(item.getTeacherFirstName()) + "'"
            + ",teacherLastName='" + ServerTool.escapeString(item.getTeacherLastName()) + "'"
            + ",teacherSex=" + item.getTeacherSex()
            + ",teacherUserId=" + item.getTeacherUserId()
            + ",teacherNickname='" + ServerTool.escapeString(item.getTeacherNickname()) + "'"
            + ",teacherEmail='" + ServerTool.escapeString(item.getTeacherEmail()) + "'"
            + ",teacherIdNumber='" + ServerTool.escapeString(item.getTeacherIdNumber()) + "'"
            + ",teacherBirth=" + (((d=item.getTeacherBirth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",teacherSchool='" + ServerTool.escapeString(item.getTeacherSchool()) + "'"
            + ",teacherFather='" + ServerTool.escapeString(item.getTeacherFather()) + "'"
            + ",teacherMother='" + ServerTool.escapeString(item.getTeacherMother()) + "'"
            + ",teacherMobile='" + ServerTool.escapeString(item.getTeacherMobile()) + "'"
            + ",teacherMobile2='" + ServerTool.escapeString(item.getTeacherMobile2()) + "'"
            + ",teacherMobile3='" + ServerTool.escapeString(item.getTeacherMobile3()) + "'"
            + ",teacherPhone='" + ServerTool.escapeString(item.getTeacherPhone()) + "'"
            + ",teacherPhone2='" + ServerTool.escapeString(item.getTeacherPhone2()) + "'"
            + ",teacherPhone3='" + ServerTool.escapeString(item.getTeacherPhone3()) + "'"
            + ",teacherZipCode='" + ServerTool.escapeString(item.getTeacherZipCode()) + "'"
            + ",teacherAddress='" + ServerTool.escapeString(item.getTeacherAddress()) + "'"
            + ",teacherComeDate=" + (((d=item.getTeacherComeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",teacherStatus=" + item.getTeacherStatus()
            + ",teacherLevel=" + item.getTeacherLevel()
            + ",teacherDepart=" + item.getTeacherDepart()
            + ",teacherPosition=" + item.getTeacherPosition()
            + ",teacherClasses=" + item.getTeacherClasses()
            + ",teacherBank1='" + ServerTool.escapeString(item.getTeacherBank1()) + "'"
            + ",teacherAccountNumber1='" + ServerTool.escapeString(item.getTeacherAccountNumber1()) + "'"
            + ",teacherAccountName1='" + ServerTool.escapeString(item.getTeacherAccountName1()) + "'"
            + ",teacherAccountDefaut=" + item.getTeacherAccountDefaut()
            + ",teacherBank2='" + ServerTool.escapeString(item.getTeacherBank2()) + "'"
            + ",teacherAccountNumber2='" + ServerTool.escapeString(item.getTeacherAccountNumber2()) + "'"
            + ",teacherAccountName2='" + ServerTool.escapeString(item.getTeacherAccountName2()) + "'"
            + ",teacherPs='" + ServerTool.escapeString(item.getTeacherPs()) + "'"
            + ",teacherActive=" + item.getTeacherActive()
            + ",teacherAccountPayWay=" + item.getTeacherAccountPayWay()
            + ",teacherParttime=" + item.getTeacherParttime()
            + ",teacherHealthType=" + item.getTeacherHealthType()
            + ",teacherHealthMoney=" + item.getTeacherHealthMoney()
            + ",teacherHealthPeople=" + item.getTeacherHealthPeople()
            + ",teacherLaborMoney=" + item.getTeacherLaborMoney()
            + ",teacherRetireMoney=" + item.getTeacherRetireMoney()
            + ",teacherRetirePercent=" + item.getTeacherRetirePercent()
            + ",teacherBunitId=" + item.getTeacherBunitId()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "id,created,modified,teacherFirstName,teacherLastName,teacherSex,teacherUserId,teacherNickname,teacherEmail,teacherIdNumber,teacherBirth,teacherSchool,teacherFather,teacherMother,teacherMobile,teacherMobile2,teacherMobile3,teacherPhone,teacherPhone2,teacherPhone3,teacherZipCode,teacherAddress,teacherComeDate,teacherStatus,teacherLevel,teacherDepart,teacherPosition,teacherClasses,teacherBank1,teacherAccountNumber1,teacherAccountName1,teacherAccountDefaut,teacherBank2,teacherAccountNumber2,teacherAccountName2,teacherPs,teacherActive,teacherAccountPayWay,teacherParttime,teacherHealthType,teacherHealthMoney,teacherHealthPeople,teacherLaborMoney,teacherRetireMoney,teacherRetirePercent,teacherBunitId,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Teacher2 item = (Teacher2) obj;

        String ret = 
            "" + item.getId()
            + "," + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getTeacherFirstName()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherLastName()) + "'"
            + "," + item.getTeacherSex()
            + "," + item.getTeacherUserId()
            + ",'" + ServerTool.escapeString(item.getTeacherNickname()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherEmail()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherIdNumber()) + "'"
            + "," + (((d=item.getTeacherBirth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getTeacherSchool()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherFather()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherMother()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherMobile()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherMobile2()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherMobile3()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherPhone()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherPhone2()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherPhone3()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherZipCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherAddress()) + "'"
            + "," + (((d=item.getTeacherComeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getTeacherStatus()
            + "," + item.getTeacherLevel()
            + "," + item.getTeacherDepart()
            + "," + item.getTeacherPosition()
            + "," + item.getTeacherClasses()
            + ",'" + ServerTool.escapeString(item.getTeacherBank1()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherAccountNumber1()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherAccountName1()) + "'"
            + "," + item.getTeacherAccountDefaut()
            + ",'" + ServerTool.escapeString(item.getTeacherBank2()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherAccountNumber2()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherAccountName2()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherPs()) + "'"
            + "," + item.getTeacherActive()
            + "," + item.getTeacherAccountPayWay()
            + "," + item.getTeacherParttime()
            + "," + item.getTeacherHealthType()
            + "," + item.getTeacherHealthMoney()
            + "," + item.getTeacherHealthPeople()
            + "," + item.getTeacherLaborMoney()
            + "," + item.getTeacherRetireMoney()
            + "," + item.getTeacherRetirePercent()
            + "," + item.getTeacherBunitId()
            + "," + item.getBunitId()

        ;
        return ret;
    }
}
