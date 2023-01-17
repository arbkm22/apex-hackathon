public class OpportunityTriggerHelper {
	public static void updateHighValueHelper(Map<Id, Decimal> accsMap) {
        List<Account> accList = new List<Account>();
        for (Id key : accsMap.keySet()) {
            Account acc = new Account();
            acc.Id = key;
            if (accsMap.get(key) > 100000) {
                acc.High_Value_Account__c = true;
            }
            else {
                acc.High_Value_Account__c = false;
            }
            accList.add(acc);
            if (!accList.isEmpty())
                UPDATE accList;
        }
    }
}