<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserBean" %>
<%
    // 로그인 세션만 해제
    UserBean login = (UserBean) session.getAttribute("login"); // 세션에서 로그인 정보 가져오기
    if (login != null) {
        session.removeAttribute("login"); // 로그인 정보만 제거
        
    }
    
    if(session.getAttribute("login") == null){
    	out.println("success");
    }else{
    	out.println("fail");
    }
%>