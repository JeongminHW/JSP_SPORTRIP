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
<header class="header header_logo">
    <a style="cursor: pointer" onclick="goMain()">
    <img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
    <a href="soccer_main.html" style="margin-left: 50px;">
    <img src=".././assets/images/k-league_logo.svg" alt="리그" id="league_logo_img"></a>
    <img style="width:80px;" src=".././assets/images/logo_img/2_울산HD.png" alt="울산" class="team_logo_img ulsan">
    <div class="login-signup-box">
        <ul>
            <li><a href="login.html" style="color: #000000;">로그인</a></li>
            <li><a href="signup.html" style="color: #000000;">회원가입</a></li>
        </ul>
    </div>
    </header>
    <div class="a_top">
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_goods')">선수 관리</a>
        </div>
        <div class="item" style="background-color: #083660;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_store')">굿즈샵</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_board')">게시판</a>
		</div>
	</div>

    <div class="addgoods-box">
        <h2>굿즈 등록</h2>
        <form action="" method="post">
            <div class="addgoods-item">
                <label class="label" for="category">굿즈 종류</label>
                <select class="goods-select" id="goods-select">
                	<option value="유니푬">유니폼</option>
                	<option value="머플러">머플러</option>
                	<option value="기타">기타</option>
                </select>
            </div>
            <div class="addgoods-item file-box">
                <label class="label" for="goods_img">굿즈 이미지</label>
				<div class="file-box">
	            	<input class="upload-file" value="img_file" placeholder="첨부파일" readonly>
	            	<label id="file-label" for="file"></label>
	                <input type="file" id="file" name="goods_img">
				</div>
            </div>
            <div class="addgoods-item">
                <label class="label" for="goodsName">굿즈 이름</label>
                <input class="input" type="text" id="goodsName" name="goodsName">
            </div>
            <div class="addgoods-item">
                <label class="label" for="goodsPrice">굿즈 가격</label>
                <input class="input" type="text" id="goodsPrice" name="goodsPrice">
            </div>
            <div class="addgoods-item">
                <input type="button" onclick="goodsManager()" value="목록">
                <input type="button" onclick="insertGoods()" value="등록">
            </div>
            </form>
    </div>
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