public class Mark_PE_Action {
    
    @InvocableMethod(label='Get Contact Parameters' description='Returns the parameters corresponding to the specified contact ID.' category='Contact')
    public static void getContactParameters(List<Contact> ids) {
        set<Id> contactsId = new set<Id>();
        for(Contact c: ids){
            contactsId.add(c.Id);
        }
        for(Contact c: [
            SELECT Account.Name, Account.CNPJ__c, Account.ContractPE__c, Name, Email, Account.Branch__c
            FROM Contact WHERE Id in :contactsId]){
                Id recordTypeAgency = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('AgenciaEscritorio').getRecordTypeId();
                String Agency = c.Account.Branch__c;                  
                String Agencia = [SELECT Id, Prefix__c FROM Account Where RecordTypeId =: recordTypeAgency AND Id =: Agency LIMIT 1].Prefix__c;    
                String Idacc = c.AccountId; 
                String ContractPE = [SELECT Company_Contract_Number__c FROM Contract WHERE AccountId =: IdAcc ORDER BY Company_Contract_Number__c DESC LIMIT 1].Company_Contract_Number__c; 
                docSingCallout(ContractPE, c.Account.CNPJ__c, c.Account.Name, c.Name, c.Email, Agencia);
            }
    }
    
    @future(callout=true)
    public static void docSingCallout(String ContractPE, String CNPJ, String CompanyName, String Name, String Email, String Agencia){
        AngPE_API.makePostCallout(ContractPE, CNPJ, CompanyName, Name, Email, Agencia);
    }
    
}