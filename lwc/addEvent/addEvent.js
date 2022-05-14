import { LightningElement,track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import EVT_OBJECT from '@salesforce/schema/Event_Info__c';
import Name from '@salesforce/schema/Event_Info__c.Name';
import Event_Organizer__c from '@salesforce/schema/Event_Info__c.Event_Organizer__c';
import Start_Date_Time__c from '@salesforce/schema/Event_Info__c.Start_Date_Time__c';
import End_Date_Time__c from '@salesforce/schema/Event_Info__c.End_Date_Time__c';
import Max_Seats__c from '@salesforce/schema/Event_Info__c.Max_Seats__c';
import Location__c from '@salesforce/schema/Event_Info__c.Location__c';
import Event_Detail__c from '@salesforce/schema/Event_Info__c.Event_Detail__c';

export default class AddEvent extends NavigationMixin(LightningElement) {
  @track eventRecord = {
        Name : '',
        Event_Organizer__c : '',
        Start_Date_Time__c : null,
        End_Date_Time__c : null,
        Max_Seats__c : null,
        Location__c : '',
        Event_Detail__c : ''

  }

  @track errors;

  handleChange(event) {
    let value = event.target.value;
    let name = event.target.name;

    this.eventRecord[name] = value;

  }

  handleLookup(event) {
    let selectedRecId = event.detail.selectedRecordId;
    let parentId = event.detail.parentfield;
    this.eventRecord[parentId] = selectedRecId;

  }

  handleClick() {
    const fields = {};
    fields[Name.fieldApiName] = this.eventRecord.Name;
    fields[Event_Organizer__c.fieldApiName] = this.eventRecord.Event_Organizer__c;
    fields[Start_Date_Time__c.fieldApiName] = this.eventRecord.Start_Date_Time__c;
    fields[End_Date_Time__c.fieldApiName] = this.eventRecord.End_Date_Time__c;
    fields[Max_Seats__c.fieldApiName] = this.eventRecord.Max_Seats__c;
    fields[Location__c.fieldApiName] = this.eventRecord.Location__c;
    fields[Event_Detail__c.fieldApiName] = this.eventRecord.Event_Detail__c;

    const eventRecord = {apiName : EVT_OBJECT.objectApiName, fields};

    createRecord(eventRecord) 
    .then((eventRec) => {
      this.dispatchEvent(new ShowToastEvent({
          title: 'Record Saved!',
          message: 'Event Draft is ready!',
          variant: 'success'
      }));
      //alert('Record Saved' + eventRec.id)
      this[NavigationMixin.Navigate]({
          type: 'standard__recordPage',
          attributes: {
              actionName: "view",
              recordId: eventRec.id,
          }
      });

    }).catch((err) => {
       this.errors = JSON.stringify(err);
       this.dispatchEvent(new ShowToastEvent({
           title: 'Error Occuured!',
           message: this.errors,
           variant: 'error'
       }));
    });

  }

  handleCancel() {
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            actionName: "home",
            objectApiName: "Event_Info__c"
        }
    });
  }
}