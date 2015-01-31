package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Place
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	placeName;
    private int   	placeActive;


    public Place() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	placeName,
        int	placeActive    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.placeName 	 = placeName;
        this.placeActive 	 = placeActive;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getPlaceName   	() { return placeName; }
    public int   	getPlaceActive   	() { return placeActive; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setPlaceName   	(String placeName) { this.placeName = placeName; }
    public void 	setPlaceActive   	(int placeActive) { this.placeActive = placeActive; }
}
