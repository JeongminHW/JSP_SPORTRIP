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
	int sportNum = MUtil.parseInt(request, "sportNum", 0); // 폼에서 받은 값이 없으면 0
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SPORTRIP</title>
    <link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap" rel="stylesheet"/>
    <link href=".././assets/css/MainText.css" rel="stylesheet" type="text/css"/>
    <link href=".././assets/css/sportmainStyle.css" rel="stylesheet" type="text/css"/>
    <link href=".././assets/css/SportripLogo.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href=".././assets/css/mainhamburger.css">
  </head>
  <body>
    <a class="logo" style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/white_sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
    
    <div id="secondScreen">
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
    <div id="background" class="c_main">
		<div class="b_wrap">
			<img id="mainImage" src=".././assets/images/newpage_img.png">
		</div>
	
    <script>
    window.onload = function(){
    	const backImg = document.getElementById("mainImage");
    	const sportNum = <%=sportNum%>;
    	if(sportNum == 1){
        	backImg.src = ".././assets/images/baseball_img.png";
    	}
    	else if(sportNum == 2){
        	backImg.src = ".././assets/images/sportmain_img.png";
    	}
    	else if(sportNum == 3){
        	backImg.src = ".././assets/images/valleyball_img.png";
    	}
    }
    
    function sendSportNum(sportNum) {
        // 세션에 값을 설정
        var form = document.createElement("form");
        form.setAttribute("method", "POST");
        form.setAttribute("action", "mainPage2.jsp"); // 데이터를 보낼 경로

        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "sportNum");
        hiddenField.setAttribute("value", sportNum);
        form.appendChild(hiddenField);

        document.body.appendChild(form);
        form.submit();
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
    
	function goMain(){
		document.location.href="mainPage.jsp";
	}
  	
	// 페이지 로드 시 체크박스 해제
	window.addEventListener('load', function() {
    const toggle = document.getElementById('toggle');
    toggle.checked = false; // 체크박스 해제
	});
    
    // 햄버거 메뉴
    document.getElementById('toggle').addEventListener('change', function() {
        const menu = document.querySelector('.menu');
        menu.classList.toggle('open');
    });
    </script>
  </body>
</html>
