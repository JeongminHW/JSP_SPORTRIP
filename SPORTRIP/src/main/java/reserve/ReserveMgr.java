package reserve;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;


public class ReserveMgr {
	private DBConnectionMgr pool;
	public ReserveMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 사용자 예약 정보 출력
	public ReserveBean setID(String id) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    ReserveBean bean = null;
	    try {
	        con = pool.getConnection();
	        sql = "SELECT * FROM LODGING WHERE ID = ?";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, id);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            bean = new ReserveBean();
	            bean.setRESERVE_NUM(rs.getInt("RESERVE_NUM")); 
	            bean.setID(rs.getString("ID"));                
	            bean.setLODGING_NUM(rs.getInt("LODGING_NUM")); 
	            bean.setROOM_NUM(rs.getInt("ROOM_NUM"));       
	            bean.setHEADCOUNT(rs.getInt("HEADCOUNT"));     
	            bean.setRESERVE_PRICE(rs.getInt("RESERVE_PRICE"));
	            bean.setCHECK_IN(rs.getDate("CHECK_IN"));         
	            bean.setCHECK_OUT(rs.getDate("CHECK_OUT"));     
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(con, pstmt, rs);
	    }
	    return bean;
	}
	
	// 예약 정보 저장
	public boolean saveReserve(ReserveBean bean) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    String sql = null;
	    boolean result = false;
	    try {
	        con = pool.getConnection();
	        sql = "INSERT INTO LODGING (RESERVE_NUM, ID, LODGING_NUM, ROOM_NUM, HEADCOUNT, RESERVE_PRICE, CHECK_IN, CHECK_OUT) "
	            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, bean.getRESERVE_NUM());  
	        pstmt.setString(2, bean.getID());        
	        pstmt.setInt(3, bean.getLODGING_NUM());  
	        pstmt.setInt(4, bean.getROOM_NUM());     
	        pstmt.setInt(5, bean.getHEADCOUNT());    
	        pstmt.setInt(6, bean.getRESERVE_PRICE());
	        pstmt.setDate(7, bean.getCHECK_IN());    
	        pstmt.setDate(8, bean.getCHECK_OUT());   
	        if (pstmt.executeUpdate() > 0) {
	            result = true;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }	    
	    return result;
	}
}
