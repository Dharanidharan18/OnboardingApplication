package com.onboardApplication.java;

import java.util.Date;

public class Employee {

    private int id;
    private String name;
    private Date startDate;
    private Date endDate;
    private String certificationType;
    private String completionOfCertification;

    public Employee(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public Employee(int id, String name, Date startDate, Date endDate, String certificationType, String completionOfCertification) {
        this.id = id;
        this.name = name;
        this.startDate = startDate;
        this.endDate = endDate;
        this.certificationType = certificationType;
        this.completionOfCertification = completionOfCertification;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getCertificationType() {
        return certificationType;
    }

    public void setCertificationType(String certificationType) {
        this.certificationType = certificationType;
    }

    public String getCompletionOfCertification() {
        return completionOfCertification;
    }

    public void setCompletionOfCertification(String completionOfCertification) {
        this.completionOfCertification = completionOfCertification;
    }
}
