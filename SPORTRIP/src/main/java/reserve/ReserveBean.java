package reserve;

import java.sql.Date;

public class ReserveBean {
	private int RESERVE_NUM;
	private String ID;
	private int LODGING_NUM;
	private int ROOM_NUM;
	private int HEADCOUNT;
	private int RESERVE_PRICE;
	private Date CHECK_IN;
	private Date CHECK_OUT;

	public int getRESERVE_NUM() {
		return RESERVE_NUM;
	}

	public void setRESERVE_NUM(int num) {
		RESERVE_NUM = num;
	}

	public String getID() {
		return ID;
	}

	public void setID(String id) {
		ID = id;
	}

	public int getLODGING_NUM() {
		return LODGING_NUM;
	}

	public void setLODGING_NUM(int num) {
		LODGING_NUM = num;
	}

	public int getROOM_NUM() {
		return ROOM_NUM;
	}

	public void setROOM_NUM(int num) {
		ROOM_NUM = num;
	}

	public int getHEADCOUNT() {
		return HEADCOUNT;
	}

	public void setHEADCOUNT(int count) {
		HEADCOUNT = count;
	}

	public int getRESERVE_PRICE() {
		return RESERVE_PRICE;
	}

	public void setRESERVE_PRICE(int price) {
		RESERVE_PRICE = price;
	}

	public Date getCHECK_IN() {
		return CHECK_IN;
	}

	public void setCHECK_IN(Date in) {
		CHECK_IN = in;
	}

	public Date getCHECK_OUT() {
		return CHECK_OUT;
	}

	public void setCHECK_OUT(Date out) {
		CHECK_OUT = out;
	}
}
