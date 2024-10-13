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
	
	// teamNum을 사용하여 팀 정보 조회  
	TeamBean teamInfo = teamMgr.getTeam(teamNum);
%>
<jsp:include page="team_header.jsp" />
<div class="team-info-box">
	<img src="<%=teamInfo.getCLUBINFO()%>" alt="구단 소개">
</div>
<script>

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
	});

</script>