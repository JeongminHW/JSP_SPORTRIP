package lodging;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;


public class LodgingMgr {
	private DBConnectionMgr pool;
	public LodgingMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 경기장 숙소 출력
	public Vector<LodgingBean> getLodgings(String stardium) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
	    Vector<LodgingBean> lodgingList = new Vector<LodgingBean>();
	    try {
	        con = pool.getConnection();
	        sql = "SELECT LODGING_NUM, LODGING_NAME, CATEGORY, GRADE, ADDRESS, LODGING_IMG, LON, LAT FROM LODGING WHERE STARDIUM = ?";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, stardium);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            LodgingBean bean = new LodgingBean();
	            bean.setLODGING_NUM(rs.getInt(1));      
	            bean.setLODGING_NAME(rs.getString(2)); 
	            bean.setCATEGORY(rs.getString(3));         
	            bean.setGRADE(rs.getString(4));               
	            bean.setADDRESS(rs.getString(5));           
	            bean.setLODGING_IMG(rs.getString(6));   
	            bean.setLON(rs.getString(7));                   
	            bean.setLAT(rs.getString(8));                   
	            lodgingList.addElement(bean);
	        }
        } catch (Exception e) {
            e.printStackTrace();
        }
	    return lodgingList;
	}

	// 경기장 숙소 2개 출력(추천)
	public Vector<LodgingBean> getLodgingsRecommend(String stardium) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
	    Vector<LodgingBean> lodgingList = new Vector<LodgingBean>();
	    try {
	        con = pool.getConnection();
	        sql = "SELECT LODGING_NUM, LODGING_NAME, CATEGORY, GRADE, ADDRESS, LODGING_IMG, LON, LAT FROM LODGING WHERE STARDIUM = ?"
	        		+ "LIMIT 2";	// 2개 제한
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, stardium);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            LodgingBean bean = new LodgingBean();
	            bean.setLODGING_NUM(rs.getInt(1));      
	            bean.setLODGING_NAME(rs.getString(2)); 
	            bean.setCATEGORY(rs.getString(3));         
	            bean.setGRADE(rs.getString(4));               
	            bean.setADDRESS(rs.getString(5));           
	            bean.setLODGING_IMG(rs.getString(6));   
	            bean.setLON(rs.getString(7));                   
	            bean.setLAT(rs.getString(8));                   
	            lodgingList.addElement(bean);
	        }
        } catch (Exception e) {
            e.printStackTrace();
        }
	    return lodgingList;
	}
}
