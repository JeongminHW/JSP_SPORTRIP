<%@page import="DB.MUtil"%>
<%@page import="user.UserBean"%>
<%@page import="team.TeamBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="userMgr" class="user.UserMgr" />
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="team" scope="session" class="team.TeamBean" />
<jsp:setProperty property="*" name="login" />
<jsp:setProperty property="*" name="team" />

<%
    String defaultUrl = ".././sport/sport_main.jsp"; // url이 없는 경우 스포츠 메인으로 이동 시킴
    String previousUrl = (String) session.getAttribute("previousPage"); // 이전 페이지 받아옴
    String url = previousUrl != null ? previousUrl : defaultUrl; 

    boolean result = userMgr.checkLogin(login.getId(), login.getPw());
    String msg = "로그인에 실패하였습니다.";

    if (result) {
        msg = "로그인에 성공하였습니다.";
        login = userMgr.getJoin(login.getId());
        session.setAttribute("idKey", login.getId());
        session.setAttribute("login", login);
    }
%>

<script>
    alert("<%=msg%>");
    location.href = "<%=url%>"; 
</script>
