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
    public Vector<BasketBean> listBasket(String id) {
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
    
	// 해당 아이디가 동일한 제품을 주문 했는지 판별
	public boolean vaildateBasket(String id, int md_num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = null;
		BasketBean basket = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			// md_num으로 그룹화하고 repair_b의 합계를 구함
			query = "SELECT * FROM BASKET WHERE ID = ?, MD_NUM = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// 리소스 해제
			if (rs != null) try { rs.close(); } catch (Exception e) {}
			if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
			if (con != null) try { con.close(); } catch (Exception e) {}
		}
		return flag;
	}
    
    // 장바구니 담기
    public boolean insertBasket(BasketBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			BasketMgr mgr = new BasketMgr();
			if(mgr.vaildateBasket(bean.getID(), bean.getMD_NUM())) {
				sql = "update basket set REPAIR_B = REPAIR_B + ? where basket_num = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, bean.getBASKET_NUM());
				pstmt.setInt(2, bean.getREPAIR_B());
			}else {
				sql = "insert into basket values(null, ?, ?, ?)";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, bean.getID());
				pstmt.setInt(2, bean.getMD_NUM());
				pstmt.setInt(3, bean.getREPAIR_B());
			}
			
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
    
    // 결제 완료 장바구니 삭제
    public boolean paymentDeleteBasket(String Id, int mdNum) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	String sql = null;
    	boolean flag = false;
    	try {
    		con = pool.getConnection();
    		sql = "delete from basket where Id = ? and md_num = ?";
    		pstmt = con.prepareStatement(sql);
    		pstmt.setString(1, Id);
    		pstmt.setInt(2, mdNum);
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
    public boolean updateBasket(int basket_num, int quantity) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "update basket set REPAIR_B = ? where basket_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, quantity);
			pstmt.setInt(2, basket_num);
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
