package md;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DB.DBConnectionMgr;

public class MDMgr {
	private DBConnectionMgr pool;
	
	public MDMgr() {
        pool = DBConnectionMgr.getInstance();
    }
	
	// 모든 굿즈 조회
    public List<MDBean> getAllMD() {
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = null;
    	MDBean md = null;
        List<MDBean> mdList = new ArrayList<>();
        try {
        	con = pool.getConnection();
            query = "SELECT * FROM MD";
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	md.setMdNum(rs.getInt(1));
                md.setTeamNum(rs.getInt(2));
                md.setSportNum(rs.getInt(3));
                md.setMdName(rs.getString(4));
                md.setMdPrice(rs.getInt(5));
                md.setMdKindOf(rs.getString(6));
                md.setMdImg(rs.getString(7));
                mdList.add(md);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mdList;
    }
}
