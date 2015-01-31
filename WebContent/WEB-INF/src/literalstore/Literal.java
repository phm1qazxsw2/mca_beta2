package literalstore;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Literal
{

    private long   	id;
    private String   	text;


    public Literal() {}


    public long   	getId   	() { return id; }
    public String   	getText   	() { return text; }


    public void 	setId   	(long id) { this.id = id; }
    public void 	setText   	(String text) { this.text = text; }

}
