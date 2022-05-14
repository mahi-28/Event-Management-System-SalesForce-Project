public class EventAttendeeTriggerHelper {
    
    public static void sendConfirmationEmail(List<Event_Attendee__c> newRecordList) {
        
        Set<Id> attendeeIdsSet = new Set<Id>();
        Set<Id> eventIdsSet = new Set<Id>();
        
        for(Event_Attendee__c ea : newRecordList) {
            attendeeIdsSet.add(ea.Attendee__c);
            eventIdsSet.add(ea.Event__c);
        }
        
        Map<Id,Attendees__c> attendeeMap = new Map<Id,Attendees__c>([select Id,Name,Email__c from Attendees__c where Id IN : attendeeIdsSet]);
            
        Map<Id,Event_Info__c> eventMap = new Map<Id,Event_Info__c>([select Id,Name,Start_Date_Time__c,Event_Organizer__c,
                                        Event_Organizer__r.Name,Location__c,Location__r.Name,
                                        Location__r.City__c,Location__r.Country__c,Location__r.Postal_Code__c,
                                        Location__r.State__c,Location__r.Street__c
                                         from Event_Info__c where Id IN : eventIdsSet]);
        
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Event_Attendee__c ea : newRecordList) {
            Attendees__c att = attendeeMap.get(ea.Attendee__c);
            Event_Info__c evt = eventMap.get(ea.Event__c);
            
            /* Prepare Email Template */
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Pass for the '+evt.Name);
            List<String> toAddress = new List<String>();
            toAddress.add(att.Email__c);
            mail.setToAddresses(toAddress);
            mail.setSenderDisplayName(evt.Event_Organizer__r.Name);
            
            String location = 'https://www.google.com/maps/place/'+' '+evt.Location__r.Street__c+' '+evt.Location__r.City__c+
                              ' '+evt.Location__r.State__c+' '+evt.Location__r.Country__c+' '+evt.Location__r.Postal_Code__c;
            String hrefForLocation = '<a href ="'+location+'"'+'target="_blank">Here</a>';
            
            String emailBody = 'Dear, '+'<br/>' +att.Name +','+ +'<br/>'+
                               'Thank you for registering for '+evt.Name+' '+
                               'which will be organized on ' +evt.Start_Date_Time__c+ ' '+
                               '& will be held in ' +evt.Location__r.Name+'.'+ '<br/>'+'We are excited to have you,see you in the event. <br/>'+
                                'Find the Google Map Location for the Event'+' '+hrefForLocation+'.<br/>'+
                                 
                                'Thanks,<br/>'+evt.Event_Organizer__r.Name+'.';
            mail.setHtmlBody(emailBody);
            emailList.add(mail);
            
        }
        
        try {
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailList, false);
            for(Messaging.SendEmailResult email : results) {
                if(!email.isSuccess()) {
                    List<Messaging.SendEmailError> errors = email.getErrors();
                    TransactionLogHandler.doHandleExceptionWithError(JSON.serialize(errors),'EventAttendeeTriggerHelper');
                }
            }
        }catch(System.Exception ex) {
            TransactionLogHandler.doHandleException(ex,'EventAttendeeTriggerHelper');
            
        }
    }

}