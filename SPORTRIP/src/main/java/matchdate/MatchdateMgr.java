package matchdate;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;

public class MatchdateMgr {
	
	private DBConnectionMgr pool;
	
	public MatchdateMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 오늘 이후 경기 일정 조회
	public Vector<MatchdateBean> listMachedate(){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<MatchdateBean> vlist = null;
		try {
			con = pool.getConnection();
			sql = "select * from matchdate where MATCH_DATE >= now()";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				MatchdateBean bean = new MatchdateBean();
				bean.setMATCH_DATE_NUM(rs.getInt(1));
				bean.setSTADIUM_NUM(rs.getInt(2));
				bean.setMATCH_DATE(rs.getString(3));
				bean.setTEAM_NUM1(rs.getInt(4));
				bean.setTEAM_NUM2(rs.getInt(5));
				vlist.addElement(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
}
