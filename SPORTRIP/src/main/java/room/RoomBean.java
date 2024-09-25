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

	public void setROOM_NUM(int num) {
		ROOM_NUM = num;
	}

	public int getLODGING_NUM() {
		return LODGING_NUM;
	}

	public void setLODGING_NUM(int num) {
		LODGING_NUM = num;
	}

	public String getROOM_NAME() {
		return ROOM_NAME;
	}

	public void setROOM_NAME(String name) {
		ROOM_NAME = name;
	}

	public int getSEAT_CAPACITY_R() {
		return SEAT_CAPACITY_R;
	}

	public void setSEAT_CAPACITY_R(int num) {
		SEAT_CAPACITY_R = num;
	}

	public int getROOM_PRICE() {
		return ROOM_PRICE;
	}

	public void setROOM_PRICE(int price) {
		ROOM_PRICE = price;
	}

	public String getROOM_IMG() {
		return ROOM_IMG;
	}

	public void setROOM_IMG(String img) {
		ROOM_IMG = img;
	}

	public int getRESERVE_NOW() {
		return RESERVE_NOW;
	}

	public void setRESERVE_NOW(int now) {
		RESERVE_NOW = now;
	}
}
