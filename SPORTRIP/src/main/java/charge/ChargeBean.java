package charge;

public class ChargeBean {
    private int chargeNum;
    private String id;
    private int mdNum;
    private int repairC;
    private int price;

    public ChargeBean() {}

    public int getChargeNum() {
        return chargeNum;
    }

    public void setChargeNum(int chargeNum) {
        this.chargeNum = chargeNum;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getMdNum() {
        return mdNum;
    }

    public void setMdNum(int mdNum) {
        this.mdNum = mdNum;
    }

    public int getRepairC() {
        return repairC;
    }

    public void setRepairC(int repairC) {
        this.repairC = repairC;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }
}
