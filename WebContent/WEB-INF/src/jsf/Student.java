package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Student
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	studentName;
    private String   	studentShortName;
    private String   	studentNumber;
    private String   	studentNickname;
    private String   	studentIDNumber;
    private int   	studentSex;
    private Date   	studentBirth;
    private String   	studentFather;
    private String   	studentMother;
    private String   	studentFatherMobile;
    private String   	studentFatherMobile2;
    private String   	studentMotherMobile;
    private String   	studentMotherMobile2;
    private int   	studentMobileDefault;
    private String   	studentFatherEmail;
    private String   	studentMotherEmail;
    private int   	studentEmailDefault;
    private String   	studentPhone;
    private String   	studentPhone2;
    private String   	studentPhone3;
    private int   	studentPhoneDefault;
    private String   	studentZipCode;
    private String   	studentAddress;
    private int   	studentStatus;
    private int   	studentDepart;
    private int   	studentClassId;
    private int   	studentGroupId;
    private int   	studentLevel;
    private String   	studentBank1;
    private String   	studentAccountNumber1;
    private String   	studentBank2;
    private String   	studentAccountNumber2;
    private String   	studentPs;
    private String   	studentPicFile;
    private int   	studentBrother;
    private int   	studentBigSister;
    private int   	studentYoungBrother;
    private int   	studentYoungSister;
    private String   	studentFathJob;
    private int   	studebtFatherDegree;
    private String   	studentMothJob;
    private int   	studentMothDegree;
    private int   	studentGohome;
    private int   	studentSchool;
    private String   	studentSpecial;
    private int   	studentPhoneTeacher;
    private Date   	studentPhoneDate;
    private int   	studentVisitTeacher;
    private Date   	studentVisitDate;
    private Date   	studentTryDate;
    private String   	studentFatherSkype;
    private String   	studentMotherSkype;
    private int   	studentSkypeDefault;
    private int   	studentFixNumber;
    private Date   	studentStuffDate;
    private int   	studentStuffUserId;
    private String   	studentStuff1;
    private String   	studentStuff2;
    private String   	studentStuff3;
    private String   	studentStuff4;
    private String   	studentStuff5;
    private String   	studentStuff6;
    private String   	studentStuffPs;
    private String   	studentWeb;
    private String   	studentFatherOffice;
    private String   	studentMotherOffice;
    private int   	bunitId;
    private String   	bloodType;


    public Student() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	studentName,
        String	studentShortName,
        String	studentNumber,
        String	studentNickname,
        String	studentIDNumber,
        int	studentSex,
        Date	studentBirth,
        String	studentFather,
        String	studentMother,
        String	studentFatherMobile,
        String	studentFatherMobile2,
        String	studentMotherMobile,
        String	studentMotherMobile2,
        int	studentMobileDefault,
        String	studentFatherEmail,
        String	studentMotherEmail,
        int	studentEmailDefault,
        String	studentPhone,
        String	studentPhone2,
        String	studentPhone3,
        int	studentPhoneDefault,
        String	studentZipCode,
        String	studentAddress,
        int	studentStatus,
        int	studentDepart,
        int	studentClassId,
        int	studentGroupId,
        int	studentLevel,
        String	studentBank1,
        String	studentAccountNumber1,
        String	studentBank2,
        String	studentAccountNumber2,
        String	studentPs,
        String	studentPicFile,
        int	studentBrother,
        int	studentBigSister,
        int	studentYoungBrother,
        int	studentYoungSister,
        String	studentFathJob,
        int	studebtFatherDegree,
        String	studentMothJob,
        int	studentMothDegree,
        int	studentGohome,
        int	studentSchool,
        String	studentSpecial,
        int	studentPhoneTeacher,
        Date	studentPhoneDate,
        int	studentVisitTeacher,
        Date	studentVisitDate,
        Date	studentTryDate,
        String	studentFatherSkype,
        String	studentMotherSkype,
        int	studentSkypeDefault,
        int	studentFixNumber,
        Date	studentStuffDate,
        int	studentStuffUserId,
        String	studentStuff1,
        String	studentStuff2,
        String	studentStuff3,
        String	studentStuff4,
        String	studentStuff5,
        String	studentStuff6,
        String	studentStuffPs,
        String	studentWeb,
        String	studentFatherOffice,
        String	studentMotherOffice,
        int	bunitId,
        String	bloodType    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.studentName 	 = studentName;
        this.studentShortName 	 = studentShortName;
        this.studentNumber 	 = studentNumber;
        this.studentNickname 	 = studentNickname;
        this.studentIDNumber 	 = studentIDNumber;
        this.studentSex 	 = studentSex;
        this.studentBirth 	 = studentBirth;
        this.studentFather 	 = studentFather;
        this.studentMother 	 = studentMother;
        this.studentFatherMobile 	 = studentFatherMobile;
        this.studentFatherMobile2 	 = studentFatherMobile2;
        this.studentMotherMobile 	 = studentMotherMobile;
        this.studentMotherMobile2 	 = studentMotherMobile2;
        this.studentMobileDefault 	 = studentMobileDefault;
        this.studentFatherEmail 	 = studentFatherEmail;
        this.studentMotherEmail 	 = studentMotherEmail;
        this.studentEmailDefault 	 = studentEmailDefault;
        this.studentPhone 	 = studentPhone;
        this.studentPhone2 	 = studentPhone2;
        this.studentPhone3 	 = studentPhone3;
        this.studentPhoneDefault 	 = studentPhoneDefault;
        this.studentZipCode 	 = studentZipCode;
        this.studentAddress 	 = studentAddress;
        this.studentStatus 	 = studentStatus;
        this.studentDepart 	 = studentDepart;
        this.studentClassId 	 = studentClassId;
        this.studentGroupId 	 = studentGroupId;
        this.studentLevel 	 = studentLevel;
        this.studentBank1 	 = studentBank1;
        this.studentAccountNumber1 	 = studentAccountNumber1;
        this.studentBank2 	 = studentBank2;
        this.studentAccountNumber2 	 = studentAccountNumber2;
        this.studentPs 	 = studentPs;
        this.studentPicFile 	 = studentPicFile;
        this.studentBrother 	 = studentBrother;
        this.studentBigSister 	 = studentBigSister;
        this.studentYoungBrother 	 = studentYoungBrother;
        this.studentYoungSister 	 = studentYoungSister;
        this.studentFathJob 	 = studentFathJob;
        this.studebtFatherDegree 	 = studebtFatherDegree;
        this.studentMothJob 	 = studentMothJob;
        this.studentMothDegree 	 = studentMothDegree;
        this.studentGohome 	 = studentGohome;
        this.studentSchool 	 = studentSchool;
        this.studentSpecial 	 = studentSpecial;
        this.studentPhoneTeacher 	 = studentPhoneTeacher;
        this.studentPhoneDate 	 = studentPhoneDate;
        this.studentVisitTeacher 	 = studentVisitTeacher;
        this.studentVisitDate 	 = studentVisitDate;
        this.studentTryDate 	 = studentTryDate;
        this.studentFatherSkype 	 = studentFatherSkype;
        this.studentMotherSkype 	 = studentMotherSkype;
        this.studentSkypeDefault 	 = studentSkypeDefault;
        this.studentFixNumber 	 = studentFixNumber;
        this.studentStuffDate 	 = studentStuffDate;
        this.studentStuffUserId 	 = studentStuffUserId;
        this.studentStuff1 	 = studentStuff1;
        this.studentStuff2 	 = studentStuff2;
        this.studentStuff3 	 = studentStuff3;
        this.studentStuff4 	 = studentStuff4;
        this.studentStuff5 	 = studentStuff5;
        this.studentStuff6 	 = studentStuff6;
        this.studentStuffPs 	 = studentStuffPs;
        this.studentWeb 	 = studentWeb;
        this.studentFatherOffice 	 = studentFatherOffice;
        this.studentMotherOffice 	 = studentMotherOffice;
        this.bunitId 	 = bunitId;
        this.bloodType 	 = bloodType;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getStudentName   	() { return studentName; }
    public String   	getStudentShortName   	() { return studentShortName; }
    public String   	getStudentNumber   	() { return studentNumber; }
    public String   	getStudentNickname   	() { return studentNickname; }
    public String   	getStudentIDNumber   	() { return studentIDNumber; }
    public int   	getStudentSex   	() { return studentSex; }
    public Date   	getStudentBirth   	() { return studentBirth; }
    public String   	getStudentFather   	() { return studentFather; }
    public String   	getStudentMother   	() { return studentMother; }
    public String   	getStudentFatherMobile   	() { return studentFatherMobile; }
    public String   	getStudentFatherMobile2   	() { return studentFatherMobile2; }
    public String   	getStudentMotherMobile   	() { return studentMotherMobile; }
    public String   	getStudentMotherMobile2   	() { return studentMotherMobile2; }
    public int   	getStudentMobileDefault   	() { return studentMobileDefault; }
    public String   	getStudentFatherEmail   	() { return studentFatherEmail; }
    public String   	getStudentMotherEmail   	() { return studentMotherEmail; }
    public int   	getStudentEmailDefault   	() { return studentEmailDefault; }
    public String   	getStudentPhone   	() { return studentPhone; }
    public String   	getStudentPhone2   	() { return studentPhone2; }
    public String   	getStudentPhone3   	() { return studentPhone3; }
    public int   	getStudentPhoneDefault   	() { return studentPhoneDefault; }
    public String   	getStudentZipCode   	() { return studentZipCode; }
    public String   	getStudentAddress   	() { return studentAddress; }
    public int   	getStudentStatus   	() { return studentStatus; }
    public int   	getStudentDepart   	() { return studentDepart; }
    public int   	getStudentClassId   	() { return studentClassId; }
    public int   	getStudentGroupId   	() { return studentGroupId; }
    public int   	getStudentLevel   	() { return studentLevel; }
    public String   	getStudentBank1   	() { return studentBank1; }
    public String   	getStudentAccountNumber1   	() { return studentAccountNumber1; }
    public String   	getStudentBank2   	() { return studentBank2; }
    public String   	getStudentAccountNumber2   	() { return studentAccountNumber2; }
    public String   	getStudentPs   	() { return studentPs; }
    public String   	getStudentPicFile   	() { return studentPicFile; }
    public int   	getStudentBrother   	() { return studentBrother; }
    public int   	getStudentBigSister   	() { return studentBigSister; }
    public int   	getStudentYoungBrother   	() { return studentYoungBrother; }
    public int   	getStudentYoungSister   	() { return studentYoungSister; }
    public String   	getStudentFathJob   	() { return studentFathJob; }
    public int   	getStudebtFatherDegree   	() { return studebtFatherDegree; }
    public String   	getStudentMothJob   	() { return studentMothJob; }
    public int   	getStudentMothDegree   	() { return studentMothDegree; }
    public int   	getStudentGohome   	() { return studentGohome; }
    public int   	getStudentSchool   	() { return studentSchool; }
    public String   	getStudentSpecial   	() { return studentSpecial; }
    public int   	getStudentPhoneTeacher   	() { return studentPhoneTeacher; }
    public Date   	getStudentPhoneDate   	() { return studentPhoneDate; }
    public int   	getStudentVisitTeacher   	() { return studentVisitTeacher; }
    public Date   	getStudentVisitDate   	() { return studentVisitDate; }
    public Date   	getStudentTryDate   	() { return studentTryDate; }
    public String   	getStudentFatherSkype   	() { return studentFatherSkype; }
    public String   	getStudentMotherSkype   	() { return studentMotherSkype; }
    public int   	getStudentSkypeDefault   	() { return studentSkypeDefault; }
    public int   	getStudentFixNumber   	() { return studentFixNumber; }
    public Date   	getStudentStuffDate   	() { return studentStuffDate; }
    public int   	getStudentStuffUserId   	() { return studentStuffUserId; }
    public String   	getStudentStuff1   	() { return studentStuff1; }
    public String   	getStudentStuff2   	() { return studentStuff2; }
    public String   	getStudentStuff3   	() { return studentStuff3; }
    public String   	getStudentStuff4   	() { return studentStuff4; }
    public String   	getStudentStuff5   	() { return studentStuff5; }
    public String   	getStudentStuff6   	() { return studentStuff6; }
    public String   	getStudentStuffPs   	() { return studentStuffPs; }
    public String   	getStudentWeb   	() { return studentWeb; }
    public String   	getStudentFatherOffice   	() { return studentFatherOffice; }
    public String   	getStudentMotherOffice   	() { return studentMotherOffice; }
    public int   	getBunitId   	() { return bunitId; }
    public String   	getBloodType   	() { return bloodType; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setStudentName   	(String studentName) { this.studentName = studentName; }
    public void 	setStudentShortName   	(String studentShortName) { this.studentShortName = studentShortName; }
    public void 	setStudentNumber   	(String studentNumber) { this.studentNumber = studentNumber; }
    public void 	setStudentNickname   	(String studentNickname) { this.studentNickname = studentNickname; }
    public void 	setStudentIDNumber   	(String studentIDNumber) { this.studentIDNumber = studentIDNumber; }
    public void 	setStudentSex   	(int studentSex) { this.studentSex = studentSex; }
    public void 	setStudentBirth   	(Date studentBirth) { this.studentBirth = studentBirth; }
    public void 	setStudentFather   	(String studentFather) { this.studentFather = studentFather; }
    public void 	setStudentMother   	(String studentMother) { this.studentMother = studentMother; }
    public void 	setStudentFatherMobile   	(String studentFatherMobile) { this.studentFatherMobile = studentFatherMobile; }
    public void 	setStudentFatherMobile2   	(String studentFatherMobile2) { this.studentFatherMobile2 = studentFatherMobile2; }
    public void 	setStudentMotherMobile   	(String studentMotherMobile) { this.studentMotherMobile = studentMotherMobile; }
    public void 	setStudentMotherMobile2   	(String studentMotherMobile2) { this.studentMotherMobile2 = studentMotherMobile2; }
    public void 	setStudentMobileDefault   	(int studentMobileDefault) { this.studentMobileDefault = studentMobileDefault; }
    public void 	setStudentFatherEmail   	(String studentFatherEmail) { this.studentFatherEmail = studentFatherEmail; }
    public void 	setStudentMotherEmail   	(String studentMotherEmail) { this.studentMotherEmail = studentMotherEmail; }
    public void 	setStudentEmailDefault   	(int studentEmailDefault) { this.studentEmailDefault = studentEmailDefault; }
    public void 	setStudentPhone   	(String studentPhone) { this.studentPhone = studentPhone; }
    public void 	setStudentPhone2   	(String studentPhone2) { this.studentPhone2 = studentPhone2; }
    public void 	setStudentPhone3   	(String studentPhone3) { this.studentPhone3 = studentPhone3; }
    public void 	setStudentPhoneDefault   	(int studentPhoneDefault) { this.studentPhoneDefault = studentPhoneDefault; }
    public void 	setStudentZipCode   	(String studentZipCode) { this.studentZipCode = studentZipCode; }
    public void 	setStudentAddress   	(String studentAddress) { this.studentAddress = studentAddress; }
    public void 	setStudentStatus   	(int studentStatus) { this.studentStatus = studentStatus; }
    public void 	setStudentDepart   	(int studentDepart) { this.studentDepart = studentDepart; }
    public void 	setStudentClassId   	(int studentClassId) { this.studentClassId = studentClassId; }
    public void 	setStudentGroupId   	(int studentGroupId) { this.studentGroupId = studentGroupId; }
    public void 	setStudentLevel   	(int studentLevel) { this.studentLevel = studentLevel; }
    public void 	setStudentBank1   	(String studentBank1) { this.studentBank1 = studentBank1; }
    public void 	setStudentAccountNumber1   	(String studentAccountNumber1) { this.studentAccountNumber1 = studentAccountNumber1; }
    public void 	setStudentBank2   	(String studentBank2) { this.studentBank2 = studentBank2; }
    public void 	setStudentAccountNumber2   	(String studentAccountNumber2) { this.studentAccountNumber2 = studentAccountNumber2; }
    public void 	setStudentPs   	(String studentPs) { this.studentPs = studentPs; }
    public void 	setStudentPicFile   	(String studentPicFile) { this.studentPicFile = studentPicFile; }
    public void 	setStudentBrother   	(int studentBrother) { this.studentBrother = studentBrother; }
    public void 	setStudentBigSister   	(int studentBigSister) { this.studentBigSister = studentBigSister; }
    public void 	setStudentYoungBrother   	(int studentYoungBrother) { this.studentYoungBrother = studentYoungBrother; }
    public void 	setStudentYoungSister   	(int studentYoungSister) { this.studentYoungSister = studentYoungSister; }
    public void 	setStudentFathJob   	(String studentFathJob) { this.studentFathJob = studentFathJob; }
    public void 	setStudebtFatherDegree   	(int studebtFatherDegree) { this.studebtFatherDegree = studebtFatherDegree; }
    public void 	setStudentMothJob   	(String studentMothJob) { this.studentMothJob = studentMothJob; }
    public void 	setStudentMothDegree   	(int studentMothDegree) { this.studentMothDegree = studentMothDegree; }
    public void 	setStudentGohome   	(int studentGohome) { this.studentGohome = studentGohome; }
    public void 	setStudentSchool   	(int studentSchool) { this.studentSchool = studentSchool; }
    public void 	setStudentSpecial   	(String studentSpecial) { this.studentSpecial = studentSpecial; }
    public void 	setStudentPhoneTeacher   	(int studentPhoneTeacher) { this.studentPhoneTeacher = studentPhoneTeacher; }
    public void 	setStudentPhoneDate   	(Date studentPhoneDate) { this.studentPhoneDate = studentPhoneDate; }
    public void 	setStudentVisitTeacher   	(int studentVisitTeacher) { this.studentVisitTeacher = studentVisitTeacher; }
    public void 	setStudentVisitDate   	(Date studentVisitDate) { this.studentVisitDate = studentVisitDate; }
    public void 	setStudentTryDate   	(Date studentTryDate) { this.studentTryDate = studentTryDate; }
    public void 	setStudentFatherSkype   	(String studentFatherSkype) { this.studentFatherSkype = studentFatherSkype; }
    public void 	setStudentMotherSkype   	(String studentMotherSkype) { this.studentMotherSkype = studentMotherSkype; }
    public void 	setStudentSkypeDefault   	(int studentSkypeDefault) { this.studentSkypeDefault = studentSkypeDefault; }
    public void 	setStudentFixNumber   	(int studentFixNumber) { this.studentFixNumber = studentFixNumber; }
    public void 	setStudentStuffDate   	(Date studentStuffDate) { this.studentStuffDate = studentStuffDate; }
    public void 	setStudentStuffUserId   	(int studentStuffUserId) { this.studentStuffUserId = studentStuffUserId; }
    public void 	setStudentStuff1   	(String studentStuff1) { this.studentStuff1 = studentStuff1; }
    public void 	setStudentStuff2   	(String studentStuff2) { this.studentStuff2 = studentStuff2; }
    public void 	setStudentStuff3   	(String studentStuff3) { this.studentStuff3 = studentStuff3; }
    public void 	setStudentStuff4   	(String studentStuff4) { this.studentStuff4 = studentStuff4; }
    public void 	setStudentStuff5   	(String studentStuff5) { this.studentStuff5 = studentStuff5; }
    public void 	setStudentStuff6   	(String studentStuff6) { this.studentStuff6 = studentStuff6; }
    public void 	setStudentStuffPs   	(String studentStuffPs) { this.studentStuffPs = studentStuffPs; }
    public void 	setStudentWeb   	(String studentWeb) { this.studentWeb = studentWeb; }
    public void 	setStudentFatherOffice   	(String studentFatherOffice) { this.studentFatherOffice = studentFatherOffice; }
    public void 	setStudentMotherOffice   	(String studentMotherOffice) { this.studentMotherOffice = studentMotherOffice; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
    public void 	setBloodType   	(String bloodType) { this.bloodType = bloodType; }
}
