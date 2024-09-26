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

<jsp:useBean id="teammgr" class="team.TeamMgr"/>
<jsp:useBean id="teamBean" class="team.TeamBean"/>
<jsp:setProperty property="*" name = "teamBean"/>
<%
    /* int sportNum = MUtil.parseInt(request, "sportNum"); */
    int teamNum = MUtil.parseInt(request, "teamNum");
    
    // 받은 값에 따라 팀 정보 가져오기
    TeamMgr teamMgr = new TeamMgr();
    PlayerMgr playerMgr = new PlayerMgr();
    HeadcoachMgr coachMgr = new HeadcoachMgr();
    
    // 팀 정보와 선수 명단 가져오기
    TeamBean teamInfo = teamMgr.getTeam(teamNum);  // teamNum을 사용하여 팀 정보 조회
    Vector<PlayerBean> playerList = playerMgr.TeamPlayers(teamNum);  // teamNum을 사용하여 해당 팀의 선수 명단 조회
    HeadcoachBean coachList = coachMgr.getHeadcoach(teamNum);
    
    Set<String> positionList = new HashSet<>();
    for (PlayerBean player : playerList) {
        positionList.add(player.getPOSITION());  // 포지션을 중복 없이 Set에 추가
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=teamInfo.getTEAM_NAME() %></title>
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
	    <a href="#" onclick="sendSportNum(<%=teamInfo.getSPORT_NUM()%>, '.././sport/sport_main')" style="margin-left: 20px; margin-right: 20px;">
	    <img src=".././assets/images/sport_logo<%=teamInfo.getSPORT_NUM()%>.svg" alt="리그" id="league_logo_img"></a>
	    <div style="position: absolute; left: 50%; transform: translateX(-50%);" class="img-box">
        <img src="<%=teamInfo.getLOGO() %>" alt="로고" class="team_logo_img">
    </div>
</header>
    <div class="t_top">
        <div class="item" style="background-color: #083660;">
            <a href="#" onclick="sendTeamNum(<%=teamInfo.getTEAM_NUM()%>, 'teamPage_Player')">선수 명단</a>
        </div>
		    <div class="item" style="background-color: #236FB5;">
			    <a href="#" onclick="sendTeamNum(<%=teamInfo.getTEAM_NUM()%>, 'teamPage_Stadium')">경기장 소개</a>
		    </div>
		    <div class="item" style="background-color: #236FB5;">
			    <a href="teamPage_teamIntro.html">구단 소개</a>
		    </div>
		    <div class="item" style="background-color: #236FB5;">
			    <a href="teamPage_teamHighlight.html">하이라이트 경기</a>
		    </div>
		    <div class="item" style="background-color: #236FB5;">
			    <a href="teamPage_Store.html">굿즈샵</a>
		    </div>
		    <div class="item" style="background-color: #236FB5;">
			    <a href="teamPage_Board.html">게시판</a>
		</div>
	</div>
	
	<!-- 감독 / 선수 -->
	<div id="sub_wrap">
		<div class="u_top">
			<div class="item" style="background-color: #236FB5;">
				<a href="#" onclick="showCoaches()">감독</a>
			</div>
			<div class="item" style="background-color: #083660;">
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
		// 스포츠 넘버 전송
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
		
	  	function sendTeamNum(teamNum, page) {
		    // 폼을 생성
		    var form = document.createElement("form");
		    form.setAttribute("method", "POST");
		    form.setAttribute("action",  `${ "${page}" }.jsp`);// 데이터를 보낼 경로
		    
		    // hidden input 생성하여 sportNum 값 전달
		    var hiddenField = document.createElement("input");
		    hiddenField.setAttribute("type", "hidden");
		    hiddenField.setAttribute("name", "teamNum");
		    hiddenField.setAttribute("value", teamNum);
		    
		    form.appendChild(hiddenField);
		
		    // 생성한 폼을 document에 추가한 후 제출
		    document.body.appendChild(form);
		    form.submit();
		  }
	  
	  	// 선수 출력
	  	function showPlayers() {
        	document.getElementById('player-List').style.display = 'block';
        	document.getElementById('coach-List').style.display = 'none';
    	}
		
	  	// 감독 출력
    	function showCoaches() {
        	document.getElementById('player-List').style.display = 'none';
        	document.getElementById('coach-List').style.display = 'block';
	    }
    	// 포지션에 따라 선수 필터링
        function filterByPosition(position) {
            var playerCards = document.querySelectorAll('.player-card');
            playerCards.forEach(function(card) {
                if (card.getAttribute('data-position') === position) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
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
