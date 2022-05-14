@isTest
public class EventAttendeeTriggerTest {
    
    @testSetup
    public static void setupData() {
        Event_Organizer__c organizer = new Event_Organizer__c (
            Name = 'Madhuri Farade',
            Phone__c = '7768453647',
            Email__c = 'madhurifarade7@gmail.com',
            Alternative_Phone__c = '7768453647',
            Alternative_Email__c = 'madhurifarade7@gmail.com'
        );
        insert organizer;
        
        Event_Info__c event = new Event_Info__c (
            Name = 'Sinhgad Hackathon',
            Event_Organizer__c = organizer.Id,
            Event_Type__c = 'Virtual',
            Frequency__c = 'Daily',
            Max_Seats__c = 500,
            Recurring__c = true,
            Live__c = true,
            Start_Date_Time__c = System.now(),
            End_Date_Time__c = System.now().addDays(5)
        );
        insert event;
        Attendees__c attendee = new Attendees__c(
            Name = 'Akash Shinde',
            Email__c = 'akash@gmail.com',
            Phone__c = '3456578767'
        );
        insert attendee;
        
        Event_Attendee__c eventatt = new Event_Attendee__c (
            Event__c = event.Id,
            Attendee__c = attendee.Id
        
        );
        insert eventatt;
    }
    
    @isTest
    static void sendEmailTest() {
        
    }

}