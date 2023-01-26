public with sharing class AccountHandler {
    @AuraEnabled
    public static void createNewAccount(String name, String phone, String accnumber, String website, String type, 
        String ownership, String industry, String employees, String bstreet, String bcity, String bstate, String bzip,
        String bcountry, String sstreet, String scity, String sstate, String szip, String scountry) {
            Account acc = new Account();
            acc.Name = name;
            if (phone != null)
                acc.Phone = phone;
            if (accnumber != null)
                acc.AccountNumber = accnumber;
            if (website != null)
                acc.Website = website;
            if (type != null)
                acc.Type = type;
            if (ownership != null)
                acc.Ownership = ownership;
            if (industry != null)
                acc.Industry = industry;
            if (employees != null)
                acc.NumberOfEmployees = Integer.valueOf(employees);
            if (bstreet != null) 
                acc.BillingStreet = bstreet;
            if (bcity != null)
                acc.BillingCity = bcity;
            if (bstate != null)
                acc.BillingState = bstate;
            if (bzip != null)
                acc.BillingPostalCode = bzip;
            if (bcountry != null)
                acc.BillingCountry = bcountry;
            if (sstreet != null) 
                acc.ShippingStreet = sstreet;
            if (scity != null)
                acc.ShippingCity = scity;
            if (sstate != null)
                acc.ShippingState = sstate;
            if (szip != null)
                acc.ShippingPostalCode = szip;
            if (scountry != null)
                acc.ShippingCountry = scountry;

            INSERT acc;
    }
}