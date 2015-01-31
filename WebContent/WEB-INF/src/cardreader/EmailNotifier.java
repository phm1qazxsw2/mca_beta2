package cardreader;

import java.io.*;
import java.util.*;
import java.text.*;
import phm.ezcounting.*;
import phm.util.*;

public class EmailNotifier {

    private boolean stop = false;
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2=new SimpleDateFormat("MM/dd");    
    SimpleDateFormat sdf3=new SimpleDateFormat("HH:mm");    

    public EmailNotifier()
    {
        new Thread(new Handler()).start();
    }

    public void shutdown()
    {
        stop = true;
    }

    class Handler extends Thread {

        public void run()
        {
            System.out.println("## email notifier started");
            while(!stop){
                try
                {
                    Thread.sleep(5*1000); // sleep 1 min
                    if (!dbo.DataSource.hasSource("card"))
                        continue;
                    EntryMgr emgr = EntryMgr.getInstance();
                    emgr.setDataSourceName("card");
                    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
                    String machineId = ps.getCardmachine();
                    if (machineId==null || machineId.trim().length()==0)
                        continue;
                    machineId = machineId.replace("#", ",");
                    // 找回上次查詢的 id
                    SchNotifierMgr snmgr = SchNotifierMgr.getInstance();
                    ArrayList<SchNotifier> list = snmgr.retrieveList("", "");
                    SchNotifier sn = null;
                    if (list.size()==0) {
                        sn = new SchNotifier();
                        sn.setLastId(0);
                        SchNotifierMgr.getInstance().create(sn);
                    }
                    else 
                        sn = list.get(0);
                    ArrayList<Entry> entries = emgr.retrieveList("id>" + sn.getLastId() + 
                        " and machineId in ("+machineId+") and datatype='0'", "order by id asc");
                    if (entries.size()>0) {
                        System.out.println("##["+sdf3.format(new Date())+"] card entries found : " + entries.size() + " machineId=" + machineId);
                        sn.setLastId(entries.get(entries.size()-1).getId());
                        snmgr.save(sn);
                        try {
                            sendNotify(entries, ps);
                        }
                        catch (Exception e) {
                            System.out.println("## email error: " + e.getMessage());
                        }
                    }
                    Thread.sleep(55*1000); // sleep 1 min
                }
                catch (Exception e)
                {
                }
            }
            System.out.println("## email notifier quits..");
        }
    }

    public void sendNotify(ArrayList<Entry> entries,  PaySystem2 ps)
        throws Exception
    {
        //sendEmail       
        String entryString = new RangeMaker().makeRange(entries, "getCardId");
        Map<String, Vector<Entry>> entryMap = new SortingMap(entries).doSort("getCardId");
        // 處理卡的對應和讀入 membr 打卡的 entry   抓最近的卡片資料
        ArrayList<CardMembr> cards = CardMembrMgr.getInstance().retrieveList("cardId in (" + entryString + ")", "");
        Map<Integer, CardMembr> membrcardMap = new SortingMap(cards).doSortSingleton("getMembrId");

        //沒有對應的membr
        if(cards ==null || cards.size()<=0)
            return;

        String membrString = new RangeMaker().makeRange(cards, "getMembrId");
        ArrayList<MembrTeacher> membr = MembrTeacherMgr.getInstance().retrieveList("membr.id in (" + membrString + ")","");

        EmailTool et = new EmailTool(ps.getPaySystemEmailServer(), false);
        for(int i=0;membr!=null && i<membr.size();i++){

            StringBuffer sbEntry=new StringBuffer("");
            MembrTeacher m=membr.get(i);
            
            CardMembr cm=membrcardMap.get(new Integer(m.getMembrId()));
            if(cm !=null){
                Vector<Entry> v=entryMap.get(cm.getCardId());
                if(v!=null && v.size()>0){
                    //out.println("size:"+v.size());
                    for(int j=0;j<v.size();j++){
                        Entry en=v.get(j);
                        sbEntry.append(sdf3.format(en.getCreated()));
                        if(j !=(v.size()-1))
                            sbEntry.append(" , ");
                    }
                }

                if(m.getTeacherEmail() !=null && checkEmail(m.getTeacherEmail())){

                    Entry en2=v.get(0);
                    String titleString=" [刷卡: "+m.getName()+"] "+sdf2.format(en2.getCreated())+" "+sbEntry.toString(); 
                    String emailAddress=m.getTeacherEmail();
                    File[] attachments = null;
                    try{
                        et.send(emailAddress,null,null,ps.getPaySystemEmailSenderAddress(),ps.getPaySystemCompanyName(),titleString,"",true,ps.getPaySystemEmailCode(),attachments);

                    }catch(Exception exce){
                        System.out.println("##email error:" + exce.getMessage());
                        exce.printStackTrace();
                    }                         
                }
            }
        }
    }

	public boolean checkEmail(String eAddress)
	{
		if(eAddress==null || eAddress.length()<4)
			return false;
		
		if(eAddress.indexOf("@")==-1)
			return false;
		
		return true;	
	}
}
