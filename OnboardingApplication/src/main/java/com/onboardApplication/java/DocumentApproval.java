package com.onboardApplication.java;

import java.sql.Blob;

public class DocumentApproval {
    private int employeeId;
    private String employeeName;
    private String phoneNum;
    private String aadharNum;
    private String panNum;
    private Blob aadharImg;
    private Blob panImg;
    private Blob marksheet;
    private Blob resume;

    // Constructor
    public DocumentApproval(int employeeId, String employeeName, String phoneNum, String aadharNum, String panNum, Blob aadharImg, Blob panImg, Blob marksheet, Blob resume) {
        this.employeeId = employeeId;
        this.employeeName = employeeName;
        this.phoneNum = phoneNum;
        this.aadharNum = aadharNum;
        this.panNum = panNum;
        this.aadharImg = aadharImg;
        this.panImg = panImg;
        this.marksheet = marksheet;
        this.resume = resume;
    }

    // Getters and Setters for each field
    public int getEmployeeId() {
        return employeeId;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public String getPhoneNum() {
        return phoneNum;
    }

    public String getAadharNum() {
        return aadharNum;
    }

    public String getPanNum() {
        return panNum;
    }

    public Blob getAadharImg() {
        return aadharImg;
    }

    public Blob getPanImg() {
        return panImg;
    }

    public Blob getMarksheet() {
        return marksheet;
    }

    public Blob getResume() {
        return resume;
    }
}
