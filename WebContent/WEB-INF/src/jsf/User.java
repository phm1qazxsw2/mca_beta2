package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class User
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	userLoginId;
    private String   	userPassword;
    private String   	userFullname;
    private String   	userEmail;
    private String   	userPhone;
    private int   	userRole;
    private int   	userEmailReport;
    private int   	userActive;
    private int   	userBunitCard;
    private int   	userBunitAccounting;
    private int   	userContentType1;
    private int   	userContentType2;
    private int   	userContentType3;
    private int   	userContentType4;
    private int   	userContentType5;
    private int   	userContentType6;
    private int   	userContentType7;
    private int   	userContentType8;
    private int   	userContentType9;
    private int   	userContentType10;
    private int   	userContentType11;
    private int   	userConfirmUpdate;


    public User() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	userLoginId,
        String	userPassword,
        String	userFullname,
        String	userEmail,
        String	userPhone,
        int	userRole,
        int	userEmailReport,
        int	userActive,
        int	userBunitCard,
        int	userBunitAccounting,
        int	userContentType1,
        int	userContentType2,
        int	userContentType3,
        int	userContentType4,
        int	userContentType5,
        int	userContentType6,
        int	userContentType7,
        int	userContentType8,
        int	userContentType9,
        int	userContentType10,
        int	userContentType11,
        int	userConfirmUpdate    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.userLoginId 	 = userLoginId;
        this.userPassword 	 = userPassword;
        this.userFullname 	 = userFullname;
        this.userEmail 	 = userEmail;
        this.userPhone 	 = userPhone;
        this.userRole 	 = userRole;
        this.userEmailReport 	 = userEmailReport;
        this.userActive 	 = userActive;
        this.userBunitCard 	 = userBunitCard;
        this.userBunitAccounting 	 = userBunitAccounting;
        this.userContentType1 	 = userContentType1;
        this.userContentType2 	 = userContentType2;
        this.userContentType3 	 = userContentType3;
        this.userContentType4 	 = userContentType4;
        this.userContentType5 	 = userContentType5;
        this.userContentType6 	 = userContentType6;
        this.userContentType7 	 = userContentType7;
        this.userContentType8 	 = userContentType8;
        this.userContentType9 	 = userContentType9;
        this.userContentType10 	 = userContentType10;
        this.userContentType11 	 = userContentType11;
        this.userConfirmUpdate 	 = userConfirmUpdate;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getUserLoginId   	() { return userLoginId; }
    public String   	getUserPassword   	() { return userPassword; }
    public String   	getUserFullname   	() { return userFullname; }
    public String   	getUserEmail   	() { return userEmail; }
    public String   	getUserPhone   	() { return userPhone; }
    public int   	getUserRole   	() { return userRole; }
    public int   	getUserEmailReport   	() { return userEmailReport; }
    public int   	getUserActive   	() { return userActive; }
    public int   	getUserBunitCard   	() { return userBunitCard; }
    public int   	getUserBunitAccounting   	() { return userBunitAccounting; }
    public int   	getUserContentType1   	() { return userContentType1; }
    public int   	getUserContentType2   	() { return userContentType2; }
    public int   	getUserContentType3   	() { return userContentType3; }
    public int   	getUserContentType4   	() { return userContentType4; }
    public int   	getUserContentType5   	() { return userContentType5; }
    public int   	getUserContentType6   	() { return userContentType6; }
    public int   	getUserContentType7   	() { return userContentType7; }
    public int   	getUserContentType8   	() { return userContentType8; }
    public int   	getUserContentType9   	() { return userContentType9; }
    public int   	getUserContentType10   	() { return userContentType10; }
    public int   	getUserContentType11   	() { return userContentType11; }
    public int   	getUserConfirmUpdate   	() { return userConfirmUpdate; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setUserLoginId   	(String userLoginId) { this.userLoginId = userLoginId; }
    public void 	setUserPassword   	(String userPassword) { this.userPassword = userPassword; }
    public void 	setUserFullname   	(String userFullname) { this.userFullname = userFullname; }
    public void 	setUserEmail   	(String userEmail) { this.userEmail = userEmail; }
    public void 	setUserPhone   	(String userPhone) { this.userPhone = userPhone; }
    public void 	setUserRole   	(int userRole) { this.userRole = userRole; }
    public void 	setUserEmailReport   	(int userEmailReport) { this.userEmailReport = userEmailReport; }
    public void 	setUserActive   	(int userActive) { this.userActive = userActive; }
    public void 	setUserBunitCard   	(int userBunitCard) { this.userBunitCard = userBunitCard; }
    public void 	setUserBunitAccounting   	(int userBunitAccounting) { this.userBunitAccounting = userBunitAccounting; }
    public void 	setUserContentType1   	(int userContentType1) { this.userContentType1 = userContentType1; }
    public void 	setUserContentType2   	(int userContentType2) { this.userContentType2 = userContentType2; }
    public void 	setUserContentType3   	(int userContentType3) { this.userContentType3 = userContentType3; }
    public void 	setUserContentType4   	(int userContentType4) { this.userContentType4 = userContentType4; }
    public void 	setUserContentType5   	(int userContentType5) { this.userContentType5 = userContentType5; }
    public void 	setUserContentType6   	(int userContentType6) { this.userContentType6 = userContentType6; }
    public void 	setUserContentType7   	(int userContentType7) { this.userContentType7 = userContentType7; }
    public void 	setUserContentType8   	(int userContentType8) { this.userContentType8 = userContentType8; }
    public void 	setUserContentType9   	(int userContentType9) { this.userContentType9 = userContentType9; }
    public void 	setUserContentType10   	(int userContentType10) { this.userContentType10 = userContentType10; }
    public void 	setUserContentType11   	(int userContentType11) { this.userContentType11 = userContentType11; }
    public void 	setUserConfirmUpdate   	(int userConfirmUpdate) { this.userConfirmUpdate = userConfirmUpdate; }
}
