package room;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;


public class RoomMgr {
	private DBConnectionMgr pool;
	public RoomMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 팀 번호로 감독 검색
	public RoomBean setRESERVE_NOW(int now) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		RoomBean bean = null;
		try {
			con = pool.getConnection();
			sql = "select * from room where room_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, now);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				bean = new RoomBean();
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
}
