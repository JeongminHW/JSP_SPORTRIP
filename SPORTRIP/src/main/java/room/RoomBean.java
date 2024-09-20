package room;

public class RoomBean {
	private int ROOM_NUM;
	private int LODGING_NUM;
	private String ROOM_NAME;
	private int SEAT_CAPACITY_R;
	private int ROOM_PRICE;
	private String ROOM_IMG;
	private int RESERVE_NOW;
	
	public int getROOM_NUM() {
		return ROOM_NUM;
	}
	public int getLODGING_NUM() {
		return LODGING_NUM;
	}
	public String getROOM_NAME() {
		return ROOM_NAME;
	}
	public int getSEAT_CAPACITY_R() {
		return SEAT_CAPACITY_R;
	}
	public int getROOM_PRICE() {
		return ROOM_PRICE;
	}
	public String getROOM_IMG() {
		return ROOM_IMG;
	}
	public int getRESERVE_NOW() {
		return RESERVE_NOW;
	}
	public void setRESERVE_NOW(int now) {
		RESERVE_NOW = now;
	}
}
