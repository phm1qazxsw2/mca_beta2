package phm.util;

public class TextUtil
{
    private final static String bad = "</script>";
    public static String escapeJSString(String org)
    {
        if (org==null)
            return "";
        StringBuilder sb = new StringBuilder();
        char c;
        for (int i=0, len=org.length(); i<len; i++)
        {
            c=org.charAt(i);
            if (c=='\n')
            {
                sb.append("\\n");
                continue;
            }            
            else if (c=='\r')
                continue;
            if (c=='\'' || c=='\\')
                sb.append('\\');
            else if (c=='"') {
                sb.append("&quot;");
                continue;
            }
            sb.append(c);
        }
        String ret = sb.toString();
        int i;
        while ((i = ret.indexOf(bad))>=0) {
                ret = ret.substring(0, i) + ret.substring(i+bad.length());
        };
        return ret;
    }


    static char[] amp = "&amp;".toCharArray();
    static char[] lt = "&lt;".toCharArray();
    static char[] gt = "&gt;".toCharArray();
    static char[] quot = "&quot;".toCharArray();    
    
    public static String encodeHtml(String str)
    {
        if (str==null) 
            return null;
        StringBuffer sb = new StringBuffer(str.length()+10);
        for (int i=0; i<str.length(); i++)
        {
            char c = str.charAt(i);
            switch (c)
            {
            case '&': sb.append(amp); break;
            case '<': sb.append(lt); break;
            case '>': sb.append(gt); break;
            case '"': sb.append(quot); break;
            default : sb.append(c); break;
            }
        }
        return sb.toString();           
    } 

    public static String abs(int num, boolean display)
    {
        if (num<0) {
            if (display)                
                return "(" + Math.abs(num) + ")";
            else
                return Math.abs(num) + "";
        }
        return num+"";
    }

    public static String makePrecise(String str, int size, boolean rightpadding, char padding)
    {
        StringBuffer result = new StringBuffer();
        if (str==null || str.length()==0) {
            for (int i=0; i<size; i++)
                result.append(padding);
            return result.toString();
        }
            
        if (rightpadding) {
            int cur = 0;
            int i=0;
            while (cur<str.length()) {
                char c = str.charAt(cur ++);
                int s = (c>255)?2:1;
                if ((i+s)>size)
                    break;
                result.append(c);
                i += s;
            }
            for ( ;i<size; i++)
                result.append(padding);
        }
        else {
            int cur = str.length()-1;
            int i=0;
            while (cur>=0) {
                char c = str.charAt(cur--);
                int s = (c>255)?2:1;
                if ((i+s)>size)
                    break;
                result.insert(0, c);
                i += s;
            }
            for ( ;i<size; i++)
                result.insert(0, padding);
        }
        return result.toString();
    }

    public static String trim(String str, String surrounding)
    {
        if (str==null || str.length()==0)
            return str;
        while (str.length()>0) {
            String c = str.substring(0,1);
            if (surrounding.indexOf(c)>=0)
                str = str.substring(1);
            else
                break;
        }
        while (str.length()>0) {
            String c = str.substring(str.length()-1, str.length());
            if (surrounding.indexOf(c)>=0)
                str = str.substring(0, str.length()-1);
            else
                break;
        }
        return str;
    }
}