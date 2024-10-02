<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="userMgr" class="user.UserMgr" />

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SPORTRIP</title>
    <link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap" rel="stylesheet"/>
    <link href=".././assets/css/signup.css" rel="stylesheet" type="text/css"/>
  </head>
  <body>
	<div id="secondScreen">
		<div id="background" class="c_main">
			<div class="b_wrap">
				<img alt="" src=".././assets/images/newpage_img.png">
			</div>
		</div>
		<div id="campaign" class="index" style="margin-top: -120px">
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
		<div class="popup-background">
			<div class="popup">
				<div class="popup-content">
					<div class="logo-section">
						<div class="singup_img">
							<img src=".././assets/images/sportrip_logo.png" alt="울산HD" id="sportrip_logo">
							<div class="signup_button">
								<button type="button" onclick="return validateForm()">회원가입</button>
							</div>
						</div>
					</div>
					<div class="signup_form">
						<form id="signupForm" accept-charset="UTF-8" action="signupCheck.jsp" method="POST">
							<div class="input_box">
								<input type="text" name="id" id="id" placeholder="아이디 *">
							</div>
							<div class="input_box">
								<input type="password" name="password" id="password" placeholder="비밀번호 *">
							</div>
							<div class="input_box">
								<input type="password" name="password_check" id="password_check" placeholder="비밀번호 확인 *">
							</div>
							<div class="input_box">
								<input type="text" name="name" id="name" placeholder="이름 *">
							</div>
							<div class="input_box">
								<input type="text" name="email" id="email" placeholder="이메일 *">
							</div>
							<div class="input_box" style="height: 40px;">
								<div class="input_label">
									<button type="button" onclick="search_address()">우편번호 검색</button>
								</div>
								<input type="text" name="zipcode" id="zipcode" placeholder="우편번호">
							</div>
							<div class="input_box" style="height: 40px; margin-bottom: 5px;">
								<input type="text" name="address" id="address" placeholder="주소" readonly>								
							</div>
							<div class="input_box">
								<input type="text" name="extraAddr" id="extraAddr" placeholder="상세주소">
							</div>
							<div class="input_box">
								<input style="margin: 0;" type="text" name="phone" id="phone" placeholder="휴대전화 *">
							</div>
						</form> 
					</div>
				</div>
			</div>
		</div>
	</div>

	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		function search_address() {
			new daum.Postcode(
					{
						oncomplete : function(data) {
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
							if (data.userSelectedType === 'R') {
								// 법정동명이 있을 경우 추가한다. (법정리는 제외)
								// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
								if (data.bname !== ''
										&& /[동|로|가]$/g.test(data.bname)) {
									extraAddr += data.bname;
								}
								// 건물명이 있고, 공동주택일 경우 추가한다.
								if (data.buildingName !== ''
										&& data.apartment === 'Y') {
									extraAddr += (extraAddr !== '' ? ', '
											+ data.buildingName
											: data.buildingName);
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

			if (!id || !password || !password_check || !name || !email
					|| !address || !extraAddr || !phone) {
				alert("모든 필수 항목을 입력하세요.");
			}

			if (password !== password_check) {
				alert("비밀번호가 일치하지 않습니다.");
			}

			var xhr = new XMLHttpRequest();

			xhr.open("POST", "validateId.jsp", true);
			xhr.setRequestHeader("Content-Type",
					"application/x-www-form-urlencoded");
			xhr.onreadystatechange = function() {
				if (xhr.readyState == 4 && xhr.status == 200) {
					var response = xhr.responseText;
					if (response.includes("duplicate")) {
						alert("중복된 아이디가 존재합니다. 다시 입력해주세요.");
					} else if (response.includes("valid")) {
						alert("회원가입이 완료되었습니다. 가입한 아이디로 로그인 해주세요.");
						document.getElementById("signupForm").submit();
					}
				}
			};
			xhr.send("id=" + id);

			return false;
		}
	</script>
	<script>
  	function sendSportNum(sportNum) {
	    // 세션에 값을 설정
	    var form = document.createElement("form");
	    form.setAttribute("method", "POST");
	    form.setAttribute("action", "sport_main.jsp"); // 데이터를 보낼 경로
		
        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "sportNum");
        hiddenField.setAttribute("value", sportNum);
	    form.appendChild(hiddenField);
	
	    document.body.appendChild(form);
	    form.submit();
	}
    </script>
  </body>
</html>
