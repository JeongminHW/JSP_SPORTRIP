package headcoach;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;

public class HeadcoachMgr {
	private DBConnectionMgr pool;

	public HeadcoachMgr() {
		pool = DBConnectionMgr.getInstance();
	}

	// 팀 번호로 감독 검색
	public HeadcoachBean getHeadcoach(int num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		HeadcoachBean bean = null;
		try {
			con = pool.getConnection();
			sql = "select * from headcoach where team_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				bean = new HeadcoachBean();
				bean.setHEADCOACH_NUM(rs.getInt(1));
				bean.setHEADCOACH_NAME(rs.getString(2));
				bean.setHEADCOACH_IMG(rs.getString(3));
				bean.setTEAM_NUM(rs.getInt(4));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
}
