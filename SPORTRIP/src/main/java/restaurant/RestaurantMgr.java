package restaurant;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;


public class RestaurantMgr {
	private DBConnectionMgr pool;
	public RestaurantMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 팀 번호로 감독 검색
	public RestaurantBean getLODGING_NAME() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		RestaurantBean bean = null;
		try {
			con = pool.getConnection();
			sql = "select * from restaurant where ";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				bean = new RestaurantBean();
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
}
