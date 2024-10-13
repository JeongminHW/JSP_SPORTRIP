<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<%
	// POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	if (teamNum == 0) {
		teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	} else {
		session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}
	// 팀 정보 가져오기
	TeamBean teamInfo = teamMgr.getTeam(teamNum);
	
	String teamName = teamInfo.getTEAM_NAME();
	
	int sportNum = MUtil.parseInt(request, "sportNum", 0); // 폼에서 받은 값이 없으면 0
	if (sportNum == 0) {
		sportNum = (Integer) session.getAttribute("sportNum"); // 세션에서 팀 번호 가져오기
	} else {
	    session.setAttribute("sportNum", sportNum); // 세션에 팀 번호 저장
	}
%>
<jsp:include page="../header.jsp" />
<div class="highlight-container">
	<script>
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

    var trimsearchteamName = "<%=teamName%>".split(" ");
    var searchteamName = null;
     
    if(trimsearchteamName[1] == "서울"){
    	searchteamName = trimsearchteamName[1];
    } else {
     	searchteamName = trimsearchteamName[0];
    }
    var pageSize = 0;
    if(sportNum == 1){
     	searchData = encodeURI(searchteamName) + encodeURI("KBO하이라이트");
     	pageSize = 12;
    }
    else if(sportNum == 2){
    	searchData =  encodeURI(searchteamName) + encodeURI("K리그1하이라이트");
     	pageSize = 24;
    }
    else if(sportNum == 3){
     	searchData =  encodeURI(searchteamName) + encodeURI("KOVO하이라이트");
     	pageSize = 12;
    }

    $(document).ready(function() {
   	const apiurl = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&"
   		+ "maxResults="+ pageSize +"&order=date&"
   		+ "q="+ searchData
   		+ "&type=video&"
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
                	  if(sportNum == 2){
                          if (title.includes("K리그1") && title.includes(searchteamName)) {
                          	$('.highlight-container').append('<div class="highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');   
        						divCount++;
                          } 	
			}
                  	else{
                  		$('.highlight-container').append('<div class="highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');   
				divCount++; 
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