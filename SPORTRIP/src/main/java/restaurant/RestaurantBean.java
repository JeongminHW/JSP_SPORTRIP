package restaurant;

public class RestaurantBean {
	private int RESTAURANT_NUM;
	private String RESTAURANT_NAME;
	private String CATEGORY;
	private String GRADE;
	private String ADDRESS;
	private String RESTAURANT_IMG;
	private String LON;
	private String LAT;
	private String STARDIUM;

	public int getRESTAURANT_NUM() {
		return RESTAURANT_NUM;
	}

	public String getRESTAURANT_NAME() {
		return RESTAURANT_NAME;
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

	public String getRESTAURANT_IMG() {
		return RESTAURANT_IMG;
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

	public void setRESTAURANT_NUM(int num) {
		RESTAURANT_NUM = num;
	}

	public void setRESTAURANT_NAME(String name) {
		RESTAURANT_NAME = name;
	}

	public void setCATEGORY(String cate) {
		CATEGORY = cate;
	}

	public void setGRADE(String grade) {
		GRADE = grade;
	}

	public void setADDRESS(String add) {
		ADDRESS = add;
	}

	public void setRESTAURANT_IMG(String img) {
		RESTAURANT_IMG = img;
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
