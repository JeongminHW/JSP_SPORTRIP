package stadium;

public class StadiumBean {
	private int STADIUM_NUM;
	private String STADIUM_NAME;
	private String STADIUM_ADDRESS;
	private String SEATS;
	private int SEAT_CAPACITY_S;
	private int TEAM_NUM;
	private String LON;
	private String LAT;
	
	public int getSTADIUM_NUM() {
		return STADIUM_NUM;
	}
	public void setSTADIUM_NUM(int sTADIUM_NUM) {
		STADIUM_NUM = sTADIUM_NUM;
	}
	public String getSTADIUM_NAME() {
		return STADIUM_NAME;
	}
	public void setSTADIUM_NAME(String sTADIUM_NAME) {
		STADIUM_NAME = sTADIUM_NAME;
	}
	public String getSTADIUM_ADDRESS() {
		return STADIUM_ADDRESS;
	}
	public void setSTADIUM_ADDRESS(String sTADIUM_ADDRESS) {
		STADIUM_ADDRESS = sTADIUM_ADDRESS;
	}
	public String getSEATS() {
		return SEATS;
	}
	public void setSEATS(String sEATS) {
		SEATS = sEATS;
	}
	public int getSEAT_CAPACITY_S() {
		return SEAT_CAPACITY_S;
	}
	public void setSEAT_CAPACITY_S(int sEAT_CAPACITY_S) {
		SEAT_CAPACITY_S = sEAT_CAPACITY_S;
	}
	public int getTEAM_NUM() {
		return TEAM_NUM;
	}
	public void setTEAM_NUM(int tEAM_NUM) {
		TEAM_NUM = tEAM_NUM;
	}
	// LON과 LAT의 getter와 setter 추가
    public String getLON() {
        return LON;
    }
    public void setLON(String LON) {
        this.LON = LON;
    }
    public String getLAT() {
        return LAT;
    }
    public void setLAT(String LAT) {
        this.LAT = LAT;
    }
}
