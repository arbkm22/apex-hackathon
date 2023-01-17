public class MyBatchClass implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Name, Company, Title, Email, Phone, LeadSource, Status FROM Lead WHERE CreatedDate = TODAY'
        );
    }

    public void execute(Database.BatchableContext bc, List<Lead> leadsToday) {
        String header = 'Id, Name, Company, Title, Email, Phone, LeadSource, Status \n';
        String finalStr = header;
        for (Lead ld : leadsToday) {
            String recordString = ld.Id + ',' + ld.Name + ',' + ld.Company + ',' + ld.Title + ',' + ld.Email + ',' + ld.Phone + ',' + ld.LeadSource + ',' + ld.Status + '\n';
            finalStr = finalStr + recordString;
        }
        blob xlsBlob = Blob.valueOf(finalStr);
        String xlsName = 'LeadsToday.xls';
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(xlsName);
        attachment.setBody(xlsBlob);
        // send mail to self
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'arbkm22@gmail.com'});
        email.setSubject('New Leads Created Today');
        email.setPlainTextBody('Attached is the excel file with new leads created today');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
        Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        System.debug('mail sent successfully: ' + result);
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Done processing records!');
    }
}