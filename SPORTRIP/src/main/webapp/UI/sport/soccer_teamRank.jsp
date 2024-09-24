<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>K-league Team Rank</title>
    <link rel="stylesheet" href="./assets/css/style.css">
    <script>
    	function goMain(){
    		document.location.href="mainPage.jsp";
    	}
    </script>
</head>
<body>
	<header class="header header_logo">
		<a style="cursor: pointer" onclick="goMain()"><img src="./assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
        <div class="league_info">
            <a href="soccer_main.html" style="margin-left: 50px;"><img src="./assets/images/k-league_logo.svg" alt="리그" id="league_logo_img"></a>
            <ul>
                <li>
                    <a href=""><img src="./assets/images/logo_img/1_강원.png" alt="강원" class="team_logo_img" title="강원"></a>
                </li>
                <li>
                    <a href="teamPage_Player.html"><img src="./assets/images/logo_img/2_울산HD.png" alt="울산" class="team_logo_img" title="울산"></a>
                </li>
                <li>
                    <a href=""><img src="./assets/images/logo_img/3_수원FC.png" alt="수원" class="team_logo_img" title="수원"></a>
                </li>
                <li>
                    <a href=""><img src="./assets/images/logo_img/4_김천상무.png" alt="김천" class="team_logo_img" title="김천"></a>
                </li>
                <li>
                    <a href=""><img src="./assets/images/logo_img/5_서울.png" alt="서울" class="team_logo_img" title="서울"></a>
                </li>
                <li>
                    <a href=""><img src="./assets/images/logo_img/6_포항.png" alt="포항" class="team_logo_img" title="포항"></a>
                </li>
                <li>
                    <a href=""><img src="./assets/images/logo_img/7_광주.png" alt="광주" class="team_logo_img" title="광주"></a>
                </li>
                <li>
                    <a href=""><img src="./assets/images/logo_img/8_제주.png" alt="제주" class="team_logo_img" title="제주"></a>
                </li>
                <li>
                    <a href=""><img src="./assets/images/logo_img/9_대전.png" alt="대전" class="team_logo_img" title="대전"></a>
                </li>
                <li>
                    <a href=""><img src="./assets/images/logo_img/10_인천.png" alt="인천" class="team_logo_img" title="인천"></a>
                </li>
                <li>
                    <a href=""><img src="./assets/images/logo_img/11_전북.png" alt="전북" class="team_logo_img" title="전북"></a>
                </li>
                <li>
                    <a href=""><img src="./assets/images/logo_img/12_대구.png" alt="대구" class="team_logo_img" title="대구"></a>
                </li>
            </ul>
        </div>
    </header>
    <div class="top">
        <div class="item" style="background-color: #083660;">
			<a href="soccer_teamRank.html">팀 순위</a>
		</div>
		<div class="item" style="background-color: #236FB5;">
			<a href="soccer_teamHighlight.html">하이라이트 경기</a>
		</div>
        <div class="item" style="background-color: #236FB5;">
            <a href="soccer_teamLeagueDate.html">경기 일정</a>
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
            <tbody> <!--  축구 2 -->
                <%
                    TeamMgr teamMgr = new TeamMgr();
                    Vector<TeamBean> teamList = teamMgr.TeamRank(2);
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
</body>
</html>