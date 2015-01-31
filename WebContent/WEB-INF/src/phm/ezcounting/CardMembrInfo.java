package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class CardMembrInfo
{

    private int   	id;
    private Date   	created;
    private String   	cardId;
    private int   	membrId;
    private int   	active2;
    private String   	name;
    private int   	active;
    private int   	type;
    private int   	surrogateId;
    private Date   	birth;


    public CardMembrInfo() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public String   	getCardId   	() { return cardId; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getActive2   	() { return active2; }
    public String   	getName   	() { return name; }
    public int   	getActive   	() { return active; }
    public int   	getType   	() { return type; }
    public int   	getSurrogateId   	() { return surrogateId; }
    public Date   	getBirth   	() { return birth; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setCardId   	(String cardId) { this.cardId = cardId; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setActive2   	(int active2) { this.active2 = active2; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setActive   	(int active) { this.active = active; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setSurrogateId   	(int surrogateId) { this.surrogateId = surrogateId; }
    public void 	setBirth   	(Date birth) { this.birth = birth; }

}
