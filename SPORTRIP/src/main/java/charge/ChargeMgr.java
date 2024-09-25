package charge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import DB.DBConnectionMgr;

public class ChargeMgr {
	private DBConnectionMgr pool;

	public ChargeMgr() {
		pool = DBConnectionMgr.getInstance();
	}

	// 아이디로 결제 내역 조회
	public Vector<ChargeBean> getCharge(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = null;
		ChargeBean charge = null;
		Vector<ChargeBean> chargeList = new Vector<ChargeBean>();
		try {
			con = pool.getConnection();
			query = "SELECT * FROM CHARGE WHERE ID = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				charge = new ChargeBean();
				charge.setCHARGE_NUM(rs.getInt(1));
				charge.setID(rs.getString(2));
				charge.setMD_NUM(rs.getInt(3));
				charge.setREPAIR_C(rs.getInt(4));
				charge.setPRICE(rs.getInt(5));
				chargeList.addElement(charge);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return chargeList;
	}

	// 굿즈 결제
	public boolean payMD(ChargeBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert into md values(null, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getID());
			pstmt.setInt(2, bean.getMD_NUM());
			pstmt.setInt(3, bean.getREPAIR_C());
			pstmt.setInt(4, bean.getPRICE());
			if (pstmt.executeUpdate() == 1) {
				flag = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}

}
