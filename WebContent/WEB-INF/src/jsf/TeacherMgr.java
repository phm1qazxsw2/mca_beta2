package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TeacherMgr extends Manager
{
    private static TeacherMgr _instance = null;

    TeacherMgr() {}

    public synchronized static TeacherMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TeacherMgr();
        }
        return _instance;
    }

    public TeacherMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "teacher";
    }

    protected Object makeBean()
    {
        return new Teacher();
    }

    protected int getBeanId(Object obj)
    {
        return ((Teacher)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Teacher item = (Teacher) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	teacherFirstName		 = rs.getString("teacherFirstName");
            String	teacherLastName		 = rs.getString("teacherLastName");
            int	teacherSex		 = rs.getInt("teacherSex");
            int	teacherUserId		 = rs.getInt("teacherUserId");
            String	teacherNickname		 = rs.getString("teacherNickname");
            String	teacherEmail		 = rs.getString("teacherEmail");
            String	teacherIdNumber		 = rs.getString("teacherIdNumber");
            java.util.Date	teacherBirth		 = rs.getTimestamp("teacherBirth");
            String	teacherSchool		 = rs.getString("teacherSchool");
            String	teacherFather		 = rs.getString("teacherFather");
            String	teacherMother		 = rs.getString("teacherMother");
            String	teacherMobile		 = rs.getString("teacherMobile");
            String	teacherMobile2		 = rs.getString("teacherMobile2");
            String	teacherMobile3		 = rs.getString("teacherMobile3");
            String	teacherPhone		 = rs.getString("teacherPhone");
            String	teacherPhone2		 = rs.getString("teacherPhone2");
            String	teacherPhone3		 = rs.getString("teacherPhone3");
            String	teacherZipCode		 = rs.getString("teacherZipCode");
            String	teacherAddress		 = rs.getString("teacherAddress");
            java.util.Date	teacherComeDate		 = rs.getTimestamp("teacherComeDate");
            int	teacherStatus		 = rs.getInt("teacherStatus");
            int	teacherLevel		 = rs.getInt("teacherLevel");
            int	teacherDepart		 = rs.getInt("teacherDepart");
            int	teacherPosition		 = rs.getInt("teacherPosition");
            int	teacherClasses		 = rs.getInt("teacherClasses");
            String	teacherBank1		 = rs.getString("teacherBank1");
            String	teacherAccountNumber1		 = rs.getString("teacherAccountNumber1");
            String	teacherAccountName1		 = rs.getString("teacherAccountName1");
            int	teacherAccountDefaut		 = rs.getInt("teacherAccountDefaut");
            String	teacherBank2		 = rs.getString("teacherBank2");
            String	teacherAccountNumber2		 = rs.getString("teacherAccountNumber2");
            String	teacherAccountName2		 = rs.getString("teacherAccountName2");
            String	teacherPs		 = rs.getString("teacherPs");
            int	teacherActive		 = rs.getInt("teacherActive");
            int	teacherAccountPayWay		 = rs.getInt("teacherAccountPayWay");
            int	teacherParttime		 = rs.getInt("teacherParttime");
            int	teacherHealthType		 = rs.getInt("teacherHealthType");
            int	teacherHealthMoney		 = rs.getInt("teacherHealthMoney");
            int	teacherHealthPeople		 = rs.getInt("teacherHealthPeople");
            int	teacherLaborMoney		 = rs.getInt("teacherLaborMoney");
            int	teacherRetireMoney		 = rs.getInt("teacherRetireMoney");
            int	teacherRetirePercent		 = rs.getInt("teacherRetirePercent");
            int	teacherBunitId		 = rs.getInt("teacherBunitId");
            String	teacherBankName1		 = rs.getString("teacherBankName1");
            String	teacherBankName2		 = rs.getString("teacherBankName2");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , teacherFirstName, teacherLastName, teacherSex
            , teacherUserId, teacherNickname, teacherEmail
            , teacherIdNumber, teacherBirth, teacherSchool
            , teacherFather, teacherMother, teacherMobile
            , teacherMobile2, teacherMobile3, teacherPhone
            , teacherPhone2, teacherPhone3, teacherZipCode
            , teacherAddress, teacherComeDate, teacherStatus
            , teacherLevel, teacherDepart, teacherPosition
            , teacherClasses, teacherBank1, teacherAccountNumber1
            , teacherAccountName1, teacherAccountDefaut, teacherBank2
            , teacherAccountNumber2, teacherAccountName2, teacherPs
            , teacherActive, teacherAccountPayWay, teacherParttime
            , teacherHealthType, teacherHealthMoney, teacherHealthPeople
            , teacherLaborMoney, teacherRetireMoney, teacherRetirePercent
            , teacherBunitId, teacherBankName1, teacherBankName2
            , bunitId);
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
        Teacher item = (Teacher) obj;

        String ret = "modified=NOW()"
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
            + ",teacherBankName1='" + ServerTool.escapeString(item.getTeacherBankName1()) + "'"
            + ",teacherBankName2='" + ServerTool.escapeString(item.getTeacherBankName2()) + "'"
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, teacherFirstName, teacherLastName, teacherSex, teacherUserId, teacherNickname, teacherEmail, teacherIdNumber, teacherBirth, teacherSchool, teacherFather, teacherMother, teacherMobile, teacherMobile2, teacherMobile3, teacherPhone, teacherPhone2, teacherPhone3, teacherZipCode, teacherAddress, teacherComeDate, teacherStatus, teacherLevel, teacherDepart, teacherPosition, teacherClasses, teacherBank1, teacherAccountNumber1, teacherAccountName1, teacherAccountDefaut, teacherBank2, teacherAccountNumber2, teacherAccountName2, teacherPs, teacherActive, teacherAccountPayWay, teacherParttime, teacherHealthType, teacherHealthMoney, teacherHealthPeople, teacherLaborMoney, teacherRetireMoney, teacherRetirePercent, teacherBunitId, teacherBankName1, teacherBankName2, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Teacher item = (Teacher) obj;

        String ret = "NOW(), NOW()"
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
            + ",'" + ServerTool.escapeString(item.getTeacherBankName1()) + "'"
            + ",'" + ServerTool.escapeString(item.getTeacherBankName2()) + "'"
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
