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
    	</div>
        <input id="toggle" type="checkbox"/>
        <label class="hamburger" for="toggle">
            <div class="top"></div>
            <div class="middle"></div>
            <div class="bottom"></div>
        </label>
    </header>
        <jsp:include page="../hamburger.jsp"/>
    
    <div class="a_top">
        <div class="item" style="background-color: #083660;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_player')">선수 관리</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_goods')">굿즈샵 관리</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_board')">게시판 관리</a>
		</div>
	</div>
</body>
<script>
	//페이지 로드 시 체크박스 해제
	window.addEventListener('load', function() {
	const toggle = document.getElementById('toggle');
	toggle.checked = false; // 체크박스 해제
	});
	
	// 햄버거 메뉴
	document.getElementById('toggle').addEventListener('change', function() {
	    const menu = document.querySelector('.menu');
	    menu.classList.toggle('open');
	});
</script>
