package phm.importing;

import jsf.*;
import java.io.*;
import phm.ezcounting.*;
import java.text.*;
import java.util.*;
import dbo.*;
import java.lang.reflect.*;

public class ImportStudent
{
    static int getInt(String str, int defValue)
    {
        try {
            return Integer.parseInt(str);
        }
        catch (Exception e) {}
        return defValue;
    }

    static int getDegree(String degree)
        throws Exception
    {
        return getDegree(degree, 0);
    }

    static int getDegree(String degree, int bunitId)
        throws Exception
    {
        if (degree==null)
            return 0;
        degree = degree.trim();
        if (degree.length()==0)
            return 0;
        BunitHelper bh = new BunitHelper();
        String space = bh.getStudentSpace("bunitId", bunitId);

        DegreeMgr dmgr = DegreeMgr.getInstance();
        if (dmgr.numOfRowsX("degreeName='" + degree + "'", space)>0) {
            Object[] objs = dmgr.retrieveX("degreeName='" + degree + "'", "", space);
            if (objs.length>1)
                throw new Exception("## degreeName ["+degree+"] not unique");
            return ((Degree)objs[0]).getId();
        }

        Degree dg = new Degree();
        dg.setDegreeName(degree);
        dg.setDegreeActive(1);
        dg.setBunitId(bh.getStudentBunitId(bunitId));
        return dmgr.createWithIdReturned(dg);
    }

    static int getDefaultContact(String def)
    {
        if (def.equals("母"))
            return 2;
        return 1;
    }

    public static int getGendar(String gen)
    {
        if (gen.equals("男"))
            return 1;
        return 0;
    }
    
    static SimpleDateFormat tw_sdf = new SimpleDateFormat("yyyy/MM/dd");
    public static Date getTaiwanDate(String dateStr, Date d)
    {
        try {
            Date twd = tw_sdf.parse(dateStr);
            int year = twd.getYear();
            twd.setYear(year + 1911);
            return twd;
        }
        catch (Exception e) {}
        return d;
    }

    static int getNum(String n)
    {
        int r = 0;
        try { r = Integer.parseInt(n); } catch (Exception e) {}
        return r;
    }

    public static String getEmergencyContact(String t1, String t2, String t3, String t4, 
        String t5, String t6, String t7, String t8)
    {
        String ret = "";
        if (t1.trim().length()>0) {
            ret = "緊急聯絡人:\n";
            ret += t2 + " " + t1 + " " + t3 + "  " + t4 + "\n";
        }
        if (t5.trim().length()>0) {
            if (ret.length()==0)
                ret += "緊急聯絡人:\n";
            ret += t5 + " " + t6 + " " + t7 + "  " + t8 + "\n";
        }
        return ret;
    }

    public static void parseStarLight(String[] tokens, Student2 student)
        throws Exception
    {
        String studentName = tokens[1];             // 姓名
        String studentNickname = tokens[2];         // English Name
        int studentSex = getGendar(tokens[3]); // getInt(tokens[3], 0);      // 性別
        Date studentBirth = getTaiwanDate(tokens[4], null);  // 生日
        String studentIDNumber = tokens[5];         // 身份證字號
        String studentBloodType = tokens[6];        // 血型
        String studentZipCode = tokens[7];          // 郵遞區號
        String studentAddress = tokens[8];          // 住址
        String studentPhone = tokens[9];            // 電話1
        String studentPhone2 = tokens[10];           // 電話2
        String studentPhone3 = tokens[11];          // 電話3        
        String studentFather = tokens[13];          // 父親姓名
        int studentFatherDegree = getDegree(tokens[14]); // 教育程度
                // tokens[15]                       // 父親生日
        String studentFathJob = tokens[16];         // 父親職業
        String studentFatherMobile = tokens[17];    // 父親手機
        String studentFatherMobile2 = tokens[18];   // 父親手機2
        String studentMother = tokens[20];          // 母親姓名
        int studentMothDegree = getDegree(tokens[21]); // 教育程度
                // tokens[22]                       // 母親生日
        String studentMothJob = tokens[23];         // 母親職業
        String studentMotherMobile = tokens[24];    // 母親手機
        String studentMotherMobile2 = tokens[25];   // 母親手機2
        String studentFatherEmail = tokens[26];     // 父親 email
        String studentMotherEmail = tokens[27];     // 母親 email
        int studentEmailDefault = getDefaultContact(tokens[28]); // 手機簡訊預設人

        int i = 29;
        String note = "";
        try {
            while (i<tokens.length) {
                String relation = tokens[i];
                String name = tokens[i+1];
                String bday = tokens[i+2];
                note += relation + " " + name + " " + bday + "\n";
                i += 3;
            }
        }
        catch (Exception e) {}
        String studentPs = note;
              
        // setting stuff
        student.setStudentName(studentName);
        student.setStudentNickname(studentNickname);
        student.setStudentSex(studentSex);
        student.setStudentBirth(studentBirth);
        student.setStudentIDNumber(studentIDNumber);
        student.setBloodType(studentBloodType);
        student.setStudentZipCode(studentZipCode);
        student.setStudentAddress(studentAddress);
        student.setStudentPhone(studentPhone);
        student.setStudentPhone2(studentPhone2);
        student.setStudentPhone3(studentPhone3);
        student.setStudentFather(studentFather);
        student.setStudebtFatherDegree(studentFatherDegree);
        student.setStudentFathJob(studentFathJob);
        student.setStudentFatherMobile(studentFatherMobile);
        student.setStudentFatherMobile2(studentFatherMobile2);
        student.setStudentMother(studentMother);
        student.setStudentMothDegree(studentMothDegree);
        student.setStudentMothJob(studentMothJob);
        student.setStudentMotherMobile(studentMotherMobile);
        student.setStudentMotherMobile2(studentMotherMobile2);
        student.setStudentFatherEmail(studentFatherEmail);
        student.setStudentMotherEmail(studentMotherEmail);
        student.setStudentEmailDefault(studentEmailDefault);
        student.setStudentPs(studentPs);
    }


    public static void parseDaoHe(String[] tokens, Student2 student)
        throws Exception
    {
        String studentName = tokens[3];             // 姓名
        String studentNickname = tokens[2];         // 學號
        int studentSex = getGendar(tokens[4]); // getInt(tokens[3], 0);      // 性別
        Date studentBirth = getTaiwanDate(tokens[5], null);  // 生日
        String studentPhone = tokens[6];            // 電話1
        String studentAddress = tokens[7];          // 住址
              
        // setting stuff
        student.setStudentName(studentName);
        student.setStudentNickname(studentNickname);
        student.setStudentSex(studentSex);
        student.setStudentBirth(studentBirth);
        student.setStudentAddress(studentAddress);
        student.setStudentPhone(studentPhone);
    }


    public static void parseHoho(String[] tokens, Student2 student)
        throws Exception
    {
        String studentName = tokens[1];             // 姓名
        String studentNickname = tokens[2];         // English Name
        int studentSex = getGendar(tokens[3]); // getInt(tokens[3], 0);      // 性別
        Date studentBirth = getTaiwanDate(tokens[4], null);  // 生日
        String studentIDNumber = tokens[5];         // 身份證字號
        String studentBloodType = tokens[6];        // 血型
        String studentZipCode = tokens[7];          // 郵遞區號
        String studentAddress = tokens[8];          // 住址
        String studentPhone = tokens[9];            // 電話1
        String studentPhone2 = tokens[10];           // 電話2
        String studentPhone3 = tokens[11];          // 電話3        
        String studentFather = tokens[13];          // 父親姓名
        int studentFatherDegree = getDegree(tokens[14]); // 教育程度
                // tokens[15]                       // 父親生日
        String studentFathJob = tokens[16];         // 父親職業
        String studentFatherMobile = tokens[17];    // 父親手機
        String studentFatherMobile2 = tokens[18];   // 父親手機2
        String studentMother = tokens[20];          // 母親姓名
        int studentMothDegree = getDegree(tokens[21]); // 教育程度
                // tokens[22]                       // 母親生日
        String studentMothJob = tokens[23];         // 母親職業
        String studentMotherMobile = tokens[24];    // 母親手機
        String studentMotherMobile2 = tokens[25];   // 母親手機2
        String studentFatherEmail = tokens[26];     // 父親 email
        String studentMotherEmail = tokens[27];     // 母親 email
        int studentEmailDefault = getDefaultContact(tokens[28]); // 手機簡訊預設人
        int studentBrother = getNum(tokens[53]);    // 兄人數
        int studentBigSister = getNum(tokens[54]);  // 姐人數
        int studentYoungBrother = getNum(tokens[55]);// 弟人數
        int studentYoungSister =  getNum(tokens[56]);// 妹人數
        Date studentTryDate = null;
        if (tokens[49].trim().length()>0)
            studentTryDate = tw_sdf.parse(tokens[49].trim());        

        StringBuffer ps = new StringBuffer();
        ps.append(getEmergencyContact(tokens[59],tokens[60],tokens[61],
            tokens[62],tokens[63],tokens[64],tokens[65],tokens[66]));
        if (tokens[57].trim().length()>0)
            ps.append("父:" + tokens[57] + "歲;");
        if (tokens[58].trim().length()>0)
            ps.append("母:" + tokens[57] + "歲;");        
        if (tokens[51].trim().length()>0) {
            if (ps.length()>0) ps.append("\n");
            ps.append("曾就讀學校:" + tokens[51]);
            if (tokens[52].trim().length()>0)
                ps.append(" " + tokens[52] + "學期");
        }
        if (tokens[48].trim().length()>0) {
            if (ps.length()>0) ps.append("\n");
            ps.append("藉貫:");
            ps.append(" " + tokens[48]);
        }
        if (tokens[50].trim().length()>0) {
            if (ps.length()>0) ps.append("\n");
            ps.append("區:");
            ps.append(" " + tokens[50]);
        }
        String studentPs = ps.toString();
             
        // setting stuff
        student.setStudentName(studentName);
        student.setStudentNickname(studentNickname);
        student.setStudentSex(studentSex);
        student.setStudentBirth(studentBirth);
        student.setStudentIDNumber(studentIDNumber);
        student.setBloodType(studentBloodType);
        student.setStudentZipCode(studentZipCode);
        student.setStudentAddress(studentAddress);
        student.setStudentPhone(studentPhone);
        student.setStudentPhone2(studentPhone2);
        student.setStudentPhone3(studentPhone3);
        student.setStudentFather(studentFather);
        student.setStudebtFatherDegree(studentFatherDegree);
        student.setStudentFathJob(studentFathJob);
        student.setStudentFatherMobile(studentFatherMobile);
        student.setStudentFatherMobile2(studentFatherMobile2);
        student.setStudentMother(studentMother);
        student.setStudentMothDegree(studentMothDegree);
        student.setStudentMothJob(studentMothJob);
        student.setStudentMotherMobile(studentMotherMobile);
        student.setStudentMotherMobile2(studentMotherMobile2);
        student.setStudentFatherEmail(studentFatherEmail);
        student.setStudentMotherEmail(studentMotherEmail);
        student.setStudentEmailDefault(studentEmailDefault);

        student.setStudentBrother(studentBrother);
        student.setStudentBigSister(studentBigSister);
        student.setStudentYoungBrother(studentYoungBrother);
        student.setStudentYoungSister(studentYoungSister);
        if (studentTryDate!=null)
            student.setStudentTryDate(studentTryDate);
        
        student.setStudentPs(studentPs);
    }


    public static void parseJianShengTainan(String[] tokens, Student2 student)
        throws Exception
    {
        String studentName = tokens[1];             // 姓名
        String studentNickname = tokens[2];         // English Name
        int studentSex = getGendar(tokens[3]); // getInt(tokens[3], 0);      // 性別
        Date studentBirth = getTaiwanDate(tokens[4], null);  // 生日
        String studentIDNumber = tokens[5];         // 身份證字號
        String studentBloodType = tokens[6];        // 血型
        String studentZipCode = tokens[7];          // 郵遞區號
        String studentAddress = tokens[8];          // 住址
        String studentPhone = tokens[9];            // 電話1
        String studentPhone2 = tokens[10];           // 電話2
        String studentPhone3 = tokens[11];          // 電話3        
        String studentFather = tokens[13];          // 父親姓名
        int studentFatherDegree = getDegree(tokens[14]); // 教育程度
                // tokens[15]                       // 父親生日
        String studentFathJob = tokens[16];         // 父親職業
        String studentFatherMobile = tokens[17];    // 父親手機
        String studentFatherMobile2 = tokens[18];   // 父親手機2
        String studentMother = tokens[20];          // 母親姓名
        int studentMothDegree = getDegree(tokens[21]); // 教育程度
                // tokens[22]                       // 母親生日
        String studentMothJob = tokens[23];         // 母親職業
        String studentMotherMobile = tokens[24];    // 母親手機
        String studentMotherMobile2 = tokens[25];   // 母親手機2
        String studentFatherEmail = tokens[26];     // 父親 email
        String studentMotherEmail = tokens[27];     // 母親 email

        StringBuffer ps = new StringBuffer();
        ps.append("緊急聯絡人:");
        ps.append(tokens[42]);
        ps.append(' ');
        ps.append(tokens[43]);
        ps.append(' ');
        ps.append(tokens[47]);
        if (tokens[45].trim().length()>0)
            ps.append("(" + tokens[45].trim() + ")");
        if (tokens[48].trim().length()>0)
            ps.append("\n" + tokens[48].trim());
        if (tokens[50].trim().length()>0)
            ps.append("\n" + tokens[50].trim());
        if (tokens[52].trim().length()>0)
            ps.append("\n入學動機：" + tokens[52].trim());
        if (tokens[53].trim().length()>0)
            ps.append("\n其他：" + tokens[53].trim());
        if (tokens[54].trim().length()>0)
            ps.append("\n填表日期：" + tokens[54].trim());
        if (tokens[55].trim().length()>0)
            ps.append("\n填表人：" + tokens[55].trim());

        String studentPs = ps.toString();
             
        // setting stuff
        student.setStudentName(studentName);
        student.setStudentNickname(studentNickname);
        student.setStudentSex(studentSex);
        student.setStudentBirth(studentBirth);
        student.setStudentIDNumber(studentIDNumber);
        student.setBloodType(studentBloodType);
        student.setStudentZipCode(studentZipCode);
        student.setStudentAddress(studentAddress);
        student.setStudentPhone(studentPhone);
        student.setStudentPhone2(studentPhone2);
        student.setStudentPhone3(studentPhone3);
        student.setStudentFather(studentFather);
        student.setStudebtFatherDegree(studentFatherDegree);
        student.setStudentFathJob(studentFathJob);
        student.setStudentFatherMobile(studentFatherMobile);
        student.setStudentFatherMobile2(studentFatherMobile2);
        student.setStudentMother(studentMother);
        student.setStudentMothDegree(studentMothDegree);
        student.setStudentMothJob(studentMothJob);
        student.setStudentMotherMobile(studentMotherMobile);
        student.setStudentMotherMobile2(studentMotherMobile2);
        student.setStudentFatherEmail(studentFatherEmail);
        student.setStudentMotherEmail(studentMotherEmail);
        //student.setStudentEmailDefault(studentEmailDefault);

        //student.setStudentBrother(studentBrother);
        //student.setStudentBigSister(studentBigSister);
        //student.setStudentYoungBrother(studentYoungBrother);
        //student.setStudentYoungSister(studentYoungSister);
        //if (studentTryDate!=null)
        //    student.setStudentTryDate(studentTryDate);
        
        student.setStudentPs(studentPs);
    }


    public static void parseJianShengDaycare(String[] tokens, Student2 student)
        throws Exception
    {
        String studentName = tokens[1];             // 姓名
        String studentNickname = tokens[2];         // English Name
        int studentSex = getGendar(tokens[3]); // getInt(tokens[3], 0);      // 性別
        Date studentBirth = null; // 生日
        try {
            studentBirth = tw_sdf.parse(tokens[4]);
            int year = studentBirth.getYear();
            studentBirth.setYear(year + 11);
        }
        catch (Exception e) {}
        String studentIDNumber = tokens[5];         // 身份證字號
        String studentBloodType = tokens[6];        // 血型
        String studentZipCode = tokens[7];          // 郵遞區號
        String studentAddress = tokens[8];          // 住址
        String studentPhone = tokens[9];            // 電話1
        String studentPhone2 = tokens[10];           // 電話2
        String studentPhone3 = tokens[11];          // 電話3        
        String studentFather = tokens[13];          // 父親姓名
        int studentFatherDegree = getDegree(tokens[14]); // 教育程度
                // tokens[15]                       // 父親生日
        String studentFathJob = tokens[16];         // 父親職業
        String studentFatherMobile = tokens[17];    // 父親手機
        String studentFatherMobile2 = tokens[18];   // 父親手機2
        String studentMother = tokens[20];          // 母親姓名
        int studentMothDegree = getDegree(tokens[21]); // 教育程度
                // tokens[22]                       // 母親生日
        String studentMothJob = tokens[23];         // 母親職業
        String studentMotherMobile = tokens[24];    // 母親手機

        StringBuffer ps = new StringBuffer();
        if (tokens[25].trim().length()>0)
            ps.append("\n班級：" + tokens[25].trim());
        if (tokens[26].trim().length()>0)
            ps.append("\n其他聯絡人：" + tokens[26].trim());

        String studentPs = ps.toString();
             
        // setting stuff
        student.setStudentName(studentName);
        student.setStudentNickname(studentNickname);
        student.setStudentSex(studentSex);
        student.setStudentBirth(studentBirth);
        student.setStudentIDNumber(studentIDNumber);
        student.setBloodType(studentBloodType);
        student.setStudentZipCode(studentZipCode);
        student.setStudentAddress(studentAddress);
        student.setStudentPhone(studentPhone);
        student.setStudentPhone2(studentPhone2);
        student.setStudentPhone3(studentPhone3);
        student.setStudentFather(studentFather);
        student.setStudebtFatherDegree(studentFatherDegree);
        student.setStudentFathJob(studentFathJob);
        student.setStudentFatherMobile(studentFatherMobile);
        student.setStudentFatherMobile2(studentFatherMobile2);
        student.setStudentMother(studentMother);
        student.setStudentMothDegree(studentMothDegree);
        student.setStudentMothJob(studentMothJob);
        student.setStudentMotherMobile(studentMotherMobile);
        //student.setStudentMotherMobile2(studentMotherMobile2);
        //student.setStudentFatherEmail(studentFatherEmail);
        //student.setStudentMotherEmail(studentMotherEmail);
        //student.setStudentEmailDefault(studentEmailDefault);

        //student.setStudentBrother(studentBrother);
        //student.setStudentBigSister(studentBigSister);
        //student.setStudentYoungBrother(studentYoungBrother);
        //student.setStudentYoungSister(studentYoungSister);
        //if (studentTryDate!=null)
        //    student.setStudentTryDate(studentTryDate);
        
        student.setStudentPs(studentPs);
    }



    public static void parseLeader(String[] tokens, Student2 student, int bunitId)
        throws Exception
    {
        String studentName = tokens[0];             // 姓名
        String studentShortName = tokens[2];         // 昵名 Name
        String studentNumber = tokens[1];
        String studentNickname = tokens[3];         // English Name
        String studentIDNumber = tokens[4];         // 身份證字號

        int studentSex = getGendar(tokens[5]); // getInt(tokens[3], 0);      // 性別
        Date studentBirth = null; // 生日
        try {
            studentBirth = tw_sdf.parse(tokens[6]);
            int year = studentBirth.getYear();
            studentBirth.setYear(year + 1911);
        }
        catch (Exception e) {}

        String studentFather = tokens[7];          // 父親姓名
        int studentFatherDegree = getDegree(tokens[8], bunitId); // 教育程度
        String studentFathJob = tokens[9];         // 父親職業
        String studentFatherMobile = tokens[12];    // 父親手機
        String studentPhone = tokens[10];            // 父電1家
        String studentPhone2 = tokens[11];            // 父電2辦
        String studentFatherEmail = tokens[13];    // 父親Email
        String studentMother = tokens[14];          // 母親姓名
        int studentMothDegree = getDegree(tokens[15], bunitId); // 教育程度
        String studentMothJob = tokens[16];         // 母親職業
        String studentPhone3 = "";
        if (!tokens[17].equals(studentPhone))
            studentPhone3 = tokens[17];          // 電話3
        String studentMotherMobile2 = tokens[18];    // 母親辦
        String studentMotherMobile = tokens[19];    // 母親手機
        String studentMotherEmail = tokens[20];    // 母親Email

        String studentBloodType = tokens[34];
        String maincontact = tokens[33];

        String comment = "";
        if (tokens[21].trim().length()>0) {
            comment = "其他連絡人:" + tokens[21];
            if (tokens[22].trim().length()>0) {
                comment += "(" + tokens[22] + ")";
            }
            if (tokens[23].trim().length()>0) {
                comment += " " + tokens[23];
            }
            if (tokens[24].trim().length()>0) {
                comment += " " + tokens[24];
            }
            if (tokens[25].trim().length()>0) {
                comment += " " + tokens[25];
            }
        }
        String studentZipCode = tokens[28];          // 郵遞區號
        String studentAddress = tokens[29];          // 住址
        if (tokens.length>32&&tokens[32].trim().length()>0) {
            if (comment.length()>0)
                comment += "\n";
            comment += tokens[32];
        }

             
        // setting stuff
        student.setStudentName(studentName);
        student.setStudentShortName(studentShortName);
        student.setStudentNickname(studentNickname);
        student.setStudentNumber(studentNumber);
        student.setStudentIDNumber(studentIDNumber);
        student.setStudentSex(studentSex);
        student.setStudentBirth(studentBirth);
        //student.setStudentBloodType(studentBloodType);
        student.setStudentZipCode(studentZipCode);
        student.setStudentAddress(studentAddress);
        student.setStudentPhone(studentPhone);
        student.setStudentPhone2(studentPhone2);
        student.setStudentPhone3(studentPhone3);
        student.setStudentFather(studentFather);
        student.setStudebtFatherDegree(studentFatherDegree);
        student.setStudentFathJob(studentFathJob);
        student.setStudentFatherMobile(studentFatherMobile);
        //student.setStudentFatherMobile2(studentFatherMobile2);
        student.setStudentMother(studentMother);
        student.setStudentMothDegree(studentMothDegree);
        student.setStudentMothJob(studentMothJob);
        student.setStudentMotherMobile(studentMotherMobile);
        student.setStudentMotherMobile2(studentMotherMobile2);
        student.setStudentFatherEmail(studentFatherEmail);
        student.setStudentMotherEmail(studentMotherEmail);
        student.setBloodType(studentBloodType);

        if (maincontact.equals("父"))
            student.setStudentEmailDefault(1);
        else if (maincontact.equals("母"))
            student.setStudentEmailDefault(2);

        //student.setStudentBrother(studentBrother);
        //student.setStudentBigSister(studentBigSister);
        //student.setStudentYoungBrother(studentYoungBrother);
        //student.setStudentYoungSister(studentYoungSister);
        //if (studentTryDate!=null)
        //    student.setStudentTryDate(studentTryDate);
        
        student.setStudentPs(comment);
    }

    public static void parseShowMe(String[] tokens, Student2 student)
        throws Exception
    {
        String studentName = tokens[1];             // 姓名
        String studentNickname = tokens[2];         // English Name
        int studentSex = getGendar(tokens[3]); // getInt(tokens[3], 0);      // 性別
        Date studentBirth = null; // 生日
        try {
            studentBirth = tw_sdf.parse(tokens[4]);
            int year = studentBirth.getYear();
            studentBirth.setYear(year + 11);
        }
        catch (Exception e) {}

        String studentIDNumber = tokens[5];         // 身份證字號
        String studentBloodType = tokens[6];        // 血型
        String studentZipCode = tokens[7];          // 郵遞區號
        String studentAddress = tokens[8];          // 住址
        String studentPhone = tokens[9];            // 電話1
        String studentPhone2 = tokens[10];           // 電話2
        String studentPhone3 = tokens[11];          // 電話3        
        String studentFather = tokens[13];          // 父親姓名
        int studentFatherDegree = getDegree(tokens[14]); // 教育程度
                // tokens[15]                       // 父親生日
        String studentFathJob = tokens[16];         // 父親職業
        String studentFatherMobile = tokens[17];    // 父親手機
        String studentFatherMobile2 = tokens[18];   // 父親手機2
        String studentMother = tokens[20];          // 母親姓名
        int studentMothDegree = getDegree(tokens[21]); // 教育程度
                // tokens[22]                       // 母親生日
        String studentMothJob = tokens[23];         // 母親職業
        String studentMotherMobile = tokens[24];    // 母親手機
        String studentMotherMobile2 = tokens[25];   // 母親手機2
        //String studentFatherEmail = tokens[26];     // 父親 email
        //String studentMotherEmail = tokens[27];     // 母親 email

        StringBuffer ps = new StringBuffer();
        if (tokens[26].trim().length()>0)
            ps.append("第一聯絡人:\n" + tokens[26].trim());

        String studentPs = ps.toString();
             
        // setting stuff
        student.setStudentName(studentName);
        student.setStudentNickname(studentNickname);
        student.setStudentSex(studentSex);
        student.setStudentBirth(studentBirth);
        student.setStudentIDNumber(studentIDNumber);
        student.setBloodType(studentBloodType);
        student.setStudentZipCode(studentZipCode);
        student.setStudentAddress(studentAddress);
        student.setStudentPhone(studentPhone);
        student.setStudentPhone2(studentPhone2);
        student.setStudentPhone3(studentPhone3);
        student.setStudentFather(studentFather);
        student.setStudebtFatherDegree(studentFatherDegree);
        student.setStudentFathJob(studentFathJob);
        student.setStudentFatherMobile(studentFatherMobile);
        student.setStudentFatherMobile2(studentFatherMobile2);
        student.setStudentMother(studentMother);
        student.setStudentMothDegree(studentMothDegree);
        student.setStudentMothJob(studentMothJob);
        student.setStudentMotherMobile(studentMotherMobile);
        student.setStudentMotherMobile2(studentMotherMobile2);
        //student.setStudentFatherEmail(studentFatherEmail);
        //student.setStudentMotherEmail(studentMotherEmail);
        //student.setStudentEmailDefault(studentEmailDefault);

        //student.setStudentBrother(studentBrother);
        //student.setStudentBigSister(studentBigSister);
        //student.setStudentYoungBrother(studentYoungBrother);
        //student.setStudentYoungSister(studentYoungSister);
        //if (studentTryDate!=null)
        //    student.setStudentTryDate(studentTryDate);
        
        student.setStudentPs(studentPs);
    }


    public static void parseShiRen(String[] tokens, Student2 student)
        throws Exception
    {
        String studentName = tokens[1];             // 姓名
        String studentNickname = tokens[2];         // English Name
        int studentSex = getGendar(tokens[3]); // getInt(tokens[3], 0);      // 性別
        Date studentBirth = null; // 生日
        try {
            studentBirth = tw_sdf.parse(tokens[4]);
            //int year = studentBirth.getYear();
            //studentBirth.setYear(year + 11);
        }
        catch (Exception e) {}

        String studentIDNumber = tokens[5];         // 身份證字號
        String studentBloodType = tokens[6];        // 血型
        String studentZipCode = tokens[7];          // 郵遞區號
        String studentAddress = tokens[8];          // 住址
        String studentPhone = tokens[9];            // 電話1
        String studentPhone2 = tokens[10];           // 電話2
        String studentPhone3 = tokens[11];          // 電話3        
        String studentFather = tokens[12];          // 父親姓名
        //int studentFatherDegree = getDegree(tokens[14]); // 教育程度
                // tokens[15]                       // 父親生日
        //String studentFathJob = tokens[16];         // 父親職業
        String studentFatherMobile = tokens[16];    // 父親手機
        //String studentFatherMobile2 = tokens[18];   // 父親手機2
        String studentMother = tokens[19];          // 母親姓名
        int studentMothDegree = getDegree(tokens[21]); // 教育程度
                // tokens[22]                       // 母親生日
        //String studentMothJob = tokens[23];         // 母親職業
        String studentMotherMobile = tokens[23];    // 母親手機
        //String studentMotherMobile2 = tokens[25];   // 母親手機2
        //String studentFatherEmail = tokens[26];     // 父親 email
        //String studentMotherEmail = tokens[27];     // 母親 email
        
        StringBuffer ps = new StringBuffer();
        //if (tokens[26].trim().length()>0)
        //    ps.append("第一聯絡人:\n" + tokens[26].trim());

        String studentPs = ps.toString();
             
        // setting stuff
        student.setStudentName(studentName);
        student.setStudentNickname(studentNickname);
        student.setStudentSex(studentSex);
        student.setStudentBirth(studentBirth);
        student.setStudentIDNumber(studentIDNumber);
        student.setBloodType(studentBloodType);
        student.setStudentZipCode(studentZipCode);
        student.setStudentAddress(studentAddress);
        student.setStudentPhone(studentPhone);
        student.setStudentPhone2(studentPhone2);
        student.setStudentPhone3(studentPhone3);
        student.setStudentFather(studentFather);
        //student.setStudebtFatherDegree(studentFatherDegree);
        //student.setStudentFathJob(studentFathJob);
        student.setStudentFatherMobile(studentFatherMobile);
        //student.setStudentFatherMobile2(studentFatherMobile2);
        student.setStudentMother(studentMother);
        //student.setStudentMothDegree(studentMothDegree);
        //student.setStudentMothJob(studentMothJob);
        student.setStudentMotherMobile(studentMotherMobile);
        //student.setStudentMotherMobile2(studentMotherMobile2);
        
        student.setStudentPs(studentPs);
    }


    // Map<getMethodName, Object>
    public static Map<String,Object> printObj(Object o, Vector<Method> v)
        throws Exception
    {
        Map<String,Object> m = new HashMap<String,Object>();
        Object[] params = {};
        for (int i=0; i<v.size(); i++) {
            Method getm = v.get(i);
            Object ret = getm.invoke(o, params);
            m.put(getm.getName(), ((ret==null)?null:ret.toString()));
        }
        return m;
    }
    
    /*
    public static void main(String[] args)
    {
        try {
            DataSource.setup("datasource");
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(args[0])));
            String line = null;
            Student2Mgr smgr = Student2Mgr.getInstance();
            int oldS = 0;
            int newS = 0;

            Student2 s = new Student2();
            Class c = s.getClass();
            Method[] methods = c.getDeclaredMethods();

            Vector<Method> getMethods = new Vector<Method>();            
            System.out.println("<table border=1><tr>");
            for (int i=0; i<methods.length; i++) {
                if (methods[i].getName().indexOf("get")>=0) {
                    getMethods.addElement(methods[i]);
                    System.out.println("<th>" + methods[i].getName() + "</th>");
                }
            }
            System.out.println("</tr>");

            while ((line=br.readLine())!=null) {
                if (line.trim().length()==0)
                    continue;
                String[] tokens = line.split("\t");
                String studentName = tokens[0];
                Student2 student = smgr.find("studentName='" + studentName + "'");
                if (student!=null) {
                    parseStarLight(tokens, student);
                    oldS ++;
                }
                else {
                    student = new Student2();
                    parseStarLight(tokens, student);
                    newS ++;
                }
                Map<String,Object> m = printObj(student, getMethods);
                System.out.println("<tr>");
                for (int i=0; i<getMethods.size(); i++) {
                    Object o = m.get(getMethods.get(i).getName());
                    System.out.println("<td>" + ((o==null)?"":o.toString()) + "</td>");
                }
                System.out.println("</tr>");
            }
            System.out.println("</table>");

            System.out.println("# old=" + oldS + ", new=" + newS);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    */
}