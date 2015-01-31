package phm.ezcounting;

public class Locked extends Exception
{
    public Locked() { 
        super("單據狀態為鎖住");
    }
}