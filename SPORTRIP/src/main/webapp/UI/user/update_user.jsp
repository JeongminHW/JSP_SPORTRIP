<%@page import="user.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="userMgr" class="user.UserMgr" />
<%
	request.setCharacterEncoding("UTF-8");

	String id = request.getParameter("id");
	String email = request.getParameter("email");
	String name = request.getParameter("name");
	String phone = request.getParameter("phone");
	String zipcode = request.getParameter("zipcode");
	String address = request.getParameter("address");
	
	if(id == null || name == null || address == null || zipcode == null || phone == null ||  email == null){
		out.println("fail");
	}else{
		UserBean userBean = new UserBean();
		
		userBean.setId(id);
		userBean.setName(name);
		userBean.setAddress(address);
		userBean.setPostcode(Integer.parseInt(zipcode));
		userBean.setPhone(phone);
		userBean.setEmail(email);
		
		if(userMgr.updateUser(userBean)) {
	        out.println("success");
	    } else {
	        out.println("fail");
	    }
	}
	
	
%>