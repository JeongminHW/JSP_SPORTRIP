<%@page import="java.util.Vector"%>
<%@page import="comment.CommentBean"%>
<%@page import="comment.CommentMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="commentMgr" class="comment.CommentMgr" />

<%
	//요청 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	int boardNum = Integer.parseInt(request.getParameter("boardNum"));
    Vector<CommentBean> commentList = commentMgr.listComment(boardNum); // 댓글 목록 가져오기
%>
<div class="box">
<!-- 댓글 -->
<% if (commentList != null && !commentList.isEmpty()) {%>
	<% for (CommentBean com : commentList) {%>
	<div class="comment-box" id="comment_<%=com.getCOMMENT_NUM() %>">
		<div class="user-box">
			<div class="userInfo">
				<span style="font-weight: bold;"><%=com.getID() %></span> <!-- 작성자 ID 표시 -->
				<span><%=com.getPOSTDATE() %></span>
				<span><%=com.getIP() %></span>
			</div>
			<% if (login != null && com.getID().equals(login.getId())) {%> <!-- 본인 댓글만 수정/삭제 -->
			<div class="update-btn">
				<button type="button" onclick="editComment(<%=com.getCOMMENT_NUM() %>)">수정</button>
                <button type="button" onclick="deleteComment(<%=com.getCOMMENT_NUM() %>)">삭제</button>
			</div>
			<% } %>
		</div>
		<div class="comment">
			<p><%=com.getCONTENTS() %></p>
		</div>
		<!-- 답글 버튼 -->
		<div class="comment-reple">
			<button onclick="repleComment(<%=com.getCOMMENT_NUM()%>)">답글</button>
		</div>
		<!-- 답글 출력 -->
		<div class="replies" style="display: none;">
		<%
			Vector<CommentBean> recommentList = commentMgr.listReply(com.getCOMMENT_NUM()); // 답글 목록 가져오기
			if (recommentList != null && !recommentList.isEmpty()) {
				for (CommentBean reCom : recommentList) {
		%>
			<div class="recomment-box" id="recomment_<%=reCom.getCOMMENT_NUM() %>">
				<div class="user-box">
					<div class="userInfo">
						<span style="font-weight: bold;"><%=reCom.getID() %></span> <!-- 답글 작성자 ID -->
						<span><%=reCom.getPOSTDATE() %></span>
						<span><%=reCom.getIP() %></span>
					</div>
					<% if (login != null && com.getID().equals(login.getId())) { %> <!-- 본인 답글만 수정/삭제 -->
					<div class="update-btn">
						<button type="button" onclick="editComment(<%=reCom.getCOMMENT_NUM() %>)">수정</button>
		                <button type="button" onclick="deleteComment(<%=reCom.getCOMMENT_NUM() %>)">삭제</button>
					</div>
					<% } %>
				</div>
				<div class="comment">
					<p><%=reCom.getCONTENTS() %></p>
				</div>
				<!-- 답글 수정-->
				<div class="comment-text-box" id="editForm_<%=reCom.getCOMMENT_NUM()%>" style="display:none;">
					<input type="hidden" name="commentNum" value="<%=reCom.getCOMMENT_NUM()%>" />
					<textarea name="comment" class="comment-text" id="textarea_<%=reCom.getCOMMENT_NUM()%>"><%=reCom.getCONTENTS()%></textarea>
			        <button type="button" class="comment-btn" onclick="updateComment(<%=reCom.getCOMMENT_NUM() %>)">완료</button>
			    </div>
			</div>
		<% } } %>
		</div>
		<!-- 로그인 했을 경우에만 답글 -->
		<% if (login.getId() != null) {%>
			<!-- 답글 -->
			<div class="reple-box" style="display: none;">
				<textarea name="comment" class="comment-text" id="recomment_<%=com.getCOMMENT_NUM() %>" placeholder="댓글을 입력해주세요."></textarea>
				<button type="button" class="comment-btn" onclick="postRepleComment(<%=com.getCOMMENT_NUM()%>)">등록</button>
			</div>
		<%} %>
		<!-- 댓글 수정-->
		<div class="comment-text-box" id="editForm_<%=com.getCOMMENT_NUM()%>" style="display:none;">
			<input type="hidden" name="commentNum" value="<%=com.getCOMMENT_NUM()%>" />
			<textarea name="comment" class="comment-text" id="textarea_<%=com.getCOMMENT_NUM()%>"><%=com.getCONTENTS()%></textarea>
	        <button type="button" class="comment-btn" onclick="updateComment(<%=com.getCOMMENT_NUM() %>)">완료</button>
	    </div>
	</div>
	<% }} else { %>
	    <p>댓글이 없습니다.</p>
	<% } %>
</div>
<!-- 로그인 했을 경우에만 댓글 -->
<% if (login.getId() != null) {%>
<div class="comment-text-box">
	<textarea name="comment" class="comment-text" placeholder="댓글을 입력해주세요." id="comment"></textarea>
	<button type="button" class="comment-btn" onclick="postComment()">등록</button>
</div>
<%} %>

<script>
	// 댓글 작성
	function postComment() {
	    const content = document.getElementById('comment').value;
	    
	 	// 파라미터
	    const params = new URLSearchParams();
	    params.append('boardNum', <%=boardNum%>);
	    params.append('content', content);
	    params.append('ip', '<%=request.getRemoteAddr()%>');
	    params.append('id', '<%=login.getId()%>');

	    fetch('comment_in.jsp', {
	        method: 'POST',
	        headers: {
	            'Content-Type': 'application/x-www-form-urlencoded'
	        },
	        body: params.toString() // 쿼리 스트링으로 변환하여 보냄
	    })
	    .then(response => response.text())
	    .then(data => {
	    	 var words = data.split('<');
	    	 console.log('서버 응답:', words[0].trim()); // 서버 응답 로그 출력
	         if (words[0].trim() === "success") { // 공백 제거 후 비교
	             location.reload(); // 댓글 등록 후 페이지 새로고침
	             alert('댓글이 등록되었습니다.');
	         } else {
	             alert('댓글이 등록되지 않았습니다.'); // 실패 시 메시지에 서버 응답 포함
	         }
	    })
	    .catch(error => console.error('Error:', error));
	}

	// 댓글 수정 폼 토글
	function editComment(commentNum) {
	    const editForm = document.getElementById('editForm_' + commentNum);
	 	// 현재 display 상태를 체크해 토글
	    if (editForm.style.display === 'none' || editForm.style.display === '') {
	        editForm.style.display = 'block';
	    } else {
	        editForm.style.display = 'none';
	    }
	}
	
	// 댓글 수정
	function updateComment(commentNum) {
	    const updatedContent = document.getElementById('textarea_' + commentNum).value;
	    // AJAX 호출로 수정 요청
	    fetch('comment_update.jsp', {
	        method: 'POST',
	        headers: {
	            'Content-Type': 'application/x-www-form-urlencoded'
	        },
	        body: new URLSearchParams({
	            'commentNum': commentNum,
	            'content': updatedContent
	        }).toString()
	    })
	    .then(response => response.text())
	    .then(data => {
	        if (data.trim() === "success") {
	            console.log('서버 응답:', data); // 서버 응답 로그 출력
	            const commentDiv = document.getElementById('comment_' + commentNum);
	            commentDiv.querySelector('p').innerText = updatedContent;
	            editComment(commentNum); // 수정 폼 닫기
	            alert('댓글이 수정되었습니다.');
	        } else {
	            alert('댓글을 수정하지 못했습니다.'); // 서버 응답 로그 출력
	        }
	    })
	    .catch(error => console.error('Error:', error));
	}
	
	// 댓글 삭제
	function deleteComment(commentNum) {
	    // AJAX 호출로 삭제 요청
	    fetch('comment_delete.jsp', {
	        method: 'POST',
	        headers: {
	            'Content-Type': 'application/x-www-form-urlencoded'
	        },
	        body: new URLSearchParams({
	            'commentNum': commentNum
	        }).toString()
	    })
	    .then(response => response.text())
	    .then(data => {
	        if (data.trim() === "success") {
	            const commentDiv = document.getElementById('comment_' + commentNum);
	            if (commentDiv) {
	                commentDiv.remove(); // 댓글 삭제 성공 시 화면에서 삭제
	                alert('댓글이 삭제되었습니다.');
	            } else {
	                console.error('댓글 요소를 찾을 수 없습니다:', commentNum);
	            }
	        } else {
	            alert('댓글을 삭제하지 못했습니다.'); // 서버 응답 로그 출력
	        }
	    })
	    .catch(error => console.error('Error:', error));
	}
	
	// 답글 입력 폼 및 답글 목록 토글
	function repleComment(commentNum) {
	    const commentBox = document.getElementById('comment_' + commentNum);
	    const repliesDiv = commentBox.querySelector('.replies');
	    const repleBox = commentBox.querySelector('.reple-box');
	    
	    // 답글 목록 및 답글 작성 창 토글
	    if (repliesDiv.style.display === 'none' || repliesDiv.style.display === '') {
	        repliesDiv.style.display = 'block';  // 답글 목록 보이기
	        repleBox.style.display = 'block';    // 답글 작성 창 보이기
	    } else {
	        repliesDiv.style.display = 'none';   // 답글 목록 숨기기
	        repleBox.style.display = 'none';     // 답글 작성 창 숨기기
	    }
	}
	
	// 답글 등록
	function postRepleComment(commentNum) {
	    const content = document.getElementById('recomment_' + commentNum).value;
	    
	    // 파라미터 준비
	    const params = new URLSearchParams();
	    params.append('replynum', commentNum); // 부모 댓글 번호
	    params.append('content', content);
	    params.append('ip', '<%=request.getRemoteAddr()%>');
	    params.append('id', '<%=login.getId()%>');
	    params.append('boardNum', <%=boardNum%>); // 이 부분에서 boardNum 전달

	    fetch('comment_re.jsp', {
	        method: 'POST',
	        headers: {
	            'Content-Type': 'application/x-www-form-urlencoded'
	        },
	        body: params.toString()
	    })
	    .then(response => response.text())
	    .then(data => {
	        if (data.trim() === "success") {
	            location.reload(); // 답글 등록 후 새로고침
	            alert('답글이 등록되었습니다.');
	        } else {
	            alert('답글이 등록되지 않았습니다.');
	        }
	    })
	    .catch(error => console.error('Error:', error));
	}
</script>
