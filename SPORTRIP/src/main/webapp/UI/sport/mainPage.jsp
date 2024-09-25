<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SPORTRIP</title>
<link
	href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap"
	rel="stylesheet">
<link href=".././assets/css/MainText.css" rel="stylesheet" type="text/css">
<link href=".././assets/css/SportripLogo.css" rel="stylesheet" type="text/css">
</head>
<body>
	<div class="container" id="animationContainer">
		<div id="textContainer">
			<span id="S" class="letter">S</span> <span id="P" class="letter">P</span>
			<img id="logo_YaChookBae" src=".././assets/images/LOGO_YaChookBae.png"
				alt="Logo_YaChookBae"> <img id="logo_DottedLine"
				src=".././assets/images/LOGO_DottedLine.png" alt="Logo_DottedLine">
			<img id="logo_Airplane" src=".././assets/images/LOGO_Airplane.png"
				alt="LOGO_Airplane"> <span id="R" class="letter">R</span> <span
				id="T" class="letter">T</span> <span id="R2" class="letter">R</span>
			<span id="I" class="letter">I</span> <span id="P2" class="letter">P</span>
		</div>
	</div>

	<!-- 2번 화면 추가 -->
	<div id="secondScreen">
		<div id="header" class="c_main">
			<div class="h_wrap">
				<nav class="h_gnb">
					<div class="hg_list">
						<ul>
							<li class="baseball"><a href="#" onclick="sendSportNum(1)">
									<span>야구</span>
							</a></li>
							<li class="soccer"><a href="#" onclick="sendSportNum(2)">
									<span>축구</span>
							</a></li>
							<li class="volleyball"><a href="#" onclick="sendSportNum(3)">
									<span>배구</span>
							</a></li>
							<li class="trip"><a href="hotel_main.html"> <span>여행</span>
							</a></li>
						</ul>
					</div>
				</nav>
			</div>
		</div>
		<div id="campaign" class="index" style="margin-top: -130px;">
			<section class="c_hero area01">
				<div class="c_marquee value02">
					<div class="cm_wrap t1">
						<div class="marquee">
							<span>LET’S KFA</span> <span>LET’S KBO</span> <span>LET’S
								KOVO</span>
						</div>
						<div class="marquee t1">
							<span>LET’S KFA</span> <span>LET’S KBO</span> <span>LET’S
								KOVO</span>
						</div>
					</div>
					<div class="cm_wrap t2">
						<div class="marqueereverse">
							<span>LET’S SPORTRIP</span> <span>LET’S SPORTRIP</span> <span>LET’S
								SPORTRIP</span>
						</div>
						<div class="marqueereverse t1">
							<span>LET’S SPORTRIP</span> <span>LET’S SPORTRIP</span> <span>LET’S
								SPORTRIP</span>
						</div>
					</div>
					<div class="cm_wrap t3">
						<div class="marquee">
							<span>LET’S KFA</span> <span>LET’S KBO</span> <span>LET’S
								KOVO</span>
						</div>
						<div class="marquee t1">
							<span>LET’S KFA</span> <span>LET’S KBO</span> <span>LET’S
								KOVO</span>
						</div>
					</div>
				</div>
			</section>
		</div>
	</div>

	<script>
    window.onload = function() {
        // 애니메이션 타이밍을 약간 조정하여 더 자연스럽게 만듦
        setTimeout(() => {
            document.getElementById('logo_YaChookBae').classList.add('show');
        }, 1000);

        setTimeout(() => {
            document.getElementById('S').classList.add('show');
        }, 1300);

        setTimeout(() => {
            document.getElementById('P').classList.add('show');
        }, 1400);

        setTimeout(() => {
            document.getElementById('R').classList.add('show');
        }, 1500);

        setTimeout(() => {
            document.getElementById('T').classList.add('show');
        }, 1600);

        setTimeout(() => {
            document.getElementById('R2').classList.add('show');
        }, 1700);

        setTimeout(() => {
            document.getElementById('I').classList.add('show');
        }, 1800);

        setTimeout(() => {
            document.getElementById('P2').classList.add('show');
        }, 1900);

        setTimeout(() => {
            document.getElementById('logo_DottedLine').classList.add('show');
        }, 2000);

        setTimeout(() => {
            document.getElementById('logo_Airplane').classList.add('show');
        }, 2100);

        // 애니메이션을 자연스럽게 이동시킴
        setTimeout(() => {
            document.getElementById('animationContainer').style.transition = 'all 1s ease'; // 이동 애니메이션을 부드럽게
            document.getElementById('animationContainer').classList.add('move-to-top-left');
        }, 3200);

        // 2번 화면과 헤더가 함께 나타남
        setTimeout(() => {
            document.getElementById('secondScreen').classList.add('show');
            document.getElementById('header').classList.add('show');
        }, 3200); 
    };
	</script>

	<script>
	  function sendSportNum(sportNum) {
	    // 폼을 생성
	    var form = document.createElement("form");
	    form.setAttribute("method", "POST");
	    form.setAttribute("action", "sport_main.jsp"); // 데이터를 보낼 경로
	    
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

</body>
</html>
