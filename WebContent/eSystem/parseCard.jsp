<%@ page language="java" import="java.util.*,cardreader.*,util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    String m=request.getParameter("words");
    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");

    SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

    try{

        if(m !=null && m.length()>0)
        {
            String[] words=m.split("#");
        
            int type=Integer.parseInt(words[0]);
            if(type ==1){
                //單筆上傳
                String bString=words[2].substring(0,40);
                Entry en = new Entry();
                en.setCreated(sdf.parse(bString.substring(18,32)));
                en.setMachineId(Integer.parseInt(bString.substring(2,4)));
                en.setCardId(bString.substring(8,18));
                en.setNumber(Integer.parseInt(bString.substring(32,36)));
                en.setDatatype(0);
                en.setDatauser(0);
                emgr.create(en);
                out.println("O.K.#0");
            }else if(type==2){
                //按自選順序上傳
                for(int i=2;i<words.length;i++)
                {
                    String bString=words[i].substring(0,40);
                                            
                    Entry en=emgr.find("created='"+sdf2.format(sdf.parse(bString.substring(18,32)))+"' and machineId='"+bString.substring(2,4)+"' and number='"+bString.substring(32,36)+"'");

                    if(en ==null){
                        en = new Entry();
                        en.setCreated(sdf.parse(bString.substring(18,32)));
                        en.setMachineId(Integer.parseInt(bString.substring(2,4)));
                        en.setCardId(bString.substring(8,18));
                        en.setNumber(Integer.parseInt(bString.substring(32,36)));
                        en.setDatatype(0);
                        en.setDatauser(0);
                        emgr.create(en);
                    }
                }                             
                out.println("O.K.#0");

            }else if(type==3){

                if(words.length <=3){
                    out.println("no data#0");
                }else{    
  
                    String bString=words[3].substring(0,40);
                    Date fistDate=sdf.parse(bString.substring(18,32));
                    Date lastDate=new Date();
                    int returnNumber=0;

                    for(int i=4;i<words.length;i++)
                    {
                        bString=words[i].substring(0,40); 

                
                        Entry en=emgr.find("created='"+sdf2.format(sdf.parse(bString.substring(18,32)))+"' and machineId='"+bString.substring(2,4)+"' and number='"+bString.substring(32,36)+"'");

                        if(en ==null){

                            Date nowDate=sdf.parse(bString.substring(18,32));
                            if(i !=4){
                                int lastIndex=i-1;
                                String bString2=words[lastIndex].substring(0,40); 
                                Date lastDate2=sdf.parse(bString2.substring(18,32));

                                if(lastDate2.compareTo(nowDate) <0 )
                                    continue;
                            }


                            en = new Entry();
                            en.setCreated(nowDate);
                            en.setMachineId(Integer.parseInt(bString.substring(2,4)));
                            en.setCardId(bString.substring(8,18));
                            en.setNumber(Integer.parseInt(bString.substring(32,36)));
                            en.setDatatype(0);
                            en.setDatauser(0);
                            emgr.create(en);
                            returnNumber=Integer.parseInt(bString.substring(32,36))+1;
                        }   

                        if(i==(words.length-1)){
                            lastDate=sdf.parse(bString.substring(18,32));
                        }             
                    }

                    if(lastDate.compareTo(fistDate) <=0)
                        returnNumber=1;

                    out.println("O.K.#"+returnNumber);
                }
            }

        }else{

            out.println("no data#0");
        }
    }catch(Exception e){
        out.println("##hava a exception :"+e.getMessage());
    }
%>