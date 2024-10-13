package restaurant;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import DB.DBConnectionMgr;

public class RestaurantMgr {
    private DBConnectionMgr pool;

    public RestaurantMgr() {
        pool = DBConnectionMgr.getInstance();
    }

    // 경기장 이름에 따른 맛집 조회 메서드
    public List<RestaurantBean> getRestaurantsByStadiumName(String stadiumName) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<RestaurantBean> restaurantList = new ArrayList<>();

        try {
            con = pool.getConnection();
            String sql = "SELECT r.* FROM restaurant r JOIN stadium s ON r.STADIUM = s.STADIUM_NAME WHERE s.STADIUM_NAME = ?";
            System.out.println("SQL Query: " + sql + " with parameter: " + stadiumName); // 디버깅용 출력

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, stadiumName);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                RestaurantBean restaurant = new RestaurantBean();
                restaurant.setRESTAURANT_NUM(rs.getInt("RESTAURANT_NUM"));
                restaurant.setRESTAURANT_NAME(rs.getString("RESTAURANT_NAME"));
                restaurant.setCATEGORY(rs.getString("CATEGORY"));
                restaurant.setGRADE(rs.getString("GRADE"));
                restaurant.setADDRESS(rs.getString("ADDRESS"));
                restaurant.setRESTAURANT_IMG(rs.getString("RESTAURANT_IMG"));
                restaurant.setLON(rs.getString("LON"));
                restaurant.setLAT(rs.getString("LAT"));
                restaurant.setSTARDIUM(rs.getString("STADIUM")); // STARDIUM 필드
                restaurantList.add(restaurant);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs); // 연결 해제
        }
        return restaurantList;
    }
}
