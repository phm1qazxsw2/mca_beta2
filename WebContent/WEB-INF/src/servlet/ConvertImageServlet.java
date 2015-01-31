package servlet;

import java.awt.*;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import Acme.JPM.Encoders.*;

public class ConvertImageServlet extends HttpServlet 
{
  public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
  {
    response.setContentType("image/gif");
    ServletOutputStream out = response.getOutputStream();
    Frame frame = null;
    Graphics g = null;
  
    String text = "henry testing";
  
    try
    {
      frame = new Frame();
      frame.addNotify();
      
      // use off-screen image
      Image image = frame.createImage(300, 300);
      g = image.getGraphics();
      
      g.setColor(Color.blue); // text color
      g.setFont(new Font("Serif", Font.PLAIN, 36));
      g.drawString(text, 10, 50);

      // output converted image
      GifEncoder encoder = new GifEncoder(image, out);
      encoder.encode();
    }
    finally
    {
      if(g != null)
        g.dispose();
      if(frame != null)
        frame.removeNotify();
    }
  }

  public void doPost(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
  {
    doGet(request, response);
  }
}
