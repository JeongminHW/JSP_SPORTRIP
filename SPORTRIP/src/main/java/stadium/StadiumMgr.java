package stadium;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DB.DBConnectionMgr;

public class StadiumMgr {
    private DBConnectionMgr pool;

    public StadiumMgr() {
        pool = DBConnectionMgr.getInstance();
    }

    // 팀별 경기장 조회
    public StadiumBean getStadium(int teamNum) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = null;
        StadiumBean bean = new StadiumBean();
        try {
            con = pool.getConnection();
            sql = "select * from stadium where team_num = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, teamNum);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                bean.setSTADIUM_NUM(rs.getInt(1));
                bean.setSTADIUM_NAME(rs.getString(2));
                bean.setSTADIUM_ADDRESS(rs.getString(3));
                bean.setSEATS(rs.getString(4));
                bean.setSEAT_CAPACITY_S(rs.getInt(5));
                bean.setTEAM_NUM(rs.getInt(6));
                bean.setLAT(rs.getString("LAT")); // 위도 추가
                bean.setLON(rs.getString("LON")); // 경도 추가
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return bean;
    }

    public List<StadiumBean> getStadiumsBySport(int sportNum) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<StadiumBean> stadiumList = new ArrayList<>();
        try {
            con = pool.getConnection();
            String sql = "SELECT * FROM stadium WHERE TEAM_NUM IN (SELECT TEAM_NUM FROM team WHERE SPORT_NUM = ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, sportNum);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                StadiumBean bean = new StadiumBean();
                bean.setSTADIUM_NUM(rs.getInt("STADIUM_NUM"));
                bean.setSTADIUM_NAME(rs.getString("STADIUM_NAME"));
                bean.setLAT(rs.getString("LAT")); // 위도 추가
                bean.setLON(rs.getString("LON")); // 경도 추가
                stadiumList.add(bean);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return stadiumList;
    }
    
    // 경기장 이름으로 조회하는 메소드 추가
    public StadiumBean getStadiumByName(String stadiumName) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StadiumBean bean = null; // 초기화
        try {
            con = pool.getConnection();
            String sql = "SELECT * FROM stadium WHERE STADIUM_NAME = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, stadiumName);
            System.out.println(stadiumName);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                bean = new StadiumBean(); // 결과가 있을 경우에만 객체 생성
                bean.setSTADIUM_NUM(rs.getInt("STADIUM_NUM"));
                bean.setSTADIUM_NAME(rs.getString("STADIUM_NAME"));
                bean.setSTADIUM_ADDRESS(rs.getString("STADIUM_ADDRESS"));
                bean.setSEATS(rs.getString("SEATS"));
                bean.setSEAT_CAPACITY_S(rs.getInt("SEAT_CAPACITY_S"));
                bean.setTEAM_NUM(rs.getInt("TEAM_NUM"));
                bean.setLAT(rs.getString("LAT")); // 위도 추가
                bean.setLON(rs.getString("LON")); // 경도 추가
                System.out.println(bean.getSTADIUM_NAME());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return bean; // 결과가 없을 경우 null 반환
    }
}
