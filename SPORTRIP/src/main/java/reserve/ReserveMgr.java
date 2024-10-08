package reserve;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

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
	
	// 사용자 예약 예정 정보 전체 출력
	public Vector<ReserveBean> soonListReserve(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<ReserveBean> vlist = new Vector<ReserveBean>();
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM Reserve WHERE ID = ? and CHECK_IN > now()";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ReserveBean bean = new ReserveBean();
				bean.setRESERVE_NUM(rs.getInt("RESERVE_NUM")); 
				bean.setID(rs.getString("ID"));                
				bean.setLODGING_NUM(rs.getInt("LODGING_NUM")); 
				bean.setROOM_NUM(rs.getInt("ROOM_NUM"));       
				bean.setHEADCOUNT(rs.getInt("HEADCOUNT"));     
				bean.setRESERVE_PRICE(rs.getInt("RESERVE_PRICE"));
				bean.setCHECK_IN(rs.getDate("CHECK_IN"));         
				bean.setCHECK_OUT(rs.getDate("CHECK_OUT"));     
				vlist.addElement(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	// 사용자 예약 종료 정보 전체 출력
	public Vector<ReserveBean> endListReserve(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<ReserveBean> vlist = new Vector<ReserveBean>();
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM Reserve WHERE ID = ? and CHECK_IN <= now()";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ReserveBean bean = new ReserveBean();
				bean.setRESERVE_NUM(rs.getInt("RESERVE_NUM")); 
				bean.setID(rs.getString("ID"));                
				bean.setLODGING_NUM(rs.getInt("LODGING_NUM")); 
				bean.setROOM_NUM(rs.getInt("ROOM_NUM"));       
				bean.setHEADCOUNT(rs.getInt("HEADCOUNT"));     
				bean.setRESERVE_PRICE(rs.getInt("RESERVE_PRICE"));
				bean.setCHECK_IN(rs.getDate("CHECK_IN"));         
				bean.setCHECK_OUT(rs.getDate("CHECK_OUT"));     
				vlist.addElement(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	// 예약 정보 저장
	public String saveReserve(ReserveBean bean) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    String sql = null;
	    String errorMsg = null; 
	    try {
	        con = pool.getConnection();
	        sql = "INSERT INTO RESERVE (ID, LODGING_NUM, ROOM_NUM, HEADCOUNT, RESERVE_PRICE, CHECK_IN, CHECK_OUT) "
	                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, bean.getID());        
	        pstmt.setInt(2, bean.getLODGING_NUM());  
	        pstmt.setInt(3, bean.getROOM_NUM());     
	        pstmt.setInt(4, bean.getHEADCOUNT());    
	        pstmt.setInt(5, bean.getRESERVE_PRICE());
	        pstmt.setDate(6, new Date(bean.getCHECK_IN().getTime())); 
	        pstmt.setDate(7, new Date(bean.getCHECK_OUT().getTime())); 
	        
	        if (pstmt.executeUpdate() > 0) {
	            return null; // 성공 시 null 반환
	        } else {
	            errorMsg = "DB 저장 실패"; // DB에 저장이 안될 경우
	        }
	    } catch (SQLException e) {
	        errorMsg = e.getMessage(); // SQL 예외 발생 시 메시지 저장
	    } catch (Exception e) {
	        errorMsg = "예약 저장 중 오류 발생: " + e.getMessage();
	    } finally {
	        pool.freeConnection(con, pstmt, null); 
	    }
	    
	    return errorMsg; // 실패 시 오류 메시지 반환
	}
}
