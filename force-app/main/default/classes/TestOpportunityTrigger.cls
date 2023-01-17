@isTest
private class TestOpportunityTrigger {
    @isTest static void testAddAccount() {
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        INSERT acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test 1';
        opp.StageName = 'Prospecting';
        opp.CloseDate = System.today().addDays(10);
        opp.AccountId = acc.Id;
        opp.Amount = 91000;
        Test.startTest();
        INSERT opp;
        Test.stopTest();
        System.assertEquals(false, acc.High_Value_Account__c);
    }
    @isTest static void testUpdateAccount() {
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        INSERT acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test 1';
        opp.StageName = 'Prospecting';
        opp.CloseDate = System.today().addDays(10);
        opp.AccountId = acc.Id;
        opp.Amount = 115000;
        INSERT opp;
        Test.startTest();
        opp.Amount = 10000;
        UPDATE opp;
        Test.stopTest();
        System.assertEquals(false, acc.High_Value_Account__c);
    }
    @isTest static void testDeleteAccount() {
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        INSERT acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test 1';
        opp.StageName = 'Prospecting';
        opp.CloseDate = System.today().addDays(10);
        opp.AccountId = acc.Id;
        opp.Amount = 120000;
        INSERT opp;
        Test.startTest();
        DELETE opp;
        Test.stopTest();
        System.assertEquals(false, acc.High_Value_Account__c);
    }
}