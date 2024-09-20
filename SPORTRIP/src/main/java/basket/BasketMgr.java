package basket;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DB.DBConnectionMgr;

public class BasketMgr {
	private DBConnectionMgr pool;
	
	public BasketMgr() {
        pool = DBConnectionMgr.getInstance();
    }
	
	// 아이디로 장바구니 목록 조회
    public List<BasketBean> getBasket(String id) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
    	BasketBean basket = null;
        List<BasketBean> basketList = new ArrayList<>();
        try {
        	con = pool.getConnection();
            query = "SELECT * FROM BASKET WHERE ID = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                basket = new BasketBean();
                basket.setBasketNum(rs.getInt(1));
                basket.setId(rs.getString(2));
                basket.setMdNum(rs.getInt(3));
                basket.setRepairB(rs.getInt(4));
                basketList.add(basket);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return basketList;
    }

}
