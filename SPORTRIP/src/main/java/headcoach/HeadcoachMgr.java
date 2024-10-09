package headcoach;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;
import player.PlayerBean;


public class HeadcoachMgr {
	private DBConnectionMgr pool;
	public HeadcoachMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	// 특정 팀의 감독 목록 조회
    public Vector<HeadcoachBean> TeamHeadCoach(int teamNum) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = null;
        HeadcoachBean coach = null;
        Vector<HeadcoachBean> coachList = new Vector<HeadcoachBean>();
        try {
            con = pool.getConnection();
            query = "SELECT * FROM headcoach WHERE TEAM_NUM = ?"; // 팀 번호로 필터링
            pstmt = con.prepareStatement(query);
            pstmt.setInt(1, teamNum); // 팀 번호 설정
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
            	coach = new HeadcoachBean(); // 새로운 PlayerBean 객체 생성
            	coach.setHEADCOACH_NUM(rs.getInt(1));
            	coach.setHEADCOACH_NAME(rs.getString(2));
            	coach.setHEADCOACH_IMG(rs.getString(3));
            	coach.setTEAM_NUM(rs.getInt(4));
            	coachList.add(coach);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 연결 종료
            pool.freeConnection(con, pstmt, rs);
        }       
        return coachList;
    }
	// 특정 감독의 정보 검색
	public HeadcoachBean getHeadcoach(int headcoachNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		HeadcoachBean coach = null;
		try {
			con = pool.getConnection();
			sql = "select * from headcoach where headcoach_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, headcoachNum);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				coach = new HeadcoachBean();
				coach.setHEADCOACH_NUM(rs.getInt(1));
				coach.setHEADCOACH_NAME(rs.getString(2));
				coach.setHEADCOACH_IMG(rs.getString(3));
				coach.setTEAM_NUM(rs.getInt(4));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return coach;
	}
	
	// 감독 등록 (관리자)
    public boolean insertHeadcoach(HeadcoachBean bean) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String sql = null;
        boolean flag = false;
        try {
            con = pool.getConnection();
            sql = "INSERT INTO headcoach VALUES (NULL, ?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, bean.getHEADCOACH_NAME());
            pstmt.setString(2, bean.getHEADCOACH_IMG());
            pstmt.setInt(3, bean.getTEAM_NUM());
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

    // 감독 수정 (관리자)
    public boolean updateHeadcoach(HeadcoachBean bean) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String sql = null;
        boolean flag = false;
        try {
            con = pool.getConnection();
            sql = "UPDATE headcoach SET HEADCOACH_NAME = ?, HEADCOACH_IMG = ? WHERE HEADCOACH_NUM = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, bean.getHEADCOACH_NAME());
            pstmt.setString(2, bean.getHEADCOACH_IMG());
            pstmt.setInt(3, bean.getHEADCOACH_NUM());
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

    // 감독 삭제 (관리자)
    public boolean deleteHeadcoach(int headcoachNum) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String sql = null;
        boolean flag = false;
        try {
            con = pool.getConnection();
            sql = "DELETE FROM headcoach WHERE HEADCOACH_NUM = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, headcoachNum);
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
}
