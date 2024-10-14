<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="headcoach.HeadcoachBean"%>
<%@page import="headcoach.HeadcoachMgr"%>
<%@page import="player.PlayerBean"%>
<%@page import="player.PlayerMgr"%>
<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />

<%
	// POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	if (teamNum == 0) {
		teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	} else {
		session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}
	
	// 팀 정보와 선수 명단 가져오기
	TeamBean teamInfo = teamMgr.getTeam(teamNum);
	PlayerMgr playerMgr = new PlayerMgr();
	Vector<PlayerBean> playerList = playerMgr.TeamPlayers(teamNum);
	
	HeadcoachMgr coachMgr = new HeadcoachMgr();
	Vector<HeadcoachBean> coachList = coachMgr.TeamHeadCoach(teamNum); // 수정된 부분
	
	Set<String> positionList = new HashSet<>();
	for (PlayerBean player : playerList) {
		positionList.add(player.getPOSITION());
	}
%>
<jsp:include page="../header.jsp" />
<!-- 감독 / 선수 -->
<div id="sub_wrap">
	<div class="u_top">
		<div class="item" id="coach">
			<a href="#" onclick="showCoaches()" data-value="감독">감독</a>
		</div>
		<div class="item" id="player">
			<a href="#" onclick="showPlayers()" data-value="선수">선수</a>
		</div>
	</div>
	<div id="coach-List">
        <% for (HeadcoachBean coach : coachList) { %>
            <div class="coach-card" data-coach-num="<%=coach.getHEADCOACH_NUM() %>">
                <img src="<%= coach.getHEADCOACH_IMG() %>" alt="<%= coach.getHEADCOACH_NAME() %>" class="coach-photo">
                <div class="coach-name">
                    <span><%= coach.getHEADCOACH_NAME() %></span>
                </div>
            </div>
        <% } %>
    </div>
</div>
<div class="players-section">
	<div id="player-List" style="display: none;">
		<!-- 포지션 버튼 생성 -->
		<div class="p_top">
			<% for (String position : positionList) { %>
			<div class="item" style="background-color: #FBFBFB;">
				<a href="#" onclick="filterByPosition('<%=position%>')"><%=position%></a>
			</div>
			<% } %>
		</div>
		<!-- 선수 리스트 -->
		<% for (PlayerBean player : playerList) { %>
		<div class="player-card" data-position="<%=player.getPOSITION()%>">
			<!-- 선수 사진 출력 -->
			<img src="<%=player.getPLAYER_IMG()%>"
				alt="<%=player.getPLAYER_NAME()%>" class="player-photo">
			<!-- 선수 이름, 나이 출력 -->
			<div class="player-name">
				<span> <%=player.getUNIFORM_NUM()%>
				</span>
				<%=player.getPLAYER_NAME()%>
			</div>
		</div>
		<% } %>
	</div>
</div>
<script src=".././assets/js/main.js"></script>