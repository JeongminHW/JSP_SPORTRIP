<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
							<label class="label" for="category">굿즈 종류</label> 
								<select	class="goods-select" id="goods-select">
									<option value="유니푬">유니폼</option>
									<option value="머플러">머플러</option>
									<option value="기타">기타</option>
								</select>
						</div>
					    <div class="addgoods-item">
					        <label class="label" for="goodsName">굿즈명</label>
					        <input class="input" type="text" id="goodsName" name="goodsName" value="">
					    </div>
			            <div class="addgoods-item"  style="margin-bottom: 60px;">
			                <label class="label" for="goodsPrice">가격</label>
			                <input class="input" type="text" id="goodsPrice" name="goodsPrice" value="">
			            </div>
						<div class="addgoods-item">
							<input type="button" onclick="goodsManager()" value="돌아가기">
							<input type="button" onclick="updateGoods()" value="굿즈 수정">
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
	    
	    function goodsManager(){
	    	document.location.href="admin_goods.jsp";
	    }
    
	    document.getElementById("file").addEventListener('change', function() {
	        var fileName = this.files.length > 0 ? this.files[0].name : ''; // 선택된 파일의 이름
	        document.querySelector(".upload-file").value = fileName; // .upload-file에 파일 이름 설정
	    });
	</script>
</body>
</html>