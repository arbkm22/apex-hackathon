@isTest
private class TestContactTrigger {
    @isTest static void testForInsert() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        INSERT acc;
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact 1';
        con.Contact_Type__c = 'Platinum';
        con.AccountId = acc.Id;
        Test.startTest();
        INSERT con;
        Test.stopTest();
        Account check = [SELECT Name, Platinum_Contacts__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1, check.Platinum_Contacts__c);
    }

    @isTest static void testForUpdate() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        INSERT acc;
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact 1';
        con.Contact_Type__c = 'Platinum';
        con.AccountId = acc.Id;
        INSERT con;
        Test.startTest();
        con.Contact_Type__c = 'Gold';
        UPDATE con;
        Test.stopTest();
        Account check = [SELECT Name, Platinum_Contacts__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, check.Platinum_Contacts__c);
    }

    @isTest static void testForDelete() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        INSERT acc;
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact 1';
        con.Contact_Type__c = 'Platinum';
        con.AccountId = acc.Id;
        Contact con2 = new Contact();
        con2.FirstName = 'Test';
        con2.LastName = 'Contact 2';
        con2.Contact_Type__c = 'Platinum';
        con2.AccountId = acc.Id;
        INSERT con;
        INSERT con2;
        Test.startTest();
        DELETE con2;
        Test.stopTest();
        Account check = [SELECT Name, Platinum_Contacts__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1, check.Platinum_Contacts__c);
    }
}