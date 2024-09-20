package reserve;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;


public class ReserveMgr {
	private DBConnectionMgr pool;
	public ReserveMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 팀 번호로 감독 검색
	public ReserveBean setID(int id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		ReserveBean bean = null;
		try {
			con = pool.getConnection();
			sql = "select * from reserve where id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				bean = new ReserveBean();
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
}
