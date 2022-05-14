public with sharing class EventDetailsService {

    @AuraEnabled
    public static List<Event_Info__c> upcomingEvents(){
        List<Event_Info__c> eventList = [select Id,Name,Event_Detail__c,
        Location__c,Start_Date_Time__c,Event_Organizer__c,Event_Organizer__r.Name,Location__r.Name
        from Event_Info__c 
        where Start_Date_Time__c >= Today AND Live__c = true
        WITH SECURITY_ENFORCED];

        return eventList;

    }


}
