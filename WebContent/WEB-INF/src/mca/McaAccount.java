package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaAccount
{

    private String   	Account;
    private String   	Location;
    private String   	Currency;
    private String   	Payment_Type;


    public McaAccount() {}


    public String   	getAccount   	() { return Account; }
    public String   	getLocation   	() { return Location; }
    public String   	getCurrency   	() { return Currency; }
    public String   	getPayment_Type   	() { return Payment_Type; }


    public void 	setAccount   	(String Account) { this.Account = Account; }
    public void 	setLocation   	(String Location) { this.Location = Location; }
    public void 	setCurrency   	(String Currency) { this.Currency = Currency; }
    public void 	setPayment_Type   	(String Payment_Type) { this.Payment_Type = Payment_Type; }

}
