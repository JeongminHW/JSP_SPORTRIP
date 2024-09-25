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
			query = "INSERT INTO USER (ID, PW, NAME, ADDRESS, POSTCODE, PHONE, EMAIL) VALUES (?, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, user.getId());
			pstmt.setString(2, user.getPw());
			pstmt.setString(3, user.getName());
			pstmt.setString(4, user.getAddress());
			pstmt.setInt(5, user.getPostcode());
			pstmt.setString(6, user.getPhone());
			pstmt.setString(7, user.getEmail());
			if (pstmt.executeUpdate() == 1) {
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
			sql = "select count(*) from user where id = ? pw = ?";
			pstmt = con.prepareStatement(sql);
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

	// 관리자 여부 확인
	public boolean checkAdmin(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "select count(*) from user where id = ? admin = 1";
			pstmt = con.prepareStatement(sql);
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
