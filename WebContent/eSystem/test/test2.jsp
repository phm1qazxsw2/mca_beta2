<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,cardreader.*,phm.ezcounting.*,phm.util.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%!
	public boolean checkEmail(String eAddress)
	{
		if(eAddress==null || eAddress.length()<4)
			return false;
		
		if(eAddress.indexOf("@")==-1)
			return false;
		
		return true;	
	}
%>
<%

//start peter
    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");
    
    String d1="2009/02/01";
    String d2="2009/03/01";

    //dataType 一定要是0 機器讀的
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2=new SimpleDateFormat("MM/dd");    
    SimpleDateFormat sdf3=new SimpleDateFormat("HH:mm");    

    ArrayList<Entry> entries = emgr.retrieveList("created>='" + d1 + "' and created<'"+d2+"' and datatype='0'", " order by created asc");

//end peter



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

    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
	EmailTool et = new EmailTool(ps.getPaySystemEmailServer(), false);
    for(int i=0;membr!=null && i<membr.size();i++){

        StringBuffer sbEntry=new StringBuffer("");

        MembrTeacher m=membr.get(i);
        out.println("name:"+m.getName()+" teacherEmail:"+m.getTeacherEmail());

        CardMembr cm=membrcardMap.get(new Integer(m.getMembrId()));
        if(cm !=null){
            Vector<Entry> v=entryMap.get(cm.getCardId());
            if(v!=null && v.size()>0){
                out.println("size:"+v.size());
                for(int j=0;j<v.size();j++){
                    Entry en=v.get(j);
                    sbEntry.append(sdf3.format(en.getCreated())+" , ");
                }
            }

            if(checkEmail(m.getTeacherEmail())){
                Entry en2=v.get(0);

                String titleString=" [刷卡: "+m.getName()+"] "+sdf2.format(en2.getCreated())+" "+sbEntry.toString(); 
                String emailAddress=m.getTeacherEmail();
                File[] attachments = null;

                try{
                    et.send(emailAddress,null,null,ps.getPaySystemEmailSenderAddress(),ps.getPaySystemCompanyName(),titleString,"",true,ps.getPaySystemEmailCode(),attachments);

                }catch(Exception exce){

                    System.out.println(exce.getMessage());
                }     
                
            }
        }
    }
%> 
done!
