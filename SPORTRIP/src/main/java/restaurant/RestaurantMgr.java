package restaurant;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;

public class RestaurantMgr {
	private DBConnectionMgr pool;

	public RestaurantMgr() {
		pool = DBConnectionMgr.getInstance();
	}

	// 식당 숙소 2개 출력(추천)
	public Vector<RestaurantBean> getRestaurantsRecommend(String stardium) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<RestaurantBean> restaurantList = new Vector<RestaurantBean>();
		try {
			con = pool.getConnection();
			sql = "SELECT RESTAURANT_NUM, RESTAURANT_NAME, CATEGORY, GRADE, ADDRESS, RESTAURANT_IMG, LON, LAT FROM LODGING WHERE STARDIUM = ?"
					+ "LIMIT 2"; // 2개 제한
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, stardium);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				RestaurantBean bean = new RestaurantBean();
				bean.setRESTAURANT_NUM(rs.getInt(1));
				bean.setRESTAURANT_NAME(rs.getString(2));
				bean.setCATEGORY(rs.getString(3));
				bean.setGRADE(rs.getString(4));
				bean.setADDRESS(rs.getString(5));
				bean.setRESTAURANT_IMG(rs.getString(6));
				bean.setLON(rs.getString(7));
				bean.setLAT(rs.getString(8));
				restaurantList.addElement(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return restaurantList;
	}
}
