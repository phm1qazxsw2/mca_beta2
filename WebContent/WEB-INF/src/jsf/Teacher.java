package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Teacher
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	teacherFirstName;
    private String   	teacherLastName;
    private int   	teacherSex;
    private int   	teacherUserId;
    private String   	teacherNickname;
    private String   	teacherEmail;
    private String   	teacherIdNumber;
    private Date   	teacherBirth;
    private String   	teacherSchool;
    private String   	teacherFather;
    private String   	teacherMother;
    private String   	teacherMobile;
    private String   	teacherMobile2;
    private String   	teacherMobile3;
    private String   	teacherPhone;
    private String   	teacherPhone2;
    private String   	teacherPhone3;
    private String   	teacherZipCode;
    private String   	teacherAddress;
    private Date   	teacherComeDate;
    private int   	teacherStatus;
    private int   	teacherLevel;
    private int   	teacherDepart;
    private int   	teacherPosition;
    private int   	teacherClasses;
    private String   	teacherBank1;
    private String   	teacherAccountNumber1;
    private String   	teacherAccountName1;
    private int   	teacherAccountDefaut;
    private String   	teacherBank2;
    private String   	teacherAccountNumber2;
    private String   	teacherAccountName2;
    private String   	teacherPs;
    private int   	teacherActive;
    private int   	teacherAccountPayWay;
    private int   	teacherParttime;
    private int   	teacherHealthType;
    private int   	teacherHealthMoney;
    private int   	teacherHealthPeople;
    private int   	teacherLaborMoney;
    private int   	teacherRetireMoney;
    private int   	teacherRetirePercent;
    private int   	teacherBunitId;
    private String   	teacherBankName1;
    private String   	teacherBankName2;
    private int   	bunitId;


    public Teacher() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	teacherFirstName,
        String	teacherLastName,
        int	teacherSex,
        int	teacherUserId,
        String	teacherNickname,
        String	teacherEmail,
        String	teacherIdNumber,
        Date	teacherBirth,
        String	teacherSchool,
        String	teacherFather,
        String	teacherMother,
        String	teacherMobile,
        String	teacherMobile2,
        String	teacherMobile3,
        String	teacherPhone,
        String	teacherPhone2,
        String	teacherPhone3,
        String	teacherZipCode,
        String	teacherAddress,
        Date	teacherComeDate,
        int	teacherStatus,
        int	teacherLevel,
        int	teacherDepart,
        int	teacherPosition,
        int	teacherClasses,
        String	teacherBank1,
        String	teacherAccountNumber1,
        String	teacherAccountName1,
        int	teacherAccountDefaut,
        String	teacherBank2,
        String	teacherAccountNumber2,
        String	teacherAccountName2,
        String	teacherPs,
        int	teacherActive,
        int	teacherAccountPayWay,
        int	teacherParttime,
        int	teacherHealthType,
        int	teacherHealthMoney,
        int	teacherHealthPeople,
        int	teacherLaborMoney,
        int	teacherRetireMoney,
        int	teacherRetirePercent,
        int	teacherBunitId,
        String	teacherBankName1,
        String	teacherBankName2,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.teacherFirstName 	 = teacherFirstName;
        this.teacherLastName 	 = teacherLastName;
        this.teacherSex 	 = teacherSex;
        this.teacherUserId 	 = teacherUserId;
        this.teacherNickname 	 = teacherNickname;
        this.teacherEmail 	 = teacherEmail;
        this.teacherIdNumber 	 = teacherIdNumber;
        this.teacherBirth 	 = teacherBirth;
        this.teacherSchool 	 = teacherSchool;
        this.teacherFather 	 = teacherFather;
        this.teacherMother 	 = teacherMother;
        this.teacherMobile 	 = teacherMobile;
        this.teacherMobile2 	 = teacherMobile2;
        this.teacherMobile3 	 = teacherMobile3;
        this.teacherPhone 	 = teacherPhone;
        this.teacherPhone2 	 = teacherPhone2;
        this.teacherPhone3 	 = teacherPhone3;
        this.teacherZipCode 	 = teacherZipCode;
        this.teacherAddress 	 = teacherAddress;
        this.teacherComeDate 	 = teacherComeDate;
        this.teacherStatus 	 = teacherStatus;
        this.teacherLevel 	 = teacherLevel;
        this.teacherDepart 	 = teacherDepart;
        this.teacherPosition 	 = teacherPosition;
        this.teacherClasses 	 = teacherClasses;
        this.teacherBank1 	 = teacherBank1;
        this.teacherAccountNumber1 	 = teacherAccountNumber1;
        this.teacherAccountName1 	 = teacherAccountName1;
        this.teacherAccountDefaut 	 = teacherAccountDefaut;
        this.teacherBank2 	 = teacherBank2;
        this.teacherAccountNumber2 	 = teacherAccountNumber2;
        this.teacherAccountName2 	 = teacherAccountName2;
        this.teacherPs 	 = teacherPs;
        this.teacherActive 	 = teacherActive;
        this.teacherAccountPayWay 	 = teacherAccountPayWay;
        this.teacherParttime 	 = teacherParttime;
        this.teacherHealthType 	 = teacherHealthType;
        this.teacherHealthMoney 	 = teacherHealthMoney;
        this.teacherHealthPeople 	 = teacherHealthPeople;
        this.teacherLaborMoney 	 = teacherLaborMoney;
        this.teacherRetireMoney 	 = teacherRetireMoney;
        this.teacherRetirePercent 	 = teacherRetirePercent;
        this.teacherBunitId 	 = teacherBunitId;
        this.teacherBankName1 	 = teacherBankName1;
        this.teacherBankName2 	 = teacherBankName2;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getTeacherFirstName   	() { return teacherFirstName; }
    public String   	getTeacherLastName   	() { return teacherLastName; }
    public int   	getTeacherSex   	() { return teacherSex; }
    public int   	getTeacherUserId   	() { return teacherUserId; }
    public String   	getTeacherNickname   	() { return teacherNickname; }
    public String   	getTeacherEmail   	() { return teacherEmail; }
    public String   	getTeacherIdNumber   	() { return teacherIdNumber; }
    public Date   	getTeacherBirth   	() { return teacherBirth; }
    public String   	getTeacherSchool   	() { return teacherSchool; }
    public String   	getTeacherFather   	() { return teacherFather; }
    public String   	getTeacherMother   	() { return teacherMother; }
    public String   	getTeacherMobile   	() { return teacherMobile; }
    public String   	getTeacherMobile2   	() { return teacherMobile2; }
    public String   	getTeacherMobile3   	() { return teacherMobile3; }
    public String   	getTeacherPhone   	() { return teacherPhone; }
    public String   	getTeacherPhone2   	() { return teacherPhone2; }
    public String   	getTeacherPhone3   	() { return teacherPhone3; }
    public String   	getTeacherZipCode   	() { return teacherZipCode; }
    public String   	getTeacherAddress   	() { return teacherAddress; }
    public Date   	getTeacherComeDate   	() { return teacherComeDate; }
    public int   	getTeacherStatus   	() { return teacherStatus; }
    public int   	getTeacherLevel   	() { return teacherLevel; }
    public int   	getTeacherDepart   	() { return teacherDepart; }
    public int   	getTeacherPosition   	() { return teacherPosition; }
    public int   	getTeacherClasses   	() { return teacherClasses; }
    public String   	getTeacherBank1   	() { return teacherBank1; }
    public String   	getTeacherAccountNumber1   	() { return teacherAccountNumber1; }
    public String   	getTeacherAccountName1   	() { return teacherAccountName1; }
    public int   	getTeacherAccountDefaut   	() { return teacherAccountDefaut; }
    public String   	getTeacherBank2   	() { return teacherBank2; }
    public String   	getTeacherAccountNumber2   	() { return teacherAccountNumber2; }
    public String   	getTeacherAccountName2   	() { return teacherAccountName2; }
    public String   	getTeacherPs   	() { return teacherPs; }
    public int   	getTeacherActive   	() { return teacherActive; }
    public int   	getTeacherAccountPayWay   	() { return teacherAccountPayWay; }
    public int   	getTeacherParttime   	() { return teacherParttime; }
    public int   	getTeacherHealthType   	() { return teacherHealthType; }
    public int   	getTeacherHealthMoney   	() { return teacherHealthMoney; }
    public int   	getTeacherHealthPeople   	() { return teacherHealthPeople; }
    public int   	getTeacherLaborMoney   	() { return teacherLaborMoney; }
    public int   	getTeacherRetireMoney   	() { return teacherRetireMoney; }
    public int   	getTeacherRetirePercent   	() { return teacherRetirePercent; }
    public int   	getTeacherBunitId   	() { return teacherBunitId; }
    public String   	getTeacherBankName1   	() { return teacherBankName1; }
    public String   	getTeacherBankName2   	() { return teacherBankName2; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTeacherFirstName   	(String teacherFirstName) { this.teacherFirstName = teacherFirstName; }
    public void 	setTeacherLastName   	(String teacherLastName) { this.teacherLastName = teacherLastName; }
    public void 	setTeacherSex   	(int teacherSex) { this.teacherSex = teacherSex; }
    public void 	setTeacherUserId   	(int teacherUserId) { this.teacherUserId = teacherUserId; }
    public void 	setTeacherNickname   	(String teacherNickname) { this.teacherNickname = teacherNickname; }
    public void 	setTeacherEmail   	(String teacherEmail) { this.teacherEmail = teacherEmail; }
    public void 	setTeacherIdNumber   	(String teacherIdNumber) { this.teacherIdNumber = teacherIdNumber; }
    public void 	setTeacherBirth   	(Date teacherBirth) { this.teacherBirth = teacherBirth; }
    public void 	setTeacherSchool   	(String teacherSchool) { this.teacherSchool = teacherSchool; }
    public void 	setTeacherFather   	(String teacherFather) { this.teacherFather = teacherFather; }
    public void 	setTeacherMother   	(String teacherMother) { this.teacherMother = teacherMother; }
    public void 	setTeacherMobile   	(String teacherMobile) { this.teacherMobile = teacherMobile; }
    public void 	setTeacherMobile2   	(String teacherMobile2) { this.teacherMobile2 = teacherMobile2; }
    public void 	setTeacherMobile3   	(String teacherMobile3) { this.teacherMobile3 = teacherMobile3; }
    public void 	setTeacherPhone   	(String teacherPhone) { this.teacherPhone = teacherPhone; }
    public void 	setTeacherPhone2   	(String teacherPhone2) { this.teacherPhone2 = teacherPhone2; }
    public void 	setTeacherPhone3   	(String teacherPhone3) { this.teacherPhone3 = teacherPhone3; }
    public void 	setTeacherZipCode   	(String teacherZipCode) { this.teacherZipCode = teacherZipCode; }
    public void 	setTeacherAddress   	(String teacherAddress) { this.teacherAddress = teacherAddress; }
    public void 	setTeacherComeDate   	(Date teacherComeDate) { this.teacherComeDate = teacherComeDate; }
    public void 	setTeacherStatus   	(int teacherStatus) { this.teacherStatus = teacherStatus; }
    public void 	setTeacherLevel   	(int teacherLevel) { this.teacherLevel = teacherLevel; }
    public void 	setTeacherDepart   	(int teacherDepart) { this.teacherDepart = teacherDepart; }
    public void 	setTeacherPosition   	(int teacherPosition) { this.teacherPosition = teacherPosition; }
    public void 	setTeacherClasses   	(int teacherClasses) { this.teacherClasses = teacherClasses; }
    public void 	setTeacherBank1   	(String teacherBank1) { this.teacherBank1 = teacherBank1; }
    public void 	setTeacherAccountNumber1   	(String teacherAccountNumber1) { this.teacherAccountNumber1 = teacherAccountNumber1; }
    public void 	setTeacherAccountName1   	(String teacherAccountName1) { this.teacherAccountName1 = teacherAccountName1; }
    public void 	setTeacherAccountDefaut   	(int teacherAccountDefaut) { this.teacherAccountDefaut = teacherAccountDefaut; }
    public void 	setTeacherBank2   	(String teacherBank2) { this.teacherBank2 = teacherBank2; }
    public void 	setTeacherAccountNumber2   	(String teacherAccountNumber2) { this.teacherAccountNumber2 = teacherAccountNumber2; }
    public void 	setTeacherAccountName2   	(String teacherAccountName2) { this.teacherAccountName2 = teacherAccountName2; }
    public void 	setTeacherPs   	(String teacherPs) { this.teacherPs = teacherPs; }
    public void 	setTeacherActive   	(int teacherActive) { this.teacherActive = teacherActive; }
    public void 	setTeacherAccountPayWay   	(int teacherAccountPayWay) { this.teacherAccountPayWay = teacherAccountPayWay; }
    public void 	setTeacherParttime   	(int teacherParttime) { this.teacherParttime = teacherParttime; }
    public void 	setTeacherHealthType   	(int teacherHealthType) { this.teacherHealthType = teacherHealthType; }
    public void 	setTeacherHealthMoney   	(int teacherHealthMoney) { this.teacherHealthMoney = teacherHealthMoney; }
    public void 	setTeacherHealthPeople   	(int teacherHealthPeople) { this.teacherHealthPeople = teacherHealthPeople; }
    public void 	setTeacherLaborMoney   	(int teacherLaborMoney) { this.teacherLaborMoney = teacherLaborMoney; }
    public void 	setTeacherRetireMoney   	(int teacherRetireMoney) { this.teacherRetireMoney = teacherRetireMoney; }
    public void 	setTeacherRetirePercent   	(int teacherRetirePercent) { this.teacherRetirePercent = teacherRetirePercent; }
    public void 	setTeacherBunitId   	(int teacherBunitId) { this.teacherBunitId = teacherBunitId; }
    public void 	setTeacherBankName1   	(String teacherBankName1) { this.teacherBankName1 = teacherBankName1; }
    public void 	setTeacherBankName2   	(String teacherBankName2) { this.teacherBankName2 = teacherBankName2; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
