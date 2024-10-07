package player;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import DB.DBConnectionMgr;

public class PlayerMgr {
	private DBConnectionMgr pool;
	
	public PlayerMgr() {
        pool = DBConnectionMgr.getInstance();
    }
    
    // 특정 팀의 선수 목록 조회
    public Vector<PlayerBean> TeamPlayers(int teamNum) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = null;
        PlayerBean player = null;
        Vector<PlayerBean> playerList = new Vector<PlayerBean>();
        
        try {
            con = pool.getConnection();
            query = "SELECT * FROM player WHERE TEAM_NUM = ?"; // 팀 번호로 필터링
            pstmt = con.prepareStatement(query);
            pstmt.setInt(1, teamNum); // 팀 번호 설정
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                player = new PlayerBean(); // 새로운 PlayerBean 객체 생성
                player.setPLAYER_NUM(rs.getInt(1));
                player.setTEAM_NUM(rs.getInt(2));
                player.setPLAYER_NAME(rs.getString(3));
                player.setBIRTH(rs.getString(4));
                player.setPLAYER_IMG(rs.getString(5));
                player.setPOSITION(rs.getString(6));
                player.setUNIFORM_NUM(rs.getString(7));
                playerList.add(player);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 연결 종료
            pool.freeConnection(con, pstmt, rs);
        }       
        return playerList;
    }
    
    // 특정 선수의 정보 조회
    public PlayerBean getPlayer(int playerNum) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
    	PlayerBean player = null;
    	
    	try {
    		con = pool.getConnection();
    		query = "SELECT * FROM player WHERE PLAYER_NUM = ?"; // 팀 번호로 필터링
    		pstmt = con.prepareStatement(query);
    		pstmt.setInt(1, playerNum); // 팀 번호 설정
    		rs = pstmt.executeQuery();
    		
    		if (rs.next()) {

    			player = new PlayerBean(); // 새로운 PlayerBean 객체 생성
    			player.setPLAYER_NUM(rs.getInt(1));
    			player.setTEAM_NUM(rs.getInt(2));
    			player.setPLAYER_NAME(rs.getString(3));
    			player.setBIRTH(rs.getString(4));
    			player.setPLAYER_IMG(rs.getString(5));
    			player.setPOSITION(rs.getString(6));
    			player.setUNIFORM_NUM(rs.getString(7));
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	} finally {
    		// 연결 종료
    		pool.freeConnection(con, pstmt, rs);
    	}       
    	return player;
    }
    
    // 선수 등록(관리자)
    public boolean insertPlayer(PlayerBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert into player values(null, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, bean.getTEAM_NUM());
			pstmt.setString(2, bean.getPLAYER_NAME());
			pstmt.setString(3, bean.getBIRTH());
			pstmt.setString(4, bean.getPLAYER_IMG());
			pstmt.setString(5, bean.getPOSITION());
			pstmt.setString(6, bean.getUNIFORM_NUM());
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
    // 선수 수정(관리자)
    public boolean updatePlayer(PlayerBean bean) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	String sql = null;
    	boolean flag = false;
    	try {
    		con = pool.getConnection();
    		sql = "update player set PLAYER_NAME = ?, BIRTH = ?, POSITION = ?, UNIFORM_NUM = ?, PLAYER_IMG = ? where PLAYER_NUM = ?";
			pstmt = con.prepareStatement(sql);
			
    		pstmt.setString(1, bean.getPLAYER_NAME());
    		pstmt.setString(2, bean.getBIRTH());
    		pstmt.setString(3, bean.getPOSITION());
    		pstmt.setString(4, bean.getUNIFORM_NUM());
    		pstmt.setString(5, bean.getPLAYER_IMG());
    		pstmt.setInt(6, bean.getPLAYER_NUM());
    		
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
    
    // 선수 삭제(관리자)
    public boolean deletePlayer(int player_num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from player where player_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, player_num);
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
