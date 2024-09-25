package lodging;

public class LodgingBean {
	private int LODGING_NUM;
	private String LODGING_NAME;
	private String CATEGORY;
	private String GRADE;
	private String ADDRESS;
	private String LODGING_IMG;
	private String LON;
	private String LAT;
	private String STARDIUM;

	public int getLODGING_NUM() {
		return LODGING_NUM;
	}

	public String getLODGING_NAME() {
		return LODGING_NAME;
	}

	public String getCATEGORY() {
		return CATEGORY;
	}

	public String getGRADE() {
		return GRADE;
	}

	public String getADDRESS() {
		return ADDRESS;
	}

	public String getLODGING_IMG() {
		return LODGING_IMG;
	}

	public String getLON() {
		return LON;
	}

	public String getLAT() {
		return LAT;
	}

	public String getSTARDIUM() {
		return STARDIUM;
	}

	public void setLODGING_NUM(int num) {
		LODGING_NUM = num;
	}

	public void setLODGING_NAME(String name) {
		LODGING_NAME = name;
	}

	public void setCATEGORY(String cg) {
		CATEGORY = cg;
	}

	public void setGRADE(String grade) {
		GRADE = grade;
	}

	public void setADDRESS(String add) {
		ADDRESS = add;
	}

	public void setLODGING_IMG(String img) {
		LODGING_IMG = img;
	}

	public void setLON(String lon) {
		LON = lon;
	}

	public void setLAT(String lat) {
		LAT = lat;
	}

	public void setSTARDIUM(String star) {
		STARDIUM = star;
	}
}
