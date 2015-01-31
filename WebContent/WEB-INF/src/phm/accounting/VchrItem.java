package phm.accounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class VchrItem
{

    private int   	vchrId;
    private int   	id;
    private int   	flag;
    private int   	threadId;
    private int   	bunitId;
    private int   	acodeId;
    private double   	debit;
    private double   	credit;
    private int   	note;


    public VchrItem() {}


    public int   	getVchrId   	() { return vchrId; }
    public int   	getId   	() { return id; }
    public int   	getFlag   	() { return flag; }
    public int   	getThreadId   	() { return threadId; }
    public int   	getBunitId   	() { return bunitId; }
    public int   	getAcodeId   	() { return acodeId; }
    public double   	getDebit   	() { return debit; }
    public double   	getCredit   	() { return credit; }
    public int   	getNote   	() { return note; }


    public void 	setVchrId   	(int vchrId) { this.vchrId = vchrId; }
    public void 	setId   	(int id) { this.id = id; }
    public void 	setFlag   	(int flag) { this.flag = flag; }
    public void 	setThreadId   	(int threadId) { this.threadId = threadId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
    public void 	setAcodeId   	(int acodeId) { this.acodeId = acodeId; }
    public void 	setDebit   	(double debit) { this.debit = debit; }
    public void 	setCredit   	(double credit) { this.credit = credit; }
    public void 	setNote   	(int note) { this.note = note; }

    public static final int FLAG_DEBIT = 0;
    public static final int FLAG_CREDIT = 1;

    public String getBunitAcodeThreadSignedKey()
    {
	String sign = "+";
	if ((this.debit!=0 && this.debit<0) || (this.credit!=0 && this.credit<0))
	    sign = "-";
        return this.getBunitId()+"#"+this.getAcodeId()+"#"+this.getThreadId()+sign;
    }

    public String getBunitAcodeKey()
    {
        return this.getBunitId()+"#"+this.getAcodeId();
    }

    public VchrItem clone()
    {
        VchrItem vi = new VchrItem();
	vi.vchrId = this.vchrId;
	vi.flag = this.flag;
	vi.threadId = this.threadId;
	vi.bunitId = this.bunitId;
	vi.acodeId = this.acodeId;
	vi.debit = this.debit;
	vi.credit = this.credit;
	return vi;
    }

}
