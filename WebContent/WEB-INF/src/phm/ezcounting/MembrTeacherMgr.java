package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MembrTeacherMgr extends dbo.Manager<MembrTeacher>
{
    private static MembrTeacherMgr _instance = null;

    MembrTeacherMgr() {}

    public synchronized static MembrTeacherMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MembrTeacherMgr();
        }
        return _instance;
    }

    public MembrTeacherMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membr join teacher";
    }

    protected Object makeBean()
    {
        return new MembrTeacher();
    }

    protected String JoinSpace()
    {
         return "membr.type=2 and membr.surrogateId=teacher.id";
    }

    protected String getFieldList()
    {
         return "membr.id,teacher.id,teacherIdNumber,teacherBank1,teacherAccountNumber1,teacherAccountName1,teacherAccountDefaut,teacherBank2,teacherAccountNumber2,teacherAccountName2,teacherAccountPayWay,membr.name,teacherStatus,teacherLevel,teacherBunitId,teacherEmail";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MembrTeacher item = (MembrTeacher) obj;
        try {
            int	membrId		 = rs.getInt("membr.id");
            item.setMembrId(membrId);
            int	teacherId		 = rs.getInt("teacher.id");
            item.setTeacherId(teacherId);
            String	name		 = rs.getString("membr.name");
            item.setName(name);
            String	teacherIdNumber		 = rs.getString("teacherIdNumber");
            item.setTeacherIdNumber(teacherIdNumber);
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
            int	teacherAccountPayWay		 = rs.getInt("teacherAccountPayWay");
            item.setTeacherAccountPayWay(teacherAccountPayWay);
            int	status		 = rs.getInt("teacherStatus");
            item.setStatus(status);
            int	teacherLevel		 = rs.getInt("teacherLevel");
            item.setTeacherLevel(teacherLevel);
            int	teacherBunitId		 = rs.getInt("teacherBunitId");
            item.setTeacherBunitId(teacherBunitId);
            String	teacherEmail		 = rs.getString("teacherEmail");
            item.setTeacherEmail(teacherEmail);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
