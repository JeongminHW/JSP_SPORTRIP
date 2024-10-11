<%@page import="md.MDBean"%>
<%@page import="java.util.Vector"%>
<%@page import="team.TeamBean"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="mdMgr" class="md.MDMgr" />
<%
	String url = request.getParameter("url");
	//POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)

	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	if (teamNum == 0) {
		teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	} else {
		session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}
	
	int sportNum = (int)session.getAttribute("sportNum");
    Vector<MDBean> vlist = mdMgr.listMD(teamNum);
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
		<div class="popup" style="height: 450px;">
			<div class="addgoods-box">
				<div class="file-box">
				    <!-- 이미지 업로드 섹션 -->
				    <div id="image_container"></div>
					<div class="form-group">
						<label id="file-label" for="file">이미지 업로드</label>
		                <input class="form-control form-control-user" type="file" id="file" name="goods_image" onchange="setThumbnail(event);">
					</div>
				</div>
				<div class="goods-info-box">
					<form action="" method="post" enctype="multipart/form-data">
						<div class="addgoods-item">
							<label class="label" for="category">굿즈 종류</label> <select
								class="goods-select" id="goods-select">
								<option value="유니푬">유니폼</option>
								<option value="머플러">머플러</option>
								<option value="기타">기타</option>
							</select>
						</div>
					    <div class="addgoods-item">
					        <label class="label" for="goodsName">굿즈명</label>
					        <input class="input" type="text" id="goodsName" name="goodsName">
					    </div>
			            <div class="addgoods-item"  style="margin-bottom: 60px;">
			                <label class="label" for="goodsPrice">가격</label>
			                <input class="input" type="text" id="goodsPrice" name="goodsPrice">
			            </div>
						<div class="addgoods-item">
							<input type="button" onclick="goodsManager()" value="돌아가기">
							<input type="button" onclick="insertGoods()" value="굿즈 등록">
						</div>
					</form>
			    </div>	
			</div>
		</div>
	</div>
	<script>
	function setThumbnail(event){
		var reader = new FileReader();
		
		// 이미지가 새로 업로드될 때 기존 이미지를 제거
		var imageContainer = document.querySelector("div#image_container");
		imageContainer.innerHTML = ""; // 기존 이미지를 삭제
		
		reader.onload = function(event){
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
	    
	    function goodsManager(){
	    	document.location.href="admin_goods.jsp";
	    }
    
	    document.getElementById("file").addEventListener('change', function() {
	        var fileName = this.files.length > 0 ? this.files[0].name : ''; // 선택된 파일의 이름
	        document.querySelector(".upload-file").value = fileName; // .upload-file에 파일 이름 설정
	    });
	    
	    function insertGoods() {
	        let goodsName = document.getElementById('goodsName').value;
	        let goodsPrice = document.getElementById('goodsPrice').value;
	        let goodsImg = document.getElementById('file').files[0]; // Get the file from the input
	        let category = document.getElementById('goods-select').value;
	        let teamNum = <%=teamNum%>;
	        let sportNum = <%=sportNum%>;

	        const formData = new FormData();
	        formData.append('goodsName', goodsName);
	        formData.append('goodsPrice', goodsPrice);
	        formData.append('goodsImg', goodsImg);
	        formData.append('teamNum', teamNum);
	        formData.append('category', category);
	        formData.append('sportNum', sportNum);

	        fetch('insert_goods.jsp', {
	            method: 'POST',
	            body: formData // Use FormData as body
	        })
	        .then(response => response.text())
	        .then(data => {
	            if (data.includes("success")) { 
	                alert('굿즈 등록이 완료되었습니다.');
	                location.href = "admin_goods.jsp"; 
	            } else {
	                alert('굿즈 등록이 되지 않았습니다.');
	            }
	        })
	        .catch(error => console.error('Error:', error));
	    }
	    
	</script>
</body>
</html>