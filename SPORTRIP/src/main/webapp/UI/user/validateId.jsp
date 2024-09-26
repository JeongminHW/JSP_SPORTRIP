<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="userMgr" class="user.UserMgr" />
<%
    String id = request.getParameter("id");
    boolean isDuplicate = userMgr.validateId(id); 

    if (isDuplicate) {
        out.print("duplicate");
    } else {
        out.print("valid"); 
    }
%>
