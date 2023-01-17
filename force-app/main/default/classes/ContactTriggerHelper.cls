public with sharing class ContactTriggerHelper {
    public static void updatePlatinumHelper(Map<Id, Integer> platinumContacts) {
        List<Account> toUpdate = new List<Account>();
        for (Id key : platinumContacts.keySet()) {
            Account acc = new Account();
            acc.Id = key;
            acc.Platinum_Contacts__c = platinumContacts.get(key);
            toUpdate.add(acc);
        }
        if (!toUpdate.isEmpty())
            UPDATE toUpdate;
    }
    public static void updatePlatinumHelper2(Set<Id> accIds) {
        List<Account> toUpdate = new List<Account>();
        for (Id key : accIds) {
            Account acc = new Account();
            acc.Id = key;
            acc.Platinum_Contacts__c = 0;
            toUpdate.add(acc);
        }
        if (!toUpdate.isEmpty())
            UPDATE toUpdate;
    }
}