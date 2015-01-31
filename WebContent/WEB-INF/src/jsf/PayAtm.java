package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class PayAtm
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	payAtmNumber;
    private int   	payAtmNumberUnique;
    private Date   	payAtmPayDate;
    private int   	payAtmPayMoney;
    private Date   	payAtmMonth;
    private String   	payAtmAccountFirst5;
    private int   	payAtmFeeticketId;
    private String   	payAtmWay;
    private String   	payAtmBankId;
    private String   	payAtmSource;
    private int   	payAtmStatus;
    private String   	payAtmPs;
    private String   	payAtmException;


    public PayAtm() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	payAtmNumber,
        int	payAtmNumberUnique,
        Date	payAtmPayDate,
        int	payAtmPayMoney,
        Date	payAtmMonth,
        String	payAtmAccountFirst5,
        int	payAtmFeeticketId,
        String	payAtmWay,
        String	payAtmBankId,
        String	payAtmSource,
        int	payAtmStatus,
        String	payAtmPs,
        String	payAtmException    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.payAtmNumber 	 = payAtmNumber;
        this.payAtmNumberUnique 	 = payAtmNumberUnique;
        this.payAtmPayDate 	 = payAtmPayDate;
        this.payAtmPayMoney 	 = payAtmPayMoney;
        this.payAtmMonth 	 = payAtmMonth;
        this.payAtmAccountFirst5 	 = payAtmAccountFirst5;
        this.payAtmFeeticketId 	 = payAtmFeeticketId;
        this.payAtmWay 	 = payAtmWay;
        this.payAtmBankId 	 = payAtmBankId;
        this.payAtmSource 	 = payAtmSource;
        this.payAtmStatus 	 = payAtmStatus;
        this.payAtmPs 	 = payAtmPs;
        this.payAtmException 	 = payAtmException;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getPayAtmNumber   	() { return payAtmNumber; }
    public int   	getPayAtmNumberUnique   	() { return payAtmNumberUnique; }
    public Date   	getPayAtmPayDate   	() { return payAtmPayDate; }
    public int   	getPayAtmPayMoney   	() { return payAtmPayMoney; }
    public Date   	getPayAtmMonth   	() { return payAtmMonth; }
    public String   	getPayAtmAccountFirst5   	() { return payAtmAccountFirst5; }
    public int   	getPayAtmFeeticketId   	() { return payAtmFeeticketId; }
    public String   	getPayAtmWay   	() { return payAtmWay; }
    public String   	getPayAtmBankId   	() { return payAtmBankId; }
    public String   	getPayAtmSource   	() { return payAtmSource; }
    public int   	getPayAtmStatus   	() { return payAtmStatus; }
    public String   	getPayAtmPs   	() { return payAtmPs; }
    public String   	getPayAtmException   	() { return payAtmException; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setPayAtmNumber   	(int payAtmNumber) { this.payAtmNumber = payAtmNumber; }
    public void 	setPayAtmNumberUnique   	(int payAtmNumberUnique) { this.payAtmNumberUnique = payAtmNumberUnique; }
    public void 	setPayAtmPayDate   	(Date payAtmPayDate) { this.payAtmPayDate = payAtmPayDate; }
    public void 	setPayAtmPayMoney   	(int payAtmPayMoney) { this.payAtmPayMoney = payAtmPayMoney; }
    public void 	setPayAtmMonth   	(Date payAtmMonth) { this.payAtmMonth = payAtmMonth; }
    public void 	setPayAtmAccountFirst5   	(String payAtmAccountFirst5) { this.payAtmAccountFirst5 = payAtmAccountFirst5; }
    public void 	setPayAtmFeeticketId   	(int payAtmFeeticketId) { this.payAtmFeeticketId = payAtmFeeticketId; }
    public void 	setPayAtmWay   	(String payAtmWay) { this.payAtmWay = payAtmWay; }
    public void 	setPayAtmBankId   	(String payAtmBankId) { this.payAtmBankId = payAtmBankId; }
    public void 	setPayAtmSource   	(String payAtmSource) { this.payAtmSource = payAtmSource; }
    public void 	setPayAtmStatus   	(int payAtmStatus) { this.payAtmStatus = payAtmStatus; }
    public void 	setPayAtmPs   	(String payAtmPs) { this.payAtmPs = payAtmPs; }
    public void 	setPayAtmException   	(String payAtmException) { this.payAtmException = payAtmException; }
}
