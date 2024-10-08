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
			sql = "insert into board values(null, ?, ?, now(), ?, ?, 0, 0, ?, 0)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getTITLE());
			pstmt.setString(2, bean.getCONTENTS());
			pstmt.setString(3, bean.getIP());
			pstmt.setString(4, bean.getID());
			pstmt.setInt(5, bean.getTEAM_NUM());
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
	        // 게시글 번호(board_num)를 기준으로 제목(TITLE)과 내용(CONTENTS)을 수정
	        sql = "UPDATE board SET TITLE = ?, CONTENTS = ?, POSTDATE = now() WHERE BOARD_NUM = ?";
	        pstmt = con.prepareStatement(sql);
	        
	        // 제목, 내용, 이미지 값을 설정
	        pstmt.setString(1, bean.getTITLE());  // 수정된 제목
	        pstmt.setString(2, bean.getCONTENTS());  // 수정된 내용
	        pstmt.setInt(3, bean.getBOARD_NUM());

	        // 업데이트 성공 시 flag를 true로 설정
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
	public boolean updateCommand(String command, int boardNum) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    String sql = null;
	    boolean flag = false;
	    try {
	        con = pool.getConnection();
	        
	        // command가 'RECOMMAND'나 'NONRECOMMAND'인 경우에만 처리
	        if ("RECOMMAND".equals(command) || "NONRECOMMAND".equals(command)) {
	            // 컬럼명을 동적으로 설정
	            sql = "UPDATE board SET " + command + " = " + command + " + 1 WHERE board_num = ?";
	            pstmt = con.prepareStatement(sql);
	            pstmt.setInt(1, boardNum);

	            if (pstmt.executeUpdate() == 1) {
	                flag = true;
	            }
	        } else {
	            System.out.println("Invalid command: " + command);
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
