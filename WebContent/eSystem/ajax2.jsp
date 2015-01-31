<%@ page language="java" contentType="text/html;charset=UTF-8"%><%
Response.ContentType = "text/xml"
Response.Expires = 0

' 載入XML文件
Object xmlDom = Server.CreateObject("MSXML2.DOMDocument")
xmlDom.async = "false"
xmlDom.load(Request)
' 取得書名



Response.Write("<?xml version='1.0' encoding='Big5'?>")
Response.Write("<title>" & strTitle & "</title>")
Set xmlDom = Nothing
%>


