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
    public void addUser(UserBean user) {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
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
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
