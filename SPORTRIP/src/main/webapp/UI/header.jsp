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
<jsp:useBean id="userMgr" class="user.UserMgr" />
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />

<%
    // 현재 폴더명 확인
	String currentPath = request.getRequestURI();
%>

<% if (currentPath.contains("/sport/")) { %>
<!-- sport 헤더 -->
<section class="first-page" id="first-page">
		<header>
			<a class="logo" style="cursor: pointer" href="mainPage.jsp"><img src=".././assets/images/white_sportrip_logo.png" alt="sportrip 로고" id="logo_img"> </a>
			<div id="header" class="c_main">
				<div class="h_wrap">
					<nav class="h_gnb">
						<div class="hg_list">
							<ul>
								<li class="highlight">
									<a href="#" onclick="document.getElementById('second-page').scrollIntoView({behavior: 'smooth'})"><span>Highlight</span></a>
								</li>
								<li class="rank">
									<a href="#" onclick="document.getElementById('third-page').scrollIntoView({behavior: 'smooth'})"><span>Rank</span></a>
								</li>
								<li class="matchdate">
									<a href=".././sport/sport_matchDate.jsp"><span>MatchDate</span></a>
								</li>
							</ul>
						</div>
					</nav>
					<input id="toggle" type="checkbox" />
					<label class="hamburger"for="toggle">
						<div class="top"></div>
						<div class="middle"></div>
						<div class="bottom"></div>
					</label>
				</div>
			</div>
<%} else if (currentPath.contains("/trip/")) { %>
<% %>
<!-- trip 헤더 -->
<a style="cursor: pointer" href=".././sport/mainPage.jsp">
	<img src=".././assets/images/white_sportrip_logo.png" alt="sportrip 로고" id="logo_img">
</a>
<div id="header" class="c_main">
	<div class="h_wrap">
		<input id="toggle" type="checkbox" />
			<label class="hamburger"for="toggle">
				<div class="top"></div>
				<div class="middle"></div>
				<div class="bottom"></div>
		</label>
	</div>
</div>
<%} else if(currentPath.contains("/admin/")){


    // POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
    int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
    
    if(teamNum == 0 && (session.getAttribute("teamNum") == null || session.getAttribute("teamNum").equals(""))){
    	teamNum = 1;
    }else if (teamNum != 0) {
        session.setAttribute("teamNum", teamNum); // 세션에 teamNum 저장
    } else {
        teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 teamNum 가져오기
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
    }%>
<!-- admin 헤더 -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=teamInfo.getTEAM_NAME() %></title>
    <link rel="stylesheet" href=".././assets/css/style.css">
    <link rel="stylesheet" href=".././assets/css/boardStyle.css">
    <link rel="stylesheet" href=".././assets/css/mainhamburger.css">
	<link rel="stylesheet" href=".././assets/css/style.css">
	<link rel="stylesheet" href=".././assets/css/adminStyle.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css">
    <link rel="stylesheet" href="https://code.jquery.com/jquery-3.5.1.min.js">
    <script type="text/JavaScript" src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script type="text/JavaScript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.js"></script>
    <script type="text/JavaScript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.js"></script>
</head>
<body>
    <header class="header team_header">
        <a href=".././sport/sport_main.jsp">
        <%	
        	String src = null;
        	if(teamInfo.getSPORT_NUM() == 1) {
        		src = ".././assets/images/sport_logo" + teamInfo.getSPORT_NUM() + ".svg";
        	}
        	else if(teamInfo.getSPORT_NUM() == 2){
        		src = ".././assets/images/sport_logo" + teamInfo.getSPORT_NUM() + ".svg";
        	}
        	else if(teamInfo.getSPORT_NUM() == 3){
        		src = ".././assets/images/sport_logo" + teamInfo.getSPORT_NUM() + ".svg";
        	}
        %>
            <img src=<%=src %> alt="리그" id="league_logo_img">
        </a>
        <div style="position: absolute; left: 50%; transform: translateX(-50%);" class="img-box">
	        <img src="<%=teamInfo.getLOGO() %>" alt="로고" class="team_logo_img">
	        <div class="t_header">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_player')"><span>선수 관리</span></a>
	        </div>
	        <div class="t_header">
	            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_goods')"><span>굿즈샵 관리</span></a>
	        </div>
	        <div class="t_header">
	            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_board')"><span>게시판 관리</span></a>
			</div>
    	</div>
        <input id="toggle" type="checkbox"/>
        <label class="hamburger" for="toggle">
            <div class="top"></div>
            <div class="middle"></div>
            <div class="bottom"></div>
        </label>
    </header>
    <script src=".././assets/js/main.js"></script>
<%} else if(currentPath.contains("/team/") || currentPath.contains("/board/")) { 


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

	boolean isAdmin = userMgr.checkAdmin(login.getId()); // 관리자인지 확인
    %>
    <%if(isAdmin){ %>
	<!-- admin 헤더 -->
	<!DOCTYPE html>
	<html lang="ko">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title><%=teamInfo.getTEAM_NAME() %></title>
	    <link rel="stylesheet" href=".././assets/css/style.css">
	    <link rel="stylesheet" href=".././assets/css/boardStyle.css">
	    <link rel="stylesheet" href=".././assets/css/mainhamburger.css">
		<link rel="stylesheet" href=".././assets/css/style.css">
		<link rel="stylesheet" href=".././assets/css/adminStyle.css">
	    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css">
	    <link rel="stylesheet" href="https://code.jquery.com/jquery-3.5.1.min.js">
	    <script type="text/JavaScript" src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	    <script type="text/JavaScript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.js"></script>
	    <script type="text/JavaScript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.js"></script>
	</head>
	<body>
    <header class="header team_header">
        <a href=".././sport/sport_main.jsp">
        <%	
        	String src = null;
        	if(teamInfo.getSPORT_NUM() == 1) {
        		src = ".././assets/images/sport_logo" + teamInfo.getSPORT_NUM() + ".svg";
        	}
        	else if(teamInfo.getSPORT_NUM() == 2){
        		src = ".././assets/images/sport_logo" + teamInfo.getSPORT_NUM() + ".svg";
        	}
        	else if(teamInfo.getSPORT_NUM() == 3){
        		src = ".././assets/images/sport_logo" + teamInfo.getSPORT_NUM() + ".svg";
        	}
        %>
            <img src=<%=src %> alt="리그" id="league_logo_img">
        </a>
        <div style="position: absolute; left: 50%; transform: translateX(-50%);" class="img-box">
	        <img src="<%=teamInfo.getLOGO() %>" alt="로고" class="team_logo_img">
	        <div class="t_header">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_player')"><span>선수 관리</span></a>
	        </div>
	        <div class="t_header">
	            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_goods')"><span>굿즈샵 관리</span></a>
	        </div>
	        <div class="t_header">
	            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_board')"><span>게시판 관리</span></a>
          </div>
    	</div>
        <input id="toggle" type="checkbox"/>
        <label class="hamburger" for="toggle">
            <div class="top"></div>
            <div class="middle"></div>
            <div class="bottom"></div>
        </label>
    </header>
	<%} else{%>
	<!-- team 헤더 -->
	<!DOCTYPE html>
	<html lang="ko">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title><%=teamInfo.getTEAM_NAME() %></title>
	    <link rel="stylesheet" href=".././assets/css/style.css">
	    <link rel="stylesheet" href=".././assets/css/highlightStyle.css">
	    <link rel="stylesheet" href=".././assets/css/boardStyle.css">
	    <link rel="stylesheet" href=".././assets/css/mainhamburger.css">
	    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css">
	    <link rel="stylesheet" href="https://code.jquery.com/jquery-3.5.1.min.js">
	    <script type="text/JavaScript" src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	    <script type="text/JavaScript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.js"></script>
	    <script type="text/JavaScript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.js"></script>
	</head>
	<body>
	    <header class="header team_header">
	        <a href=".././sport/sport_main.jsp">
	            <img src=".././assets/images/sport_logo<%=teamInfo.getSPORT_NUM()%>.svg" alt="리그" id="league_logo_img">
	        </a>
	        <div style="position: absolute; left: 50%; transform: translateX(-50%);" class="img-box">
	        	<a class="t_header" href=".././team/teamPage_teamintro.jsp"><span>Info</span></a>
	        	<a class="t_header" href=".././team/teamPage_player.jsp"><span>Player</span></a>
	        	<a class="t_header" href=".././team/teamPage_highlight.jsp"><span>Highlight</span></a>
		        <img src="<%=teamInfo.getLOGO() %>" alt="로고" class="team_logo_img">
		        <a class="t_header" href=".././team/teamPage_stadium.jsp"><span>Stadium</span></a>
		        <a class="t_header" href=".././team/teamPage_store.jsp"><span>Shop</span></a>
		        <a class="t_header" href=".././team/teamPage_board.jsp"><span>Board</span></a>
	    	</div>
	        <input id="toggle" type="checkbox"/>
	        <label class="hamburger" for="toggle">
	            <div class="top"></div>
	            <div class="middle"></div>
	            <div class="bottom"></div>
	        </label>
    </header>
	<%} %>
<%} %>

<jsp:include page="hamburger.jsp"/>