import { LightningElement, api, track } from 'lwc';
import getSpeakers from '@salesforce/apex/EventDetailsController.getSpeakers';
import getLocationDetails from '@salesforce/apex/EventDetailsController.getLocationDetails';
import getEventAttendee from '@salesforce/apex/EventDetailsController.getEventAttendee';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
const columns = [
  
  {
    label: 'Name', 
    fieldName: 'Name',
    cellAttributes: 
    {
      iconName: 'standard:user',
      iconPosition: 'left',
    }
  },
  {label: 'Email', fieldName: 'Email', type: 'email'},
  {label: 'Phone', fieldName: 'Phone', type: 'phone'},
  {label: 'Company Name', fieldName: 'CompanyName'}

];

const columnsAtt = [
  
  {
    label: 'Name', 
    fieldName: 'Name',
    cellAttributes: 
    {
      iconName: 'standard:user',
      iconPosition: 'left',
    }
  },
  {label: 'Email', fieldName: 'Email', type: 'email'},
  {label: 'Phone', fieldName: 'Phone', type: 'phone'},
  {label: 'Company Name', fieldName: 'CompanyName'}

];

export default class EventDetails extends NavigationMixin(LightningElement) {
  @api recordId;
  @track speakerList;
  @track eventRec;

  
  @track attendeesList;
  errors;
  columnsList = columns;
  columnsAtt = columnsAtt;
  handleSpeakerActive() {
    getSpeakers({
      eventId : this.recordId
    })
    .then((result) => {
      result.forEach(speaker => {
        speaker.Name = speaker.Speaker__r.Name;
        speaker.Email = speaker.Speaker__r.Email__c;
        speaker.Phone = speaker.Speaker__r.Phone__c;
        speaker.CompanyName = speaker.Speaker__r.Company__c;
      });
      window.console.log('result ',result);
      this.speakerList = result;
      this.errors = undefined;

    }).catch((err) => {
      this.errors = err;
      this.speakerList = undefined;

    })
    
  }


  handleLocationDetails() {
    getLocationDetails({
      eventId : this.recordId
    })
    .then((result) => {
      if (result.Location__c) {
        this.eventRec = result;

      } else {
        this.eventRec = undefined;
      }
      this.eventRec = result;
      this.errors = undefined;

    }).catch((err) => {
      this.errors = err;
      this.speakerList = undefined;

    })

  }

  handleEventAttendee() {
    getEventAttendee({
      eventId : this.recordId
    })
    .then((result) => {
      result.forEach(att => {
        att.Name = att.Attendee__r.Name;
        att.Email = att.Attendee__r.Email__c;
        att.Phone = att.Attendee__r.Phone__c;
        att.CompanyName = att.Attendee__r.Company_Name__c;
        
      });
      
      this.attendeesList = JSON.parse(JSON.stringify(result));
      window.console.log('result ',attendeesList);
      this.errors = undefined;

    }).catch((err) => {
      this.errors = err;
      this.speakerList = undefined;

    })

  }

  createSpeaker() {
    const defaultValues = encodeDefaultFieldValues({
      Event__c: this.recordId
      });
      this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
      objectApiName: 'EventSpeaker__c',
      actionName: 'new'
      },
      state: {
      defaultFieldValues: defaultValues
      }
      });
  }

  createAttendee() {
    const defaultValues = encodeDefaultFieldValues({
      Event__c: this.recordId
      });
      this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
      objectApiName: 'Event_Attendee__c',
      actionName: 'new'
      },
      state: {
      defaultFieldValues: defaultValues
      }
      });
  }
}