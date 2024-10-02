package comment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import DB.DBConnectionMgr;
import board.BoardBean;

public class CommentMgr {
	private DBConnectionMgr pool;

	public CommentMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 해당 글의 댓글 조회
	public Vector<CommentBean> listComment(int boardnum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		CommentBean comment = null;
		Vector<CommentBean> vlist = new Vector<CommentBean>(); 
		try {
			con = pool.getConnection();
			sql = "select * from comment where board_num = ? AND REPLY_NUM IS NULL";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				comment = new CommentBean(); // 새로운 Bean 객체 생성
				comment.setCOMMENT_NUM(rs.getInt(1));
				comment.setREPLY_NUM(rs.getInt(2));
				comment.setCONTENTS(rs.getString(3));
				comment.setPOSTDATE(rs.getString(4));
				comment.setIP(rs.getString(5));
				comment.setID(rs.getString(6));
				comment.setBOARD_NUM(rs.getInt(7));
				vlist.addElement(comment);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	// 댓글 작성
	public boolean postComment(CommentBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert into comment values(null, null, ?, now(), ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getCONTENTS());
			pstmt.setString(2, bean.getIP());
			pstmt.setString(3, bean.getID());
			pstmt.setInt(4, bean.getBOARD_NUM());

			if(pstmt.executeUpdate() == 1) {
				flag = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	// 댓글/답글 수정
	public boolean updateComment(CommentBean bean) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    String sql = null;
	    boolean flag = false;
	    try {
	        con = pool.getConnection();
	        // IP와 ID는 수정하지 않고 내용만 업데이트
	        sql = "update comment set CONTENTS = ?, POSTDATE = now() where COMMENT_NUM = ?";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, bean.getCONTENTS()); // 내용
	        pstmt.setInt(2, bean.getCOMMENT_NUM()); // 댓글 번호

	        if (pstmt.executeUpdate() == 1) {
	            flag = true;
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(con, pstmt);
	    }
	    return flag;
	}
	
	// 댓글/대댓글 삭제
	public boolean deleteComment(int comment_num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from comment where comment_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, comment_num);

			if(pstmt.executeUpdate() == 1) {
				flag = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	// 답글 조회
	public Vector<CommentBean> listReply(int comment_num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		CommentBean comment = null;
		Vector<CommentBean> vlist = new Vector<CommentBean>(); 
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM comment WHERE REPLY_NUM = ? ORDER BY POSTDATE ASC";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, comment_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				comment = new CommentBean(); // 새로운 Bean 객체 생성
				comment.setCOMMENT_NUM(rs.getInt(1));
				comment.setREPLY_NUM(rs.getInt(2));
				comment.setCONTENTS(rs.getString(3));
				comment.setPOSTDATE(rs.getString(4));
				comment.setIP(rs.getString(5));
				comment.setID(rs.getString(6));
				comment.setBOARD_NUM(rs.getInt(7));
				vlist.addElement(comment);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	// 답글 작성
	public boolean postReply(CommentBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert into comment values(null, ?, ?, now(), ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, bean.getREPLY_NUM());
			pstmt.setString(2, bean.getCONTENTS());
			pstmt.setString(3, bean.getIP());
			pstmt.setString(4, bean.getID());
			pstmt.setInt(5, bean.getBOARD_NUM());

			if(pstmt.executeUpdate() == 1) {
				flag = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	
	// 답글 수정
	public boolean updateReply(CommentBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "update comment set CONTENTS = ?, POSTDATE = now() where COMMENT_NUM = ?";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, bean.getCONTENTS()); // 내용
	        pstmt.setInt(2, bean.getCOMMENT_NUM()); // 댓글 번호
			if(pstmt.executeUpdate() == 1) {
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	
	// 답글 삭제
	public boolean deleteReply(int comment_num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from comment where comment_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, comment_num);

			if(pstmt.executeUpdate() == 1) {
				flag = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
}
