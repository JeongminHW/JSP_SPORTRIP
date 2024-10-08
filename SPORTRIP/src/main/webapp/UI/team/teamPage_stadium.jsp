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
	int teamNum = MUtil.parseInt(request, "teamNum");
	
	// 받은 값에 따라 팀 정보 가져오기
	TeamMgr teamMgr = new TeamMgr();
	StadiumMgr stadium = new StadiumMgr();
	
	// 팀, 경기장 정보 가져오기
	TeamBean teamInfo = teamMgr.getTeam(teamNum); // teamNum을 사용하여 팀 정보 조회    
	StadiumBean StadiumInfo = stadium.getStadium(teamNum);
%>
<jsp:include page="team_header.jsp" />
<div class="stadium-intro">
	<div class="stadium-img">
		<img alt=<%=StadiumInfo.getSTADIUM_NAME()%>
			src="<%=StadiumInfo.getSEATS()%>">
	</div>
	<div class="stadium-info">
		<div class="stadium-text">
			<span>명칭 : <%=StadiumInfo.getSTADIUM_NAME()%></span><br> <span>위치
				: <%=StadiumInfo.getSTADIUM_ADDRESS()%></span><br> <span>수용 인원
				: <%=StadiumInfo.getSEAT_CAPACITY_S()%>명
			</span><br>
		</div>
		<div class="climate-info">
			<button class="climate-button">날씨 정보 보기</button>
		</div>
	</div>
</div>
<script>
	// 스포츠 넘버 전송
	function sendSportNum(sportNum, page) {
		// 폼을 생성
		var form = document.createElement("form");
		form.setAttribute("method", "POST");
		form.setAttribute("action", `${ "${page}" }.jsp`);// 데이터를 보낼 경로

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
		const overlay = document.getElementById('overlay');

		menu.classList.toggle('open');
		overlay.classList.toggle('open');
	});

	// 클릭 시 메뉴 닫기
	overlay.addEventListener('click', function() {
		document.getElementById('toggle').checked = false; // 체크박스 해제
		const menu = document.querySelector('.menu');
		menu.classList.remove('open'); // 메뉴 숨김
		overlay.classList.remove('open'); // 배경 숨김
	});
</script>