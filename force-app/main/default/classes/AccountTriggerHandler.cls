public with sharing class AccountTriggerHandler {
    public static void updateState(List<Account> accList, Map<Id, Account> accMap) {
        for (Account acc : accList) {
            if (acc.BillingState != null) {
                if (acc.BillingState != accMap.get(acc.Id).BillingState)
                    acc.State_Changed__c = true;
            }
        }
    }

    public static void updateEmail(List<Account> accList, Map<Id, Account> oldMap, Map<Id, Account> newAccMap) {
        Set<Id> accIds = new Set<Id>();
        for (Account acc : accList) {
            if (acc.Email__c != oldMap.get(acc.Id).Email__c)
                accIds.add(acc.Id);
        }
        // Map<Id, Account> accMap = new Map<Id, Account>([SELECT Name, Email__c FROM Account WHERE Id IN :accIds]);
        List<Opportunity> opList = [SELECT AccountId, Name, Email__c FROM Opportunity WHERE AccountId IN :accIds AND Email__c = NULL];
        List<Opportunity> toUpdate = new List<Opportunity>();
        for (Opportunity op : opList) {
            op.Email__c = newAccMap.get(op.AccountId).Email__c;
            toUpdate.add(op);
        }
        if (!toUpdate.isEmpty()) {
            UPDATE toUpdate;
        }
    }
}