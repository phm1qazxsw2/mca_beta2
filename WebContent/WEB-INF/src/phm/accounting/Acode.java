package phm.accounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Acode
{

    private int   	id;
    private String   	main;
    private String   	sub;
    private int   	name1;
    private int   	name2;
    private int   	catId;
    private int   	rootId;
    private int   	active;
    private int   	type;
    private int   	bunitId;


    public Acode() {}


    public int   	getId   	() { return id; }
    public String   	getMain   	() { return main; }
    public String   	getSub   	() { return sub; }
    public int   	getName1   	() { return name1; }
    public int   	getName2   	() { return name2; }
    public int   	getCatId   	() { return catId; }
    public int   	getRootId   	() { return rootId; }
    public int   	getActive   	() { return active; }
    public int   	getType   	() { return type; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setMain   	(String main) { this.main = main; }
    public void 	setSub   	(String sub) { this.sub = sub; }
    public void 	setName1   	(int name1) { this.name1 = name1; }
    public void 	setName2   	(int name2) { this.name2 = name2; }
    public void 	setCatId   	(int catId) { this.catId = catId; }
    public void 	setRootId   	(int rootId) { this.rootId = rootId; }
    public void 	setActive   	(int active) { this.active = active; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

    public static final int TYPE_MANUAL = 0;
    public static final int TYPE_SYSTEM = 1;

    public static final int ACTIVE_NO  = 0;
    public static final int ACTIVE_YES = 1;

    public String getAcctcode()
    {
        return makeKey(getMain(), getSub());
    }

    public static String makeKey(String main, String sub)
    {
        String key = main;
        if (sub!=null)
            key += sub;
        return key;
    }

    public static String makeQueryKey(String main, String sub, String space)
    {
        String key = "main='" + main + "'";
	if (sub==null || sub.length()==0)
            key += " and rootId=0";
	else
	    key += " and sub='" + sub + "'";
	key += " and active=1";
	if (space!=null)
	    key = space + " and (" + key + ")";
        return key;
    }

    public static String makeSearchKey(String main, String sub, String space)
    {
        String key = "main='" + main + "'";
	if (sub!=null && sub.length()>0)
	    key += " and sub='" + sub + "'";
	if (space!=null)
	    key = space + " and (" + key + ")";
        return key;
    }

    public Acode clone()
    {
        Acode ret = new Acode();
        ret.setMain(this.getMain());
        ret.setSub(this.getSub());
        ret.setName1(this.getName1());
        ret.setName2(this.getName2());
        ret.setCatId(this.getCatId());
        ret.setRootId(this.getRootId());
        ret.setActive(1);
        ret.setType(this.getType());
	ret.setBunitId(this.getBunitId());
        return ret;
    }    

}
