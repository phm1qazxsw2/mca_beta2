package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Esystem
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	esystemIncomeVerufy;
    private int   	esystemCostVerufy;
    private int   	esystemIncomePage;
    private int   	esystemCostPage;
    private int   	esystemStupage;
    private int   	esystemTeapage;
    private String   	esystemMySqlfile;
    private String   	esystemMysqlName;
    private String   	esystemMysqlBinary;
    private String   	esystemDBfile;
    private int   	esystemShowCash;
    private int   	esystemDateType;
    private int   	esystemLogMins;
    private String   	esystememailTitle;
    private String   	esystemEmailContent;
    private int   	esystemEmailType;


    public Esystem() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	esystemIncomeVerufy,
        int	esystemCostVerufy,
        int	esystemIncomePage,
        int	esystemCostPage,
        int	esystemStupage,
        int	esystemTeapage,
        String	esystemMySqlfile,
        String	esystemMysqlName,
        String	esystemMysqlBinary,
        String	esystemDBfile,
        int	esystemShowCash,
        int	esystemDateType,
        int	esystemLogMins,
        String	esystememailTitle,
        String	esystemEmailContent,
        int	esystemEmailType    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.esystemIncomeVerufy 	 = esystemIncomeVerufy;
        this.esystemCostVerufy 	 = esystemCostVerufy;
        this.esystemIncomePage 	 = esystemIncomePage;
        this.esystemCostPage 	 = esystemCostPage;
        this.esystemStupage 	 = esystemStupage;
        this.esystemTeapage 	 = esystemTeapage;
        this.esystemMySqlfile 	 = esystemMySqlfile;
        this.esystemMysqlName 	 = esystemMysqlName;
        this.esystemMysqlBinary 	 = esystemMysqlBinary;
        this.esystemDBfile 	 = esystemDBfile;
        this.esystemShowCash 	 = esystemShowCash;
        this.esystemDateType 	 = esystemDateType;
        this.esystemLogMins 	 = esystemLogMins;
        this.esystememailTitle 	 = esystememailTitle;
        this.esystemEmailContent 	 = esystemEmailContent;
        this.esystemEmailType 	 = esystemEmailType;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getEsystemIncomeVerufy   	() { return esystemIncomeVerufy; }
    public int   	getEsystemCostVerufy   	() { return esystemCostVerufy; }
    public int   	getEsystemIncomePage   	() { return esystemIncomePage; }
    public int   	getEsystemCostPage   	() { return esystemCostPage; }
    public int   	getEsystemStupage   	() { return esystemStupage; }
    public int   	getEsystemTeapage   	() { return esystemTeapage; }
    public String   	getEsystemMySqlfile   	() { return esystemMySqlfile; }
    public String   	getEsystemMysqlName   	() { return esystemMysqlName; }
    public String   	getEsystemMysqlBinary   	() { return esystemMysqlBinary; }
    public String   	getEsystemDBfile   	() { return esystemDBfile; }
    public int   	getEsystemShowCash   	() { return esystemShowCash; }
    public int   	getEsystemDateType   	() { return esystemDateType; }
    public int   	getEsystemLogMins   	() { return esystemLogMins; }
    public String   	getEsystememailTitle   	() { return esystememailTitle; }
    public String   	getEsystemEmailContent   	() { return esystemEmailContent; }
    public int   	getEsystemEmailType   	() { return esystemEmailType; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setEsystemIncomeVerufy   	(int esystemIncomeVerufy) { this.esystemIncomeVerufy = esystemIncomeVerufy; }
    public void 	setEsystemCostVerufy   	(int esystemCostVerufy) { this.esystemCostVerufy = esystemCostVerufy; }
    public void 	setEsystemIncomePage   	(int esystemIncomePage) { this.esystemIncomePage = esystemIncomePage; }
    public void 	setEsystemCostPage   	(int esystemCostPage) { this.esystemCostPage = esystemCostPage; }
    public void 	setEsystemStupage   	(int esystemStupage) { this.esystemStupage = esystemStupage; }
    public void 	setEsystemTeapage   	(int esystemTeapage) { this.esystemTeapage = esystemTeapage; }
    public void 	setEsystemMySqlfile   	(String esystemMySqlfile) { this.esystemMySqlfile = esystemMySqlfile; }
    public void 	setEsystemMysqlName   	(String esystemMysqlName) { this.esystemMysqlName = esystemMysqlName; }
    public void 	setEsystemMysqlBinary   	(String esystemMysqlBinary) { this.esystemMysqlBinary = esystemMysqlBinary; }
    public void 	setEsystemDBfile   	(String esystemDBfile) { this.esystemDBfile = esystemDBfile; }
    public void 	setEsystemShowCash   	(int esystemShowCash) { this.esystemShowCash = esystemShowCash; }
    public void 	setEsystemDateType   	(int esystemDateType) { this.esystemDateType = esystemDateType; }
    public void 	setEsystemLogMins   	(int esystemLogMins) { this.esystemLogMins = esystemLogMins; }
    public void 	setEsystememailTitle   	(String esystememailTitle) { this.esystememailTitle = esystememailTitle; }
    public void 	setEsystemEmailContent   	(String esystemEmailContent) { this.esystemEmailContent = esystemEmailContent; }
    public void 	setEsystemEmailType   	(int esystemEmailType) { this.esystemEmailType = esystemEmailType; }
}
