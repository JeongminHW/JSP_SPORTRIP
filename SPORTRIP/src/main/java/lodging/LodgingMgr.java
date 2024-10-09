package lodging;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import DB.DBConnectionMgr;
import reserve.ReserveBean;

public class LodgingMgr {
    private DBConnectionMgr pool;

    public LodgingMgr() {
        pool = DBConnectionMgr.getInstance();
    }

    // 경기장 이름에 따른 숙소 조회 메서드
    public List<LodgingBean> getLodgingsByStadiumName(String stadiumName) {
    	Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<LodgingBean> lodgingList = new ArrayList<>();

        try {
            con = pool.getConnection();
            String sql = "SELECT l.* FROM lodging l JOIN stadium s ON l.STARDIUM = s.STADIUM_NAME WHERE s.STADIUM_NAME = ?";
            System.out.println("SQL Query: " + sql + " with parameter: " + stadiumName); // 디버깅용 출력
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, stadiumName);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                LodgingBean lodging = new LodgingBean();
                lodging.setLODGING_NUM(rs.getInt("LODGING_NUM"));
                lodging.setLODGING_NAME(rs.getString("LODGING_NAME"));
                lodging.setCATEGORY(rs.getString("CATEGORY"));
                lodging.setGRADE(rs.getString("GRADE"));
                lodging.setADDRESS(rs.getString("ADDRESS"));
                lodging.setLODGING_IMG(rs.getString("LODGING_IMG"));
                lodging.setLON(rs.getString("LON"));
                lodging.setLAT(rs.getString("LAT"));
                lodging.setSTARDIUM(rs.getString("STARDIUM")); // STARDIUM 필드
                lodgingList.add(lodging);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs); // 연결 해제
        }
        return lodgingList;
    }
    
    public List<LodgingBean> getAllLodgings() {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<LodgingBean> lodgingList = new ArrayList<>();

        try {
            con = pool.getConnection();
            String sql = "SELECT * FROM lodging"; // 모든 숙소 정보 가져오기
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                LodgingBean lodging = new LodgingBean();
                lodging.setLODGING_NUM(rs.getInt("LODGING_NUM"));
                lodging.setLODGING_NAME(rs.getString("LODGING_NAME"));
                lodging.setCATEGORY(rs.getString("CATEGORY"));
                lodging.setGRADE(rs.getString("GRADE"));
                lodging.setADDRESS(rs.getString("ADDRESS"));
                lodging.setLODGING_IMG(rs.getString("LODGING_IMG"));
                lodging.setLON(rs.getString("LON"));
                lodging.setLAT(rs.getString("LAT"));
                lodging.setSTARDIUM(rs.getString("STARDIUM")); // STARDIUM 필드
                lodgingList.add(lodging);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs); // 연결 해제
        }
        return lodgingList;
    }
    
	public LodgingBean getLodging(int lodgingNum) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    LodgingBean lodging = null;
	    try {
	        con = pool.getConnection();
	        sql = "SELECT * FROM lodging WHERE LODGING_NUM = ?";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, lodgingNum);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
                lodging = new LodgingBean();
                lodging.setLODGING_NUM(rs.getInt("LODGING_NUM"));
                lodging.setLODGING_NAME(rs.getString("LODGING_NAME"));
                lodging.setCATEGORY(rs.getString("CATEGORY"));
                lodging.setGRADE(rs.getString("GRADE"));
                lodging.setADDRESS(rs.getString("ADDRESS"));
                lodging.setLODGING_IMG(rs.getString("LODGING_IMG"));
                lodging.setLON(rs.getString("LON"));
                lodging.setLAT(rs.getString("LAT"));
                lodging.setSTARDIUM(rs.getString("STARDIUM")); // STARDIUM 필드
                
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(con, pstmt, rs);
	    }
	    return lodging;
	}

}
