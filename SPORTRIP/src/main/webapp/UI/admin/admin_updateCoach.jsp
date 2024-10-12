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
     
	int coachNum = MUtil.parseInt(request, "coachNum", 0);
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
					<form action="" method="post" enctype="multipart/form-data">
					<input type="hidden" name="headcoachNum" value="<%= coachNum %>"> <!-- 팀 번호 숨은 필드 추가 -->
						<div class="file-box">
						    <!-- 플레이어 이미지 업로드 섹션 -->
						    <div id="image_container"></div>
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
								<input type="hidden" id="headcoachNum" name="headcoachNum" value="<%= headcoachBean.getHEADCOACH_NUM() %>">
								<input type="submit" value="수정">
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
   

	</script>
</body>
</html>