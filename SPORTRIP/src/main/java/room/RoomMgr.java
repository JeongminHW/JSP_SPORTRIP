package room;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import DB.DBConnectionMgr;

public class RoomMgr {
    private DBConnectionMgr pool;

    public RoomMgr() {
        pool = DBConnectionMgr.getInstance();
    }

    // 숙소번호에 따른 객실 출력
    public List<RoomBean> getRoomsByLodgingNum(int lodgingNum) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = null;
        List<RoomBean> roomlist = new ArrayList<>();

        try {
            con = pool.getConnection();
            sql = "SELECT * FROM Room WHERE LODGING_NUM = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, lodgingNum);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                RoomBean room = new RoomBean();
                room.setROOM_NUM(rs.getInt("ROOM_NUM"));
                room.setLODGING_NUM(rs.getInt("LODGING_NUM"));
                room.setROOM_NAME(rs.getString("ROOM_NAME"));
                room.setSEAT_CAPACITY_R(rs.getInt("SEAT_CAPACITY_R"));
                room.setROOM_PRICE(rs.getInt("ROOM_PRICE"));
                room.setROOM_IMG(rs.getString("ROOM_IMG"));
                room.setRESERVE_NOW(rs.getInt("RESERVE_NOW"));
                roomlist.add(room);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return roomlist;
    }
    
}
