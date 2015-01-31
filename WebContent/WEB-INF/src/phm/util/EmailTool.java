package phm.util;

import java.util.*;
import java.io.*;
import java.text.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;

public class EmailTool {
    String mailServer = "218.32.77.180";
    boolean debug;

    public EmailTool(String mailServer, boolean debug) {
        this.mailServer = mailServer;
        this.debug = debug;
    }

    public void send(String to, String cc, String bcc, String from,
                     String subject, String content, boolean html, String messageEncoding)
            throws Exception {
        send(to, cc, bcc, from, null, subject, content, html, messageEncoding, null);
    }

    public void send(String to, String cc, String bcc, String from, String fromName,
                     String subject, String content, boolean html, String messageEncoding, File[] attachments)
            throws Exception {
        InternetAddress[] address = null;
        InternetAddress[] cc_address = null;
        InternetAddress[] bcc_address = null;

        boolean sessionDebug = debug;

        java.util.Properties props = System.getProperties();
System.out.println("### sending email, mailServer=" + mailServer + " to=" + to);
        props.put("mail.host", mailServer);
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.debug", sessionDebug + "");
        props.put("mail.smtp.localhost", mailServer);

        Session mailSession = Session.getInstance(props, null);
        mailSession.setDebug(sessionDebug);

        Message msg = new MimeMessage(mailSession);

        InternetAddress fromaddr = null;
        if (from == null)
            fromaddr = new InternetAddress(from);
        else
            fromaddr = new InternetAddress(from, fromName, messageEncoding);

        msg.setFrom(fromaddr);

        address = InternetAddress.parse(to, false);
        msg.setRecipients(Message.RecipientType.TO, address);
        //msg.setRecipient(Message.RecipientType.TO, new InternetAddress(receiver_mail));

        if (cc != null) {
            cc_address = InternetAddress.parse(cc, false);
            msg.setRecipients(Message.RecipientType.CC, cc_address);
        }

        if (bcc != null) {
            bcc_address = InternetAddress.parse(bcc, false);
            msg.setRecipients(Message.RecipientType.BCC, bcc_address);
        }

        String enSubject =
                javax.mail.internet.MimeUtility.encodeText(subject, messageEncoding, null);

        msg.setSubject(enSubject);

        msg.setSentDate(new Date());

       
        MimeMultipart mp = new MimeMultipart();
        MimeBodyPart mbp = new MimeBodyPart();

        if (messageEncoding == null)
            messageEncoding = "latin1";

        if (html)
            mbp.setContent(content,"text/html;charset="+messageEncoding);
        else
            mbp.setText(content, messageEncoding);

        //mbp.setDataHandler(
        //    new DataHandler(new HtmlDataSource(content, "text/html", messageEncoding)));


        mp.addBodyPart(mbp);

        for (int i=0; attachments!=null && i<attachments.length; i++)
        {
            MimeBodyPart mbody = new MimeBodyPart();
            DataSource source = new FileDataSource(attachments[i]);
            mbody.setDataHandler(new DataHandler(source));
            mbody.setFileName(attachments[i].getName());
            mp.addBodyPart(mbody);
        }

        msg.setContent(mp);

        Transport.send(msg);
    }

    public void send(String to, String sender_mail, String subject,
                     String content, boolean html, String messageEncoding)
            throws Exception {
        send(to, null, null, sender_mail, subject,
                content, html, messageEncoding);
    }

    public static void main(String[] args) {
        try {
            EmailTool e = new EmailTool(args[0], false);
            // e.send("nicepeter@ipart.cn", null, null, "nicepeter@gmail.com", "林君豪", "測試郵件寄送", 
            //        "今天天氣很好,要快樂哦!", false, "UTF-8", null);

            File[] attachments = new File[1];
            attachments[0] = new File("D:/resin-3.0.25/webapps/ezcounting/eSystem/exlfile/1214378685921.xls");    
           // attachments[1] = new File("testdata/demo.pdf");            
            e.send("pjhlin@hotmail.com", null, null, "nicepeter@gmail.com", "from Peter", "report test", 
                    "今天天氣很好,要快樂哦!", false, "UTF-8", attachments);

        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}

class HtmlDataSource implements javax.activation.DataSource {
    String mimeType;
    String content;
    String encoding;

    public HtmlDataSource(String content, String mimeType, String encoding) {
        this.mimeType = mimeType;
        this.content = content;
        this.encoding = encoding;
    }

    public String getContentType() {
        return mimeType;
    }

    public InputStream getInputStream()
            throws java.io.UnsupportedEncodingException {
        return new ByteArrayInputStream(content.getBytes(encoding));
    }

    public String getName() {
        return "HtmlDataSource";
    }

    public OutputStream getOutputStream() {
        return null;
    }
}