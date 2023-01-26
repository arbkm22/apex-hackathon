trigger CustomerDetailTrigger on Custom__c(before insert) {
    if (Trigger.isBefore) {
        CustomerDetailTriggerHandler.checkDuplicates(Trigger.new);
    }
}