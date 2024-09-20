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
}
