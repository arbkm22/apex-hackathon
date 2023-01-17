@isTest
private class TestAccountTrigger {
    @isTest static void testUpdateState() {
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.BillingState = 'NY';
        INSERT acc;
        acc.BillingState = 'AZ';
        Test.startTest();
        UPDATE acc;
        Test.stopTest();
        Account accCheck = [SELECT Name, State_Changed__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(true, accCheck.State_Changed__c);
    }    
    @isTest static void testNoUpdateState() {
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.BillingState = 'NY';
        Test.startTest();
        INSERT acc;
        Test.stopTest();
        Account accCheck = [SELECT Name, State_Changed__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(false, accCheck.State_Changed__c);
    }
}