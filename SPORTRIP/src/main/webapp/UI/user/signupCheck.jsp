<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");  // 이 부분을 최상단에 위치시킴
%>
<jsp:useBean id="userMgr" class="user.UserMgr" />
<jsp:useBean id="userBean" class="user.UserBean" />
<jsp:setProperty property="*" name="userBean" />

<%
    String id = request.getParameter("id");
    String password = request.getParameter("password");
    String password_check = request.getParameter("password_check");
    String name = request.getParameter("name");
    String address = request.getParameter("address");
    String extraAddr = request.getParameter("extraAddr");
    int postcode = MUtil.parseInt(request, "zipcode");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");

    userBean.setId(id);
    userBean.setPw(password);
    userBean.setName(name);
    userBean.setAddress(address + "(" + extraAddr + ")");
    userBean.setPostcode(postcode);
    userBean.setPhone(phone);
    userBean.setEmail(email);

    if(userMgr.addUser(userBean)){
        response.sendRedirect("login.jsp");
    }
%>
