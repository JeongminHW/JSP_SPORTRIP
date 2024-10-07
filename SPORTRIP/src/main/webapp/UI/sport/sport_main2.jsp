<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:useBean id="teamSession" scope="session" class="team.TeamBean" />
<jsp:setProperty property="*" name="teamSession" />
<%
	int teamNum = 0;
/* 	int sportNum = MUtil.parseInt(request, "sportNum", 0); // 폼에서 받은 값이 없으면 0 */
	int sportNum = 2;
	if (sportNum == 0) {
		sportNum = (Integer) session.getAttribute("sportNum"); // 세션에서 팀 번호 가져오기
	} else {
	    session.setAttribute("sportNum", sportNum); // 세션에 팀 번호 저장
	}
	Vector<TeamBean> teamVlist = teamMgr.listTeam(sportNum);
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <link href=".././assets/css/sports_main2.css" rel="stylesheet" type="text/css"/>
  </head>
  <body>
    	<section class="first_page" style="background-color: aqua; height: 100vh">
	      <div id="header" class="c_main">
	        <div class="h_wrap">
	          <nav class="h_gnb">
	            <div class="hg_list">
	              <ul>
	                <li class="rank">
	                  <a href=".././sport/team_rank.jsp">
	                    <span>Rank</span>
	                  </a>
	                </li>
	                <li class="highlight">
	                  <a href=".././sport/main_highlight.jsp">
	                    <span>Highlight</span>
	                  </a>
	                </li>
	                <li class="matchdate">
	                  <a href=".././sport/sport_matchDate.jsp">
	                    <span>MatchDate</span>
	                  </a>
	                </li>
	              </ul>
	            </div>
	          </nav>
	          <input id="toggle" type="checkbox"/>
	        	<label class="hamburger" for="toggle">
	            <div class="top"></div>
	            <div class="middle"></div>
	            <div class="bottom"></div>
	        	</label>
	        </div>
	      </div>
	      <div class="menu">
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
	                <li class="menu-item"><a href="#"><span>팀 선택<span></a>
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
    </section>
    <section class="second_page" style="background-color: aquamarine; height: 100vh"></section>
    <section class="third_page" style="background-color: bisque; height: 100vh"></section>
  </body>

<script type="text/javascript">
</script>
</html>