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
	
	String teamName = teamInfo.getTEAM_NAME();
	int sportNum = (int)session.getAttribute("sportNum");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=teamInfo.getTEAM_NAME()%></title>
<link rel="stylesheet" href=".././assets/css/style.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
	<header class="header header_logo">
		<a style="cursor: pointer" onclick="goMain()"><img
			src=".././assets/images/sportrip_logo.png" alt="sportrip 로고"
			id="logo_img"></a> <a href=".././sport/sport_main.jsp"
			style="margin-left: 20px; margin-right: 20px;"> <img
			src=".././assets/images/sport_logo<%=teamInfo.getSPORT_NUM()%>.svg"
			alt="리그" id="league_logo_img"></a>
		<div
			style="position: absolute; left: 50%; transform: translateX(-50%);"
			class="img-box">
			<img src="<%=teamInfo.getLOGO()%>" alt="로고" class="team_logo_img">
		</div>
	</header>
	    <div class="t_top">
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_player')">선수 명단</a>
        </div>
	    <div class="item" style="background-color: #236FB5;">
		    <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_stadium')">경기장 소개</a>
	    </div>
	    <div class="item" style="background-color: #236FB5;">
		    <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_teamintro')">구단 소개</a>
	    </div>
	    <div class="item" style="background-color: #083660;">
           <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_highlight')">하이라이트 경기</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_store')">굿즈샵</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_board')">게시판</a>
		</div>
	</div>
	<div class="highlight-container">
		<script type="text/javascript">
	        function goMain(){
	            document.location.href="mainPage.jsp";
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
	     
	        const sportNum = <%=sportNum%>;
	
	        var searchteamName = encodeURI("<%=teamName%>");
	        var pageSize = 0;
	        if(sportNum == 1){
	        	searchData = searchteamName + "KBO%ED%95%98%EC%9D%B4%EB%9D%BC%EC%9D%B4%ED%8A%B8&";
	        	pageSize = 12;
	        }
	        else if(sportNum == 2){
	        	searchData =  searchteamName + "K%EB%A6%AC%EA%B7%B81%20%ED%95%98%EC%9D%B4%EB%9D%BC%EC%9D%B4%ED%8A%B8&";
	        	pageSize = 24;
	        }
	        else if(sportNum == 3){
	        	searchData =  searchteamName + "kobo%EC%97%AC%EC%9E%90%EB%B0%B0%EA%B5%AC%ED%95%98%EC%9D%B4%EB%9D%BC%EC%9D%B4%ED%8A%B8&";
	        	pageSize = 12;
	        }

            $(document).ready(function() {
	          	const apiurl = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&"
	          		+ "maxResults="+ pageSize +"&order=date&"
	          		+ "q="+ searchData
	          		+ "type=video&"
	          		+ "videoDuration=medium&"
	          		+ "key=AIzaSyADuItf8mzFqwyrWiWKYs89YaWA7TuwdWs";
	
	            function convertUTCToKST(utcStr) {
	                const date = new Date(utcStr);
	                    const offset = 9 * 60; 
	                    const localDate = new Date(date.getTime() + offset * 60000);
	                    localDate.setDate(localDate.getDate() - 1); // 하루를 빼기
	    
	                    const yyyy = localDate.getFullYear();
	                    const mm = String(localDate.getMonth() + 1).padStart(2, '0');
	                    const dd = String(localDate.getDate()).padStart(2, '0');
	                    return `${ "${yyyy}" }-${ "${mm}" }-${ "${dd}" }`;
              }
      
              function truncateTitle(title) {
                      const separatorIndex = title.indexOf('|');
                      if (separatorIndex !== -1) {
                          return title.substring(0, separatorIndex).trim();
                      }
                      return title;
              }
              
              $.ajax({
               type: "GET",
               dataType: "json",
               url: apiurl,
               contentType : "application/json",
               success : function(data) {
                   let divCount = 0; 

                   data.items.forEach(function(element, index) {
                       const title = element.snippet.title;
                       const publishedDate = convertUTCToKST(element.snippet.publishedAt);
                       const truncatedTitle = truncateTitle(title);
					   var team = "<%=teamName%>".split(" ");
                          if (divCount >= 12) {
                              return; 
                          }
                          if (title.includes(team[0]) && team[1] != "서울") {
                          	if(sportNum == 2){
                                  if (title.includes("K리그1")) {
                                  	$('.highlight-container').append('<div class="highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');   
                						divCount++;
                                  } 	
  							}
                          	else{
                          		$('.highlight-container').append('<div class="highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');   
  								divCount++; 
                          	}
                          }
                          
                         	if (title.includes(team[1]) && team[1] == "서울"){
                                 if (title.includes("K리그1")) {
                                 	$('.highlight-container').append('<div class="highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');   
               						divCount++;
                                 } 	
                          }
                      });
                  },
                  complete : function(data) {
                  },
                  error : function(xhr, status, error) {
                      console.log("유튜브 요청 에러: "+error);
                  }
              });
          });
        </script>
	</div>
</body>
</html>