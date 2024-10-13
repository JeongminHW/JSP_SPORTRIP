<%@page import="java.util.List"%>
<%@page import="matchdate.MatchdateBean"%>
<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="matchdateMgr" class="matchdate.MatchdateMgr" />
<jsp:useBean id="stadiumMgr" class="stadium.StadiumMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<link href=".././assets/css/matchDate.css" rel="stylesheet" type="text/css"/>
<% 
    // 세션에서 sportNum 가져오기
    int sportNum = (int)session.getAttribute("sportNum");

    // 선택된 월 확인 (없으면 0으로 처리)
    String selectedMonthStr = request.getParameter("month");
    int selectedMonth = selectedMonthStr != null ? Integer.parseInt(selectedMonthStr) : 0;

    // 경기 데이터를 가져오기 (월별 혹은 전체)
    Vector<MatchdateBean> matchdateVlist = new Vector<>();
    if (selectedMonth > 0) {
        // 선택된 월이 있으면 해당 월 데이터만 조회
        matchdateVlist = matchdateMgr.monthMachedate(sportNum, selectedMonth);
    } else {
        // 선택된 월이 없으면 전체 데이터를 조회
        matchdateVlist = matchdateMgr.listMachedate(sportNum);
    }
%>

<jsp:include page="matchDate_header.jsp"/>


<div class="matchdate-header">
    <h1 class="matchdate-title">Match Date</h1>
</div>

	<!-- 월 선택 박스 -->
	<div class="category-box">
	    <form method="GET" action="">
	        <select name="month" class="select month" onchange="this.form.submit()">
	            <option value="0">전체</option>
	            <% for (int i = 1; i <= 12; i++) { %>
	                <option value="<%=i%>" <%= (i == selectedMonth) ? "selected" : "" %>><%=i%>월</option>
	            <% } %>
	        </select>
	    </form>
	</div>
<!-- 경기 일정 테이블 -->
<div class="league-date-table">
    <table>
        <thead>
            <tr>
                <th>날짜</th>
                <th>시간</th>
                <th>경기</th>
                <th>장소</th>
            </tr>
        </thead>
        <tbody>
            <% 
                String lastMatchDate = "";
                int rowspan = 1;
                if (matchdateVlist != null && !matchdateVlist.isEmpty()) {
                    // 각 날짜별로 rowspan 값을 계산
                    for (int i = 0; i < matchdateVlist.size(); i++) {
                        MatchdateBean matchDate = matchdateVlist.get(i);
                        String currentMatchDate = matchDate.getMATCH_DATE();
                        
                        // 같은 날짜의 경기가 연속으로 몇 개 있는지 확인
                        rowspan = 1;
                        for (int j = i + 1; j < matchdateVlist.size(); j++) {
                            if (currentMatchDate.equals(matchdateVlist.get(j).getMATCH_DATE())) {
                                rowspan++;
                            } else {
                                break;
                            }
                        }
                        i += rowspan - 1; // 인덱스 조정

                        for (int k = 0; k < rowspan; k++) {
                            MatchdateBean currentMatch = matchdateVlist.get(i - rowspan + 1 + k);
                            String team1[] = teamMgr.getTeamInfo(currentMatch.getTEAM_NUM1());
                            String team2[] = teamMgr.getTeamInfo(currentMatch.getTEAM_NUM2());
                            
                            if (k == 0) {
            %>
                <tr>
                    <!-- rowspan을 적용하여 날짜를 한 번만 표시 -->
                    <td rowspan="<%=rowspan%>" class="date-cell"><%=currentMatchDate%></td>
                    <td><%=currentMatch.getMATCH_TIME()%></td>
                    <td class="team-info">
                        <img src="<%=team1[1]%>" alt="<%=team1[0]%>" />
                        <span><%=team1[0]%></span>
                        <span class="score"><%=currentMatch.getTEAM1_POINT()%> : <%=currentMatch.getTEAM2_POINT()%></span>
                        <img src="<%=team2[1]%>" alt="<%=team2[0]%>" />
                        <span><%=team2[0]%></span>
                    </td>
                    <td><%=matchdateMgr.getstadiumName(currentMatch.getMATCH_DATE_NUM())%></td>
                </tr>
            <% 
                            } else {
            %>
                <tr>
                    <td><%=currentMatch.getMATCH_TIME()%></td>
                    <td class="team-info">
                        <img src="<%=team1[1]%>" alt="<%=team1[0]%>" />
                        <span><%=team1[0]%></span>
                        <span class="score"><%=currentMatch.getTEAM1_POINT()%> : <%=currentMatch.getTEAM2_POINT()%></span>
                        <img src="<%=team2[1]%>" alt="<%=team2[0]%>" />
                        <span><%=team2[0]%></span>
                    </td>
                    <td><%=matchdateMgr.getstadiumName(currentMatch.getMATCH_DATE_NUM())%></td>
                </tr>
            <% 
                            }
                        }
                    }
                } else { 
            %>
                <!-- 경기 일정이 없을 경우 -->
                <tr>
                    <td colspan="4" class="no-matches">해당 월에 경기가 없습니다.</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>
   <div class="test-element" style="height: 50px; background-color: #f9f9f9;"></div> 

