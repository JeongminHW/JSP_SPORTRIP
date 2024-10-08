package charge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import DB.DBConnectionMgr;
import basket.BasketMgr;

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
                charge.setORDER_NUM(rs.getString(3));
                charge.setCHARGE_DATE(rs.getString(5));
                charge.setMD_NUM(rs.getInt(6));
                charge.setREPAIR_C(rs.getInt(7));
                charge.setPRICE(rs.getInt(8));
                chargeList.addElement(charge);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return chargeList;
    }
    
    // 아이디와 스포츠로 결제 내역 조회
    public Vector<ChargeBean> findSportCharge(String id, int sportNum) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
    	ChargeBean charge = null;
    	Vector<ChargeBean> chargeList = new Vector<ChargeBean>();
    	try {
    		con = pool.getConnection();
    		query = "SELECT c.*"
    				+" FROM CHARGE c"
    				+" JOIN MD m ON c.MD_NUM = m.MD_NUM"
    				+" WHERE c.ID = ? and m.SPORT_NUM = ?";
    		

    		pstmt = con.prepareStatement(query);
    		pstmt.setString(1, id);
    		pstmt.setInt(2, sportNum);
    		rs = pstmt.executeQuery();
    		while (rs.next()) {
    			charge = new ChargeBean();
    			charge.setCHARGE_NUM(rs.getInt(1));
    			charge.setID(rs.getString(2));
    			charge.setORDER_NUM(rs.getString(3));
    			charge.setCHARGE_DATE(rs.getString(4));
    			charge.setMD_NUM(rs.getInt(5));
    			charge.setREPAIR_C(rs.getInt(6));
    			charge.setPRICE(rs.getInt(7));
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
			sql = "insert into charge values(null, ?, ?, now(), ?, ?, ? )";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getID());
			pstmt.setString(2, bean.getORDER_NUM());
			pstmt.setInt(3, bean.getMD_NUM());
			pstmt.setInt(4, bean.getREPAIR_C());
			pstmt.setInt(5, bean.getPRICE());
			
			if(pstmt.executeUpdate() == 1) {
				BasketMgr basketmgr = new BasketMgr();
				if(basketmgr.paymentDeleteBasket(bean.getID(), bean.getMD_NUM())) {
					flag = true;
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}

}
