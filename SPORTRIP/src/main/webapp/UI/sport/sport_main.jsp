<%@page import="team.TeamBean"%> <%@page import="java.util.Vector"%> <%@page
import="DB.MUtil"%> <%@ page language="java" contentType="text/html;
charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:setProperty property="*" name="teamBean" />
<% 
	int sportNum = MUtil.parseInt(request, "sportNum"); 
	Vector<TeamBean> teamVlist = teamMgr.listTeam(sportNum); 
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SPORTRIP</title>
<link href=".././assets/css/style.css" rel="stylesheet" type="text/css">
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
				<a href="#" onclick="sendSportNum(<%=sportNum%>, 'sport_main')" style="margin-left: 20px; margin-right: 20px;"><img src=".././assets/images/sport_logo<%=sportNum%>.svg" alt="리그" id="league_logo_img"></a>
				<ul>
					<% for(int i = 0; i < teamVlist.size(); i++){
							teamBean = teamVlist.get(i);
					%>
							<li><a href="#" onclick="sendTeamNum(<%=teamBean.getTEAM_NUM()%>, '.././team/teamPage_Player')"><img src="<%=teamBean.getLOGO()%>" alt="<%=teamBean.getTEAM_NAME() %>" class="team_logo_img"></a></li>
					<%
						}
					%>
				</ul>
		</div>
	</header>
	
	<div class="top">
		<div class="item" style="background-color: #236FB5;">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'soccer_teamRank')">팀 순위</a>
		</div>
		<div class="item" style="background-color: #236FB5;">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'main_highlight')">하이라이트 경기</a>
		</div>
		<div class="item" style="background-color: #236FB5;">
			<a href="soccer_teamLeagueDate.html">경기 일정</a>
		</div>
	</div>
	
	<p>
	
	<div class="outer">
		<div class="inner-list">
			<div class="inner">
				<img src=".././assets/images/banner_img/banner_image1.png" alt="배너이미지1" id="banner_img">
			</div>
			<div class="inner">
				<img src=".././assets/images/banner_img/banner_image2.png" alt="배너이미지2" id="banner_img">
			</div>
			<div class="inner">
				<img src=".././assets/images/banner_img/banner_image3.png" alt="배너이미지3" id="banner_img">
			</div>
			<div class="inner">
				<img src=".././assets/images/banner_img/banner_image4.png" alt="배너이미지4" id="banner_img">
			</div>
			<div class="inner">
				<img src=".././assets/images/banner_img/banner_image5.png" alt="배너이미지5" id="banner_img">
			</div>
		</div>
		
		<div class="button-list">
			<button class="button-left">&lt;</button>
			<!-- '<' 기호 -->
			<button class="button-right">&gt;</button>
			<!-- '>' 기호 -->
		</div>
		<!-- 배너 인디케이터 -->
		<div class="indicator-list">
			<span class="indicator active"></span> 
			<span class="indicator"></span>
			<span class="indicator"></span> 
			<span class="indicator"></span> 
			<span class="indicator"></span>
		</div>
	</div>

	<script>
/*
  div 사이즈 동적으로 구하기
*/
        const outer = document.querySelector(".outer");
        const innerList = document.querySelector(".inner-list");
        const inners = document.querySelectorAll(".inner");
        let currentIndex = 0; // 현재 슬라이드 화면 인덱스

        inners.forEach((inner) => {
          inner.style.width = `${outer.clientWidth}px`; // inner의 width를 모두 outer의 width로 만들기
        });

        innerList.style.width = `${outer.clientWidth * inners.length}px`; // innerList의 width를 inner의 width * inner의 개수로 만들기

        const indicators = document.querySelectorAll(".indicator");

        // 인디케이터 업데이트 함수
        const updateIndicators = () => {
          indicators.forEach((indicator, index) => {
            indicator.classList.toggle("active", index === currentIndex);
          });
        };

        /*
		  버튼에 이벤트 등록하기
		*/
        const buttonLeft = document.querySelector(".button-left");
        const buttonRight = document.querySelector(".button-right");

        buttonLeft.addEventListener("click", () => {
          currentIndex--;
          if (currentIndex < 0) {
            currentIndex = inners.length - 1; // 첫 번째 배너를 넘어가면 마지막 배너로 돌아감
          }
          innerList.style.marginLeft = `-${outer.clientWidth * currentIndex}px`; // index만큼 margin을 주어 옆으로 밀기
          clearInterval(interval); // 기존 동작되던 interval 제거
          interval = getInterval(); // 새로운 interval 등록
          updateIndicators(); // 인디케이터 업데이트
        });

        buttonRight.addEventListener("click", () => {
          currentIndex++;
          if (currentIndex >= inners.length) {
            currentIndex = 0; // 마지막 배너를 넘어가면 첫 번째 배너로 돌아감
          }
          innerList.style.marginLeft = `-${outer.clientWidth * currentIndex}px`; // index만큼 margin을 주어 옆으로 밀기
          clearInterval(interval); // 기존 동작되던 interval 제거
          interval = getInterval(); // 새로운 interval 등록
          updateIndicators(); // 인디케이터 업데이트
        });

        /*
		  주기적으로 화면 넘기기
		*/
		const getInterval = () => {
		  return setInterval(() => {
		    currentIndex++;
		    if (currentIndex >= inners.length) {
		      currentIndex = 0; // 마지막 배너를 넘어가면 첫 번째 배너로 돌아감
		    }
		    innerList.style.marginLeft = `-${outer.clientWidth * currentIndex}px`;
		    updateIndicators(); // 인디케이터 업데이트
		  }, 2000);
		}
		
		let interval = getInterval(); // interval 등록
	</script>
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
	</script>
</body>
</html>