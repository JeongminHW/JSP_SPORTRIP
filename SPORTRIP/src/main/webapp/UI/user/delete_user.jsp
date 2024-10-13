<%@page import="user.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="userMgr" class="user.UserMgr" />
<%
	request.setCharacterEncoding("UTF-8");

	String id = request.getParameter("id");

	if(id == null){
		out.println("fail");
	}else{
		UserBean userBean = new UserBean();
		
		userBean.setId(id);
		
		if(userMgr.deleteUser(id)) {
	        out.println("success");
	    } else {
	        out.println("fail");
	    }
	}
	
	
%>