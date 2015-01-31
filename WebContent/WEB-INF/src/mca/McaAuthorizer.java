package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaAuthorizer
{

    private int   	Account_Number;
    private int   	Sub_Account;
    private String   	Account_Name;
    private String   	Description1;
    private String   	Description2;
    private int   	Primary_Authorizer;
    private int   	Secondary_Authorizer;
    private int   	Budget;


    public McaAuthorizer() {}


    public int   	getAccount_Number   	() { return Account_Number; }
    public int   	getSub_Account   	() { return Sub_Account; }
    public String   	getAccount_Name   	() { return Account_Name; }
    public String   	getDescription1   	() { return Description1; }
    public String   	getDescription2   	() { return Description2; }
    public int   	getPrimary_Authorizer   	() { return Primary_Authorizer; }
    public int   	getSecondary_Authorizer   	() { return Secondary_Authorizer; }
    public int   	getBudget   	() { return Budget; }


    public void 	setAccount_Number   	(int Account_Number) { this.Account_Number = Account_Number; }
    public void 	setSub_Account   	(int Sub_Account) { this.Sub_Account = Sub_Account; }
    public void 	setAccount_Name   	(String Account_Name) { this.Account_Name = Account_Name; }
    public void 	setDescription1   	(String Description1) { this.Description1 = Description1; }
    public void 	setDescription2   	(String Description2) { this.Description2 = Description2; }
    public void 	setPrimary_Authorizer   	(int Primary_Authorizer) { this.Primary_Authorizer = Primary_Authorizer; }
    public void 	setSecondary_Authorizer   	(int Secondary_Authorizer) { this.Secondary_Authorizer = Secondary_Authorizer; }
    public void 	setBudget   	(int Budget) { this.Budget = Budget; }

}
