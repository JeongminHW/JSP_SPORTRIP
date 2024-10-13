<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:useBean id="teamSession" scope="session" class="team.TeamBean" />
<jsp:setProperty property="*" name="teamSession" />
<jsp:useBean id="userMgr" class="user.UserMgr" />
<jsp:useBean id="login" scope="session" class="user.UserBean" />

<%
	int teamNum = 0;
	int sportNum = MUtil.parseInt(request, "sportNum", 0); // 폼에서 받은 값이 없으면 0
	if (sportNum == 0) {
		sportNum = (Integer) session.getAttribute("sportNum"); // 세션에서 팀 번호 가져오기
	} else {
	    session.setAttribute("sportNum", sportNum); // 세션에 팀 번호 저장
	}
	Vector<TeamBean> teamVlist = teamMgr.listTeam(sportNum);

	boolean isLogin = false;

	if (login != null && login.getId() != null && !login.getId().isEmpty()) {
	    isLogin = true;
	}
	boolean isAdmin = userMgr.checkAdmin(login.getId()); // 관리자인지 확인

%>

<div class="menu" style="position:fixed; z-index: 2;">
        <!-- 관리자 햄버거 메뉴 -->
    		<%if(isAdmin){%>
	    		<ul class="menu-list">
			<li class="menu-item"><a style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/white_sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a></li>
            <li class="menu-item">
				<a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_player')"><span>야구</span></a>
				<ul>
                    	<% 
                    	// 스포츠 별 팀 불러오기
                    	teamVlist = teamMgr.listTeam(1);
                    	
                    		for(int i = 0; i < teamVlist.size(); i++){
							teamBean = teamVlist.get(i);
							teamNum = teamBean.getTEAM_NUM();
						%>
							<li><a href="#" onclick="sendTeamNum(<%=teamNum%>, 'admin_player')"><span><%=teamBean.getTEAM_NAME()%></span></a></li>
						<%
							}
						%>
                </ul>
			</li>
            <li class="menu-item">
            	<a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_goods')">축구</a>
            	<ul>
                    	<% 
                    	// 스포츠 별 팀 불러오기
                    	teamVlist = teamMgr.listTeam(2);
                    	
                    		for(int i = 0; i < teamVlist.size(); i++){
							teamBean = teamVlist.get(i);
							teamNum = teamBean.getTEAM_NUM();
						%>
							<li><a href="#" onclick="sendTeamNum(<%=teamNum%>, 'admin_player')"><span><%=teamBean.getTEAM_NAME()%></span></a></li>
						<%
							}
						%>
                </ul>
			</li>
            <li class="menu-item">
            	<a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'admin_board')">배구</a>
            	<ul>
                    	<% 
                    	// 스포츠 별 팀 불러오기
                    	teamVlist = teamMgr.listTeam(3);
                    	
                    		for(int i = 0; i < teamVlist.size(); i++){
							teamBean = teamVlist.get(i);
							teamNum = teamBean.getTEAM_NUM();
						%>
							<li><a href="#" onclick="sendTeamNum(<%=teamNum%>, 'admin_player')"><span><%=teamBean.getTEAM_NAME()%></span></a></li>
						<%
							}
						%>
                </ul>
			</li>
			<li class="menu-item"><a href="#">회원정보</a>
                    <ul>
						<!-- 로그인 상태에 따라 텍스트 변경 -->
	                    <li id="login">
						    <a id="log" href="<%= isLogin ? ".././user/logout.jsp" : ".././user/login.jsp" %>">
						        <span id="loginCheck"><%= isLogin ? "로그아웃" : "로그인" %></span>
						    </a>
						</li>
						<li id="signup"><a href=".././user/signup.jsp"><span>회원가입</span></a></li>
                        <li><a href=".././md/shoppingPage_basket.jsp"><span>장바구니</span></a></li>
                        <li><a href=".././user/myPage.jsp"><span>마이페이지</span></a></li>
                    </ul>
                </li>
        </ul>
    		<%} else {%>
    		<!-- 일반 햄버거 메뉴 -->
            <ul class="menu-list">
                <li class="menu-item">
                	<a href="#"><span>스포츠</span></a>
                    <ul>
                        <li class="baseball"><a href="#" onclick="sendSportNum(1)"><span>야구</span></a></li>
                        <li class="soccer"><a href="#" onclick="sendSportNum(2)"><span>축구</span></a></li>
                        <li class="volleyball"><a href="#" onclick="sendSportNum(3)"><span>배구</span></a></li>
                    </ul>
                </li>
                <li class="menu-item"><a href="#"><span>팀<span></a>
                    <ul>
                    	<% for(int i = 0; i < teamVlist.size(); i++){
							teamBean = teamVlist.get(i);
							teamNum = teamBean.getTEAM_NUM();
						%>
							<li><a href="#" onclick="sendTeamNum(<%=teamNum%>, '.././team/teamPage_player')"><span><%=teamBean.getTEAM_NAME()%></span></a></li>
						<%
							}
						%>
                    </ul>
                </li>
                <li class="menu-item"><a href="#">여행</a>
                    <ul>
						<li id="login"><a href=".././trip/tripPage_hotel.jsp"><span>숙박</span></a></li>
						<li id="signup"><a href=".././trip/tripPage_food.jsp"><span>식당</span></a></li>
                    </ul>
                </li>
                <li class="menu-item"><a href="#">회원정보</a>
                    <ul>
						<!-- 로그인 상태에 따라 텍스트 변경 -->
	                    <li id="login">
						    <a id="log" href="<%= isLogin ? ".././user/logout.jsp" : ".././user/login.jsp" %>">
						        <span id="loginCheck"><%= isLogin ? "로그아웃" : "로그인" %></span>
						    </a>
						</li>
						<li id="signup"><a href=".././user/signup.jsp"><span>회원가입</span></a></li>
                        <li><a href=".././md/shoppingPage_basket.jsp"><span>장바구니</span></a></li>
                        <li><a href=".././user/myPage.jsp"><span>마이페이지</span></a></li>
                    </ul>
                </li>
            </ul>
			<%} %>
    </div>
    
    <script>
    // 로그아웃 시 세션 해제
    document.getElementById('log').addEventListener('click', function(e) {
        if (document.getElementById('loginCheck').innerHTML === '로그아웃') {
            e.preventDefault(); // 기본 동작 방지
            // 로그아웃 처리: 세션 해제
            fetch('.././user/logout.jsp')
                .then(response => {
                    if (response.ok) {
                        alert("로그아웃 되었습니다.");
                        location.reload();
                    }
                })
                .catch(error => console.error('Logout failed:', error));
        }
    });
    </script>

