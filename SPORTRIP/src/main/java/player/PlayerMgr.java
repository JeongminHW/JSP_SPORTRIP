package player;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DB.DBConnectionMgr;

public class PlayerMgr {
	private DBConnectionMgr pool;
	
	public PlayerMgr() {
        pool = DBConnectionMgr.getInstance();
    }
	
	// 전체 선수 목록 조회
    public List<PlayerBean> getAllPlayer() {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
    	PlayerBean player = null;
        List<PlayerBean> playerList = new ArrayList<>();
        try {
        	con = pool.getConnection();
            query = "SELECT * FROM PLAYER";
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	player.setPlayerNum(rs.getInt(1));
                player.setTeamNum(rs.getInt(2));
                player.setPlayerName(rs.getString(3));
                player.setPlayerImg(rs.getString(4));
                player.setBirth(rs.getDate(5));
                player.setPosition(rs.getString(6));
                player.setUniformNum(rs.getString(7));
                playerList.add(player);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return playerList;
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
			pstmt.setInt(1, bean.getTeamNum());
			pstmt.setString(2, bean.getPlayerName());
			pstmt.setDate(3, bean.getBirth());
			pstmt.setString(4, bean.getPlayerImg());
			pstmt.setString(5, bean.getPosition());
			pstmt.setString(6, bean.getUniformNum());
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
    public boolean updatePlayer(int player_num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete player where player_num = ?";
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
