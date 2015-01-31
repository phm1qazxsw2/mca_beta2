package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class CitemTag
{

    private int   	id;
    private int   	tagId;
    private int   	chargeItemId;


    public CitemTag() {}


    public int   	getId   	() { return id; }
    public int   	getTagId   	() { return tagId; }
    public int   	getChargeItemId   	() { return chargeItemId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setTagId   	(int tagId) { this.tagId = tagId; }
    public void 	setChargeItemId   	(int chargeItemId) { this.chargeItemId = chargeItemId; }

}
