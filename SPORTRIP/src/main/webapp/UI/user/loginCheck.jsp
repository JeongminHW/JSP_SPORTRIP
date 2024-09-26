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
    String url = "login.jsp";
    //int teamNum = (int)session.getAttribute("teamNum");
    if(request.getParameter("url") != null && !request.getParameter("url").equals(null)) {
        url = request.getParameter("url");
    }

    boolean result = userMgr.checkLogin(login.getId(), login.getPw());
    String msg = "로그인에 실패하였습니다.";

    if(result){
        msg = "로그인에 성공하였습니다.";
        login = userMgr.getJoin(login.getId());
        session.setAttribute("idKey", login.getId());
        session.setAttribute("login", login);
    }
%>

<script>
    alert("<%=msg%>");
    location.href = ".././team/teamPage_Player.jsp"; // 로그인 후 다시 팀 페이지로 리다이렉트
</script>
