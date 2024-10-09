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
	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	System.out.println("받은 teamNum: " + teamNum); // 디버깅 출력
	if (teamNum == 0) {
	    teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	    System.out.println("세션에서 가져온 teamNum: " + teamNum); // 디버깅 출력
	} else {
	    session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}

    // 팀 정보와 선수 명단 가져오기
    TeamBean teamInfo = teamMgr.getTeam(teamNum);
    HeadcoachMgr coachMgr = new HeadcoachMgr();
    Vector<HeadcoachBean> coachList = coachMgr.TeamHeadCoach(teamNum);
    
 // 디버깅 출력: 감독 리스트의 크기 확인
    System.out.println("감독 리스트 크기: " + coachList.size());
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>K-league</title>
    <link rel="stylesheet" href=".././assets/css/style.css">
    <link rel="stylesheet" href=".././assets/css/adminStyle.css">
    <script src=".././assets/js/main.js"></script>
</head>
<body>
<header class="header header_logo">
    <a style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
    <a href=".././sport/sport_main.jsp" style="margin-left: 20px; margin-right: 20px;">
    <img src=".././assets/images/sport_logo<%=teamInfo.getSPORT_NUM()%>.svg" alt="리그" id="league_logo_img"></a>
    <div style="position: absolute; left: 50%; transform: translateX(-50%);" class="img-box">
        <img src="<%=teamInfo.getLOGO() %>" alt="로고" class="team_logo_img">
    </div>
</header>
<div class="a_top">
    <div class="item" style="background-color: #083660;">
        <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_player')">선수 관리</a>
    </div>
    <div class="item" style="background-color: #236FB5;">
        <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_store')">굿즈샵</a>
    </div>
    <div class="item" style="background-color: #236FB5;">
        <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_board')">게시판</a>
    </div>
</div>

<div class="addplayer-box">
    <h2>감독 등록</h2>
    <form action="insert_coach.jsp" method="post" enctype="multipart/form-data">
        <input type="hidden" name="teamNum" value="<%= teamNum %>"> <!-- 팀 번호 숨은 필드 추가 -->
        <div class="addplayer-item">
            <label class="label" for="headcoachName">감독 이름</label>
            <input class="input" type="text" id="headcoachName" name="headcoachName" required>
        </div>
        <div class="addplayer-item file-box">
            <label class="label" for="headcoachImg">감독 이미지</label>
            <div class="file-box">
                <input class="upload-file" value="img_file" placeholder="첨부파일" readonly>
                <label id="file-label" for="file"></label>
                <input type="file" id="file" name="headcoachImg" required>
            </div>
        </div>
        <div class="addplayer-item">
            <input type="button" onclick="playerManager()" value="목록">
            <input type="submit" value="등록">
        </div>
    </form>
</div>

<script>
    function goMain(){
        document.location.href="mainPage.jsp";
    }
    
    function playerManager(){
        document.location.href="admin_player.jsp";
    }

    document.getElementById("file").addEventListener('change', function() {
        var fileName = this.files.length > 0 ? this.files[0].name : ''; // 선택된 파일의 이름
        document.querySelector(".upload-file").value = fileName; // .upload-file에 파일 이름 설정
    });
</script>
</body>
</html>