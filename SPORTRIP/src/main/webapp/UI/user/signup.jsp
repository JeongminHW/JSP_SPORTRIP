<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="userMgr" class="user.UserMgr" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign up</title>
    <link rel="stylesheet" href=".././assets/css/style.css">
</head>
<body>
	<jsp:include page=".././team/team_header.jsp"/>
    <div class="container">
        <div id="login" class="item" style="background-color: #236FB5">
            <a href="login.html">로그인</a>
        </div>
        <div id="signup" class="item" style="background-color: #083660">
            <a href="signup.jsp" >회원가입</a>
        </div>
    </div>

    <div class="login_main">
        <div class="login_title">
            <h1>회원가입</h1>
        </div>
        <div class="login_form">
			<form id="signupForm" accept-charset="UTF-8" action="signupCheck.jsp" method="POST" onsubmit="return validateForm()">
			    <div class="input_box">
			        <div class="input_label">아이디 <label style="color: red; font-size: 20px;">*</label></div>
			        <input type="text" name="id" id="id" placeholder="아이디">
			    </div>
			    <div class="input_box">
			        <div class="input_label">비밀번호 <label style="color: red; font-size: 20px;">*</label></div>
			        <input type="password" name="password" id="password" placeholder="비밀번호">
			    </div>
			    <div class="input_box">
			        <div class="input_label">비밀번호 확인 <label style="color: red; font-size: 20px;">*</label></div>
			        <input type="password" name="password_check" id="password_check" placeholder="비밀번호 확인">
			    </div>
			    <div class="input_box">
			        <div class="input_label">이름 <label style="color: red; font-size: 20px;">*</label></div>
			        <input type="text" name="name" id="name" placeholder="이름">
			    </div>
			    <div class="input_box">
			        <div class="input_label">이메일 <label style="color: red; font-size: 20px;">*</label></div>
			        <input type="text" name="email" id="email" placeholder="sportrip@domain.com">
			    </div>
			    <div class="input_box">
			        <div class="input_label">주소 <label style="color: red; font-size: 20px;">*</label>
			            <button type="button" onclick="search_address()">주소 검색</button>
			        </div>
			        <input type="text" name="zipcode" id="zipcode" placeholder="우편번호" readonly>
			        <input type="text" name="address" id="address" placeholder="주소" readonly><br>
			        <input type="text" name="extraAddr" id="extraAddr" placeholder="상세주소">
			    </div>
			    <div class="input_box">
			        <div class="input_label">전화번호 <label style="color: red; font-size: 20px;">*</label></div>
			        <input type="number" name="phone" id="phone" placeholder="01012341234">
			    </div>
			    <div class="login_button">
			        <button type="submit">회원가입하기</button>
			    </div>
			</form>
        </div>
    </div>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
        function search_address() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                } else {
                    document.getElementById("address").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById("zipcode").value = data.zonecode;
                document.getElementById("address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("address").focus();
            	}
        	}).open();
    	}
	        
        function validateForm() {
            var id = document.getElementById("id").value;
            var password = document.getElementById("password").value;
            var password_check = document.getElementById("password_check").value;
            var name = document.getElementById("name").value;
            var email = document.getElementById("email").value;
            var address = document.getElementById("address").value;
            var extraAddr = document.getElementById("extraAddr").value;
            var phone = document.getElementById("phone").value;
            
            if (!id || !password || !password_check || !name || !email || !address || !extraAddr || !phone) {
                alert("모든 필수 항목을 입력하세요.");
            }

            if (password !== password_check) {
                alert("비밀번호가 일치하지 않습니다.");
            }

            var xhr = new XMLHttpRequest();

            xhr.open("POST", "validateId.jsp", true); 
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    var response = xhr.responseText;
                    if (response.includes("duplicate")) {
                        alert("중복된 아이디가 존재합니다. 다시 입력해주세요.");
                    } else if (response.includes("valid")) {
                        document.getElementById("signupForm").submit();
                    }
                }
            };
            xhr.send("id=" + id);

            return false; 
        }


    </script>
</body>
</html>