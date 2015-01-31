package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Level
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	levelName;
    private int   	levelActive;


    public Level() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	levelName,
        int	levelActive    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.levelName 	 = levelName;
        this.levelActive 	 = levelActive;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getLevelName   	() { return levelName; }
    public int   	getLevelActive   	() { return levelActive; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setLevelName   	(String levelName) { this.levelName = levelName; }
    public void 	setLevelActive   	(int levelActive) { this.levelActive = levelActive; }
}
