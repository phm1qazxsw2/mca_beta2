<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%@ page import="java.io.*" %>
<%@ page import="util.*" %>

<h3>album system auth</h3>
<%

	String authKey="Xo4Y6GhL";  //jsf code

	//String authKey="XoHTCfhL";  //album code 
	
	
	String authData="J2S0F09950488330";

	
	//15BD439DCFED7E9F59A85E39CFF159BC  
	
	
	//String authData="JSMC0100"; //type 2
	String  cipher="";
	cipher=util.SymmetricCipher.encodeECBAsHexString(authKey, authData);

	out.println(cipher);
	
	
	byte[] xData=util.SymmetricCipher.hexStringToByteArray(cipher);


	String original=util.SymmetricCipher.decodeECBString(authKey, xData);


	out.println("<br>"+original);
%>             