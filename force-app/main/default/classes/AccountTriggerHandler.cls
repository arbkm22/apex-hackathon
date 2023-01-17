public with sharing class AccountTriggerHandler {
    public static void updateState(List<Account> accList, Map<Id, Account> accMap) {
        for (Account acc : accList) {
            if (acc.BillingState != null) {
                if (acc.BillingState != accMap.get(acc.Id).BillingState)
                    acc.State_Changed__c = true;
            }
        }
    }
}