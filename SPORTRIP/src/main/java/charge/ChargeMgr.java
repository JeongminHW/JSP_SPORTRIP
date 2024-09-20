package charge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DB.DBConnectionMgr;

public class ChargeMgr {
	private DBConnectionMgr pool;
	
	public ChargeMgr() {
        pool = DBConnectionMgr.getInstance();
    }
	
	// 아이디로 결제 내역 조회
    public List<ChargeBean> getCharge(String id) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
    	ChargeBean charge = null;
        List<ChargeBean> chargeList = new ArrayList<>();
        try {
        	con = pool.getConnection();
            query = "SELECT * FROM CHARGE WHERE ID = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	charge = new ChargeBean();
                charge.setChargeNum(rs.getInt(1));
                charge.setId(rs.getString(2));
                charge.setMdNum(rs.getInt(3));
                charge.setRepairC(rs.getInt(4));
                charge.setPrice(rs.getInt(5));
                chargeList.add(charge);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return chargeList;
    }

}
