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

%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>K-league</title>
<link rel="stylesheet" href=".././assets/css/adminStyle.css">
<script src=".././assets/js/main.js"></script>
<script>
    function goMain(){
        document.location.href="mainPage.jsp";
    }
</script>
</head>
<body>
	<div id="background" class="c_main">
		<div class="b_wrap">
			<img alt="" src=".././assets/images/main_page_img.png">
		</div>
	</div>
	<div class="popup-background">
		<div class="popup">
			<div class="addplayer-box">
				<div class="file-box">
				    <!-- 플레이어 이미지 업로드 섹션 -->
					<img id="playerImg" src=".././assets/images/default_player.png" alt="Player Image">
					<label id="file-label" for="file">이미지 업로드</label>
	                <input type="file" id="file" name="playerImg">
				</div>
				<div class="player-info-box">
					<form action="" method="post" enctype="multipart/form-data">
					    <div class="addplayer-item">
					        <label class="label" for="playerName">선수명</label>
					        <input class="input" type="text" id="playerName" name="playerName">
					    </div>
			            <div class="addplayer-item">
			                <label class="label" for="playerPosition">포지션</label>
			                <input class="input" type="text" id="playerPosition" name="playerPosition">
			            </div>
					    <div class="addplayer-item">
					        <label class="label" for="playerBirthday">생년월일</label>
					        <input class="input" type="text" id="playerBirthday" name="playerBirthday">
					    </div>
			            <div class="addplayer-item"  style="margin-bottom: 60px;">
			                <label class="label" for="playerBacknum">등번호</label>
			                <input class="input" type="text" id="playerBacknum" name="playerBacknum">
			            </div>
						<div class="addplayer-item">
							<input type="button" onclick="playerManager()" value="돌아가기">
							<input type="button" onclick="insertPlayer()" value="선수 등록">
						</div>
					</form>
			    </div>	
			</div>
		</div>
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
	    
	    function insertPlayer() {
	        let playerName = document.getElementById('playerName').value;
	        let playerPosition = document.getElementById('playerPosition').value;
	        let playerBacknum = document.getElementById('playerBacknum').value;
	        let playerImg = document.getElementById('file').files[0]; // Get the file from the input
	        let teamNum = <%=teamNum%>;

	        const formData = new FormData();
	        formData.append('teamNum', teamNum);
	        formData.append('playerName', playerName);
	        formData.append('playerPosition', playerPosition);
	        formData.append('playerBacknum', playerBacknum);
	        formData.append('playerImg', playerImg); // Add the file to FormData

	        fetch('insert_player.jsp', {
	            method: 'POST',
	            body: formData // Use FormData as body
	        })
	        .then(response => response.text())
	        .then(data => {
	            if (data.includes("success")) { 
	                alert('선수 등록이 완료되었습니다.');
	                location.href = "admin_player.jsp"; 
	            } else {
	                alert('선수 등록이 되지 않았습니다.');
	            }
	        })
	        .catch(error => console.error('Error:', error));
	    }
	</script>
</body>
</html>