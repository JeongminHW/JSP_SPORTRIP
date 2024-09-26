<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html;
charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:setProperty property="*" name="teamBean" />
<%
int sportNum = MUtil.parseInt(request, "sportNum");
Vector<TeamBean> teamVlist = teamMgr.listTeam(sportNum);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>SPORTRIP</title>
<link href=".././assets/css/style.css" rel="stylesheet" type="text/css" />
<link href=".././assets/css/bannerStyle.css" rel="stylesheet"
	type="text/css" />
<script>
      function goMain() {
        document.location.href = "mainPage.jsp";
      }
    </script>
</head>
<body>
	<header class="header header_logo">
		<a style="cursor: pointer" onclick="goMain()"><img
			src=".././assets/images/sportrip_logo.png" alt="sportrip 로고"
			id="logo_img" /></a>
		<div class="league_info">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'sport_main')"
				style="margin-left: 20px; margin-right: 20px"><img
				src=".././assets/images/sport_logo<%=sportNum%>.svg" alt="리그"
				id="league_logo_img" /></a>
			<ul>
				<%
				if (teamVlist != null) {
					for (TeamBean team : teamVlist) {
				%>
				<li><a href="teamPage_Player.jsp"><img
						src="<%=team.getLOGO()%>" alt="<%=team.getTEAM_NAME()%>"
						class="team_logo_img" /></a></li>
				<%
				}
				}
				%>
			</ul>
		</div>
	</header>

	<div class="top">
		<div class="item" style="background-color: #236fb5">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'team_rank')">팀
				순위</a>
		</div>

		<div class="item" style="background-color: #236fb5">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'main_highlight')">하이라이트
				경기</a>
		</div>

		<div class="item" style="background-color: #236fb5">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'sport_matchDate')">경기
				일정</a>
		</div>
	</div>

	<p></p>
	<div class="slider">
		<div class="slide active">
			<img src=".././assets/images/banner_img/banner_image1.png"
				alt="이미지 1">
		</div>
		<div class="slide">
			<img src=".././assets/images/banner_img/banner_image2.png"
				alt="이미지 2">
		</div>
		<div class="slide">
			<img src=".././assets/images/banner_img/banner_image3.png"
				alt="이미지 3">
		</div>
		<div class="slide">
			<img src=".././assets/images/banner_img/banner_image4.png"
				alt="이미지 4">
		</div>
		<div class="slide">
			<img src=".././assets/images/banner_img/banner_image5.png"
				alt="이미지 5">
		</div>
		<div class="button-list">
			<button class="button-left">&lt;</button>
			<button class="button-right">&gt;</button>
		</div>
		<div class="indicator-list">
			<span class="indicator active"></span> <span class="indicator"></span>
			<span class="indicator"></span> <span class="indicator"></span> <span
				class="indicator"></span>
		</div>
	</div>

	<script>
	let currentSlide = 0;
	const slides = document.querySelectorAll('.slide');
	const slideCount = slides.length;
	const indicators = document.querySelectorAll('.indicator');

	function showSlide(n) {
	    // 슬라이드를 모두 숨기고 인디케이터 비활성화
	    slides.forEach((slide, index) => {
	        slide.classList.remove('active');
	        indicators[index].classList.remove('active');
	    });

	    // 현재 슬라이드와 인디케이터 활성화
	    slides[n].classList.add('active');
	    indicators[n].classList.add('active');
	}

	function nextSlide() {
	    currentSlide = (currentSlide + 1) % slideCount;
	    showSlide(currentSlide);
	}

	function prevSlide() {
	    currentSlide = (currentSlide - 1 + slideCount) % slideCount;
	    showSlide(currentSlide);
	}

	// 페이지 로딩 시 첫 번째 슬라이드 표시 및 3초마다 자동 슬라이드
	document.addEventListener('DOMContentLoaded', () => {
	    showSlide(currentSlide);
	    setInterval(nextSlide, 3000); // 3초마다 자동 슬라이드
	});

	// 버튼 클릭 시 슬라이드 전환
	document.querySelector('.button-right').addEventListener('click', nextSlide);
	document.querySelector('.button-left').addEventListener('click', prevSlide);

      </script>
	<script>
      function sendSportNum(sportNum, page) {
        // 폼을 생성
        var form = document.createElement("form");
        form.setAttribute("method", "POST");
        form.setAttribute("action", `${"${page}"}.jsp`); // 데이터를 보낼 경로

        // hidden input 생성하여 sportNum 값 전달
        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "sportNum");
        hiddenField.setAttribute("value", sportNum);

        form.appendChild(hiddenField);

        // 생성한 폼을 document에 추가한 후 제출
        document.body.appendChild(form);
        form.submit();
      }
    </script>
</body>
</html>
