CREATE TABLE DRUG_DRIVE
( WWM_DD_ID number(10) NOT NULL,
  WWM_SERIAL_NO number(5),
  WWM_YEAR VARCHAR2(2) NOT NULL,
  WWM_URN VARCHAR2(20),
  WWM_OFFICER_UID VARCHAR2(12) NOT NULL,
  WWM_OFFICER_FORCE VARCHAR2(2) NOT NULL,
  WWM_OFFICER_COLLAR VARCHAR2(10) NOT NULL,
  WWM_OFFICER_NAME VARCHAR2(100) NOT NULL,
  WWM_OFFICER_EMAIL VARCHAR2(150) NOT NULL,
  WWM_TEST_FORCE VARCHAR2(2),
  POLICE_FORCE_CODE VARCHAR2(2),
  WWM_TEST_LPA VARCHAR2(1),
  WWM_TEST_BEAT varchar2(4),
  WWM_TEST_GRIDREF VARCHAR2(16),  
  WWM_INCIDENT_REF VARCHAR2(30),
  WWM_TEST_LOCATION VARCHAR2(15),
  WWM_DATE_CREATED DATE,
  CUSTODY_REF VARCHAR2(20),
  DATE_INITIAL_STOP DATE,
  TIME_INITIAL_STOP VARCHAR2(5),
  ADDITIONAL_INFORMATION VARCHAR2(4000),
  AGE NUMBER(3),
  ARRESTED VARCHAR2(1),
  ARRESTED_FOR_DRUGSORALC VARCHAR2(1),
  ARRESTED_FOR_FAILURE VARCHAR2(1),
  ARRESTED_FOR_S4ALC VARCHAR2(1),
  ARRESTED_FOR_S4DRUGS VARCHAR2(1),
  ARRESTED_FOR_S5ALC VARCHAR2(1),
  ARRESTED_FOR_S5DRUGS VARCHAR2(1),
  ARRESTED_FOR_OTHER VARCHAR2(250),
  BLOOD_DOCTOR VARCHAR2(1),
  BLOOD_NURSE VARCHAR2(1),
  BLOOD_FAILURE_REASON VARCHAR2(250),
  BLOOD_OTHER VARCHAR2(1),
  BLOOD_PROVIDED VARCHAR2(1),
  BLOOD_REQUESTED VARCHAR2(1),
  BLOOD_TIME VARCHAR2(5),
  DISPOSAL_ALCORDRUGS VARCHAR2(1),
  DISPOSAL_FAILURE VARCHAR2(1),
  DISPOSAL_OTHER VARCHAR2(250),
  DISPOSAL_S4ALC VARCHAR2(1),
  DISPOSAL_S4DRUGS VARCHAR2(1),
  DISPOSAL_S5ALC VARCHAR2(1),
  DISPOSAL_S5DRUGS VARCHAR2(1),
  DISPOSAL_OTHER_DETAILS VARCHAR2(250),
  ETHICITY VARCHAR2(3),
  GENDER VARCHAR2(1),
  INVESTIGATION_FOR_DRUGSORALC VARCHAR2(1),
  INVESTIGATION_FOR_FAILURE VARCHAR2(1),
  INVESTIGATION_FOR_S4ALC VARCHAR2(1),
  INVESTIGATION_FOR_S4DRUGS VARCHAR2(1),
  INVESTIGATION_FOR_S5ALC VARCHAR2(1),
  INVESTIGATION_FOR_S5DRUGS VARCHAR2(1),
  INVESTIGATION_FOR_OTHER VARCHAR2(1),
  LAB_LGC VARCHAR2(1),
  LAB_ROAR VARCHAR2(1),
  LAB_RANDOX VARCHAR2(1),
  LAB_OTHER VARCHAR2(1),
  RTC VARCHAR2(1),
  REASON_NOT_ARRESTED VARCHAR2(250),
  ROADSIDE_BREATH_DONE VARCHAR2(1),
  ROADSIDE_BREATH_TIME VARCHAR2(5),
  ROADSIDE_BREATH_RESULT NUMBER(3),
  ROADSIDE_FIT_DONE VARCHAR2(1),
  ROADSIDE_FIT_OK VARCHAR2(1),
  ROADSIDE_FIT_POOR VARCHAR2(1),
  ROADSIDE_FIT_TIME VARCHAR2(5),
  ROADSIDE_SALIVA_DONE VARCHAR2(1),
  ROADSIDE_SALIVA_DRUG VARCHAR2(250),
  ROADSIDE_SALIVA_RESULT VARCHAR2(10),
  ROADSIDE_SALIVA_TIME VARCHAR2(5),
  ROADSIDE_DEVICE_TYPE3 VARCHAR2(1),
  STATION_BREATH_DONE VARCHAR2(1),
  STATION_BREATH_TIME VARCHAR2(5),
  STATION_BREATH_RESULT NUMBER(3),
  STATION_BREATH_DATE DATE,
  STATION_SALIVA_DONE VARCHAR2(1),
  STATION_SALIVA_DRUG VARCHAR2(250),
  STATION_SALIVA_RESULT VARCHAR2(10),
  STATION_SALIVA_TIME VARCHAR2(5),
  STATION_SALIVA_DATE DATE,
  STATION_DEVICE_TYPE3 VARCHAR2(1),
  STATION_HCP_TIME VARCHAR2(5),
  STATION_HCP_DATE DATE,
  TEST_REF VARCHAR2(30),
  URINE_TIME1 VARCHAR2(5),
  URINE_TIME2 VARCHAR2(5),
  URINE_PROVIDED VARCHAR2(1),
  HCP_ASSESSED VARCHAR2(1),
  HCP_DECISION VARCHAR2(250),
  HCP_DOCTOR VARCHAR2(1),
  HCP_NURSE VARCHAR2(1),
  HCP_OTHER VARCHAR2(100),
  HCP_REFERRAL VARCHAR2(1),
  MEDICAL_DEFENCE_CLAIMED VARCHAR2(1),
  MEDICAL_DEFENCE_DRUGS VARCHAR2(250),
  CONSTRAINT DRUG_DRIVE_PK PRIMARY KEY (WWM_DD_ID)
);