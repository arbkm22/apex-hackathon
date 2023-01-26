public with sharing class PetroHandler {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Name, Location__Latitude__s, Location__Longitude__s FROM Account WHERE Location__Latitude__s != NULL];
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccount(Id accId){
        try {
            return [SELECT Name, Location__Latitude__s, Location__Longitude__s FROM Account WHERE Id = :accId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createVisit(Id accountId, String purpose, String checkInTime, String checkOutTime, Decimal checkInLat, Decimal checkInLong, Decimal checkOutLat, Decimal checkOutLong, Integer distance) {
        Account acc = new Account();
        acc.Id = accountId;
        
        List<String> checkInTimeStr = checkInTime.split(':');
        Time checkInTimeComp = Time.newInstance(Integer.valueOf(checkInTimeStr[0]), 
                                                Integer.valueOf(checkInTimeStr[1]), 
                                                Integer.valueOf(checkInTimeStr[2]), 0);
        List<String> checkOutTimeStr = checkOutTime.split(':');
        Time checkOutTimeComp = Time.newInstance(Integer.valueOf(checkOutTimeStr[0]), 
                                                Integer.valueOf(checkOutTimeStr[1]), 
                                                Integer.valueOf(checkOutTimeStr[2]), 0);
                                                
        Visit__c newVisit = new Visit__c();
        newVisit.Account__c = acc.Id;
        newVisit.Check_In_Time__c = checkInTimeComp;
        newVisit.Check_Out_Time__c = checkOutTimeComp;
        newVisit.Checkin__Latitude__s = checkInLat;
        newVisit.Checkin__Longitude__s = checkInLong;
        newVisit.Checkout__Latitude__s = checkOutLat;
        newVisit.Checkout__Longitude__s = checkOutLong;
        Date visitDate = date.parse(System.today().format());
        newVisit.Date__c = visitDate;
        newVisit.Purpose__c = purpose;
        newVisit.Distance__c = (Double) distance;
        INSERT newVisit;
    }
}