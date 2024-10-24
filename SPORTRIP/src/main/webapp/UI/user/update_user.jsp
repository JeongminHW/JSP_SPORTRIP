<%
	request.setCharacterEncoding("UTF-8");
%>
<%@page import="user.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="userMgr" class="user.UserMgr" />
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:setProperty property="*" name="login" />

<%
	String id = request.getParameter("id");
	String email = request.getParameter("email");
	String name = request.getParameter("name");
	String phone = request.getParameter("phone");
	String zipcode = request.getParameter("zipcode");
	String address = request.getParameter("address");
	UserBean userBean = new UserBean();
	System.out.println(name);
	
	if(id == null || name == null || address == null || zipcode == null || phone == null ||  email == null){
		out.println("fail");
	}else{
		userBean.setId(id);
		userBean.setName(name);
		userBean.setAddress(address);
		userBean.setPostcode(Integer.parseInt(zipcode));
		userBean.setPhone(phone);
		userBean.setEmail(email);
		System.out.println(userBean.getName());
		
		if(userMgr.updateUser(userBean)) {
	        out.println("success");
	        session.setAttribute("login", userBean);
	    } else {
	        out.println("fail");
	    }
	}
	
	
%>