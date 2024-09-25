<%@page import="team.TeamMgr"%>
<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="teamMgr" class="team.TeamMgr"/>
<jsp:useBean id="teamBean" class="team.TeamBean"/>
<jsp:setProperty property="*" name = "teamBean"/>
<%
	int sportNum =	MUtil.parseInt(request, "sportNum");
	Vector<TeamBean> teamVlist = teamMgr.listTeam(sportNum);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>K-league Team Rank</title>
    <link rel="stylesheet" href=".././assets/css/style.css">
    <script>
    	function goMain(){
    		document.location.href="mainPage.jsp";
    	}
    </script>
</head>
<body>
	<header class="header header_logo">
		<a style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
		<div class="league_info">
				<a href="#" onclick="sendSportNum(<%=sportNum%>, 'sport_main')" style="margin-left: 20px; margin-right: 20px;"><img src="./assets/images/sport_logo<%=sportNum%>.svg" alt="리그" id="league_logo_img"></a>
				<ul>
					<% 
						if(teamVlist != null){
							for(TeamBean team : teamVlist){
					%>
							<li><a href="teamPage_Player.html"><img src="<%=team.getLOGO()%>" alt="<%=team.getTEAM_NAME() %>" class="team_logo_img"></a></li>
					<%
						}}
					%>
				</ul>
		</div>
	</header>
	
	<div class="top">
		<div class="item" style="background-color: #236FB5;">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'team_rank')">팀 순위</a>
		</div>
		<div class="item" style="background-color: #236FB5;">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'main_highlight')">하이라이트 경기</a>
		</div>
		<div class="item" style="background-color: #236FB5;">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'sport_matchDate')">경기 일정</a>
		</div>
	</div>

    <div class="rank-table">
        <table>
            <thead>
                <tr>
                    <th>순위</th>
                    <th>팀</th>
                    <th>경기</th>
                    <th>승점</th>
                    <th>승</th>
                    <th>무</th>
                    <th>패</th>
                    <th>득점</th>
                    <th>실점</th>
                </tr>
            </thead>
            <tbody>
                <%
                    teamMgr = new TeamMgr();
                    Vector<TeamBean> teamList = teamMgr.TeamRank(sportNum);
                    if (teamList != null) {
                        for (TeamBean team : teamList) {
                %>
			                <tr>
			                    <td><%= team.getRANKING() %></td>
			                    <td><img src="<%= team.getLOGO()%>" alt=""><%= team.getTEAM_NAME() %></td>
			                    <td><%= team.getGAME() %></td>
			                    <td><%= team.getPOINT() %></td>
			                    <td><%= team.getWIN() %></td>
			                    <td><%= team.getDRAW() %></td>
			                    <td><%= team.getLOSS() %></td>
			                    <td><%= team.getWIN_POINT() %></td>
			                    <td><%= team.getLOSS_POINT() %></td>
			                </tr>
                <%
                        }
                    } else {
                        out.println("<tr><td colspan='9'>데이터가 없습니다.</td></tr>");
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
	    form.setAttribute("action",  `${ "${page}" }.jsp`);// 데이터를 보낼 경로
	    
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