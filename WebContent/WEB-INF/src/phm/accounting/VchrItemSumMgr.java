package phm.accounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VchrItemSumMgr extends dbo.Manager<VchrItemSum>
{
    private static VchrItemSumMgr _instance = null;

    VchrItemSumMgr() {}

    public synchronized static VchrItemSumMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VchrItemSumMgr();
        }
        return _instance;
    }

    public VchrItemSumMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vchr_item join vchr_holder join acode join vchr_thread";
    }

    protected Object makeBean()
    {
        return new VchrItemSum();
    }

    protected String JoinSpace()
    {
         return "vchr_item.vchrId=vchr_holder.id and acodeId=acode.id and vchr_item.threadId=vchr_thread.id";
    }

    protected String getFieldList()
    {
         return "sum(debit) as debit,sum(credit) as credit,concat(acode.main,acode.sub) as fullkey,acodeId,main,sub,name1,name2";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VchrItemSum item = (VchrItemSum) obj;
        try {
            double	debit		 = rs.getDouble("debit");
            item.setDebit(debit);
            double	credit		 = rs.getDouble("credit");
            item.setCredit(credit);
            int	acodeId		 = rs.getInt("acodeId");
            item.setAcodeId(acodeId);
            String	main		 = rs.getString("main");
            item.setMain(main);
            String	sub		 = rs.getString("sub");
            item.setSub(sub);
            int	name1		 = rs.getInt("name1");
            item.setName1(name1);
            int	name2		 = rs.getInt("name2");
            item.setName2(name2);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
