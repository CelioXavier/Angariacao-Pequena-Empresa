@isTest
private class Mark_PE_ActionTest {
    
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
            StartDate  = Date.newInstance(2021, 03, 2)
        );
        insert ctr;     
    }     
    
    @isTest
    static void getContactParametersTest() {
        Test.setMock(HttpCalloutMock.Class, new MockWebserviceCallsTest.AngPESuccess());        
        Test.startTest();        
        List<Contact> cts = [
            SELECT Account.Name, Account.CNPJ__c, Account.ContractPE__c, Name, Email, Account.Branch__c
            FROM Contact
        ];        
        Mark_PE_Action.getContactParameters(cts);        
        Test.stopTest();
    }
}