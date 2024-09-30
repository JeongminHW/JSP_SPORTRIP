<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>K-league</title>
<link rel="stylesheet" href=".././assets/css/style.css">
<link rel="stylesheet" href=".././assets/css/adminStyle.css">
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
    <div class="t_top">
        <div class="item" style="background-color: #083660;">
            <a href="">선수 명단</a>
        </div>
		<div class="item" style="background-color: #236FB5;">
			<a href="teamPage_Stadium.html">경기장 소개</a>
		</div>
		<div class="item" style="background-color: #236FB5;">
			<a href="teamPage_teamIntro.html">구단 소개</a>
		</div>
		<div class="item" style="background-color: #236FB5;">
			<a href="teamPage_teamHighlight.html">하이라이트 경기</a>
		</div>
		<div class="item" style="background-color: #236FB5;">
			<a href="teamPage_Store.html">굿즈샵</a>
		</div>
    </div>

    <div class="addplayer-box">
        <h2>선수 등록</h2>
        <form action="" method="post">
            <div class="addplayer-item">
                <label for="player_name">선수 이름</label>
                <input type="text" id="player_name" name="player_name">
            </div>
            <div class="addplayer-item">
                <label for="player_number">선수 번호</label>
                <input type="text" id="player_number" name="player_number">
            </div>
            <div class="addplayer-item">
                <label for="player_position">선수 포지션</label>
                <input type="text" id="player_position" name="player_position">
            </div>
            <div class="addplayer-item">
                <label for="player_backnum">선수 등번호</label>
                <input type="text" id="player_backnum" name="player_backnum">
            </div>
            <div class="addplayer-item">
                <label for="player_img">선수 이미지</label>
                <input type="file" id="player_img" name="player_img">
            </div>
            <div class="addplayer-item">
                <input type="submit" value="등록하기">
            </div>
    </div>
</body>
</html>