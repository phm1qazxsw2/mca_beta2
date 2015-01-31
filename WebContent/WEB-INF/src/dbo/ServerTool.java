package dbo;

import java.sql.*;

public class ServerTool
{
    public static boolean hasAnyResult(ResultSet rs)
    {
        try {
            if (!rs.isAfterLast() && !rs.isBeforeFirst())
                 return false;
            return true;
        }
        catch (SQLException e)
        {
            e.printStackTrace();
            return false;
        }
    }

    public static String escapeString(String s)
    {
        if (s==null)
            return "";

        // strip the double quotes
        if ((s.length()>2) && (s.charAt(0)=='"' && s.charAt(s.length()-1)=='"'))
            s = s.substring(1, s.length()-1);

        StringBuffer sb = new StringBuffer();
        for (int i=0, len=s.length(); i<len; i++)
        {
            char c = s.charAt(i);            
 
            if (c=='\'') {
                sb.append('\'');
            }
            else if (c=='\\') {
                sb.append('\\');
            }
            sb.append(c);
        }
        return sb.toString().trim();
    }
}