package com.onboardApplication.java;

public class DocumentApproval {

	
	        private int employeeId;
	        private String employeeName;
	        private String phoneNum;
	        private String aadharNum;
	        private String panNum;

	        public DocumentApproval(int employeeId, String employeeName, String phoneNum, String aadharNum, String panNum) {
	            this.employeeId = employeeId;
	            this.employeeName = employeeName;
	            this.phoneNum = phoneNum;
	            this.aadharNum = aadharNum;
	            this.panNum = panNum;
	        }

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
	    }
