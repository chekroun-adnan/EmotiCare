package com.EmotiCare.DTO;

import java.util.Map;

public class AIAction {
    private String action;
    private Map<String, Object> data;

    public AIAction() {}
    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
    public Map<String, Object> getData() { return data; }
    public void setData(Map<String, Object> data) { this.data = data; }
}
