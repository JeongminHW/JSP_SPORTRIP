package team;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;

public class TeamMgr {
	private DBConnectionMgr pool;
	
	public TeamMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 선택된 스포츠 팀 리스트 출력
	public Vector<TeamBean> listTeam(int sportNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<TeamBean> vlist = new Vector<TeamBean>();
		try {
			con = pool.getConnection();
			sql = "select * from team where sport_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, sportNum);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				TeamBean bean = new TeamBean();
				bean.setTEAM_NUM(rs.getInt(1));
				bean.setSPORT_NUM(rs.getInt(2));
				bean.setRANKING(rs.getInt(3));
				bean.setTEAM_NAME(rs.getString(4));
				bean.setGAME(rs.getInt(5));
				bean.setPOINT(rs.getInt(6));
				bean.setWIN(rs.getInt(7));
				bean.setDRAW(rs.getInt(8));
				bean.setLOSS(rs.getInt(9));
				bean.setWIN_POINT(rs.getInt(10));
				bean.setLOSS_POINT(rs.getInt(11));
				bean.setCLUBINFO(rs.getString(12));
				
				vlist.addElement(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	// 선택된 하나의 팀 출력
	public TeamBean getTeam(int teamNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		TeamBean bean = new TeamBean();
		try {
			con = pool.getConnection();
			sql = "select * from team where team_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, teamNum);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				bean.setTEAM_NUM(rs.getInt(1));
				bean.setSPORT_NUM(rs.getInt(2));
				bean.setRANKING(rs.getInt(3));
				bean.setTEAM_NAME(rs.getString(4));
				bean.setGAME(rs.getInt(5));
				bean.setPOINT(rs.getInt(6));
				bean.setWIN(rs.getInt(7));
				bean.setDRAW(rs.getInt(8));
				bean.setLOSS(rs.getInt(9));
				bean.setWIN_POINT(rs.getInt(10));
				bean.setLOSS_POINT(rs.getInt(11));
				bean.setCLUBINFO(rs.getString(12));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
}
