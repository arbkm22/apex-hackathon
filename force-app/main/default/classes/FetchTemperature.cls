public with sharing class FetchTemperature {

    public static String getUserCity() {
        Id uid = UserInfo.getUserId();
        User usr = [SELECT Id, Name, Average_Temperature__c, City FROM User WHERE ID =: uid];
        return usr.City;        
    }
    public static Decimal getAvgTemp() {
        Id uid = UserInfo.getUserId();
        User usr = [SELECT Id, Name, Average_Temperature__c, City FROM User WHERE ID =: uid];
        return usr.Average_Temperature__c;        
    }

    @AuraEnabled(cacheable=true) 
    public static List<User> getUser() {
        Id uid = UserInfo.getUserId();
        return [SELECT Id, Name, Average_Temperature__c, City FROM User WHERE ID =: uid];
    }

    @AuraEnabled
	public static Decimal getTemp() {
        String city = getUserCity();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String apiKey = '9220a370539a0c8e76bb74ca76013f78';
        String endpoint = 'http://api.openweathermap.org/data/2.5/weather?q='+city+',in&units=metric&appid='+apiKey;
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        Decimal currentTemp;
        HttpResponse response = http.send(request);  
        if (response.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug(result);
            Map<String, Object> temp = (Map<String, Object>) result.get('main');
            // System.debug('current temp: ' + temp.get('temp'));
            System.debug('temp: ' + temp);
            currentTemp = (Decimal)temp.get('temp');
            Decimal tempMin = (Decimal)temp.get('temp_min');
            Decimal tempMax = (Decimal)temp.get('temp_max');
            Decimal averageTemp = getAvgTemp();
            if (averageTemp < currentTemp) {
                System.debug('entered here' + averageTemp + ' ' + currentTemp);
                Decimal tempDiff = currentTemp - averageTemp;
                createCase(tempDiff);
                sendMail(tempDiff);
            }
        }
        return currentTemp;
    }

    // public static void setAverageTemp(Decimal avgTemp) {
    //     Id uid = UserInfo.getUserId();
    //     User usr = [SELECT Id, Name, Average_Temperature__c, City FROM User WHERE ID =: uid];
    //     usr.Average_Temperature__c = avgTemp;
    //     UPDATE usr;
    // }

    public static void createCase(Decimal tempDiff) {
        Case newCase = new Case();
        newCase.Status = 'New';
        newCase.Origin = 'Web';
        newCase.Subject = 'Current Temp is above average Temp by ' + tempDiff + '°C';
        INSERT newCase;
    }

    public static void sendMail(Decimal tempDiff) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'arbkm22@gmail.com'});
        email.setSubject('Current Temperature greater than average temperature');
        email.setPlainTextBody('The current temperature of your city has raised by ' + tempDiff + '°C.');
        Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}