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
    HeadcoachBean coachList = coachMgr.getHeadcoach(teamNum);

    Set<String> positionList = new HashSet<>();
    for (PlayerBean player : playerList) {
        positionList.add(player.getPOSITION());
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title><%=teamInfo.getTEAM_NAME() %></title>
	<link rel="stylesheet" href=".././assets/css/style.css">
	<link rel="stylesheet" href=".././assets/css/adminStyle.css">
</head>
<body>
<header class="header header_logo">
		<a style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
	    <a href=".././sport/sport_main.jsp" style="margin-left: 20px; margin-right: 20px;">
	    <img src=".././assets/images/sport_logo<%=teamInfo.getSPORT_NUM()%>.svg" alt="리그" id="league_logo_img"></a>
	    <div style="position: absolute; left: 50%; transform: translateX(-50%);" class="img-box">
	        <img src="<%=teamInfo.getLOGO() %>" alt="로고" class="team_logo_img">
    	</div>
</header>
    <div class="t_top">
        <div class="item" style="background-color: #083660;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_player')">선수 명단</a>
        </div>
	    <div class="item" style="background-color: #236FB5;">
		    <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_stadium')">경기장 소개</a>
	    </div>
	    <div class="item" style="background-color: #236FB5;">
		    <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_teamintro')">구단 소개</a>
	    </div>
	    <div class="item" style="background-color: #236FB5;">
           <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_highlight')">하이라이트 경기</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_store')">굿즈샵</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_board')">게시판</a>
		</div>
	</div>
	
	<!-- 감독 / 선수 -->
	<div id="sub_wrap">
		<div class="u_top">
			<div class="item" style="background-color: #083660;" id="coach">
				<a href="#" onclick="showCoaches()">감독</a>
			</div>
			<div class="item" style="background-color: #236FB5;" id="player">
				<a href="#" onclick="showPlayers()">선수</a>
			</div>
		</div>
		<div id="coach-List" >
               <div class="coach-card">
               	<!-- 감독 사진 출력 -->
                   <img src="<%=coachList.getHEADCOACH_IMG() %>" alt="<%=coachList.getHEADCOACH_NAME() %>" class="coach-photo">
                   <!-- 감독 이름 출력 -->
                   <div class="coach-name">
                       <span> <%=coachList.getHEADCOACH_NAME() %> </span>
                   </div>
               </div>
	    </div>
	    
		<div class="update-player">
			<button class="update-btn">삭제하기</button>
			<button class="update-btn">등록하기</button>
		</div>
	    <div class="players-section">
	    	<div id="player-List" style="display: none;">
	    	<!-- 포지션 버튼 생성 -->
		    <div class="p_top">
		        <% for (String position : positionList) { %>
		            <div class="item" style="background-color: #236FB5;">
		                <a href="#" onclick="filterByPosition('<%=position%>')"><%= position %></a>
		            </div>
		        <% } %>
		    </div>
	    	<!-- 선수 리스트 -->
    		<% for (PlayerBean player : playerList) { %>
            <div class="player-card" data-position="<%= player.getPOSITION() %>">
                <!-- 선수 사진 출력 -->
                <img src="<%=player.getPLAYER_IMG() %>" alt="<%=player.getPLAYER_NAME() %>" class="player-photo">
                <!-- 선수 이름, 나이 출력 -->
                <div class="player-name">
                    <span> <%=player.getPLAYER_NUM() %> </span> <%=player.getPLAYER_NAME() %>
            	</div>
            </div>
            <% } %>
        	</div>
	    </div>
    </div>
	<script>
	 	function goMain(){
	        document.location.href=".././sport/mainPage.jsp";
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
	  	// 선수 출력
	  	function showPlayers() {
        	document.getElementById('player-List').style.display = 'block';
        	document.getElementById('coach-List').style.display = 'none';
        	document.getElementById('player').style.backgroundColor = '#083660'; 
        	document.getElementById('coach').style.backgroundColor = '#236FB5'; 
        	var playerCards = document.querySelectorAll('.player-card');
            playerCards.forEach(function(card) {
            	card.style.display = 'inline-block';
            });
    	}
		
	  	// 감독 출력
    	function showCoaches() {
        	document.getElementById('player-List').style.display = 'none';
        	document.getElementById('coach-List').style.display = 'block';
        	document.getElementById('player').style.backgroundColor = '#236FB5'; 
        	document.getElementById('coach').style.backgroundColor = '#083660'; 
	    }
	  	
    	// 포지션에 따라 선수 필터링
        function filterByPosition(position) {
            var playerCards = document.querySelectorAll('.player-card');
            var positionItems  = document.querySelectorAll('.p_top .item');  // 포지션 버튼 선택
            
            // 선수 카드 필터링
            playerCards.forEach(function(card) {
                if (card.getAttribute('data-position') === position) {
                    card.style.display = 'inline-block';
                } else {
                    card.style.display = 'none';
                }
            });
         	// 이전 선택된 버튼에서 'selected-item' 클래스 제거
            positionItems.forEach(function(item) {
            	item.classList.remove('selected-item');
            });
            // 현재 클릭한 버튼에 'selected-item' 클래스 추가
            var currentItem = event.target.parentElement;   // 현재 클릭한 버튼
            currentItem.classList.add('selected-item');
        }

        // 모든 선수 보여주기 (초기 상태)
        function showAllPlayers() {
            var playerCards = document.querySelectorAll('.player-card');
            playerCards.forEach(function(card) {
                card.style.display = 'block';
            });
        }
	  </script>
</body>
</html>
