<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="headcoach.HeadcoachBean"%>
<%@page import="headcoach.HeadcoachMgr"%>
<%@page import="player.PlayerBean"%>
<%@page import="player.PlayerMgr"%>
<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />

<%
    // POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
    int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
    if (teamNum == 0) {
        teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
    } else {
        session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
    }
    
    // 팀 정보와 선수 명단 가져오기
    TeamBean teamInfo = teamMgr.getTeam(teamNum);
    PlayerMgr playerMgr = new PlayerMgr();
    Vector<PlayerBean> playerList = playerMgr.TeamPlayers(teamNum);

    HeadcoachMgr coachMgr = new HeadcoachMgr();
    HeadcoachBean coachList = coachMgr.getHeadcoach(teamNum);

    Set<String> positionList = new HashSet<>();
    for (PlayerBean player : playerList) {
        positionList.add(player.getPOSITION());
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=teamInfo.getTEAM_NAME() %></title>
    <link rel="stylesheet" href=".././assets/css/style.css">
    <link rel="stylesheet" href=".././assets/css/hamburger.css">
</head>
<body>
    <header class="header team_header">
        <a href=".././sport/sport_main.jsp">
            <img src=".././assets/images/sport_logo<%=teamInfo.getSPORT_NUM()%>.svg" alt="리그" id="league_logo_img">
        </a>
        <div style="position: absolute; left: 50%; transform: translateX(-50%);" class="img-box">
	        <img src="<%=teamInfo.getLOGO() %>" alt="로고" class="team_logo_img">
    	</div>
        <input id="toggle" type="checkbox" />
        <label class="hamburger" for="toggle">
            <div class="top"></div>
            <div class="middle"></div>
            <div class="bottom"></div>
        </label>
    </header>
    
    <div class="overlay" id="overlay"></div>
    <nav class="menu">
        <ul class="menu-list">
			<li><a style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a></li>
			<ul class="user-box">
				<li id="login"><a href=".././user/login.jsp">로그인</a></li>
				<li id="signup"><a href=".././user/signup.jsp">회원가입</a></li>
			</ul>
            <li>
				<a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_player')">선수 명단</a>
			</li>
            <li>
		    <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_stadium')">경기장 소개</a>
			</li>
            <li>
		    <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_teamintro')">구단 소개</a>
			</li>
            <li>
           <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_highlight')">하이라이트 경기</a>
			</li>
            <li>
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_board')">게시판</a>
			</li>
            <li>
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_store')">굿즈샵</a>
			</li>
            <li>
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, '')">장바구니</a>
			</li>
        </ul>
    </nav>
