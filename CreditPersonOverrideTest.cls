@isTest 
public class CreditPersonOverrideTest 
{
    
     @TestSetup
    static void initData()
    {
        //Creating US Credit Policy
        forseva1__CreditPolicy__c us_cp = new forseva1__CreditPolicy__c(name = 'US', forseva1__Default_Policy__c = true, forseva1__First_Credit_Review_Product__c = 'test', forseva1__First_Prequalification_Product__c='test', forseva1__First_Verification_Product__c='test');
        insert us_cp;
        
        //Creating Canada Credit Policy
        forseva1__CreditPolicy__c canada_cp = new forseva1__CreditPolicy__c(name = 'Canada', forseva1__Default_Policy__c = false, forseva1__First_Credit_Review_Product__c = 'test', forseva1__First_Prequalification_Product__c='test', forseva1__First_Verification_Product__c='test');
        insert canada_cp;
        
        RecordType resRT = [Select  r.Id, r.SobjectType,DeveloperName From RecordType r where r.SobjectType='Account' and DeveloperName  = 'PersonAccount'];
        System.debug(' in test  resRT.id = ' + resRT.id);
        System.assert(resRT != null,'no Residential record type');
        
        //Creating Accounts        
        List<Account>  aclist = new List<Account>();
        aclist.add(new Account(firstname = 'Cam', lastname='bridge' , forseva1__Credit_Policy__c = us_cp.Id, RecordTypeId = resRT.id, Has_Declared_Bankruptcy__c = 'No' ));
        insert aclist;
        
       // List<Contact> contactList = new List<Contact>();
       // Contact contact1 = new Contact(FirstName = 'PG1', LastName = 'Contact', AccountId = aclist[0].Id);
       // contactList.add(contact1);
       // insert contactList;
        
    }
    
    
  static testMethod void generateReportUnitTest() 
  {
        
    Account account1 = [select Id from Account where name = 'Cam bridge'];
    
        Test.StartTest();
        
        CreditPersonOverride cpo= new CreditPersonOverride();
        cpo.getCreditSubject(account1.Id);
        System.assertNotEquals(null, cpo.getCreditSubjectUsingParameterStringPub('accountId:001U0000008VAL5,contactId:001U0000008VAL'));
        System.assertNotEquals(null, cpo.getCreditBureauRequestParametersPub('accountId:001U0000008VAL5,contactId:001U0000008VAL'));
        
        
        Test.stopTest();
        
  }
    
  
  static testMethod void ParamUnitTest() 
  {
        
    Account account1 = [select Id from Account where name = 'Cam bridge'];
    Contact cnt1 = [select Id from Contact where Account.name = 'Cam bridge'];
    
        Test.StartTest();
        
        CreditPersonOverride creditPerson = new CreditPersonOverride();
        creditPerson.getCreditSubject(account1.Id);
        
   //     System.assertNotEquals(null, creditPerson.getCreditBureauRequestParametersPub(account1.Id, cnt1.Id));
        
        Test.stopTest();
        
  }
    
    
}