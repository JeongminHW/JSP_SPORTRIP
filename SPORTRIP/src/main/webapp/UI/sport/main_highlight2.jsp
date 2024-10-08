<%@page import="team.TeamBean"%> <%@page import="java.util.Vector"%> <%@page
import="DB.MUtil"%> <%@ page language="java" contentType="text/html;
charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:setProperty property="*" name="teamBean" />

<% 
	int sportNum =	(int)session.getAttribute("sportNum");	
	Vector<TeamBean> teamVlist = teamMgr.listTeam(sportNum); 
%>
<jsp:include page="sport_header.jsp"/>

	<div class="slide_wrap">
	  <div class="slide_show">
	    <div class="slide_list">
	    
	    </div>
	  </div>
	  <div class="slide_btn">
	    <button class="prev">prev</button>
	    <button class="next">next</button>
	  </div>
	</div>
	<script type="text/javascript">
		          const sportNum = <%=sportNum%>;
		
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
		          						$('.slide_list').append('<div class="slide-card highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');
		                                        divCount++;
		                                    }
		                          	  }else{
		                          		  $('.slide_list').append('<div class="slide-card highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');
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
	
       <%-- <div class="highlight-container">
        <script type="text/javascript">
          const sportNum = <%=sportNum%>;

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
          						$('.highlight-container').append('<div class="slide highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');
                                        divCount++;
                                    }
                          	  }else{
                          		  $('.highlight-container').append('<div class="slide highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="560" height="315" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');
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
        </script> --%>

        <script>
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
        
	    // 슬라이드 기능
	   	let slideWrap = $(".slide_wrap"),
		    slideShow = slideWrap.find(".slide_show"),
		    slideList = slideShow.find(".slide_list"),
		    slides = slideList.find(".slide-card"),
		    slideBtn = slideWrap.find(".slide_btn");
		
		let slideCount = slides.length,
		    slideWidth = slides.innerWidth(),
		    showNum = 3,
		    num = 0,
		    currentIndex = 0;
		    
		    slideCopy = $(".slide-card:lt("+ showNum +")").clone();
		    slideList.append(slideCopy);
		
		//이미지 움직이기
		function backShow(){
		  if( num == 0 ){
		    //시작
		    num= slideCount;
		    slideList.css("left", -num * slideWidth + "px");
		  }
		  num--;
		  slideList.stop().animate({ left : -slideWidth * num +"px"}, 400);
		}
		
		function nextShow(){
		  if( num == slideCount ){
		    //마지막
		    num= 0;
		    slideList.css("left", num);
		  }
		  num++;
		  slideList.stop().animate({ left : -slideWidth * num +"px"}, 400);
		}
		
		//왼쪽, 오른쪽 버튼 설정
		slideBtn.on("click","button",function(){
		  if( $(this).hasClass("prev")){
		    //왼쪽 버튼을 클릭
		    backShow();
		  } else {
		    //오른쪽 버튼을 클릭
		    nextShow();
		  }
		});
        </script>
      <!-- </div> -->
    </body>
</html>