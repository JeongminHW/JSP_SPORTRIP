<%@page import="user.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="userMgr" class="user.UserMgr" />
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<%
	request.setCharacterEncoding("UTF-8");

	String id = request.getParameter("id");

	if(id == null){
		out.println("fail");
	}else{
		UserBean userBean = new UserBean();
		
		userBean.setId(id);
		
		if(userMgr.deleteUser(id)) {
 	        session.removeAttribute("login"); // 로그인 정보만 제거 
	        out.println("success");
	    } else {
	        out.println("fail");
	    }
	}
	
	
%>