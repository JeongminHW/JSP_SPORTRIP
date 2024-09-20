package lodging;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;


public class LodgingMgr {
	private DBConnectionMgr pool;
	public LodgingMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 팀 번호로 감독 검색
	public LodgingBean getLODGING_NAME() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		LodgingBean bean = null;
		try {
			con = pool.getConnection();
			sql = "select * from lodging where ";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				bean = new LodgingBean();
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
}
