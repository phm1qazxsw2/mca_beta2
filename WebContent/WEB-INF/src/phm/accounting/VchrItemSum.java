package phm.accounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class VchrItemSum
{

    private double   	debit;
    private double   	credit;
    private int   	acodeId;
    private String   	main;
    private String   	sub;
    private int   	name1;
    private int   	name2;


    public VchrItemSum() {}


    public double   	getDebit   	() { return debit; }
    public double   	getCredit   	() { return credit; }
    public int   	getAcodeId   	() { return acodeId; }
    public String   	getMain   	() { return main; }
    public String   	getSub   	() { return sub; }
    public int   	getName1   	() { return name1; }
    public int   	getName2   	() { return name2; }


    public void 	setDebit   	(double debit) { this.debit = debit; }
    public void 	setCredit   	(double credit) { this.credit = credit; }
    public void 	setAcodeId   	(int acodeId) { this.acodeId = acodeId; }
    public void 	setMain   	(String main) { this.main = main; }
    public void 	setSub   	(String sub) { this.sub = sub; }
    public void 	setName1   	(int name1) { this.name1 = name1; }
    public void 	setName2   	(int name2) { this.name2 = name2; }

    public String getFirstDigit()
    {
        return main.substring(0,1);
    }


}
