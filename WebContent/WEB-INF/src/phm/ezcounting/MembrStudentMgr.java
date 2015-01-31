package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MembrStudentMgr extends dbo.Manager<MembrStudent>
{
    private static MembrStudentMgr _instance = null;

    MembrStudentMgr() {}

    public synchronized static MembrStudentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MembrStudentMgr();
        }
        return _instance;
    }

    public MembrStudentMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membr join student";
    }

    protected Object makeBean()
    {
        return new MembrStudent();
    }

    protected String JoinSpace()
    {
         return "membr.type=1 and membr.surrogateId=student.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MembrStudent item = (MembrStudent) obj;
        try {
            int	membrId		 = rs.getInt("membr.id");
            item.setMembrId(membrId);
            int	studentId		 = rs.getInt("student.id");
            item.setStudentId(studentId);
            String	name		 = rs.getString("membr.name");
            item.setName(name);
            int	status		 = rs.getInt("student.studentStatus");
            item.setStatus(status);
            String	studentNumber		 = rs.getString("studentNumber");
            item.setStudentNumber(studentNumber);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
