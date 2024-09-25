<%@page import="java.util.List"%>
<%@page import="matchdate.MatchdateBean"%>
<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="matchdateMgr" class="matchdate.MatchdateMgr" />
<jsp:useBean id="stadiumMgr" class="stadium.StadiumMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />

<% 
	int sportNum = MUtil.parseInt(request, "sportNum"); 	
	Vector<TeamBean> teamVlist = teamMgr.listTeam(sportNum); 
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Sport MatchDate</title>
<link rel="stylesheet" href=".././assets/css/style.css" />
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
				<% if(teamVlist != null){ 
        	  		for(TeamBean team : teamVlist){ 
          %>
				<li><a href="teamPage_Player.jsp"><img
						src="<%=team.getLOGO()%>" alt="<%=team.getTEAM_NAME() %>"
						class="team_logo_img" /></a></li>
				<% }} %>
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

	<div class="select-box">
		<select name="year" class="select year">
			<option value="0">년</option>
			<script>
          let year = new Date().getFullYear();
          for (let i = year; i > year - 12; i--) {
            document.write(`<option value="${i}">${i}</option>`);
          }
        </script>
		</select> <select name="month" class="select month">
			<option value="0">월</option>
			<script>
          let month = new Date().getMonth() + 1;
          for (let i = 1; i <= 12; i++) {
            document.write(`<option value="${i}">${i}</option>`);
          }
        </script>
		</select>
	</div>

	<div class="league-date-table">
		<table>
			<thead>
				<tr>
					<th>날짜</th>
					<th>시간</th>
					<th colspan="5">경기</th>
					<th colspan="2">장소</th>
				</tr>
			</thead>
			<tbody>
				<%
					Vector<MatchdateBean> matchdateVlist = matchdateMgr.listMachedate(sportNum);
					if(matchdateVlist != null){
						for(MatchdateBean matchDate : matchdateVlist){
							String team1[] = teamMgr.getTeamInfo(matchDate.getTEAM_NUM1());
							String team2[] = teamMgr.getTeamInfo(matchDate.getTEAM_NUM2());
				%>			
							<tr>
							<td><%=matchDate.getMATCH_DATE()%></td>
							<td>18:00</td>
							<td colspan="5">
								<img src="<%=team1[1]%>" alt=""/> <%=team1[0]%>
								<span style="margin-left:40px;">0 : 0</span>
								<img src="<%=team2[1]%>" alt="" /> <%=team2[0]%>
							</td>
							<td><%=matchdateMgr.getstadiumName(matchDate.getMATCH_DATE_NUM())%></td>
						</tr>

				<%
						}
					}
				%>

			</tbody>
		</table>
	</div>

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
