package charge;

import java.util.List;

public class PaymentBean {
	private List<PaymentBean> orders;
	private String ID;
	private int MD_NUM;
	private int REPAIR_C;
	private int PRICE;
    private String TEAM_NAME;
    private String MD_NAME;
    private String MD_IMG;
    
	public List<PaymentBean> getOrders() {
		return orders;
	}
	public void setOrders(List<PaymentBean> orders) {
		this.orders = orders;
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
	public String getTEAM_NAME() {
		return TEAM_NAME;
	}
	public void setTEAM_NAME(String tEAM_NAME) {
		TEAM_NAME = tEAM_NAME;
	}
	public String getMD_NAME() {
		return MD_NAME;
	}
	public void setMD_NAME(String mD_NAME) {
		MD_NAME = mD_NAME;
	}
	public String getMD_IMG() {
		return MD_IMG;
	}
	public void setMD_IMG(String mD_IMG) {
		MD_IMG = mD_IMG;
	}
	
	@Override
	public String toString() {
		return "OrderPageDTO [orders=" + orders + "]";
	}
}
