package md;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;

public class MDMgr {
	private DBConnectionMgr pool;
	
	public MDMgr() {
        pool = DBConnectionMgr.getInstance();
    }
	
	// 모든 굿즈 조회
    public Vector<MDBean> listMD(int TeamNum) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
    	
        Vector<MDBean> mdVector = new Vector<MDBean>();
        try {
        	con = pool.getConnection();
            query = "SELECT * FROM md where team_num = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setInt(1, TeamNum);
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	MDBean md = new MDBean();
            	md.setMD_NUM(rs.getInt(1));
                md.setTEAM_NUM(rs.getInt(2));
                md.setSPORT_NUM(rs.getInt(3));
                md.setMD_NAME(rs.getString(4));
                md.setMD_PRICE(rs.getInt(5));
                md.setMD_KINDOF(rs.getString(6));
                md.setMD_IMG(rs.getString(7));
                mdVector.addElement(md);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mdVector;
    }
    
    // 카테고리 별 굿즈 조회
    public Vector<MDBean> listCategoryMD(String md_kindof) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
    	MDBean md = null;
    	Vector<MDBean> mdVector = new Vector<MDBean>();
        try {
        	con = pool.getConnection();
            query = "SELECT * FROM md WHERE MD_KINDOF = ?";
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	md.setMD_NUM(rs.getInt(1));
                md.setTEAM_NUM(rs.getInt(2));
                md.setSPORT_NUM(rs.getInt(3));
                md.setMD_NAME(rs.getString(4));
                md.setMD_PRICE(rs.getInt(5));
                md.setMD_KINDOF(rs.getString(6));
                md.setMD_IMG(rs.getString(7));
                mdVector.add(md);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mdVector;
    }
    
    // 해당 넘버를 가진 상품 조회
    public MDBean getMD(int md_num) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
    	MDBean md = new MDBean();
    	
    	try {
    		con = pool.getConnection();
    		query = "SELECT * FROM md WHERE md_num = ?";
    		pstmt = con.prepareStatement(query);
    		pstmt.setInt(1, md_num);
    		rs = pstmt.executeQuery();
    		while (rs.next()) {
    			md.setMD_NUM(rs.getInt(1));
    			md.setTEAM_NUM(rs.getInt(2));
    			md.setSPORT_NUM(rs.getInt(3));
    			md.setMD_NAME(rs.getString(4));
    			md.setMD_PRICE(rs.getInt(5));
    			md.setMD_KINDOF(rs.getString(6));
    			md.setMD_IMG(rs.getString(7));
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	return md;
    }
    
    // 상품 등록
    public boolean insertMD(MDBean bean) {
    	Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		
		try {
			con = pool.getConnection();
			sql = "insert md values(null, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, bean.getTEAM_NUM());
			pstmt.setInt(2, bean.getSPORT_NUM());
			pstmt.setString(3, bean.getMD_NAME());
			pstmt.setInt(4, bean.getMD_PRICE());
			pstmt.setString(5, bean.getMD_KINDOF());
			pstmt.setString(6, bean.getMD_IMG());
			
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
    
    // 굿즈 수정(관리자)
    public boolean updateMD(MDBean bean) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String sql = null;
        boolean flag = false;

        try {
            con = pool.getConnection();
            sql = "UPDATE md SET md_name = ?, md_price = ?, md_kindof = ?, md_img = ? WHERE md_num = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, bean.getMD_NAME());
            pstmt.setInt(2, bean.getMD_PRICE());
            pstmt.setString(3, bean.getMD_KINDOF());
            pstmt.setString(4, bean.getMD_IMG());
            pstmt.setInt(5, bean.getMD_NUM());

            if (pstmt.executeUpdate() == 1) {
                flag = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
        return flag;
    }
    
    // 굿즈 삭제(관리자)
    public boolean deleteMD(int mdNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from md where md_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, mdNum);
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
