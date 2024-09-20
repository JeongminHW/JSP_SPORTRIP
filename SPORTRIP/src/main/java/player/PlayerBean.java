package player;

import java.sql.Date;

public class PlayerBean {
    private int playerNum;
    private int teamNum;
    private String playerName;
    private Date birth;
    private String playerImg;
    private String position;
    private String uniformNum;

    public PlayerBean() {}

    public int getPlayerNum() {
        return playerNum;
    }

    public void setPlayerNum(int playerNum) {
        this.playerNum = playerNum;
    }

    public int getTeamNum() {
        return teamNum;
    }

    public void setTeamNum(int teamNum) {
        this.teamNum = teamNum;
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public Date getBirth() {
        return birth;
    }

    public void setBirth(Date birth) {
        this.birth = birth;
    }
    
    public String getPlayerImg() {
        return playerImg;
    }

    public void setPlayerImg(String playerImg) {
        this.playerImg = playerImg;
    }


    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getUniformNum() {
        return uniformNum;
    }

    public void setUniformNum(String uniformNum) {
        this.uniformNum = uniformNum;
    }
}