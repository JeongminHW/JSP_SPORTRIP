<%@page import="team.TeamBean"%> <%@page import="java.util.Vector"%> <%@page
import="DB.MUtil"%> <%@ page language="java" contentType="text/html;
charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:setProperty property="*" name="teamBean" />

<% int sportNum = MUtil.parseInt(request, "sportNum"); Vector<TeamBean>
  teamVlist = teamMgr.listTeam(sportNum); %>

  <!DOCTYPE html>
  <html lang="ko">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>SPORTRIP</title>
      <link rel="stylesheet" href=".././assets/css/style.css" />
      <script>
        function goMain() {
          document.location.href = "mainPage.jsp";
        }
      </script>
      <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
    </head>
    <body>
      <header class="header header_logo">
        <a style="cursor: pointer" onclick="goMain()"
          ><img
            src=".././assets/images/sportrip_logo.png"
            alt="sportrip 로고"
            id="logo_img"
        /></a>
        <div class="league_info">
          <a
            href="#"
            onclick="sendSportNum(<%=sportNum%>, 'sport_main')"
            style="margin-left: 20px; margin-right: 20px"
            ><img
              src=".././assets/images/sport_logo<%=sportNum%>.svg"
              alt="리그"
              id="league_logo_img"
          /></a>
          <ul>
            <% for(int i = 0; i < teamVlist.size(); i++){ teamBean =
            teamVlist.get(i); %>
            <li>
              <a href="teamPage_Player.jsp"
                ><img
                  src="<%=teamBean.getLOGO()%>"
                  alt="<%=teamBean.getTEAM_NAME() %>"
                  class="team_logo_img"
              /></a>
            </li>
            <% } %>
          </ul>
        </div>
      </header>

      <div class="top">
		<div class="item" style="background-color: #236FB5;">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'team_rank')">팀 순위</a>
		</div>
		<div class="item" style="background-color: #236FB5;">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'main_highlight')">하이라이트 경기</a>
		</div>
		<div class="item" style="background-color: #236FB5;">
			<a href="#" onclick="sendSportNum(<%=sportNum%>, 'sport_matchDate')">경기 일정</a>
		</div>
      </div>
      <div class="highlight-container">
        <script type="text/javascript">
          const sportNum = <%=sportNum%>;
          console.log(sportNum);
          var searchData = null;
          var pageSize = 0;
          if(sportNum == 1){
          	searchData = "KBO%ED%95%98%EC%9D%B4%EB%9D%BC%EC%9D%B4%ED%8A%B8&";
          	pageSize = 12;
          }
          else if(sportNum == 2){
          	searchData = "K%EB%A6%AC%EA%B7%B81%20%ED%95%98%EC%9D%B4%EB%9D%BC%EC%9D%B4%ED%8A%B8&";
          	pageSize = 24;
          }
          else if(sportNum == 3){
          	searchData = "kobo%EC%97%AC%EC%9E%90%EB%B0%B0%EA%B5%AC%ED%95%98%EC%9D%B4%EB%9D%BC%EC%9D%B4%ED%8A%B8&";
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
                            const offset = 9 * 60; // Korea Standard Time (UTC+9) in minutes
                            const localDate = new Date(date.getTime() + offset * 60000);
                            localDate.setDate(localDate.getDate() - 1); // 하루를 빼기

                            const yyyy = localDate.getFullYear();
                            const mm = String(localDate.getMonth() + 1).padStart(2, '0');
                            const dd = String(localDate.getDate()).padStart(2, '0');
                            return `${ "${yyyy}" }-${ "${mm}" }-${ "${dd}" }`;
                    }

                    function truncateTitle(title) {
                            const separatorIndex = title.indexOf('|');
                            const separatorIndex2 = title.indexOf('｜');
                            if (separatorIndex !== -1) {
                                return title.substring(0, separatorIndex).trim();
                            }
                            if (separatorIndex2 !== -1) {
                                return title.substring(0, separatorIndex2).trim();
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

                          	  if(sportNum == 2){
                                    if (divCount >= 12) {
                                        return;
                                    }

                                    if (title.includes("K리그1")) {
          						$('.highlight-container').append('<div class="highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');
                                        divCount++;
                                    }
                          	  }else{
                          		  $('.highlight-container').append('<div class="highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');
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

        <script>
          function sendSportNum(sportNum, page) {
            // 폼을 생성
            var form = document.createElement("form");
            form.setAttribute("method", "POST");
            form.setAttribute("action", `${"${page}"}.jsp`); // 데이터를 보낼 경로

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
        </script>
      </div>
    </body>
  </html>
</TeamBean>
