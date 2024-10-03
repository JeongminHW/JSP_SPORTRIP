package charge;

public class ChargeBean {
    private int CHARGE_NUM;
    private String ID;
    private String ORDER_NUM;
    private String CHARGE_DATE;
    private int MD_NUM;
    private int REPAIR_C;
    private int PRICE;
    
	public int getCHARGE_NUM() {
		return CHARGE_NUM;
	}
	public void setCHARGE_NUM(int cHARGE_NUM) {
		CHARGE_NUM = cHARGE_NUM;
	}
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	public int getMD_NUM() {
		return MD_NUM;
	}
	public void setMD_NUM(int mD_NUM) {
		MD_NUM = mD_NUM;
	}
	public int getREPAIR_C() {
		return REPAIR_C;
	}
	public void setREPAIR_C(int rEPAIR_C) {
		REPAIR_C = rEPAIR_C;
	}
	public int getPRICE() {
		return PRICE;
	}
	public void setPRICE(int pRICE) {
		PRICE = pRICE;
	}
	public String getORDER_NUM() {
		return ORDER_NUM;
	}
	public void setORDER_NUM(String oRDER_NUM) {
		ORDER_NUM = oRDER_NUM;
	}
	public String getCHARGE_DATE() {
		return CHARGE_DATE;
	}
	public void setCHARGE_DATE(String cHARGE_DATE) {
		CHARGE_DATE = cHARGE_DATE;
	}

    
}
