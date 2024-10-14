<%@page import="headcoach.HeadcoachBean"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="headcoachMgr" class="headcoach.HeadcoachMgr" />
<%
    // POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
    int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
    if (teamNum == 0) {
        teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
    } else {
        session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
    }
     
	int coachNum  = MUtil.parseInt(request, "coachNum", 0);
	HeadcoachBean headcoachBean = headcoachMgr.getHeadcoach(coachNum);
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>K-league</title>
<link rel="stylesheet" href=".././assets/css/style.css">
<link rel="stylesheet" href=".././assets/css/adminStyle.css">
<script src=".././assets/js/main.js"></script>
<script>
    function goMain(){
        document.location.href="mainPage.jsp";
    }
</script>
</head>
<body>
	<div id="background" class="c_main">
		<div class="b_wrap">
			<img alt="" src=".././assets/images/main_page_img.png">
		</div>
	</div>
	<div class="popup-background">
		<div class="popup" style="width: 800px; height: 400px;">
			<div class="addplayer-box">
				<div class="coach-info-box">
					<form action="update_coach.jsp" method="post" enctype="multipart/form-data">
					<input type="hidden" name="coachNum" value="<%= coachNum %>"> <!-- 팀 번호 숨은 필드 추가 -->
						<div class="file-box">
						    <!-- 플레이어 이미지 업로드 섹션 -->
						    <div id="image_container"><img id="headcoachImg" src="<%= headcoachBean.getHEADCOACH_IMG() %>" alt="Headcoach Image"></div>
							<div class="form-group">
								<input type="hidden" class="upload-file" placeholder="첨부파일" readonly>
								<label id="file-label" for="file">이미지 업로드</label>
				                <input type="file" id="file" name="headcoachImg" onchange="setThumbnail(event);" />
							</div>
						</div>
						<div class="addcoach-group">
						    <div class="addcoach-item">
						        <label class="label" for="headcoachName">감독 이름</label>
						        <input class="input" type="text" id="headcoachName" name="headcoachName" value="<%= headcoachBean.getHEADCOACH_NAME() %>">
						    </div>
							<div class="addcoach-item" style="margin-top: 30px;">
								<input type="button" onclick="playerManager()" value="돌아가기">
								<input type="hidden" id="coachNum" name="coachNum" value="<%= headcoachBean.getHEADCOACH_NUM() %>">
								<input type="button" onclick="updateCoach()" value="수정하기">
							</div>
						</div>	
					</form>
			    </div>	
			</div>
		</div>
	</div>
	<script>
		function setThumbnail(event) {
			var reader = new FileReader();

			// 이미지가 새로 업로드될 때 기존 이미지를 제거
			var imageContainer = document.querySelector("div#image_container");
			imageContainer.innerHTML = ""; // 기존 이미지를 삭제

			reader.onload = function(event) {
				var img = document.createElement("img");
				img.setAttribute("src", event.target.result);
				img.setAttribute("class", "col-lg-6");
				document.querySelector("div#image_container").appendChild(img);
			};

			reader.readAsDataURL(event.target.files[0]);
		}
	</script>    
    <script>
	    function goMain(){
	        document.location.href="mainPage.jsp";
	    }
	    
	    function playerManager(){
	    	document.location.href="admin_player.jsp";
	    }
	    document.getElementById("file").addEventListener('change', function() {
	        var fileName = this.files.length > 0 ? this.files[0].name : ''; // 선택된 파일의 이름
	        document.querySelector(".upload-file").value = fileName; // .upload-file에 파일 이름 설정
	    });
	    
	       function updateCoach() {
	           let headcoachName = document.getElementById('headcoachName').value;
	           
	           // 파일 input의 파일을 가져옵니다.
	           let headcoachImgInput = document.getElementById('file'); // 파일 input을 가져옴
	           let headcoachImg = headcoachImgInput ? headcoachImgInput.files[0] : null; // 파일이 있을 때만 참조
	           let coachNum = document.getElementById('coachNum').value;
	           
	           console.log("coachNum: ", coachNum); // coachNum 값 확인
	           
	           const formData = new FormData();
	           formData.append('headcoachName', headcoachName);
	           formData.append('headcoachNum', coachNum);
	           
	           // 파일이 선택된 경우에만 FormData에 추가
	           if (headcoachImg) {
	               formData.append('headcoachImg', headcoachImg);
	           }

	           // fetch 요청으로 폼 데이터를 서버로 전송
	           fetch('update_coach.jsp', {
	               method: 'POST',
	               body: formData
	           })
	           .then(response => response.text())
	           .then(data => {
	        	   console.log("Response: ", data); // 서버로부터 받은 응답 출력
	               if (data.includes("success")) {
	                   alert('감독 수정이 완료되었습니다.');
	                   location.href = "admin_player.jsp";
	               } else {
	                   alert('감독 수정이 실패했습니다.');
	               }
	           })
	           .catch(error => console.error('Error:', error));
	       }
	</script>
</body>
</html>