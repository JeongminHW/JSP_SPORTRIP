package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;
import player.PlayerBean;

public class UserMgr {
	private DBConnectionMgr pool;
	
	public UserMgr() {
        pool = DBConnectionMgr.getInstance();
    }
	
	// 사용자 추가
    public boolean addUser(UserBean user) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	String query = null;
    	boolean flag = false;
    	
        try {
			con = pool.getConnection();
            query = "INSERT INTO USER (ID, PW, NAME, ADDRESS, POSTCODE, PHONE, EMAIL, ADMIN) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, user.getId());
            pstmt.setString(2, user.getPw());
            pstmt.setString(3, user.getName());
            pstmt.setString(4, user.getAddress());
            pstmt.setInt(5, user.getPostcode());
            pstmt.setString(6, user.getPhone());
            pstmt.setString(7, user.getEmail());
            pstmt.setInt(8, user.getAdmin());
            if(pstmt.executeUpdate() == 1) {
            	flag = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return flag;
    }
    
    // 사용자 수정
    public boolean updateUser(UserBean user) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	String query = null;
    	boolean flag = false;
    	
    	try {
    		con = pool.getConnection();
    		query = "update user set NAME = ?, ADDRESS = ?, POSTCODE = ?, PHONE = ?, EMAIL = ? where ID = ?";
    		pstmt = con.prepareStatement(query);
    		pstmt.setString(1, user.getName());
    		pstmt.setString(2, user.getAddress());
    		pstmt.setInt(3, user.getPostcode());
    		pstmt.setString(4, user.getPhone());
    		pstmt.setString(5, user.getEmail());
    		pstmt.setString(6, user.getId());
    		if(pstmt.executeUpdate() == 1) {
    			flag = true;
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	return flag;
    }
    
    // 로그인
	public boolean checkLogin(String id, String pw) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "select id from user where id = ? and pw = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return flag;
	}

	public UserBean getJoin(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		UserBean bean = new UserBean();
		try {
			con = pool.getConnection();
			sql = "select * from user where id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				bean.setId(rs.getString(1));
				bean.setPw(rs.getString(2));
				bean.setName(rs.getString(3));
				bean.setAddress(rs.getString(4));
				bean.setPostcode(rs.getInt(5));
				bean.setPhone(rs.getString(6));
				bean.setEmail(rs.getString(7));
				bean.setAdmin(rs.getInt(8));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
	
	// 관리자 여부 확인
	public boolean checkAdmin(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "select id from user where id = ? and admin = 1";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return flag;
	}
	
	// 아아디 중복 확인
	public boolean validateId(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "select id from user where id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return flag;
	}
}
