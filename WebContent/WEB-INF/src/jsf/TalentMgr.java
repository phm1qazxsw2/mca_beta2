package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TalentMgr extends Manager
{
    private static TalentMgr _instance = null;

    TalentMgr() {}

    public synchronized static TalentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TalentMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "talent";
    }

    protected Object makeBean()
    {
        return new Talent();
    }

    protected int getBeanId(Object obj)
    {
        return ((Talent)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Talent item = (Talent) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	talentName		 = rs.getString("talentName");
            String	talentEnName		 = rs.getString("talentEnName");
            int	talentActive		 = rs.getInt("talentActive");
            int	talentStatus		 = rs.getInt("talentStatus");
            int	talentTeacherId		 = rs.getInt("talentTeacherId");
            String	talentPs		 = rs.getString("talentPs");
            int	talentTimes		 = rs.getInt("talentTimes");
            int	talentActualTimes		 = rs.getInt("talentActualTimes");
            int	talentNeedPeople		 = rs.getInt("talentNeedPeople");
            int	talentActualPeople		 = rs.getInt("talentActualPeople");
            String	talentQuality		 = rs.getString("talentQuality");
            java.util.Date	talentStartDate		 = rs.getTimestamp("talentStartDate");
            java.util.Date	talentEndDate		 = rs.getTimestamp("talentEndDate");
            int	talentFee		 = rs.getInt("talentFee");
            String	talentFeeExplain		 = rs.getString("talentFeeExplain");
            int	talentPlace		 = rs.getInt("talentPlace");
            int	talentFinanceType		 = rs.getInt("talentFinanceType");
            int	talentFinanceBigItem		 = rs.getInt("talentFinanceBigItem");
            int	talentFinanceSmallItem		 = rs.getInt("talentFinanceSmallItem");
            int	talentSalaryTypeId		 = rs.getInt("talentSalaryTypeId");

            item
            .init(id, created, modified
            , talentName, talentEnName, talentActive
            , talentStatus, talentTeacherId, talentPs
            , talentTimes, talentActualTimes, talentNeedPeople
            , talentActualPeople, talentQuality, talentStartDate
            , talentEndDate, talentFee, talentFeeExplain
            , talentPlace, talentFinanceType, talentFinanceBigItem
            , talentFinanceSmallItem, talentSalaryTypeId);
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
        Talent item = (Talent) obj;

        String ret = "modified=NOW()"
            + ",talentName='" + ServerTool.escapeString(item.getTalentName()) + "'"
            + ",talentEnName='" + ServerTool.escapeString(item.getTalentEnName()) + "'"
            + ",talentActive=" + item.getTalentActive()
            + ",talentStatus=" + item.getTalentStatus()
            + ",talentTeacherId=" + item.getTalentTeacherId()
            + ",talentPs='" + ServerTool.escapeString(item.getTalentPs()) + "'"
            + ",talentTimes=" + item.getTalentTimes()
            + ",talentActualTimes=" + item.getTalentActualTimes()
            + ",talentNeedPeople=" + item.getTalentNeedPeople()
            + ",talentActualPeople=" + item.getTalentActualPeople()
            + ",talentQuality='" + ServerTool.escapeString(item.getTalentQuality()) + "'"
            + ",talentStartDate=" + (((d=item.getTalentStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",talentEndDate=" + (((d=item.getTalentEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",talentFee=" + item.getTalentFee()
            + ",talentFeeExplain='" + ServerTool.escapeString(item.getTalentFeeExplain()) + "'"
            + ",talentPlace=" + item.getTalentPlace()
            + ",talentFinanceType=" + item.getTalentFinanceType()
            + ",talentFinanceBigItem=" + item.getTalentFinanceBigItem()
            + ",talentFinanceSmallItem=" + item.getTalentFinanceSmallItem()
            + ",talentSalaryTypeId=" + item.getTalentSalaryTypeId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, talentName, talentEnName, talentActive, talentStatus, talentTeacherId, talentPs, talentTimes, talentActualTimes, talentNeedPeople, talentActualPeople, talentQuality, talentStartDate, talentEndDate, talentFee, talentFeeExplain, talentPlace, talentFinanceType, talentFinanceBigItem, talentFinanceSmallItem, talentSalaryTypeId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Talent item = (Talent) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getTalentName()) + "'"
            + ",'" + ServerTool.escapeString(item.getTalentEnName()) + "'"
            + "," + item.getTalentActive()
            + "," + item.getTalentStatus()
            + "," + item.getTalentTeacherId()
            + ",'" + ServerTool.escapeString(item.getTalentPs()) + "'"
            + "," + item.getTalentTimes()
            + "," + item.getTalentActualTimes()
            + "," + item.getTalentNeedPeople()
            + "," + item.getTalentActualPeople()
            + ",'" + ServerTool.escapeString(item.getTalentQuality()) + "'"
            + "," + (((d=item.getTalentStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getTalentEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getTalentFee()
            + ",'" + ServerTool.escapeString(item.getTalentFeeExplain()) + "'"
            + "," + item.getTalentPlace()
            + "," + item.getTalentFinanceType()
            + "," + item.getTalentFinanceBigItem()
            + "," + item.getTalentFinanceSmallItem()
            + "," + item.getTalentSalaryTypeId()
        ;
        return ret;
    }
}
