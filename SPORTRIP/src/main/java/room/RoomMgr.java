package room;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;

public class RoomMgr {
	private DBConnectionMgr pool;
	public RoomMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 숙소번호, 객실번호에 따른 객실 출력
	public Vector<RoomBean> getRoom(int lnum, int rnum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
    	Vector<RoomBean> roomlist = new Vector<RoomBean>();
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM ROOM WHERE ROOM_NUM = ? AND LODGING_NUM = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, lnum);
			pstmt.setInt(2, rnum);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				RoomBean bean = new RoomBean();
				bean.setROOM_NUM(rs.getInt(1));
				bean.setLODGING_NUM(rs.getInt(2));
				bean.setROOM_NAME(rs.getString(3));
				bean.setSEAT_CAPACITY_R(rs.getInt(4));
				bean.setROOM_PRICE(rs.getInt(5));
				bean.setROOM_IMG(rs.getString(6));
				bean.setRESERVE_NOW(rs.getInt(7));
				roomlist.addElement(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return roomlist;
	}
}
