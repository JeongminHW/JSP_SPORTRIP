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

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SPORTRIP</title>
<link href=".././assets/css/style.css" rel="stylesheet" type="text/css">
<link href=".././assets/css/bannerStyle.css" rel="stylesheet" type="text/css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
	function goMain(){
		document.location.href="mainPage.jsp";
	}
</script>
</head>
<body>
	<header class="header">
		<a style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
		<div class="header-view">
			<div class="item">
				<a href=".././sport/team_rank.jsp"><img src=".././assets/images/rank_img.png">구단 순위</a>
			</div>
			<div class="item">
				<a href=".././sport/main_highlight.jsp"><img src=".././assets/images/star_img.png">하이라이트 경기</a>
			</div>
			<div class="item">
				<a href=".././sport/sport_matchDate.jsp"><img src=".././assets/images/schedule_img.png">경기 일정</a>
			</div>
		</div>
	</header>
	<div class="league_info">
				<a href="sport_main.jsp"><img src=".././assets/images/sport_logo<%=sportNum%>.svg" alt="리그" id="league_logo_img"></a>
				<ul>
					<% for(int i = 0; i < teamVlist.size(); i++){
							teamBean = teamVlist.get(i);
							teamNum = teamBean.getTEAM_NUM();
					%>
<%-- 						<li><a href="#" onclick="sendTeamAndSport(<%=sportNum%>, <%=teamBean.getTEAM_NUM()%>)"><img src="<%=teamBean.getLOGO()%>" alt="<%=teamBean.getTEAM_NAME() %>" class="team_logo_img"></a></li> --%>
							<li><a href="#" onclick="sendTeamNum(<%=teamNum%>, '.././team/teamPage_Player')"><img src="<%=teamBean.getLOGO()%>" alt="<%=teamBean.getTEAM_NAME() %>" class="team_logo_img"></a></li>
					<%
						}
					%>
				</ul>
		</div>