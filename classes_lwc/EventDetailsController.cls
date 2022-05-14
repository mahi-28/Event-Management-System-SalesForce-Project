public with sharing class EventDetailsController {

    @AuraEnabled
    public static List<EventSpeaker__c> getSpeakers(String eventId){
        List<EventSpeaker__c> speakerList = [Select Id,Name,Speaker__c,
        Speaker__r.Name,Speaker__r.Phone__c,Speaker__r.Email__c,Speaker__r.Company__c
        From EventSpeaker__c
        Where Event__c =: eventId
        WITH SECURITY_ENFORCED
        ];
        return speakerList;
    }
    @AuraEnabled
    public static Event_Info__c getLocationDetails(String eventId){
        Event_Info__c eventRecord = [Select Id,Name,Location__c,
        Location__r.Name,Location__r.City__c,Location__r.Country__c,
        Location__r.State__c,Location__r.Postal_Code__c,Location__r.Landmark__c,Location__r.Street__c
        From Event_Info__c
        Where Id =: eventId
        WITH SECURITY_ENFORCED];
        return eventRecord;
    }

    @AuraEnabled
    public static List<Event_Attendee__c> getEventAttendee(String eventId){
         
        List<Event_Attendee__c> eventAttendeeList = [Select Id,Name,Attendee__c,
        Attendee__r.Name,Attendee__r.Company_Name__c,Attendee__r.Phone__c,Attendee__r.Email__c
        From Event_Attendee__c Where Event__c =: eventId
        WITH SECURITY_ENFORCED];
        return eventAttendeeList;

    }

    }

