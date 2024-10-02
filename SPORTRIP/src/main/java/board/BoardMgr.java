package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;
import player.PlayerBean;

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
			sql = "insert into board values(null, ?, ?, now(), ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getTITLE());
			pstmt.setString(2, bean.getCONTENTS());
			pstmt.setString(3, bean.getIP());
			pstmt.setString(4, bean.getID());
			pstmt.setInt(5, bean.getRECOMMAND());
			pstmt.setInt(6, bean.getNONRECOMMAND());
			pstmt.setInt(7, bean.getTEAM_NUM());
			pstmt.setString(8, bean.getBOARD_IMG());
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
	
	// 게시글 1개 조회
	public BoardBean getBoard(int boardNum) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    BoardBean bean = new BoardBean();
	    try {
	        con = pool.getConnection();
	        sql = "SELECT * FROM board WHERE board_num = ?"; // WHERE 절 추가
	        pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, boardNum); // boardNum 값 바인딩
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
	            updateViews(bean.getTEAM_NUM(), bean.getBOARD_NUM()); // 조회수 업데이트
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
		BoardBean board = null;
		Vector<BoardBean> vlist = new Vector<BoardBean>();
		try {
			con = pool.getConnection();
			sql = "select * from board where team_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, teamNum);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				board = new BoardBean(); // 새로운 Bean 객체 생성
				board.setBOARD_NUM(rs.getInt(1));
				board.setTITLE(rs.getString(2));
				board.setCONTENTS(rs.getString(3));
				board.setPOSTDATE(rs.getString(4));
				board.setIP(rs.getString(5));
				board.setID(rs.getString(6));
				board.setRECOMMAND(rs.getInt(7));
				board.setNONRECOMMAND(rs.getInt(8));
				board.setTEAM_NUM(rs.getInt(9));
				board.setVIEWS(rs.getInt(10));
				board.setBOARD_IMG(rs.getString(11));
				vlist.addElement(board);
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
			sql = "update board set ? = ? + 1 where team_num = ? and board_num = ?";
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
			sql = "update board set views = views + 1 where team_num = ? and board_num = ?";
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

	
	
}
