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
	int sportNum =	(int)session.getAttribute("sportNum");	
	Vector<TeamBean> teamVlist = teamMgr.listTeam(sportNum); 
%>
<jsp:include page="sport_header.jsp"/>
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
