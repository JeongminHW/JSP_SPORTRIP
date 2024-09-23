package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;

public class BoardMgr {
	private DBConnectionMgr pool;
	
	public BoardMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 게시글 등록
	public boolean insertBoard(BoardBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert board values(null, bean.getTITLE(), bean.getCONTENTS(), now(), bean.getIP(), bean.getID(), bean.getRECOMMAND(), bean.getNONRECOMMAND(), bean.getTEAM_NUM(), bean.getBOARD_IMG())";
			pstmt = con.prepareStatement(sql);

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
	
	// 게시글 수정
	public boolean updateBoard(BoardBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "update board set TITLE = bean.getTITLE(),CONTENTS = bean.getCONTENTS()), BOARD_IMG = bean.getBOARD_IMG() where team_num = ? and board_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, bean.getBOARD_NUM());
			pstmt.setInt(2, bean.getTEAM_NUM());
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
	
	// 게시글 삭제
	public boolean deleteBoard(int BoardNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from board where board_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, BoardNum);
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
	
	// 게시글 1개 조회(본인 글일 경우 수정/삭제 , 본인 글이 아닐 경우 추천/비추천 버튼 출력)
	public BoardBean getBoard(int teamNum, int boardNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		BoardBean bean = new BoardBean();
		try {
			con = pool.getConnection();
			sql = "select * from board where team_num = ? and board_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, teamNum);
			pstmt.setInt(2, boardNum);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				bean.setBOARD_NUM(rs.getInt(1));
				bean.setTITLE(rs.getString(2));
				bean.setCONTENTS(rs.getString(3));
				bean.setPOSTDATE(rs.getString(4));
				bean.setIP(rs.getString(5));
				bean.setID(rs.getString(6));
				bean.setRECOMMAND(rs.getInt(7));
				bean.setNONRECOMMAND(rs.getInt(8));
				bean.setTEAM_NUM(rs.getInt(9));
				bean.setVIEWS(rs.getInt(10));
				bean.setBOARD_IMG(rs.getString(11));
				
				updateViews(bean.getTEAM_NUM(), bean.getBOARD_NUM());
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
	
	// 게시글 리스트 조회
	public Vector<BoardBean> listBoard(int teamNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<BoardBean> vlist = new Vector<BoardBean>();
		try {
			con = pool.getConnection();
			sql = "select * from board where team_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, teamNum);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BoardBean bean = null;
				bean.setBOARD_NUM(rs.getInt(1));
				bean.setTITLE(rs.getString(2));
				bean.setCONTENTS(rs.getString(3));
				bean.setPOSTDATE(rs.getString(4));
				bean.setIP(rs.getString(5));
				bean.setID(rs.getString(6));
				bean.setRECOMMAND(rs.getInt(7));
				bean.setNONRECOMMAND(rs.getInt(8));
				bean.setTEAM_NUM(rs.getInt(9));
				bean.setVIEWS(rs.getInt(10));
				bean.setBOARD_IMG(rs.getString(11));
				vlist.addElement(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	// 게시글 추천, 비추천 상승
	public boolean updateCommand(String command, int teamNum, int boardNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "update board ? set ? + 1 where team_num = ? and board_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, command);
			pstmt.setString(2, command);
			pstmt.setInt(3, teamNum);
			pstmt.setInt(4, boardNum);
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
	
	// 조회 수 증가
	public void updateViews(int teamNum, int boardNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "update board views set views + 1 where team_num = ? and board_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, teamNum);
			pstmt.setInt(2, boardNum);
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	// 관리자 여부 확인
	public boolean checkAdmin(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "select count(*) from user where id = ? admin = 1";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return flag;
	}
	
	
}
