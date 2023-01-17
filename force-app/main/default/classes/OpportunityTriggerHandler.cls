public class OpportunityTriggerHandler {
	public static void updateHighValue(List<Opportunity> oppList) {
        Set<Id> accIds = new Set<Id>();
        for (Opportunity opp : oppList) {
            accIds.add(opp.AccountId);
        }
        List<Account> accs = [SELECT Name, High_Value_Account__c FROM Account WHERE Id IN :accIds];
        List<AggregateResult> agResult = [SELECT AccountId, SUM(Amount)amts FROM Opportunity WHERE AccountId IN :accIds GROUP By AccountId];
        Map<Id, Decimal> accOppSum = new Map<Id, Decimal>();
        for (AggregateResult ag : agResult) {
            Id accId = (Id)ag.get('AccountId');
            Decimal amount = (Decimal)ag.get('amts');
            accOppSum.put(accId, amount);
        }
        if (!accOppSum.isEmpty())
            OpportunityTriggerHelper.updateHighValueHelper(accOppSum);
    }
}