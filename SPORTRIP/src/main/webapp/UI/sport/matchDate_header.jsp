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
<link href=".././assets/css/mainhamburger.css" rel="stylesheet" type="text/css" />
<link href=".././assets/css/highlightStyle.css" rel="stylesheet" type="text/css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
	function goMain(){
		document.location.href="mainPage.jsp";
	}
</script>
</head>
<body>
	<header class="header">
		<a style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/white_sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
		<div class="header-view">
			<div class="item">
				<a href=".././sport/team_rank.jsp">Rank</a>
			</div>
			<div class="item">
				<a href=".././sport/main_highlight.jsp">Highlight</a>
			</div>
			<div class="item">
				<a href=".././sport/sport_matchDate.jsp">MatchDate</a>
			</div>
		</div>
		<input id="toggle" type="checkbox"/>
        	<label class="hamburger" for="toggle">
            <div class="top"></div>
            <div class="middle"></div>
            <div class="bottom"></div>
        	</label>
	</header>
	<div class="menu" style="position:fixed; z-index: 2;">
        <nav>
            <ul class="menu-list">
                <li class="menu-item">
                	<a href="#"><span>스포츠</span></a>
                    <ul>
                        <li class="baseball"><a href="#" onclick="sendSportNum(1)"><span>야구</span></a></li>
                        <li class="soccer"><a href="#" onclick="sendSportNum(2)"><span>축구</span></a></li>
                        <li class="volleyball"><a href="#" onclick="sendSportNum(3)"><span>배구</span></a></li>
                    </ul>
                </li>
                <li class="menu-item"><a href="#"><span>리그 정보<span></a>
                    <ul>
                    	<li class="trip"><a href=".././trip/tripPage_Hotel.jsp"><span>팀 순위</span> </a></li>
                    	<li class="trip"><a href=".././trip/tripPage_Food.jsp"><span>하이라이트</span> </a></li>
                    	<li class="trip"><a href=".././trip/tripPage_Food.jsp"><span>경기 일정</span> </a></li>
                    </ul>
                </li>
                <li class="menu-item"><a href="#"><span>팀<span></a>
                    <ul>
                    	<% for(int i = 0; i < teamVlist.size(); i++){
							teamBean = teamVlist.get(i);
							teamNum = teamBean.getTEAM_NUM();
						%>
							<li><a href="#" onclick="sendTeamNum(<%=teamNum%>, '.././team/teamPage_player')"><span><%=teamBean.getTEAM_NAME()%></span></a></li>
						<%
							}
						%>
                    </ul>
                </li>
                <li class="menu-item"><a href="#">여행</a>
                    <ul>
						<li id="login"><a href=".././trip/tripPage_Hotel.jsp"><span>숙박</span></a></li>
						<li id="signup"><a href=".././trip/tripPage_Food.jsp"><span>식당</span></a></li>
                    </ul>
                </li>
                <li class="menu-item"><a href="#">회원정보</a>
                    <ul>
						<li id="login"><a href=".././user/login.jsp"><span>로그인</span></a></li>
						<li id="signup"><a href=".././user/signup.jsp"><span>회원가입</span></a></li>
                        <li><a href=".././md/shoppingPage_basket.jsp"><span>장바구니</span></a></li>
                        <li><a href=".././user/myPage.html"><span>마이페이지</span></a></li>
                    </ul>
                </li>
            </ul>
        </nav>
    </div>