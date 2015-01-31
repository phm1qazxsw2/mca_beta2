package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SalaryTicketMgr extends Manager
{
    private static SalaryTicketMgr _instance = null;

    SalaryTicketMgr() {}

    public synchronized static SalaryTicketMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SalaryTicketMgr();
        }
        return _instance;
    }

    public SalaryTicketMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "salaryticket";
    }

    protected Object makeBean()
    {
        return new SalaryTicket();
    }

    protected int getBeanId(Object obj)
    {
        return ((SalaryTicket)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SalaryTicket item = (SalaryTicket) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	salaryTicketMonth		 = rs.getTimestamp("salaryTicketMonth");
            int	salaryTicketSanumberId		 = rs.getInt("salaryTicketSanumberId");
            int	salaryTicketTeacherId		 = rs.getInt("salaryTicketTeacherId");
            int	salaryTicketDepartId		 = rs.getInt("salaryTicketDepartId");
            int	salaryTicketPositionId		 = rs.getInt("salaryTicketPositionId");
            int	salaryTicketClassesId		 = rs.getInt("salaryTicketClassesId");
            int	salaryTicketMoneyType1		 = rs.getInt("salaryTicketMoneyType1");
            int	salaryTicketMoneyType2		 = rs.getInt("salaryTicketMoneyType2");
            int	salaryTicketMoneyType3		 = rs.getInt("salaryTicketMoneyType3");
            int	salaryTicketTotalMoney		 = rs.getInt("salaryTicketTotalMoney");
            int	salaryTicketPayMoney		 = rs.getInt("salaryTicketPayMoney");
            int	salaryTicketPayTimes		 = rs.getInt("salaryTicketPayTimes");
            java.util.Date	salaryTicketPayDate		 = rs.getTimestamp("salaryTicketPayDate");
            int	salaryTicketStatus		 = rs.getInt("salaryTicketStatus");
            int	salaryFeePrintNeed		 = rs.getInt("salaryFeePrintNeed");
            String	salaryTicketPs		 = rs.getString("salaryTicketPs");
            int	salaryTicketNewFeenumber		 = rs.getInt("salaryTicketNewFeenumber");
            int	salaryTicketAcceptStatus		 = rs.getInt("salaryTicketAcceptStatus");
            String	salaryTicketAcceptPs		 = rs.getString("salaryTicketAcceptPs");
            int	salaryTicketTeacherParttime		 = rs.getInt("salaryTicketTeacherParttime");

            item
            .init(id, created, modified
            , salaryTicketMonth, salaryTicketSanumberId, salaryTicketTeacherId
            , salaryTicketDepartId, salaryTicketPositionId, salaryTicketClassesId
            , salaryTicketMoneyType1, salaryTicketMoneyType2, salaryTicketMoneyType3
            , salaryTicketTotalMoney, salaryTicketPayMoney, salaryTicketPayTimes
            , salaryTicketPayDate, salaryTicketStatus, salaryFeePrintNeed
            , salaryTicketPs, salaryTicketNewFeenumber, salaryTicketAcceptStatus
            , salaryTicketAcceptPs, salaryTicketTeacherParttime);
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
        SalaryTicket item = (SalaryTicket) obj;

        String ret = "modified=NOW()"
            + ",salaryTicketMonth=" + (((d=item.getSalaryTicketMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryTicketSanumberId=" + item.getSalaryTicketSanumberId()
            + ",salaryTicketTeacherId=" + item.getSalaryTicketTeacherId()
            + ",salaryTicketDepartId=" + item.getSalaryTicketDepartId()
            + ",salaryTicketPositionId=" + item.getSalaryTicketPositionId()
            + ",salaryTicketClassesId=" + item.getSalaryTicketClassesId()
            + ",salaryTicketMoneyType1=" + item.getSalaryTicketMoneyType1()
            + ",salaryTicketMoneyType2=" + item.getSalaryTicketMoneyType2()
            + ",salaryTicketMoneyType3=" + item.getSalaryTicketMoneyType3()
            + ",salaryTicketTotalMoney=" + item.getSalaryTicketTotalMoney()
            + ",salaryTicketPayMoney=" + item.getSalaryTicketPayMoney()
            + ",salaryTicketPayTimes=" + item.getSalaryTicketPayTimes()
            + ",salaryTicketPayDate=" + (((d=item.getSalaryTicketPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryTicketStatus=" + item.getSalaryTicketStatus()
            + ",salaryFeePrintNeed=" + item.getSalaryFeePrintNeed()
            + ",salaryTicketPs='" + ServerTool.escapeString(item.getSalaryTicketPs()) + "'"
            + ",salaryTicketNewFeenumber=" + item.getSalaryTicketNewFeenumber()
            + ",salaryTicketAcceptStatus=" + item.getSalaryTicketAcceptStatus()
            + ",salaryTicketAcceptPs='" + ServerTool.escapeString(item.getSalaryTicketAcceptPs()) + "'"
            + ",salaryTicketTeacherParttime=" + item.getSalaryTicketTeacherParttime()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, salaryTicketMonth, salaryTicketSanumberId, salaryTicketTeacherId, salaryTicketDepartId, salaryTicketPositionId, salaryTicketClassesId, salaryTicketMoneyType1, salaryTicketMoneyType2, salaryTicketMoneyType3, salaryTicketTotalMoney, salaryTicketPayMoney, salaryTicketPayTimes, salaryTicketPayDate, salaryTicketStatus, salaryFeePrintNeed, salaryTicketPs, salaryTicketNewFeenumber, salaryTicketAcceptStatus, salaryTicketAcceptPs, salaryTicketTeacherParttime";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SalaryTicket item = (SalaryTicket) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getSalaryTicketMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getSalaryTicketSanumberId()
            + "," + item.getSalaryTicketTeacherId()
            + "," + item.getSalaryTicketDepartId()
            + "," + item.getSalaryTicketPositionId()
            + "," + item.getSalaryTicketClassesId()
            + "," + item.getSalaryTicketMoneyType1()
            + "," + item.getSalaryTicketMoneyType2()
            + "," + item.getSalaryTicketMoneyType3()
            + "," + item.getSalaryTicketTotalMoney()
            + "," + item.getSalaryTicketPayMoney()
            + "," + item.getSalaryTicketPayTimes()
            + "," + (((d=item.getSalaryTicketPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getSalaryTicketStatus()
            + "," + item.getSalaryFeePrintNeed()
            + ",'" + ServerTool.escapeString(item.getSalaryTicketPs()) + "'"
            + "," + item.getSalaryTicketNewFeenumber()
            + "," + item.getSalaryTicketAcceptStatus()
            + ",'" + ServerTool.escapeString(item.getSalaryTicketAcceptPs()) + "'"
            + "," + item.getSalaryTicketTeacherParttime()
        ;
        return ret;
    }
}
