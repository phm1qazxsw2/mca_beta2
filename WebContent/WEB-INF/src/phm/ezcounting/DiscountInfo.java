package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class DiscountInfo extends Discount
{

    private String   	membrName;
    private String   	discountTypeName;
    private String   	userLoginId;


    public DiscountInfo() {}


    public String   	getMembrName   	() { return membrName; }
    public String   	getDiscountTypeName   	() { return discountTypeName; }
    public String   	getUserLoginId   	() { return userLoginId; }


    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }
    public void 	setDiscountTypeName   	(String discountTypeName) { this.discountTypeName = discountTypeName; }
    public void 	setUserLoginId   	(String userLoginId) { this.userLoginId = userLoginId; }

}
