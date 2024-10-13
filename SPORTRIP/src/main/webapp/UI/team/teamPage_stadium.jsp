<%@page import="stadium.StadiumBean"%>
<%@page import="stadium.StadiumMgr"%>
<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="teammgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:setProperty property="*" name="teamBean" />

<%
	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	if (teamNum == 0) {
		teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	} else {
		session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}

	
	// 받은 값에 따라 팀 정보 가져오기
	TeamMgr teamMgr = new TeamMgr();
	StadiumMgr stadium = new StadiumMgr();
	
	// 팀, 경기장 정보 가져오기
	TeamBean teamInfo = teamMgr.getTeam(teamNum); // teamNum을 사용하여 팀 정보 조회    
	StadiumBean StadiumInfo = stadium.getStadium(teamNum);
%>
<jsp:include page="team_header.jsp" />
<div class="stadium-intro">
	<div class="stadium-info">
		<div class="climate-info">
			<div class="climate-infoDetail">
	          <img id="weather-img" />
			</div>
			  <span id="weather-temp"></span>
		</div>
		<div class="stadium-text">
			<p id="stadium-name"><%=StadiumInfo.getSTADIUM_NAME()%></p>
			<span>위치 : <%=StadiumInfo.getSTADIUM_ADDRESS()%></span><br> 
			<span>수용 인원 : <%=StadiumInfo.getSEAT_CAPACITY_S()%>명
			</span><br>
		</div>
	</div>
	<div class="stadium-img">
		<img alt=<%=StadiumInfo.getSTADIUM_NAME()%>
			src="<%=StadiumInfo.getSEATS()%>">
	</div>

</div>
<script>

	const weatherIconImg = document.querySelector("#weather-img");
	const weather_KEY = '55d0f0b2f63264b3079894777e5ff4b4';
	const lat = <%=StadiumInfo.getLAT()%>
	  const lon = <%=StadiumInfo.getLON()%>
	  const url = `https://api.openweathermap.org/data/2.5/weather?lat=${"${lat}"}&lon=${"${lon}"}&appid=${"${weather_KEY}"}&units=metric&lang=kr`;
	  fetch(url) 
	    .then((response) => response.json())
	    .then((data) => {
	      const weatherIcon = data.weather[0].icon;
	      const iconURL = `http://openweathermap.org/img/wn/${"${weatherIcon}"}@2x.png`;
	
	      weatherIconImg.setAttribute('src', iconURL);
	      const weather = document.querySelector("#weather-temp");
	      weather.innerText = `${"${data.main.temp}"}°C`;
	    });

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

	// 페이지 로드 시 체크박스 해제
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