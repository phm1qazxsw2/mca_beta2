package phm.ezcounting;

public class AlreadyExists extends Exception
{
    public AlreadyExists() { 
        super("要產生的物件已經存在");
    }
}

