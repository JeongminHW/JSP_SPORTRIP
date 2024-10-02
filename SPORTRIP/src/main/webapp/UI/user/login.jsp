<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" class="user.UserBean" scope="session" />

<%
    String previousUrl = request.getParameter("url");
    
    if (previousUrl != null && !previousUrl.isEmpty()) {
        session.setAttribute("previousPage", previousUrl);
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href=".././assets/css/style.css">
</head>
<body>
    <header class="header">
        <div>
            
        </div>
    </header>

    <div class="container">
        <div id="login" class="item" style="background-color: #083660">
            <a href="login.html">로그인</a>
        </div>
        <div id="signup" class="item" style="background-color: #236FB5">
            <a href="signup.html">회원가입</a>
        </div>
    </div>

    <div class="login_main">
        <div class="login_title">
            <h1>로그인</h1>
        </div>
        <div class="login_form">
            <form action="loginCheck.jsp" method="POST">
                <div class="input_box">
                    <div id="idlabel">아이디</div>
                    <input type="text" name="id" placeholder="아이디">
                </div>
                <div class="input_box">
                    <div id="pwlabel">비밀번호</div>
                    <input type="password" name="pw" placeholder="비밀번호">
                </div>
                <div class="login_button">
                    <input type="hidden" name="url" value="<%= session.getAttribute("previousPage") %>">
                    <button type="submit">로그인하기</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>