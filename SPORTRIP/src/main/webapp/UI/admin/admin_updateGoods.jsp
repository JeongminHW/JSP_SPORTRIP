<%@page import="md.MDBean"%>
<%@page import="player.PlayerBean"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="MDMgr" class="md.MDMgr" />
<%
    // POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
    int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
    if (teamNum == 0) {
        teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
    } else {
        session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
    }
     
 	// 굿즈 번호를 파라미터로 받아옴
    int mdNum =  MUtil.parseInt(request, "goodsNum", 0);
	MDBean goods = MDMgr.getMD(mdNum);
	
	// 굿즈 정보를 가져왔는지 확인
    if (goods == null) {
        out.println("<script>alert('굿즈 정보를 가져오는 데 실패했습니다.'); history.back();</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>굿즈 수정</title>
<link rel="stylesheet" href=".././assets/css/adminStyle.css">
<link href=".././assets/css/style.css" rel="stylesheet" type="text/css">
<script src=".././assets/js/main.js"></script>
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
				    <div id="image_container"><img id="playerImg" src="<%= goods.getMD_IMG()%>" alt="Player Image"></div>
					<div class="form-group">
						<input type="hidden" class="upload-file" placeholder="첨부파일" readonly>
						<label id="file-label" for="file">이미지 업로드</label>
		                <input class="form-control form-control-user" type="file" id="file" name="goodsImg" onchange="setThumbnail(event);">
					</div>
				</div>
				<div class="goods-info-box">
					<form id="updateGoodsForm" action="update_goods.jsp" method="post" enctype="multipart/form-data">
						<!-- 숨겨진 필드로 굿즈 번호 전달 -->
					    <input type="hidden" name="mdNum" value="<%=mdNum%>">
					
						<div class="addgoods-item">
							<label class="label" for="category">굿즈 종류</label> 
							<select	class="goods-select" id="goods-select" name="mdKindOf">
								<option value="유니폼" <%=goods.getMD_KINDOF().equals("유니폼") ? "selected" : "" %>>유니폼</option>
								<option value="머플러" <%=goods.getMD_KINDOF().equals("머플러") ? "selected" : "" %>>머플러</option>
								<option value="기타" <%=goods.getMD_KINDOF().equals("기타") ? "selected" : "" %>>기타</option>
							</select>
						</div>
					     <div class="addgoods-item">
					        <label class="label" for="goodsName">굿즈명</label>
					        <input class="input" type="text" id="goodsName" name="goodsName" value="<%=goods.getMD_NAME()%>">
					    </div>
			            <div class="addgoods-item"  style="margin-bottom: 60px;">
			                <label class="label" for="goodsPrice">가격</label>
			                <input class="input" type="text" id="goodsPrice" name="goodsPrice" value="<%=goods.getMD_PRICE()%>">
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
		// 이미지 미리보기
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
		
		// 굿즈 화면 돌아가기
	    function goodsManager(){
	    	document.location.href="admin_goods.jsp";
	    }
    
	    document.getElementById("file").addEventListener('change', function() {
	        var fileName = this.files.length > 0 ? this.files[0].name : ''; // 선택된 파일의 이름
	        document.querySelector(".upload-file").value = fileName; // .upload-file에 파일 이름 설정
	    });
	    
	    function updateGoods() {
	        const form = document.getElementById("updateGoodsForm");

	        const goodsName = document.getElementById('goodsName').value;
	        const goodsPrice = document.getElementById('goodsPrice').value;
	        const goodsCategory = document.getElementById('goods-select').value;
	        const goodsImgInput = document.getElementById('file');
	        const goodsImg = goodsImgInput ? goodsImgInput.files[0] : null;

	        if (!goodsName || !goodsPrice || !goodsCategory) {
	            alert("모든 필드를 입력하세요.");
	            return;
	        }

	        const formData = new FormData(form);

	        // 선택된 파일이 있을 경우에만 추가
	        if (goodsImg) {
	            formData.append('goodsImg', goodsImg);
	        }

	        fetch('update_goods.jsp', {
	            method: 'POST',
	            body: formData
	        })
	        .then(response => response.text())
	        .then(data => {
	            if (data.includes("success")) {
	                alert('굿즈 수정이 완료되었습니다.');
	                location.href = "admin_goods.jsp";
	            } else {
	                alert('굿즈 수정이 실패했습니다.');
	            }
	        })
	        .catch(error => console.error('Error:', error));
	    }
	</script>
</body>
</html>