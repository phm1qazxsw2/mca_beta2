package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaDeferred
{

    private int   	id;
    private String   	ticketId;
    private int   	type;
    private int   	bunitId;


    public McaDeferred() {}


    public int   	getId   	() { return id; }
    public String   	getTicketId   	() { return ticketId; }
    public int   	getType   	() { return type; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setTicketId   	(String ticketId) { this.ticketId = ticketId; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

    public static final int TYPE_NONE     = 0;
    public static final int TYPE_STANDARD = 1;
    public static final int TYPE_MONTHLY  = 2;

}
