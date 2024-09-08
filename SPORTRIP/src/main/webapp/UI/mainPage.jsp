<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>JSP 애니메이션</title>
<link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap" rel="stylesheet">
<link href="layout.css" rel="stylesheet" type="text/css">
<style>
/* 1번 코드 스타일 */
body {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
    background-color: white;
    flex-direction: column;
    position: relative;
    overflow: hidden;
}

.letter {
    font-family: 'Black Han Sans', sans-serif;
    font-size: 96px;
    font-weight: bold;
    color: #236FB5;
    opacity: 0;
    transition: opacity 1s ease-in;
    margin: 0 2px;
    text-shadow: 4px 4px 8px rgba(0, 0, 0, 0.4);
}

.show {
    opacity: 1;
}

.container {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: row;
    position: relative;
    transition: transform 0.5s ease-in-out;
    z-index: 5;  /* 2번 화면보다 위에 표시되도록 z-index를 5로 설정 */ 
}

#logo_DottedLine {
    position: absolute;
    top: -122px;
    width: 340px;
    height: auto;
    z-index: 1;
    opacity: 0;
    transition: opacity 1s ease-in;
    left: calc(76% - 290px);
    filter: drop-shadow(4px 4px 8px rgba(0, 0, 0, 0.4));
}

#logo_DottedLine.show {
    opacity: 1;
}

#logo_YaChookBae {
    width: 120px;
    height: 120px;
    opacity: 0;
    transition: opacity 1s ease-in;
    position: relative;
    top: -10px;
    margin: 0 0px;
    filter: drop-shadow(4px 4px 8px rgba(0, 0, 0, 0.4));
    transform: translateX(-100%) rotate(-360deg); /* 왼쪽에서 굴러오는 애니메이션 */
    animation: rollIn 1s ease-out forwards;
}

@keyframes rollIn {
    0% {
        transform: translateX(-100vw) rotate(-360deg);
        opacity: 0;
    }
    100% {
        transform: translateX(0) rotate(0);
        opacity: 1;
    }
}

#logo_YaChookBae.show {
    opacity: 1;
}

#logo_Airplane {
    position: absolute;
    top: -122px;
    width: 120px;
    height: auto;
    z-index: 1;
    opacity: 0;
    transition: opacity 1s ease-in;
    left: calc(100% - 100px);
    filter: drop-shadow(4px 4px 8px rgba(0, 0, 0, 0.4));
}

#logo_Airplane.show {
    opacity: 1;
}

#textContainer {
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    z-index: 2;
}

.move-to-top-left {
    transform: translate(-96%, -225%) scale(0.4);
    transition: transform 0.7s ease-in-out;
    cursor: pointer;
}

/* 2번 화면 슬라이드 애니메이션 */
#secondScreen {
    position: fixed;
    bottom: -200vh; /* 처음엔 화면 밖에 위치 */
    width: 100%;
    background-color: transparent;
    z-index: 1; /* 1번 화면 아래에 위치하도록 설정 */
    transition: transform 1s ease-out;
}

#secondScreen.show {
    transform: translateY(-180vh); /* 위로 슬라이드해서 올라오는 애니메이션 */
}
</style>
</head>
<body>
    <div class="container" id="animationContainer">
        <div id="textContainer">
            <span id="S" class="letter">S</span> <span id="P" class="letter">P</span>
            <img id="logo_YaChookBae" src="images/LOGO_YaChookBae.png" alt="Logo_YaChookBae">
            <img id="logo_DottedLine" src="images/LOGO_DottedLine.png" alt="Logo_DottedLine">
            <img id="logo_Airplane" src="images/LOGO_Airplane.png" alt="LOGO_Airplane">
            <span id="R" class="letter">R</span> <span id="T" class="letter">T</span>
            <span id="R2" class="letter">R</span> <span id="I" class="letter">I</span>
            <span id="P2" class="letter">P</span>
        </div>
    </div>

    <!-- 2번 화면 추가 -->
    <div id="secondScreen">
        <div id="campaign" class="index">
            <section class="c_hero area01">
                <div class="c_marquee value02">
                    <div class="cm_wrap t1">
                        <div class="marquee">
                            <span>LET’S KFA</span> <span>LET’S KBO</span> <span>LET’S KOVO</span>
                        </div>
                        <div class="marquee t1">
                            <span>LET’S KFA</span> <span>LET’S KBO</span> <span>LET’S KOVO</span>
                        </div>
                    </div>
                    <div class="cm_wrap t2">
                        <div class="marqueereverse">
                            <span>LET’S SPORTRIP</span> <span>LET’S SPORTRIP</span> <span>LET’S SPORTRIP</span>
                        </div>
                        <div class="marqueereverse t1">
                            <span>LET’S SPORTRIP</span> <span>LET’S SPORTRIP</span> <span>LET’S SPORTRIP</span>
                        </div>
                    </div>
                    <div class="cm_wrap t3">
                        <div class="marquee">
                            <span>LET’S KFA</span> <span>LET’S KBO</span> <span>LET’S KOVO</span>
                        </div>
                        <div class="marquee t1">
                            <span>LET’S KFA</span> <span>LET’S KBO</span> <span>LET’S KOVO</span>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>

<script>
    window.onload = function() {
        // 야축배 애니메이션 (왼쪽에서 굴러오는 애니메이션)
        setTimeout(() => {
            document.getElementById('logo_YaChookBae').classList.add('show');
        }, 1000);

        // S, P 순차적으로 나타내기
        setTimeout(() => {
            document.getElementById('S').classList.add('show');
        }, 1300);

        setTimeout(() => {
            document.getElementById('P').classList.add('show');
        }, 1400);

        // R, T, R2, I, P2 순차적으로 나타내기
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

        // P2가 나온 후 점선 나타내기
        setTimeout(() => {
            document.getElementById('logo_DottedLine').classList.add('show');
        }, 2000);

        // 점선이 나온 후 비행기 나타내기
        setTimeout(() => {
            document.getElementById('logo_Airplane').classList.add('show');
        }, 2100);

        // 좌측 상단으로 이동하는 애니메이션
        setTimeout(() => {
            document.getElementById('animationContainer').classList.add('move-to-top-left');
        }, 3200);

        // 1번 화면의 애니메이션이 끝난 후 2번 화면 슬라이드
        setTimeout(() => {
            document.getElementById('secondScreen').classList.add('show');
        }, 3200); // 약간의 지연 후 2번 화면이 올라옴
    };
</script>
</body>
</html>
