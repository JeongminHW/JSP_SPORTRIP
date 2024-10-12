<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<section class="first-page" id="first-page">
		<header>
			<a class="logo" style="cursor: pointer" href="mainPage.jsp"><img src=".././assets/images/white_sportrip_logo.png" alt="sportrip 로고" id="logo_img"> </a>
			<div id="header" class="c_main">
				<div class="h_wrap">
					<nav class="h_gnb">
						<div class="hg_list">
							<ul>
								<li class="rank">
									<a href="#" onclick="document.getElementById('third-page').scrollIntoView({behavior: 'smooth'})"><span>Rank</span></a>
								</li>
								<li class="highlight">
									<a href="#" onclick="document.getElementById('second-page').scrollIntoView({behavior: 'smooth'})"><span>Highlight</span></a>
								</li>
								<li class="matchdate">
									<a href=".././sport/sport_matchDate.jsp"><span>MatchDate</span></a>
								</li>
							</ul>
						</div>
					</nav>
					<input id="toggle" type="checkbox" /> <label class="hamburger"
						for="toggle">
						<div class="top"></div>
						<div class="middle"></div>
						<div class="bottom"></div>
					</label>
				</div>
			</div>
	<jsp:include page="../hamburger.jsp"/>