<%@ page import="DB.MUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="login" class="user.UserBean" scope="session"/>

<%
    String url = request.getParameter("url");  // Capturing the URL passed to the login page
    if (url == null || url.isEmpty()) {
        url = (String) session.getAttribute("previousPage"); // Use session-stored previousPage if available
        if (url == null) {
            url = ".././sport/sport_main.jsp";  // Default URL if none is provided
        }
    }

    session.setAttribute("previousPage", url);  // Store the URL in session for later use
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SPORTRIP</title>
    <link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap" rel="stylesheet"/>
    <link href=".././assets/css/MainText2.css" rel="stylesheet" type="text/css"/>
  </head>
  <body>
    <div id="secondScreen">
        <div id="background" class="c_main">
            <div class="b_wrap">
                <img alt="" src=".././assets/images/newpage_img.png">
            </div>
        </div>
        <div id="campaign" class="index" style="margin-top: -160px">
            <section class="c_hero area01">
                <!-- Content omitted for brevity -->
            </section>
        </div>
        <div class="popup-background">
            <div class="popup">
                <div class="popup-content">
                    <div class="login_img">
                        <img src=".././assets/images/logo_img/2_울산HD.png" alt="울산HD" id="team_img">
                    </div>
                    <div class="login_form">
                        <form action="loginCheck.jsp" method="POST">
                            <div class="input_box">
                                <input type="text" name="id" placeholder="아이디">
                            </div>
                            <div class="input_box">
                                <input type="password" name="pw" placeholder="비밀번호">
                            </div>
                            <div class="login_button">
                                <input type="hidden" name="url" value="<%=url%>">  <!-- Passing previous URL -->
                                <button type="submit">로그인</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="u-popup">
                <span class="u-popup-text">스포트립이 처음이신가요? </span><a class="sign-up">회원가입</a>
            </div>
        </div>
    </div>

    <script>
        window.onload = function () {
            setTimeout(() => {
                document.getElementById("secondScreen").classList.add("show");
                document.getElementById("background").classList.add("show");
            }, 200);
        };
    </script>
  </body>
</html>
