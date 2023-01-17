trigger ContactTrigger on Contact (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate || Trigger.isInsert)
            ContactTriggerHandler.updatePlatinum(Trigger.new);
        if (Trigger.isDelete)
            ContactTriggerHandler.updatePlatinum(Trigger.old);
    }
}