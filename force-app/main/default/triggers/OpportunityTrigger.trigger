trigger OpportunityTrigger on Opportunity (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            OpportunityTriggerHandler.updateHighValue(Trigger.New);
        }
        if (Trigger.isDelete) {
            OpportunityTriggerHandler.updateHighValue(Trigger.old);
        }
    }
}