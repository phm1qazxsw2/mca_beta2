package dbo;

public class NotUniqueException extends Exception
{
    public NotUniqueException(String msg) {
        super(msg);
    }
}