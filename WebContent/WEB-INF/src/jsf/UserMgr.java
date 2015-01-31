package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class UserMgr extends Manager
{
    private static UserMgr _instance = null;

    UserMgr() {}

    public synchronized static UserMgr getInstance()
    {
        if (_instance==null) {
            _instance = new UserMgr();
        }
        return _instance;
    }

    public UserMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "user";
    }

    protected Object makeBean()
    {
        return new User();
    }

    protected int getBeanId(Object obj)
    {
        return ((User)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        User item = (User) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	userLoginId		 = rs.getString("userLoginId");
            String	userPassword		 = rs.getString("userPassword");
            String	userFullname		 = rs.getString("userFullname");
            String	userEmail		 = rs.getString("userEmail");
            String	userPhone		 = rs.getString("userPhone");
            int	userRole		 = rs.getInt("userRole");
            int	userEmailReport		 = rs.getInt("userEmailReport");
            int	userActive		 = rs.getInt("userActive");
            int	userBunitCard		 = rs.getInt("userBunitCard");
            int	userBunitAccounting		 = rs.getInt("userBunitAccounting");
            int	userContentType1		 = rs.getInt("userContentType1");
            int	userContentType2		 = rs.getInt("userContentType2");
            int	userContentType3		 = rs.getInt("userContentType3");
            int	userContentType4		 = rs.getInt("userContentType4");
            int	userContentType5		 = rs.getInt("userContentType5");
            int	userContentType6		 = rs.getInt("userContentType6");
            int	userContentType7		 = rs.getInt("userContentType7");
            int	userContentType8		 = rs.getInt("userContentType8");
            int	userContentType9		 = rs.getInt("userContentType9");
            int	userContentType10		 = rs.getInt("userContentType10");
            int	userContentType11		 = rs.getInt("userContentType11");
            int	userConfirmUpdate		 = rs.getInt("userConfirmUpdate");

            item
            .init(id, created, modified
            , userLoginId, userPassword, userFullname
            , userEmail, userPhone, userRole
            , userEmailReport, userActive, userBunitCard
            , userBunitAccounting, userContentType1, userContentType2
            , userContentType3, userContentType4, userContentType5
            , userContentType6, userContentType7, userContentType8
            , userContentType9, userContentType10, userContentType11
            , userConfirmUpdate);
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
        User item = (User) obj;

        String ret = "modified=NOW()"
            + ",userLoginId='" + ServerTool.escapeString(item.getUserLoginId()) + "'"
            + ",userPassword='" + ServerTool.escapeString(item.getUserPassword()) + "'"
            + ",userFullname='" + ServerTool.escapeString(item.getUserFullname()) + "'"
            + ",userEmail='" + ServerTool.escapeString(item.getUserEmail()) + "'"
            + ",userPhone='" + ServerTool.escapeString(item.getUserPhone()) + "'"
            + ",userRole=" + item.getUserRole()
            + ",userEmailReport=" + item.getUserEmailReport()
            + ",userActive=" + item.getUserActive()
            + ",userBunitCard=" + item.getUserBunitCard()
            + ",userBunitAccounting=" + item.getUserBunitAccounting()
            + ",userContentType1=" + item.getUserContentType1()
            + ",userContentType2=" + item.getUserContentType2()
            + ",userContentType3=" + item.getUserContentType3()
            + ",userContentType4=" + item.getUserContentType4()
            + ",userContentType5=" + item.getUserContentType5()
            + ",userContentType6=" + item.getUserContentType6()
            + ",userContentType7=" + item.getUserContentType7()
            + ",userContentType8=" + item.getUserContentType8()
            + ",userContentType9=" + item.getUserContentType9()
            + ",userContentType10=" + item.getUserContentType10()
            + ",userContentType11=" + item.getUserContentType11()
            + ",userConfirmUpdate=" + item.getUserConfirmUpdate()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, userLoginId, userPassword, userFullname, userEmail, userPhone, userRole, userEmailReport, userActive, userBunitCard, userBunitAccounting, userContentType1, userContentType2, userContentType3, userContentType4, userContentType5, userContentType6, userContentType7, userContentType8, userContentType9, userContentType10, userContentType11, userConfirmUpdate";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        User item = (User) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getUserLoginId()) + "'"
            + ",'" + ServerTool.escapeString(item.getUserPassword()) + "'"
            + ",'" + ServerTool.escapeString(item.getUserFullname()) + "'"
            + ",'" + ServerTool.escapeString(item.getUserEmail()) + "'"
            + ",'" + ServerTool.escapeString(item.getUserPhone()) + "'"
            + "," + item.getUserRole()
            + "," + item.getUserEmailReport()
            + "," + item.getUserActive()
            + "," + item.getUserBunitCard()
            + "," + item.getUserBunitAccounting()
            + "," + item.getUserContentType1()
            + "," + item.getUserContentType2()
            + "," + item.getUserContentType3()
            + "," + item.getUserContentType4()
            + "," + item.getUserContentType5()
            + "," + item.getUserContentType6()
            + "," + item.getUserContentType7()
            + "," + item.getUserContentType8()
            + "," + item.getUserContentType9()
            + "," + item.getUserContentType10()
            + "," + item.getUserContentType11()
            + "," + item.getUserConfirmUpdate()
        ;
        return ret;
    }
    
    public User findLoginId(String loginId)
    {
        Object[] objs = retrieve("userLoginId='" +ServerTool.escapeString(loginId)+ "' and userActive='1'", "");   
        
        User ret = null;
        
        if (objs!=null && objs.length>0)
        {
            ret = (User) objs[0];   
        }
        return ret;
    }        
}
