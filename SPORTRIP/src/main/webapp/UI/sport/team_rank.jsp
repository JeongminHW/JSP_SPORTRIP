<%@page import="team.TeamMgr"%>
<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="teamMgr" class="team.TeamMgr"/>
<jsp:useBean id="teamBean" class="team.TeamBean"/>
<jsp:setProperty property="*" name = "teamBean"/>
<%
	int sportNum =	(int)session.getAttribute("sportNum");
	Vector<TeamBean> teamVlist = teamMgr.listTeam(sportNum);
%>
<jsp:include page="sport_header.jsp"/>
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