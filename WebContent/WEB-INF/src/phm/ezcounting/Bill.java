package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Bill
{

    private int   	id;
    private String   	name;
    private String   	prettyName;
    private int   	status;
    private int   	balanceWay;
    private int   	billType;
    private int   	privLevel;
    private int   	bunitId;
    private String   	comName;
    private String   	comAddr;
    private String   	payNote;
    private String   	regInfo;


    public Bill() {}


    public int   	getId   	() { return id; }
    public String   	getName   	() { return name; }
    public String   	getPrettyName   	() { return prettyName; }
    public int   	getStatus   	() { return status; }
    public int   	getBalanceWay   	() { return balanceWay; }
    public int   	getBillType   	() { return billType; }
    public int   	getPrivLevel   	() { return privLevel; }
    public int   	getBunitId   	() { return bunitId; }
    public String   	getComName   	() { return comName; }
    public String   	getComAddr   	() { return comAddr; }
    public String   	getPayNote   	() { return payNote; }
    public String   	getRegInfo   	() { return regInfo; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setPrettyName   	(String prettyName) { this.prettyName = prettyName; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setBalanceWay   	(int balanceWay) { this.balanceWay = balanceWay; }
    public void 	setBillType   	(int billType) { this.billType = billType; }
    public void 	setPrivLevel   	(int privLevel) { this.privLevel = privLevel; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
    public void 	setComName   	(String comName) { this.comName = comName; }
    public void 	setComAddr   	(String comAddr) { this.comAddr = comAddr; }
    public void 	setPayNote   	(String payNote) { this.payNote = payNote; }
    public void 	setRegInfo   	(String regInfo) { this.regInfo = regInfo; }
    // static
    public final static int STATUS_ACTIVE = 1;
    public final static int STATUS_NOTUSE = 0;

    // balanceWay
    public final static int MANUAL = 0; // 獨立銷單
    public final static int FIFO = 1;  // 先進先銷

    // type
    public final static int TYPE_BILLING = 0; // 帳單
    public final static int TYPE_SALARY = 1;  // 薪資

    // priLevel
    public final static int PRIV_ADMIN = 1;	// 1: 管理者 only
    public final static int PRIV_OFFICER = 2;	// 2: 經營者以上
    public final static int PRIV_FINANCE = 3;	// 3: 會計以上
    public final static int PRIV_MANAGER = 4;	// 4: 行政以上
    public final static int PRIV_STAFF = 5;	// 5: 老師以上

}
