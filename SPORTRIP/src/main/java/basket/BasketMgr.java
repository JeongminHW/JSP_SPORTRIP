package basket;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import DB.DBConnectionMgr;

public class BasketMgr {
	private DBConnectionMgr pool;
	
	public BasketMgr() {
        pool = DBConnectionMgr.getInstance();
    }
	
	// 아이디로 장바구니 목록 조회
    public Vector<BasketBean> getBasket(String id) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
    	BasketBean basket = null;
    	Vector<BasketBean> basketList = new Vector<BasketBean>();
        try {
        	con = pool.getConnection();
            query = "SELECT * FROM BASKET WHERE ID = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                basket = new BasketBean();
                basket.setBASKET_NUM(rs.getInt(1));
                basket.setID(rs.getString(2));
                basket.setMD_NUM(rs.getInt(3));
                basket.setREPAIR_B(rs.getInt(4));
                basketList.add(basket);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return basketList;
    }
    
    // 장바구니 담기
    public boolean insertBasket(BasketBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert into basket values(null, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getID());
			pstmt.setInt(2, bean.getMD_NUM());
			pstmt.setInt(3, bean.getREPAIR_B());
			if(pstmt.executeUpdate() == 1) {
				flag = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
    
    // 장바구니 삭제
    public boolean deleteBasket(int basket_num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from basket where basket_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, basket_num);
			if(pstmt.executeUpdate() == 1) {
				flag = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
    
    // 장바구니 수량 수정
    public boolean updateBasket(BasketBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "update basket set REPAIR_B = ? where basket_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, bean.getREPAIR_B());
			pstmt.setInt(2, bean.getBASKET_NUM());
			if(pstmt.executeUpdate() == 1) {
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
