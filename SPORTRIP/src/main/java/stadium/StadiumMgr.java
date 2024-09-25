package stadium;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;
import team.TeamBean;

public class StadiumMgr {	
	private DBConnectionMgr pool;
	
	public StadiumMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 팀별 경기장 조회
	public StadiumBean getStadium(int teamNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		StadiumBean bean = new StadiumBean();
		try {
			con = pool.getConnection();
			sql = "select * from stadium where team_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, teamNum);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				bean.setSTADIUM_NUM(rs.getInt(1));
				bean.setSTADIUM_NAME(rs.getString(2));
				bean.setSTADIUM_ADDRESS(rs.getString(3));
				bean.setSEATS(rs.getString(4));
				bean.setSEAT_CAPACITY_S(rs.getInt(5));
				bean.setTEAM_NUM(rs.getInt(6));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
}
