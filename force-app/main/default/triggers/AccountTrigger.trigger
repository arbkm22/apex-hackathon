trigger AccountTrigger on Account (before update, after update) {
    if (trigger.isBefore) {
        if (trigger.isUpdate) {
            AccountTriggerHandler.updateState(Trigger.New, Trigger.oldMap);
        }
    }
    if (trigger.isAfter) {
        if (trigger.isUpdate) {
            AccountTriggerHandler.updateEmail(Trigger.New, Trigger.oldMap, Trigger.newMap);
        }
    }
}