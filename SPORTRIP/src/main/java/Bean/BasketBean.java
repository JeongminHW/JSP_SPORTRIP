package Bean;

public class BasketBean {
    private int basketNum;
    private String id;
    private int mdNum;
    private int repairB;

    public BasketBean() {}

    public int getBasketNum() {
        return basketNum;
    }

    public void setBasketNum(int basketNum) {
        this.basketNum = basketNum;
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

    public int getRepairB() {
        return repairB;
    }

    public void setRepairB(int repairB) {
        this.repairB = repairB;
    }
}