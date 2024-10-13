<%@page import="board.BoardBean"%>
<%@page import="board.BoardMgr"%>
<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:useBean id="boardMgr" class="board.BoardMgr" />
<jsp:useBean id="boardBean" class="board.BoardBean" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<%
    // 수정할 게시글 번호 가져오기
    int boardNum = MUtil.parseInt(request, "boardNum", 0);
    BoardBean board = boardMgr.getBoard(boardNum); // 게시글 정보 가져오기
%>
<jsp:include page="../header.jsp" />
   <div class="post-box">
       <form action="" name="postForm">
           <!-- 글 작성 테이블 -->
           <table class="post-table">
               <colgroup>
                   <col width="10%">
                   <col width="80%">
               </colgroup>
               <tr>
                   <th>제목</th>
                   <td><input type="text" name="title" placeholder="제목을 입력해주세요." value="<%= board.getTITLE() %>"></td>
               </tr>
               <tr>
                   <th>작성자</th>
                   <td><input type="text" name="writer" value="<%=login.getId() %>" readonly></td>
               </tr>
               <tr>
                   <th>내용</th>
                   <td style="text-align: left;"><textarea name="postediter" id="summernote"><%= board.getCONTENTS() %></textarea></td>
               </tr>
           </table>
       </form>
   </div>
<div class="post-btn-box">
    <button type="button" class="post-btn" onclick="updateBoard(<%= boardNum %>)">수정</button>
    <button type="button" class="post-btn" onclick="goList()">목록</button>
</div>
<script>
    $(document).ready(function() {
        $('#summernote').summernote({
            height: 550, 
            lang: "ko-KR", 
            placeholder: "내용을 입력하세요.", 
            toolbar: [
                ['fontname', ['fontname']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['style', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['height', ['height']],
                ['insert', ['picture']]
            ]
        });
    });

    function updateBoard(boardNum) {
        var content = $('#summernote').val();
        var title = $('input[name="title"]').val();

        var formData = $('form[name="updateForm"]').serialize();
        formData += '&postediter=' + encodeURIComponent(content);
        formData += '&title=' + title;  
        formData += '&boardNum=' + boardNum;

        $.ajax({
            url: ".././board/board_update_in.jsp", 
            type: "POST",
            data: formData,
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            success: function(response) {
                if (response.includes('success')) {
                    alert("게시글이 성공적으로 수정되었습니다.");
                    location.href = ".././team/teamPage_board.jsp";
                } else {
                    alert("게시글 수정에 실패했습니다.");
                }
            },
            error: function() {
                alert("오류가 발생했습니다.");
            }
        });
    }

    function goList() {
        history.back();
    }
</script>