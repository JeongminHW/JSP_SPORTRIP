<%@page import="player.PlayerBean"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="playerMgr" class="player.PlayerMgr" />
<%
    // POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
    int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
    if (teamNum == 0) {
        teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
    } else {
        session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
    }
     
	int playerNum = MUtil.parseInt(request, "playerNum", 0);
	PlayerBean playerBean = playerMgr.getPlayer(playerNum);
	
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
<script>
    function goMain(){
        document.location.href="mainPage.jsp";
    }
</script>
</head>
<body>
<header class="header header_logo">
    <a style="cursor: pointer" onclick="goMain()">
    <img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
    <a href="soccer_main.html" style="margin-left: 50px;">
    <img src=".././assets/images/k-league_logo.svg" alt="리그" id="league_logo_img"></a>
    <img style="width:80px;" src=".././assets/images/logo_img/2_울산HD.png" alt="울산" class="team_logo_img ulsan">
    <div class="login-signup-box">
        <ul>
            <li><a href="login.html" style="color: #000000;">로그인</a></li>
            <li><a href="signup.html" style="color: #000000;">회원가입</a></li>
        </ul>
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

    <div class="updateplayer-box">
        <h2>선수 수정</h2>
		<form action="updatePlayer.jsp" method="post" enctype="multipart/form-data">
		    <input type="hidden" name="playerNum" value="<%= playerNum %>">
		    <div class="updateplayer-item">
		        <label class="label" for="player_name">선수 이름</label>
		        <input class="input" type="text" id="player_name" name="player_name" value="<%= playerBean.getPLAYER_NAME() %>">
		    </div>
		    <div class="updateplayer-item">
		        <label class="label" for="player_position">선수 포지션</label>
		        <input class="input" type="text" id="player_position" name="player_position" value="<%= playerBean.getPOSITION() %>">
		    </div>
		    <div class="updateplayer-item">
		        <label class="label" for="player_backnum">선수 등번호</label>
		        <input class="input" type="text" id="player_backnum" name="player_backnum" value="<%= playerBean.getUNIFORM_NUM() %>">
		    </div>
		    <div class="updateplayer-item file-box">
		        <label class="label" for="player_img">선수 이미지</label>
		        <div class="file-box">
		            <input class="upload-file" placeholder="첨부파일" readonly>
		            <label id="file-label" for="file"></label>
		            <input type="file" id="file" name="player_img">
		        </div>
		    </div>
		    <div class="updateplayer-item">
		        <input type="button" onclick="playerManager()" value="목록">
		        <input type="hidden" id="player_num" name="player_num" value="<%= playerBean.getPLAYER_NUM() %>">
		        <input type="submit" value="수정">
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