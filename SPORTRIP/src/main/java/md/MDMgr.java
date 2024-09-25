package md;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import DB.DBConnectionMgr;

public class MDMgr {
	private DBConnectionMgr pool;

	public MDMgr() {
		pool = DBConnectionMgr.getInstance();
	}

	// 모든 굿즈 조회
	public List<MDBean> getAllMD() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = null;
		MDBean md = null;
		List<MDBean> mdList = new ArrayList<>();
		try {
			con = pool.getConnection();
			query = "SELECT * FROM MD";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				md.setMD_NUM(rs.getInt(1));
				md.setTEAM_NUM(rs.getInt(2));
				md.setSPORT_NUM(rs.getInt(3));
				md.setMD_NAME(rs.getString(4));
				md.setMD_PRICE(rs.getInt(5));
				md.setMD_KINDOF(rs.getString(6));
				md.setMD_IMG(rs.getString(7));
				mdList.add(md);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mdList;
	}

	// 카테고리 별 굿즈 조회
	public Vector<MDBean> getAllMD(String md_kindof) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = null;
		MDBean md = null;
		Vector<MDBean> mdList = new Vector<MDBean>();
		try {
			con = pool.getConnection();
			query = "SELECT * FROM MD WHERE MD_KINDOF = ?";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				md.setMD_NUM(rs.getInt(1));
				md.setTEAM_NUM(rs.getInt(2));
				md.setSPORT_NUM(rs.getInt(3));
				md.setMD_NAME(rs.getString(4));
				md.setMD_PRICE(rs.getInt(5));
				md.setMD_KINDOF(rs.getString(6));
				md.setMD_IMG(rs.getString(7));
				mdList.add(md);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mdList;
	}
}
