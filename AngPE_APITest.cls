@isTest
public class AngPE_APITest {
    
    @testSetup
    static void setup(){
        Id recordTypePJs = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('AgenciaEscritorio').getRecordTypeId();
        Account act = new Account(
            Name = 'Brasilprev',
            Prefix__c = '3065',
            RecordTypeId = recordTypePJs  
        );
        insert act; 
        
        Id recordTypePJ = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PessoaJuridica').getRecordTypeId();
        Account acc = new Account(
            Name = 'AngPE Test',            
            ContractPE__c = '123456',
            CNPJ__c = '43052547000143',
            Branch__c = act.Id,
            RecordTypeId = recordTypePJ
        );
        insert acc;  
        
        Id recordType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('PE_RH').getRecordTypeId();
        Contact ct = new Contact(
            FirstName = 'Célio',
            LastName = 'Xavier',
            Email = 'angpe@teste.com.br',            
            AccountId = acc.Id,
            recordTypeId = recordType
        );
        insert ct;      
        
        Id ctid = [SELECT Id FROM Account WHERE Name = 'AngPE Test' LIMIT 1].Id;  
        Contract ctr = new Contract(
            AccountId = ctid,
            Company_Contract_Number__c = '123456',
            Status = 'Draft', 
            ContractTerm = 12,
            StartDate  = System.today()
        );
        insert ctr;     
    }  
    
    @isTest
    static void makePostCalloutTest(){
        Test.setMock(HttpCalloutMock.Class, new MockWebserviceCallsTest.AngPESuccess());
        Test.startTest();
        Contact ct = [
            SELECT Account.ContractPE__c, Account.CNPJ__c, Account.Name, Name, Email, Account.Owner_Branch__c 
            FROM Contact];
        
        HttpResponse hpt = AngPE_API.makePostCallout(ct.Account.ContractPE__c, ct.Account.CNPJ__c, ct.Account.Name, ct.Name, ct.Email, ct.Account.Owner_Branch__c);
        Test.stopTest();
    }
}