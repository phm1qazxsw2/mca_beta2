package phm.accounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VchrItemInfoMgr extends dbo.Manager<VchrItemInfo>
{
    private static VchrItemInfoMgr _instance = null;

    VchrItemInfoMgr() {}

    public synchronized static VchrItemInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VchrItemInfoMgr();
        }
        return _instance;
    }

    public VchrItemInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vchr_item join vchr_holder join acode join vchr_thread";
    }

    protected Object makeBean()
    {
        return new VchrItemInfo();
    }

    protected String JoinSpace()
    {
         return "vchr_item.vchrId=vchr_holder.id and acodeId=acode.id and vchr_holder.threadId=vchr_thread.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VchrItemInfo item = (VchrItemInfo) obj;
        try {
            int	vchrId		 = rs.getInt("vchrId");
            item.setVchrId(vchrId);
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	flag		 = rs.getInt("flag");
            item.setFlag(flag);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
            int	acodeId		 = rs.getInt("acodeId");
            item.setAcodeId(acodeId);
            double	debit		 = rs.getDouble("debit");
            item.setDebit(debit);
            double	credit		 = rs.getDouble("credit");
            item.setCredit(credit);
            int	note		 = rs.getInt("vchr_item.note");
            item.setNote(note);
            int	threadId		 = rs.getInt("threadId");
            item.setThreadId(threadId);
            java.util.Date	registerDate		 = rs.getTimestamp("registerDate");
            item.setRegisterDate(registerDate);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            String	main		 = rs.getString("main");
            item.setMain(main);
            String	sub		 = rs.getString("sub");
            item.setSub(sub);
            int	name1		 = rs.getInt("name1");
            item.setName1(name1);
            int	name2		 = rs.getInt("name2");
            item.setName2(name2);
            int	vnote		 = rs.getInt("vchr_holder.note");
            item.setVnote(vnote);
            String	serial		 = rs.getString("serial");
            item.setSerial(serial);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
