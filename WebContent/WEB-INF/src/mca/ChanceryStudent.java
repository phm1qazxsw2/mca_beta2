package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class ChanceryStudent
{

    private int   	id;
    private Date   	ExportDate;
    private Date   	ImportDate;
    private int   	StudentID;
    private String   	StudentFirstName;
    private String   	StudentSurname;
    private String   	StudentChineseName;
    private String   	BirthDate;
    private String   	PassportNumber;
    private String   	PassportCountry;
    private String   	Sex;
    private String   	HomePhone;
    private String   	FatherFirstName;
    private String   	FatherSurname;
    private String   	FatherChineseName;
    private String   	FatherPhone;
    private String   	FatherCell;
    private String   	FatherEmail;
    private String   	FatherSendEmail;
    private String   	MotherFirstName;
    private String   	MotherSurname;
    private String   	MotherChineseName;
    private String   	MotherPhone;
    private String   	MotherCell;
    private String   	MotherEmail;
    private String   	MotherSendEmail;
    private String   	CountryID;
    private String   	CountyID;
    private String   	CityID;
    private String   	DistrictID;
    private String   	ChineseStreetAddress;
    private String   	EnglishStreetAddress;
    private String   	PostalCode;


    public ChanceryStudent() {}


    public int   	getId   	() { return id; }
    public Date   	getExportDate   	() { return ExportDate; }
    public Date   	getImportDate   	() { return ImportDate; }
    public int   	getStudentID   	() { return StudentID; }
    public String   	getStudentFirstName   	() { return StudentFirstName; }
    public String   	getStudentSurname   	() { return StudentSurname; }
    public String   	getStudentChineseName   	() { return StudentChineseName; }
    public String   	getBirthDate   	() { return BirthDate; }
    public String   	getPassportNumber   	() { return PassportNumber; }
    public String   	getPassportCountry   	() { return PassportCountry; }
    public String   	getSex   	() { return Sex; }
    public String   	getHomePhone   	() { return HomePhone; }
    public String   	getFatherFirstName   	() { return FatherFirstName; }
    public String   	getFatherSurname   	() { return FatherSurname; }
    public String   	getFatherChineseName   	() { return FatherChineseName; }
    public String   	getFatherPhone   	() { return FatherPhone; }
    public String   	getFatherCell   	() { return FatherCell; }
    public String   	getFatherEmail   	() { return FatherEmail; }
    public String   	getFatherSendEmail   	() { return FatherSendEmail; }
    public String   	getMotherFirstName   	() { return MotherFirstName; }
    public String   	getMotherSurname   	() { return MotherSurname; }
    public String   	getMotherChineseName   	() { return MotherChineseName; }
    public String   	getMotherPhone   	() { return MotherPhone; }
    public String   	getMotherCell   	() { return MotherCell; }
    public String   	getMotherEmail   	() { return MotherEmail; }
    public String   	getMotherSendEmail   	() { return MotherSendEmail; }
    public String   	getCountryID   	() { return CountryID; }
    public String   	getCountyID   	() { return CountyID; }
    public String   	getCityID   	() { return CityID; }
    public String   	getDistrictID   	() { return DistrictID; }
    public String   	getChineseStreetAddress   	() { return ChineseStreetAddress; }
    public String   	getEnglishStreetAddress   	() { return EnglishStreetAddress; }
    public String   	getPostalCode   	() { return PostalCode; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setExportDate   	(Date ExportDate) { this.ExportDate = ExportDate; }
    public void 	setImportDate   	(Date ImportDate) { this.ImportDate = ImportDate; }
    public void 	setStudentID   	(int StudentID) { this.StudentID = StudentID; }
    public void 	setStudentFirstName   	(String StudentFirstName) { this.StudentFirstName = StudentFirstName; }
    public void 	setStudentSurname   	(String StudentSurname) { this.StudentSurname = StudentSurname; }
    public void 	setStudentChineseName   	(String StudentChineseName) { this.StudentChineseName = StudentChineseName; }
    public void 	setBirthDate   	(String BirthDate) { this.BirthDate = BirthDate; }
    public void 	setPassportNumber   	(String PassportNumber) { this.PassportNumber = PassportNumber; }
    public void 	setPassportCountry   	(String PassportCountry) { this.PassportCountry = PassportCountry; }
    public void 	setSex   	(String Sex) { this.Sex = Sex; }
    public void 	setHomePhone   	(String HomePhone) { this.HomePhone = HomePhone; }
    public void 	setFatherFirstName   	(String FatherFirstName) { this.FatherFirstName = FatherFirstName; }
    public void 	setFatherSurname   	(String FatherSurname) { this.FatherSurname = FatherSurname; }
    public void 	setFatherChineseName   	(String FatherChineseName) { this.FatherChineseName = FatherChineseName; }
    public void 	setFatherPhone   	(String FatherPhone) { this.FatherPhone = FatherPhone; }
    public void 	setFatherCell   	(String FatherCell) { this.FatherCell = FatherCell; }
    public void 	setFatherEmail   	(String FatherEmail) { this.FatherEmail = FatherEmail; }
    public void 	setFatherSendEmail   	(String FatherSendEmail) { this.FatherSendEmail = FatherSendEmail; }
    public void 	setMotherFirstName   	(String MotherFirstName) { this.MotherFirstName = MotherFirstName; }
    public void 	setMotherSurname   	(String MotherSurname) { this.MotherSurname = MotherSurname; }
    public void 	setMotherChineseName   	(String MotherChineseName) { this.MotherChineseName = MotherChineseName; }
    public void 	setMotherPhone   	(String MotherPhone) { this.MotherPhone = MotherPhone; }
    public void 	setMotherCell   	(String MotherCell) { this.MotherCell = MotherCell; }
    public void 	setMotherEmail   	(String MotherEmail) { this.MotherEmail = MotherEmail; }
    public void 	setMotherSendEmail   	(String MotherSendEmail) { this.MotherSendEmail = MotherSendEmail; }
    public void 	setCountryID   	(String CountryID) { this.CountryID = CountryID; }
    public void 	setCountyID   	(String CountyID) { this.CountyID = CountyID; }
    public void 	setCityID   	(String CityID) { this.CityID = CityID; }
    public void 	setDistrictID   	(String DistrictID) { this.DistrictID = DistrictID; }
    public void 	setChineseStreetAddress   	(String ChineseStreetAddress) { this.ChineseStreetAddress = ChineseStreetAddress; }
    public void 	setEnglishStreetAddress   	(String EnglishStreetAddress) { this.EnglishStreetAddress = EnglishStreetAddress; }
    public void 	setPostalCode   	(String PostalCode) { this.PostalCode = PostalCode; }

}
