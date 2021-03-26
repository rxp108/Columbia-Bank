global with sharing class CreditPersonOverride extends forseva1.CreditPersonDefault {

    
    //WebService Implementation

    // Used by blended reports.
    global override virtual List<forseva1.Person> getCreditSubject(ID acctId) {
        return getCreditSubjectPub(acctId);        
    }
    
    // Used by consumer credit framework
    global override virtual List<forseva1.Person> getCreditSubjectUsingParameterString(String parameterString) {
        return getCreditSubjectUsingParameterStringPub(parameterString);
    }
    // Used by consumer credit framework
    global override virtual List<String> getCreditBureauRequestParameters(String parameterString) {
        return getCreditBureauRequestParametersPub(parameterString);
    }

    // Public Interface
    public List<forseva1.Person> getCreditSubjectPub(ID acctId) {
        
        
        System.debug('getCreditSubjectPub...acctId=' + acctId);
                
        List<Account> accounts = [Select Name, FirstName, LastName, PersonMailingStreet, PersonMailingCity, PersonMailingState, 
                                                            PersonMailingPostalCode, PersonMailingCountry, LLC_BI__SS__pc, CLBK_Date_of_Birth__pc
                                                                    from Account
                                                                    where id =: acctId
                                                                    ];
                                  
        List<forseva1.Person> persons = new List<forseva1.Person>();
        
        for (Account acct : accounts) { 
            forseva1.Person p = new forseva1.Person();
            p.UnparsedAddress = acct.PersonMailingStreet;
            p.City = acct.PersonMailingCity;
            p.FirstName = acct.FirstName;
            p.LastName = acct.LastName;
            p.PostalCode = cleanPostalCode(acct.PersonMailingPostalCode);
            p.State = acct.PersonMailingState;
            p.personId = acct.id;
            p.SSN = acct.LLC_BI__SS__pc;
            
            if (acct.CLBK_Date_of_Birth__pc != null)
                p.age = acct.CLBK_Date_of_Birth__pc.monthsBetween(Date.today())/12;
                
            p.DateOfBirth = acct.CLBK_Date_of_Birth__pc;
                
            persons.add(p);
            
        } 

        return persons;        
    }
  
    public List<forseva1.Person> getCreditSubjectUsingParameterStringPub(String parameterString) {
        System.debug('parameterString=' + parameterString);
        Id accountId = null;
        List<String> nvpList = parameterString.split(',');
        for (String nvp : nvpList) {
            String nm = getNameFromNvp(nvp);
            String val = getValueFromNvp(nvp);
            if (nm == 'accountId') {
                accountId = Id.valueOf(val);
            }
        }
        return getCreditSubjectPub(accountId);

    }

    public List<String> getCreditBureauRequestParametersPub(String parameterString) {
        // Experian Parms...
        List<String> parmList = new List<String>();
        String parm = null;

        parm = 'ExperianProduct!CustomSolution';
        parmList.add(parm);
    //    parm = 'Add Ons!CustomRRDashKeyword:' + SystemPreferenceService.getExperianConsumerSystemPreferences().get(Constants.EXP_CONSUMER_SYS_PREF_CUSTOM_RR_DASH_KEYWORD);
    //    parmList.add(parm);
    //    parm = 'Options!ReferenceNumber:' + SystemPreferenceService.getExperianConsumerSystemPreferences().get(Constants.EXP_CONSUMER_SYS_PREF_REF_NUMBER);
    //    parmList.add(parm);
        //parm = 'Risk Models!Bankruptcy';
        //parmList.add(parm);
        //parm = 'Risk Models!FICO2';
        parm = 'Risk Models!FICO3';
        parmList.add(parm);
        parm = 'Options!OFAC:Y';
        parmList.add(parm);
        parm = 'Options!OFACMSG:Y';
        parmList.add(parm);
        //parm = 'Risk Models!FraudShield';
        //parmList.add(parm);
        //parm = 'Options!ConnectCheckGen3:Y';
        //parm = 'Output Options!TTY';  // ARF or TTY
        //parmList.add(parm);
        parm = 'Output Options!XML'; // XML or ARF or TTY
        parmList.add(parm);
        parm = 'XML Output Options!Demographics:Y';
        parmList.add(parm);
        parm = 'XML Output Options!Y2K:Y';
        parmList.add(parm);
        parm = 'XML Output Options!Segment130:Y';
        parmList.add(parm);
    //    parm = 'Account Type!' + SystemPreferenceService.getExperianConsumerSystemPreferences().get(Constants.EXP_CONSUMER_SYS_PREF_ACCOUNT_TYPE);
    //    parmList.add(parm);

        // equifax parms
        parm = 'Flags!BeaconFlag';
        parmList.add(parm);
        parm = 'Flags!OnLineDirectoryFlag';
        parmList.add(parm);
        parm = 'Flags!ConsumerReferralLocationFlag';
        parmList.add(parm);
        parm = 'Flags!AlertContactFlag';
        parmList.add(parm);
        //parm = 'Models!2784';
        //parmlist.add(parm);
        parm = 'Models!5143';
        parmList.add(parm);
        parm = 'Models!5047';
        parmList.add(parm);
        parm = 'Models!5127';
        parmList.add(parm);


        parm = 'Customer Options!RawFileAppendIndicator:N';
        parmList.add(parm);
        parm = 'Customer Options!PrintImageCDATAInclude:Y';
        parmList.add(parm);
        parm = 'Customer Options!OutputFormat:67';
        parmList.add(parm);
        // account...
        String accountId = null;
        List<String> nvpList = parameterString.split(',');
        for (String nvp : nvpList) {
            String nm = getNameFromNvp(nvp);
            String val = getValueFromNvp(nvp);
            if (nm == 'accountId') {
                accountId = Id.valueOf(val);
                parm = 'accountId!' + accountId;
                parmList.add(parm);
            }

        }

        return parmList;
    }


// private interface

    private String cleanPostalCode(String postalCode) {
                if (postalCode == null) {
                                return postalCode;
                }
                
                                return postalCode.replace('-','');
    }
    
    private String getNameFromNvp(String nvp) {
        List<String> lst = nvp.split(':');
        return lst[0];
    }
    private String getValueFromNvp(String nvp) {
        System.debug(' nvp=' + nvp);
        List<String> lst = nvp.split(':');
        return lst[1];
    }
        
    
}