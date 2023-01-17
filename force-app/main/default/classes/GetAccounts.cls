public with sharing class GetAccounts {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, AccountNumber, Phone, Type, Industry, Website, Ownership, NumberOfEmployees, AnnualRevenue, Sic FROM Account];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> accounts(){
        try {
            return [SELECT Id, Name, AccountNumber, Phone, Type, Industry, Website, Ownership, NumberOfEmployees, AnnualRevenue, Sic FROM Account];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, Name, Phone, Title, Department, Email, LeadSource, Languages__c, Level__c, Birthdate  FROM Contact];
    }
}