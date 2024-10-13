<%@ page import="DB.MUtil" %>
<%@ page import="user.UserBean" %>
<%@ page import="team.TeamBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="userMgr" class="user.UserMgr" />
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="team" scope="session" class="team.TeamBean" />
<jsp:setProperty property="*" name="login" />
<jsp:setProperty property="*" name="team" />

<%
	
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	System.out.println(id);
	System.out.println(pw);
	if(id == null || pw == null){
		out.println("fail");
	}else{
	    boolean result = userMgr.checkLogin(id, pw);
		
	    if (result) {
	    	login = userMgr.getJoin(id);
	    	if(userMgr.checkAdmin(id)){
	    		out.println("admin");
	    	}else{
	    		out.println("user");
	    	}
	        
	    }else{
	    	out.println("fail");
	    }
	}

    

%>
