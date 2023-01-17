public with sharing class ContactTriggerHandler {
    public static void updatePlatinum(List<Contact> conList) {
        Set<Id> accIds = new Set<Id>();
        for (Contact con : conList) {
            accIds.add(con.AccountId);
        }
        List<AggregateResult> agResult = [SELECT AccountId, COUNT(Contact_Type__c)platinums 
            FROM Contact WHERE Contact_Type__c = 'Platinum' AND AccountId IN :accIds GROUP BY AccountId];
        Map<Id, Integer> platinumContacts = new Map<Id, Integer>();
        for (AggregateResult ag : agResult) {
            Id accId = (Id)ag.get('AccountId');
            Integer nos = (Integer)ag.get('platinums');
            platinumContacts.put(accId, nos);
        }
        if (!platinumContacts.isEmpty())
            ContactTriggerHelper.updatePlatinumHelper(platinumContacts);
        else if (platinumContacts.isEmpty())
            ContactTriggerHelper.updatePlatinumHelper2(accIds);
    }
}