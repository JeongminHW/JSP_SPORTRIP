<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:useBean id="teamSession" scope="session" class="team.TeamBean" />
<jsp:setProperty property="*" name="teamSession" />
<jsp:setProperty property="*" name = "teamBean"/>

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
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Home</title>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link href=".././assets/css/sportsmainStyle.css" rel="stylesheet" type="text/css" />
<link href=".././assets/css/highlightStyle.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href=".././assets/css/mainhamburger.css">
</head>
<body>
	<section class="first-page" id="first-page">
		<header>
			<a class="logo" style="cursor: pointer" onclick="goMain()"> <img
				src=".././assets/images/white_sportrip_logo.png" alt="sportrip 로고"
				id="logo_img">
			</a>
			<div id="header" class="c_main">
				<div class="h_wrap">
					<nav class="h_gnb">
						<div class="hg_list">
							<ul>
								<li class="rank">
									<a href="#" onclick="document.getElementById('third-page').scrollIntoView({behavior: 'smooth'})"><span>Rank</span></a>
								</li>
								<li class="highlight">
									<a href="#" onclick="document.getElementById('second-page').scrollIntoView({behavior: 'smooth'})"><span>Highlight</span></a>
								</li>
								<li class="matchdate">
									<a href=".././sport/sport_matchDate.jsp"><span>MatchDate</span></a>
								</li>
							</ul>
						</div>
					</nav>
					<input id="toggle" type="checkbox" /> <label class="hamburger"
						for="toggle">
						<div class="top"></div>
						<div class="middle"></div>
						<div class="bottom"></div>
					</label>
				</div>
			</div>
			<div class="menu" style="position:fixed;">
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
		</header>
		<div class="banner-container">
			<div class="banner-slide">
				<div class="slide">
					<div class="visual-img">
						<img src=".././assets/images/banner_img/banner_image1.png"
							alt="Image 1" />
						<div class="overlay"></div>
					</div>
					<div class="visual-text show">
						<p>
							여행과 응원이 함께하는 곳,<br>그 시작을 SPORTRIP이 함께 합니다
						</p>
					</div>
				</div>
				<div class="slide">
					<div class="visual-img">
						<img src=".././assets/images/banner_img/banner_image2.png"
							alt="Image 2" />
						<div class="overlay"></div>
					</div>
					<div class="visual-text">
						<p>
							경기와 여행을 하나로 :<br>팬들을 위한 종합 플랫폼
						</p>
					</div>
				</div>
				<div class="slide">
					<div class="visual-img">
						<img src=".././assets/images/banner_img/banner_image3.png"
							alt="Image 3" />
						<div class="overlay"></div>
					</div>
					<div class="visual-text">
						<p>
							스포츠와 여행의 새로운 길,<br>팬들의 여정을 설계하다
						</p>
					</div>
				</div>
				<div class="slide">
					<div class="visual-img">
						<img src=".././assets/images/banner_img/banner_image4.png"
							alt="Image 4" />
						<div class="overlay"></div>
					</div>
					<div class="visual-text">
						<p>
							축구부터 야구 배구 숙소까지,<br>팬들의 모든 순간을 함께하다
						</p>
					</div>
				</div>
			</div>
			<!-- progress bar container는 슬라이드 외부에 위치 -->
			<div class="progress-bar-container">
				<div class="progress-bar"></div>
			</div>
			<div class="arrow arrow-left">
				<i class="fas fa-chevron-left"></i>
			</div>
			<div class="arrow arrow-right">
				<i class="fas fa-chevron-right"></i>
			</div>
		</div>
	</section>

	<section id="second-page" class="second-page" style="background-color: #ffffff; height: 100vh">
		<div class="slide_wrap">
			<div class="slide_show">
				<div class="slide_list"></div>
			</div>
			<div class="slide_btn">
				<button class="prev">&#8678;</button>
				<button class="next">&#8680;</button>
			</div>
		</div>
	</section>

	<section id="third-page" class="third-page">
		<header>
			<span>RANK</span>
		</header>
		<table class="rank-table">
			<thead>
				<tr>
					<th>순위</th>
					<th>클럽</th>
					<th>경기</th>
					<th>승점</th>
					<th>승</th>
					<th>무</th>
					<th>패</th>
					<th>득점</th>
					<th>실점</th>
				</tr>
			</thead>
            <tbody>
                <%
                    teamMgr = new TeamMgr();
                    Vector<TeamBean> teamList = teamMgr.TeamRank(sportNum);
                    if (teamList != null) {
                        for (TeamBean team : teamList) {
                %>
			                <tr>
			                    <td><%= team.getRANKING() %></td>
			                    <td><img src="<%= team.getLOGO()%>" alt=""><%= team.getTEAM_NAME() %></td>
			                    <td><%= team.getGAME() %></td>
			                    <td><%= team.getPOINT() %></td>
			                    <td><%= team.getWIN() %></td>
			                    <td><%= team.getDRAW() %></td>
			                    <td><%= team.getLOSS() %></td>
			                    <td><%= team.getWIN_POINT() %></td>
			                    <td><%= team.getLOSS_POINT() %></td>
			                </tr>
                <%
                        }
                    } else {
                        out.println("<tr><td colspan='9'>데이터가 없습니다.</td></tr>");
                    }
                %>
            </tbody>
		</table>
	</section>

	<footer style="background-color: #ffffff; height: 20vh">
		<div class="wrap">
			<!-- 배너표시영역 -->
			<div class="rolling-list">
				<!-- 원본배너 -->
				<ul>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/1_강원.png" alt="강원 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/2_울산HD.png" alt="울산 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/3_수원FC.png" alt="수원 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/4_김천상무.png" alt="김천 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/5_서울.png" alt="서울 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/6_포항.png" alt="포항 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/7_광주.png" alt="광주 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/8_제주.png" alt="제주 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/9_대전.png" alt="대전 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/10_인천.png" alt="인천 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/11_전북.png" alt="전북 로고">
						</div>
					</li>
					<li>
						<div class="image-wrap">
							<img src=".././assets/images/logo_img/12_대구.png" alt="대구 로고">
						</div>
					</li>
				</ul>
			</div>
		</div>
	</footer>
	
	<button id="scrollTopBtn" onclick="scrollToTop()">▲</button>
	
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
	<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
	
	<script>
		  let scrollTimeout;
		
		  window.onscroll = function() {
		    scrollFunction();
		  };
		
		  function scrollFunction() {
		    var scrollTopBtn = document.getElementById("scrollTopBtn");
		
		    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
		      scrollTopBtn.classList.add("show");
		      scrollTopBtn.classList.remove("hide");
		
		      // 버튼이 스크롤을 따라가도록 위치를 지연시켜 변경
		      if (scrollTimeout) {
		        clearTimeout(scrollTimeout);
		      }
		
		      scrollTimeout = setTimeout(function() {
		        let scrollPosition = window.scrollY + window.innerHeight - 100; // 스크롤 위치에서 살짝 띄움
		        scrollTopBtn.style.top = scrollPosition + "px"; // 부드럽게 따라오도록 top 값을 변경
		      }); // 0.2초 딜레이 후 위치 변경
		    } else {
		      scrollTopBtn.classList.add("hide");
		      setTimeout(function() {
		        scrollTopBtn.classList.remove("show");
		      });
		    }
		  }
		
		  function scrollToTop() {
		    window.scrollTo({top: 0, behavior: 'smooth'}); // 부드럽게 스크롤 위로
		  }
	</script>
	
	<script>
        $(document).ready(function(){
            const $progressBar = $('.progress-bar');
            const slideDuration = 4000; // 슬라이드 전환 시간 (4초)
            const delayBeforeSlide = 500; // 전환 전 지연 시간 (0.5초)

            $('.banner-slide').slick({
                infinite: true,
                autoplay: false, // 자동 재생 꺼짐
                arrows: false, // 기본 화살표는 숨김
                speed: 1000, // 슬라이드 애니메이션 속도
                pauseOnHover: false,
                slide: 'div'
            });

            function startProgressBar() {
                $progressBar.css('transition', 'none');
                $progressBar.css('width', '0%');

                setTimeout(() => {
                    $progressBar.css('transition', `width ${"${slideDuration}"}ms linear`);
                    $progressBar.css('width', '100%');
                }, 100);
            }

            function resetProgressBar() {
                $progressBar.css('transition', 'none');
                $progressBar.css('width', '0%');
            }

            // 재생바가 꽉 차면 0.5초 기다렸다가 슬라이드 전환
            $progressBar.on('transitionend', function() {
                if ($progressBar.width() >= $progressBar.parent().width()) {
                    setTimeout(() => {
                        $('.banner-slide').slick('slickNext');
                    }, delayBeforeSlide); // 0.5초 지연 후 슬라이드 전환
                }
            });

            // 슬라이드 변경 전
            $('.banner-slide').on('beforeChange', function(event, slick, currentSlide, nextSlide){
                resetProgressBar();
                $('.visual-text').removeClass('show'); // 텍스트 숨김
            });

            // 슬라이드 변경 후
            $('.banner-slide').on('afterChange', function(event, slick, currentSlide){
                startProgressBar();
                $('.visual-text').addClass('show'); // 텍스트 표시
            });

            // 왼쪽 화살표 클릭 시 이전 슬라이드로 이동
            $('.arrow-left').on('click', function() {
                $('.banner-slide').slick('slickPrev');
                resetProgressBar();
                startProgressBar();
                $('.visual-text').removeClass('show'); // 텍스트 숨김
            });

            // 오른쪽 화살표 클릭 시 다음 슬라이드로 이동
            $('.arrow-right').on('click', function() {
                $('.banner-slide').slick('slickNext');
                resetProgressBar();
                startProgressBar();
                $('.visual-text').removeClass('show'); // 텍스트 숨김
            });

            // 초기 시작
            startProgressBar();
        });
    </script>

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
		          						$('.slide_list').append('<div class="slide-card highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="624" height="351" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');
		                                        divCount++;
		                                    }
		                          	  }else{
		                          		  $('.slide_list').append('<div class="slide-card highlight-box highlight'+index+'"> <div class="highlight-video"> <iframe width="624" height="351" src="https://www.youtube.com/embed/'+element.id.videoId+'" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> </div> <div class="info-box"> <span style="color: red; font-weight: bold;">[하이라이트]</span><br> <span>'+ truncatedTitle + '</span><br> <span> (' + publishedDate + ')</span> </div> </div>');
		                          	  }
		                            });
		                         	// 슬라이드 기능
		                            let slideWrap = $(".slide_wrap"),
			                            slideShow = slideWrap.find(".slide_show"),
			                            slideList = slideShow.find(".slide_list"),
			                            slides = slideList.find(".slide-card"),
			                            slideBtn = slideWrap.find(".slide_btn");
	
			                        let slideCount = slides.length,
			                            slideWidth = slides.innerWidth()+20,
			                            showNum = 3,
			                            num = 0,
			                            currentIndex = 0,
			                            
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
		                        },
		                        complete : function(data) {
		                        },
		                        error : function(xhr, status, error) {
		                            console.log("유튜브 요청 에러: "+error);
		                        }
		                    });
		                });
		        </script>

	<script type="text/javascript">
        // 롤링 배너 복제본 생성
        let roller = document.querySelector('.rolling-list');
        roller.id = 'roller1'; // 아이디 부여
 
        let clone = roller.cloneNode(true)
        // cloneNode : 노드 복제. 기본값은 false. 자식 노드까지 복제를 원하면 true 사용
        clone.id = 'roller2';
        document.querySelector('.wrap').appendChild(clone); // wrap 하위 자식으로 부착

        let clone1 = roller.cloneNode(true)
        clone1.id = 'roller3';
        document.querySelector('.wrap').appendChild(clone1); // wrap 하위 자식으로 부착
 
        document.querySelector('#roller1').style.left = '0px';
        document.querySelector('#roller2').style.left = document.querySelector('.rolling-list ul').offsetWidth + 'px';
        document.querySelector('#roller2').style.left = (document.querySelector('.rolling-list ul').offsetWidth * 2) + 'px';
        // offsetWidth : 요소의 크기 확인(margin을 제외한 padding값, border값까지 계산한 값)
 
        roller.classList.add('original');
        clone.classList.add('clone');
        clone1.classList.add('clone1');
    </script>
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
	        form.setAttribute("action", "sports_main.jsp"); // 데이터를 보낼 경로
	
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
    <script>
	  function toggleMenuVisibility() {
	    const rank = document.querySelector('.rank');
	    const highlight = document.querySelector('.highlight');
	    const matchdate = document.querySelector('.matchdate');
	    const menuCheckbox = document.getElementById('toggle'); // 햄버거 메뉴 체크박스
	
	    // 햄버거 메뉴가 열렸을 때
	    if (menuCheckbox.checked) {
	      rank.style.display = 'none';
	      highlight.style.display = 'none';
	      matchdate.style.display = 'none';
	      document.body.style.overflow = 'hidden'; // 스크롤 비활성화
	    } else { // 햄버거 메뉴가 닫혔을 때
	      rank.style.display = 'inline-block';
	      highlight.style.display = 'inline-block';
	      matchdate.style.display = 'inline-block';
	      document.body.style.overflow = ''; // 스크롤 활성화
	    }
	  }
	
	  // 햄버거 메뉴 클릭 이벤트에 함수 연결
	  document.getElementById('toggle').addEventListener('change', toggleMenuVisibility);
	</script>
</body>
</html>