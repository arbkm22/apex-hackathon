public with sharing class CustomerDetailTriggerHandler {
    public static void checkDuplicates(List<Custom__c> cdlist) {
        Set<String> checkEmail = new Set<String>();
        Set<Decimal> checkBank = new Set<Decimal>();
        for (Custom__c cd : cdlist) {
            checkEmail.add(cd.Email__c);
            checkBank.add(cd.Bank_Account_Number__c);
        }
        Set<Decimal> bankData = new Set<Decimal>();
        Set<String> emailData = new Set<String>();
        List<Custom__c> checkList = [SELECT Name, Email__c, Bank_Account_Number__c FROM Custom__c WHERE Email__C IN :checkEmail AND Bank_Account_Number__c IN :checkBank];
        for (Custom__c cd : checkList) {
            bankData.add(cd.Bank_Account_Number__c);
            emailData.add(cd.Email__C);
        }
        for (Custom__c cd : checkList) {
            if (bankData.contains(cd.Bank_Account_Number__c) && emailData.contains(cd.Email__c)) {
                cd.addError('Duplicate email and phone');
            }
        }
    }
}