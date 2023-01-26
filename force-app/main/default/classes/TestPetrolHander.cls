@isTest 
private class TestPetrolHander {
    @isTest static void testCreateVisit() {
        Account acc = new Account(
            Name = 'Test Account',
            Location__Latitude__s = 37.7749295,
            Location__Longitude__s = -122.4194155
        );
        INSERT acc;
        Time checkInTime = Time.newInstance(10, 10, 10, 10);
        Time checkOutTime = Time.newInstance(11, 11, 11, 11);
        Decimal checkInLat = 28.635308;
        Decimal checkInLong = 77.22496;
        Date visitDate = Date.parse(System.today().format());
        Location loc1 = Location.newInstance(checkInLat, checkInLong);
        Location loc2 = Location.newInstance(acc.Location__Latitude__s, acc.Location__Longitude__s);
        Double dist = Location.getDistance(loc1, loc2, 'km');
        // calculate time of visit
        Integer checkInHour = checkInTime.hour(), checkInMin = checkInTime.minute(), checkInSec = checkInTime.second();
        Integer checkOutHour = checkOutTime.hour(), checkOutMin = checkOutTime.minute(), checkOutSec = checkOutTime.second();
        Integer hour = checkOutHour - checkInHour, minute = checkOutMin - checkInMin, second = checkOutSec - checkInSec;
        String duration = hour + ':' + minute + ':' + second;
        Visit__c testVisit = new Visit__c(
            Account__c = acc.Id,
            Check_In_Time__c = checkInTime, 
            Check_Out_Time__c = checkOutTime,
            Checkin__Latitude__s = checkInLat,
            Checkin__Longitude__s = checkInLong, 
            Checkout__Latitude__s = checkInLat, 
            Checkout__Longitude__s = checkInLong,
            Date__c = visitDate, 
            Purpose__c = 'Testing',
            Distance__c = (Integer)dist,
            Visit_Duration__c = duration
        );
        test.startTest();
        INSERT testVisit;
        test.stopTest();
        Visit__c checkTestVisit = [SELECT Distance__c, Visit_Duration__c FROM Visit__c WHERE Id = :testVisit.Id];
        System.assertEquals(12352, checkTestVisit.Distance__c);
        System.assertEquals('1:1:1', checkTestVisit.Visit_Duration__c);
    }
}