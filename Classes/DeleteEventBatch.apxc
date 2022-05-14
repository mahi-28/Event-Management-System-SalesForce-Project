global class DeleteEventBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext batchContext) {
        String Query = 'select id,name from Event_Info__c where Live__c = true AND End_Date_Time__c < LAST_N_MONTHS:2';
        
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext batchContext, List<Event_Info__c> eventList) {
        if(!eventList.isEmpty()) {
            List<Database.DeleteResult> deleteResult = Database.delete(eventList);
            for(Database.DeleteResult dr : deleteResult) {
                if(!dr.isSuccess()) {
                    List<Database.Error> errors = dr.getErrors();
                    String errorInString = String.join(errors, ',');
                    TransactionLogHandler.doHandleExceptionWithError(errorInString,'DeleteEventBatch');
                    
                }
            }
            
        }
        
    }
    
    global void finish(Database.BatchableContext batchContext) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Batch Processing Completed!!');
            List<String> toAddress = new List<String>();
            toAddress.add('madhurifarade7@gmail.com');
            mail.setToAddresses(toAddress);
            mail.setSenderDisplayName('Madhuri Farade');
           
            mail.setHtmlBody('The DeleteEventBatch processing has been completed');
            List<Messaging.SingleEmailMessage> emails =  new List<Messaging.SingleEmailMessage> {mail};
            Messaging.sendEmail(emails);
    }
}