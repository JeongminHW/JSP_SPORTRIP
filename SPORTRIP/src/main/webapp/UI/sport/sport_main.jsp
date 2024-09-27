<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html;
charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:useBean id="teamSession" scope="session" class="team.TeamBean" />
<jsp:setProperty property="*" name="teamSession" />
<%
	int teamNum = 0;
	int sportNum = MUtil.parseInt(request, "sportNum", 0); // 폼에서 받은 값이 없으면 0
	if (sportNum == 0) {
		sportNum = (Integer) session.getAttribute("sportNum"); // 세션에서 팀 번호 가져오기
	} else {
	    session.setAttribute("sportNum", sportNum); // 세션에 팀 번호 저장
	}
	Vector<TeamBean> teamVlist = teamMgr.listTeam(sportNum);
%>
<jsp:include page="sport_header.jsp"/>
	<p>
	
	<div class="slider">
		<div class="slide active">
			<img src=".././assets/images/banner_img/banner_image1.png" alt="배너이미지 1">
		</div>
		<div class="slide">
			<img src=".././assets/images/banner_img/banner_image2.png" alt="배너이미지 2">
		</div>
		<div class="slide">
			<img src=".././assets/images/banner_img/banner_image3.png" alt="배너이미지 3">
		</div>
		<div class="slide">
			<img src=".././assets/images/banner_img/banner_image4.png" alt="배너이미지 4">
		</div>
		<div class="slide">
			<img src=".././assets/images/banner_img/banner_image5.png" alt="배너이미지 5">
		</div>
		<div class="button-list">
			<button class="button-left">&lt;</button>
			<button class="button-right">&gt;</button>
		</div>
		<div class="indicator-list">
			<span class="indicator active"></span> 
      <span class="indicator"></span>
			<span class="indicator"></span> 
      <span class="indicator"></span> 
      <span class="indicator"></span>
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
	
	// 팀 번호 전달
	function sendTeamNum(teamNum, page) {
	    // 세션에 값을 설정
	    var form = document.createElement("form");
	    form.setAttribute("method", "POST");
	    form.setAttribute("action", page + ".jsp");
	
	    var teamField = document.createElement("input");
	    teamField.setAttribute("type", "hidden");
	    teamField.setAttribute("name", "teamNum");
	    teamField.setAttribute("value", teamNum);
	    form.appendChild(teamField);
	
	    document.body.appendChild(form);
	    form.submit();
	}
	</script>
</body>
</html>
