package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Bunit
{

    private int   	id;
    private String   	label;
    private int   	status;
    private int   	flag;
    private int   	buId;


    public Bunit() {}


    public int   	getId   	() { return id; }
    public String   	getLabel   	() { return label; }
    public int   	getStatus   	() { return status; }
    public int   	getFlag   	() { return flag; }
    public int   	getBuId   	() { return buId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setLabel   	(String label) { this.label = label; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setFlag   	(int flag) { this.flag = flag; }
    public void 	setBuId   	(int buId) { this.buId = buId; }

    public final static int STATUS_ACTIVE   = 1;
    public final static int STATUS_INACTIVE = 0;
    public final static int FLAG_BIZ = 1;
    public final static int FLAG_SCH = 0;
}
