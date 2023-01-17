@isTest 
private class TestMyBatchClass {
    @TestSetup
    static void setup(){
        List<Lead> leads = new List<Lead>();
        for (Integer i=0; i<10; i++) {
            Lead ld = new Lead();
            ld.FirstName = 'Test';
            ld.LastName = 'Lead ' + i+1;
            ld.Company = 'Test Company';
            ld.Status = 'Open - Not Contacted';
            leads.add(ld);
        }
        try {
			INSERT leads;            
        }
        catch (DmlException e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
    @isTest static void test() {
        Test.startTest();
        MyBatchClass mbc = new MyBatchClass();
        Id batchId = Database.executeBatch(mbc);
        Test.stopTest();
        System.assertEquals(10, [SELECT Count() FROM Lead WHERE CreatedDate = TODAY], 'Size of lead');
    }
}