<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="userMgr" class="user.UserMgr" />
<jsp:useBean id="userBean" class="user.UserBean" />
<jsp:setProperty property="*" name="userBean" />

<%
	request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String password = request.getParameter("password");
    String password_check = request.getParameter("password_check");
    String name = request.getParameter("name");
    String address = request.getParameter("address");
    String extraAddr = request.getParameter("extraAddr");
    int postcode = MUtil.parseInt(request, "zipcode");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    System.out.println(address);
	userBean.setId(id);
	userBean.setPw(password);
	userBean.setName(name);
	userBean.setAddress(address+"("+extraAddr+")");
	userBean.setPostcode(postcode);
	userBean.setPhone(phone);
	userBean.setEmail(email);
	
	if(userMgr.addUser(userBean)){
		response.sendRedirect("login.html");
	}
%>






