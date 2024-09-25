package player;

import java.sql.Date;

public class PlayerBean {
    private int PLAYER_NUM;
    private int TEAM_NUM;
    private String PLAYER_NAME;
    private Date BIRTH;
    private String PLAYER_IMG;
    private String POSITION;
    private String UNIFORM_NUM;
	public int getPLAYER_NUM() {
		return PLAYER_NUM;
	}
	public void setPLAYER_NUM(int pLAYER_NUM) {
		PLAYER_NUM = pLAYER_NUM;
	}
	public int getTEAM_NUM() {
		return TEAM_NUM;
	}
	public void setTEAM_NUM(int tEAM_NUM) {
		TEAM_NUM = tEAM_NUM;
	}
	public String getPLAYER_NAME() {
		return PLAYER_NAME;
	}
	public void setPLAYER_NAME(String pLAYER_NAME) {
		PLAYER_NAME = pLAYER_NAME;
	}
	public Date getBIRTH() {
		return BIRTH;
	}
	public void setBIRTH(Date bIRTH) {
		BIRTH = bIRTH;
	}
	public String getPLAYER_IMG() {
		return PLAYER_IMG;
	}
	public void setPLAYER_IMG(String pLAYER_IMG) {
		PLAYER_IMG = pLAYER_IMG;
	}
	public String getPOSITION() {
		return POSITION;
	}
	public void setPOSITION(String pOSITION) {
		POSITION = pOSITION;
	}
	public String getUNIFORM_NUM() {
		return UNIFORM_NUM;
	}
	public void setUNIFORM_NUM(String uNIFORM_NUM) {
		UNIFORM_NUM = uNIFORM_NUM;
	}

    
}