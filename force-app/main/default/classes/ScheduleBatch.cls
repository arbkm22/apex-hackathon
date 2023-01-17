global with sharing class ScheduleBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        Id batchId = Database.executeBatch(new MyBatchClass(), 200);
    }
}