public with sharing class AttendeeEventService {

    @AuraEnabled
    public static List<Event_Attendee__c> upcomingEvents(String attendeeId){
         
        List<Event_Attendee__c> eventLists = [Select Id,Name,Event__c,Event__r.Name,
        Event__r.Location__c,Event__r.Location__r.Name,
        Event__r.Event_Organizer__c,Event__r.Event_Organizer__r.Name,
        Event__r.Start_Date_Time__c From 
        Event_Attendee__c Where Attendee__c =:attendeeId
        AND Event__r.Start_Date_Time__c >=today AND Event__r.Live__c = true
        WITH SECURITY_ENFORCED
        
        ];
        return eventLists;


    }

    @AuraEnabled
    public static List<Event_Attendee__c> pastEvents(String attendeeId){
        List<Event_Attendee__c> eventLists = [Select Id,Name,Event__c,Event__r.Name,
        Event__r.Location__c,Event__r.Location__r.Name,
        Event__r.Event_Organizer__c,Event__r.Event_Organizer__r.Name,
        Event__r.Start_Date_Time__c From 
        Event_Attendee__c Where Attendee__c =:attendeeId
        AND Event__r.Start_Date_Time__c < today 
        WITH SECURITY_ENFORCED
        ];
        return eventLists;

    }



}
