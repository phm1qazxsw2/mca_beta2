package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class CardMembr
{

    private int   	id;
    private Date   	created;
    private String   	cardId;
    private int   	membrId;
    private int   	active2;


    public CardMembr() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public String   	getCardId   	() { return cardId; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getActive2   	() { return active2; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setCardId   	(String cardId) { this.cardId = cardId; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setActive2   	(int active2) { this.active2 = active2; }

	
    public String getCardIdTerm()
    {
        return "'" + this.cardId + "'";
    }
    /*  active2 1=���brun   2=�Ȯɪ�   0=�L�j�  */


    public static Hashtable<String,String> getCardDate(Date d1,Date d2,Membr mem){

	java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy/MM/dd");
	Calendar c=Calendar.getInstance();
	c.setTime(d2);
	c.add(Calendar.DATE,1);
	Date nextDay=c.getTime();
	ArrayList<CardMembr> cm=CardMembrMgr.getInstance().retrieveList("membrId='"+mem.getId()+"' and created <'"+sdf.format(nextDay)+"'","order by created desc");
	Hashtable<String,String> ha=new Hashtable();

	int duringDate=(int)((d2.getTime()-d1.getTime())/(long)(1000*60*60*24));
	c.setTime(d1);
	for(int i=0;i<(duringDate+1);i++){
		Date nowDate=c.getTime();		
		for(int j=0;j<cm.size();j++){
			CardMembr cmx=cm.get(j);
			if(cmx.getCreated().compareTo(nowDate)<=0){
				ha.put(sdf.format(nowDate),cmx.getCardId());
				break;	
			}
		}
		c.add(Calendar.DATE,1);
	}
	return ha;
    }

    public static Date[] getValidTime(Vector<cardreader.Entry> vEntry,Date d1,Date d2){

	Date[] validDate=new Date[2];			
	java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm");

	cardreader.Entry en=vEntry.get(0);	

	if(en.getCreated().compareTo(d1)<=0)
	{
		validDate[0]=d1;
	}else{
		validDate[0]=en.getCreated();
	}

	en=vEntry.get((vEntry.size()-1));
	if(en.getCreated().compareTo(d2)<=0){

		validDate[1]=en.getCreated();	
	}else{

		validDate[1]=d2;
	}
	return validDate;
    }

}
