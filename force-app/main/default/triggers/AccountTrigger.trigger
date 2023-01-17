trigger AccountTrigger on Account (before update) {
    if (trigger.isBefore) {
        if (trigger.isUpdate) {
            AccountTriggerHandler.updateState(Trigger.New, Trigger.oldMap);
        }
    }
}