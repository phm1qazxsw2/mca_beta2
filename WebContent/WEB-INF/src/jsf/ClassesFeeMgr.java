package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ClassesFeeMgr extends Manager
{
    private static ClassesFeeMgr _instance = null;

    ClassesFeeMgr() {}

    public synchronized static ClassesFeeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ClassesFeeMgr();
        }
        return _instance;
    }

    public ClassesFeeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "classesfee";
    }

    protected Object makeBean()
    {
        return new ClassesFee();
    }

    protected int getBeanId(Object obj)
    {
        return ((ClassesFee)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        ClassesFee item = (ClassesFee) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	classesFeeCMId		 = rs.getInt("classesFeeCMId");
            int	classesFeeStudentId		 = rs.getInt("classesFeeStudentId");
            int	classesFeeStuClassId		 = rs.getInt("classesFeeStuClassId");
            int	classesFeeStuGroupId		 = rs.getInt("classesFeeStuGroupId");
            int	classesFeeStuLevelId		 = rs.getInt("classesFeeStuLevelId");
            java.util.Date	classesFeeMonth		 = rs.getTimestamp("classesFeeMonth");
            int	classesFeeFeenumberId		 = rs.getInt("classesFeeFeenumberId");
            int	classesFeeShouldNumber		 = rs.getInt("classesFeeShouldNumber");
            int	classesFeeTotalDiscount		 = rs.getInt("classesFeeTotalDiscount");
            int	classesFeeLogId		 = rs.getInt("classesFeeLogId");
            String	classesFeeLogPs		 = rs.getString("classesFeeLogPs");
            int	classesFeeVNeed		 = rs.getInt("classesFeeVNeed");
            int	classesFeeVUserId		 = rs.getInt("classesFeeVUserId");
            java.util.Date	classesFeeVDate		 = rs.getTimestamp("classesFeeVDate");
            String	classesFeeVPs		 = rs.getString("classesFeeVPs");
            int	classesFeeStatus		 = rs.getInt("classesFeeStatus");
            int	classesFeeChargeId		 = rs.getInt("classesFeeChargeId");

            item
            .init(id, created, modified
            , classesFeeCMId, classesFeeStudentId, classesFeeStuClassId
            , classesFeeStuGroupId, classesFeeStuLevelId, classesFeeMonth
            , classesFeeFeenumberId, classesFeeShouldNumber, classesFeeTotalDiscount
            , classesFeeLogId, classesFeeLogPs, classesFeeVNeed
            , classesFeeVUserId, classesFeeVDate, classesFeeVPs
            , classesFeeStatus, classesFeeChargeId);
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
        ClassesFee item = (ClassesFee) obj;

        String ret = "modified=NOW()"
            + ",classesFeeCMId=" + item.getClassesFeeCMId()
            + ",classesFeeStudentId=" + item.getClassesFeeStudentId()
            + ",classesFeeStuClassId=" + item.getClassesFeeStuClassId()
            + ",classesFeeStuGroupId=" + item.getClassesFeeStuGroupId()
            + ",classesFeeStuLevelId=" + item.getClassesFeeStuLevelId()
            + ",classesFeeMonth=" + (((d=item.getClassesFeeMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",classesFeeFeenumberId=" + item.getClassesFeeFeenumberId()
            + ",classesFeeShouldNumber=" + item.getClassesFeeShouldNumber()
            + ",classesFeeTotalDiscount=" + item.getClassesFeeTotalDiscount()
            + ",classesFeeLogId=" + item.getClassesFeeLogId()
            + ",classesFeeLogPs='" + ServerTool.escapeString(item.getClassesFeeLogPs()) + "'"
            + ",classesFeeVNeed=" + item.getClassesFeeVNeed()
            + ",classesFeeVUserId=" + item.getClassesFeeVUserId()
            + ",classesFeeVDate=" + (((d=item.getClassesFeeVDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",classesFeeVPs='" + ServerTool.escapeString(item.getClassesFeeVPs()) + "'"
            + ",classesFeeStatus=" + item.getClassesFeeStatus()
            + ",classesFeeChargeId=" + item.getClassesFeeChargeId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, classesFeeCMId, classesFeeStudentId, classesFeeStuClassId, classesFeeStuGroupId, classesFeeStuLevelId, classesFeeMonth, classesFeeFeenumberId, classesFeeShouldNumber, classesFeeTotalDiscount, classesFeeLogId, classesFeeLogPs, classesFeeVNeed, classesFeeVUserId, classesFeeVDate, classesFeeVPs, classesFeeStatus, classesFeeChargeId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        ClassesFee item = (ClassesFee) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getClassesFeeCMId()
            + "," + item.getClassesFeeStudentId()
            + "," + item.getClassesFeeStuClassId()
            + "," + item.getClassesFeeStuGroupId()
            + "," + item.getClassesFeeStuLevelId()
            + "," + (((d=item.getClassesFeeMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClassesFeeFeenumberId()
            + "," + item.getClassesFeeShouldNumber()
            + "," + item.getClassesFeeTotalDiscount()
            + "," + item.getClassesFeeLogId()
            + ",'" + ServerTool.escapeString(item.getClassesFeeLogPs()) + "'"
            + "," + item.getClassesFeeVNeed()
            + "," + item.getClassesFeeVUserId()
            + "," + (((d=item.getClassesFeeVDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getClassesFeeVPs()) + "'"
            + "," + item.getClassesFeeStatus()
            + "," + item.getClassesFeeChargeId()
        ;
        return ret;
    }
}
