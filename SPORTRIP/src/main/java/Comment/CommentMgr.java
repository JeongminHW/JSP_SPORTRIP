package Comment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;

public class CommentMgr {
	private DBConnectionMgr pool;

	public CommentMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 해당 글의 댓글 조회
	public Vector<CommentBean> listComment(int board_num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<CommentBean> vlist = new Vector<CommentBean>(); 
		try {
			con = pool.getConnection();
			sql = "select * from comment where board_nnum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, board_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				CommentBean bean = new CommentBean();
				vlist.addElement(bean);
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
			sql = "insert into comment values(null, null, ?, now(), ?, ?, ?";
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
	
	// 댓글/대댓글 수정
	public boolean updateComment(CommentBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "update comment set CONTENTS = ?, POSTDATE = now(), IP = ?, ID = ? where COMMENT_NUM = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getCONTENTS());
			pstmt.setString(2, bean.getIP());
			pstmt.setString(3, bean.getID());
			pstmt.setInt(4, bean.getCOMMENT_NUM());

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
	
	// 대댓글 조회
	public Vector<CommentBean> listReply(int comment_num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<CommentBean> vlist = new Vector<CommentBean>(); 
		try {
			con = pool.getConnection();
			sql = "select * from comment where board_nnum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, comment_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				CommentBean bean = new CommentBean();
				vlist.addElement(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	// 대댓글 작성
	public boolean postReply(CommentBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert into comment values(null, ?, ?, now(), ?, ?, ?";
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
	
	
	// 대댓글 수정
	public boolean updateReply(CommentBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "update comment set CONTENTS = ?, POSTDATE = now(), IP = ?, ID = ? where COMMENT_NUM = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getCONTENTS());
			pstmt.setString(2, bean.getIP());
			pstmt.setString(3, bean.getID());
			pstmt.setInt(4, bean.getCOMMENT_NUM());

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
	
	
	// 대댓글 삭제
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
