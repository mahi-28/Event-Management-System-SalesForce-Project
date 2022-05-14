import { LightningElement, track, wire } from 'lwc';
import upcomingEvents from '@salesforce/apex/EventDetailsService.upcomingEvents';

const columns = [

  {
    label: 'View',
    fieldName: 'detailsPage',
    type: 'url',
    wrapText: 'true',
    typeAttributes: {
      label: {
        fieldName: 'Name'
      }
    }
  },
  
  {
    label: 'Name', 
    fieldName: 'Name',
    cellAttributes: 
    {
      iconName: 'standard:event',
      iconPosition: 'left',
    }
  },
  {
    label: 'Name', 
    fieldName: 'EVNT_ORG',
    cellAttributes: 
    {
      iconName: 'standard:user',
      iconPosition: 'left',
    }
  },
  {label: 'Location', fieldName: 'Location', type: 'text',
  cellAttributes: 
  {
    iconName: 'utility:location',
    iconPosition: 'left',
  }},
  {label: 'Details', fieldName: 'Details', type: 'text', wrapText:true}


];

export default class EventList extends LightningElement {

  columnsList = columns;
  error;
  startDateTime;
  @track result;
  @track recordsToDisplay;

  connectedCallback() {
    this.upcomingEventsFromApex();

  }

  upcomingEventsFromApex() {
    upcomingEvents() 
    .then((data) => {
      window.console.log("event list ", data);
      data.forEach(record => {
        record.detailsPage = "https://" + window.location.host + '/' +record.Id;
        record.EVNT_ORG = record.Event_Organizer__r.Name;
        if(record.Location__c) {
          record.Location = record.Location__r.Name;

        } else {
          record.Location = 'This is Virtual Event';
        }
        
      });
      this.result = data;
      this.recordsToDisplay = data;
      this.error = undefined;

    }).catch((err) => {
      window.console.log(err);
      this.error = JSON.stringify(err);
      this.result = undefined;

    });

  }

  handleSearch(event) {
    let keyword = event.detail.value;
    let filteredEvents = this.result.filter((record,index,arrayObject) => {
      return record.Name.toLowerCase().includes(keyword.toLowerCase());

    }); 
    if(keyword && keyword.length >=2) {
      this.recordsToDisplay = filteredEvents;
    } else {
      this.recordsToDisplay = this.result;
    }
    
  }

  handleStartDate(event) {
    let valueDateTime = event.target.value;
    window.console.log("valueDateTime ", valueDateTime);
    let filteredEvents = this.result.filter((record,index,arrayObject) => {
      window.console.log("Start_Date_Time__c ",Start_Date_Time__c);
       return record.Start_Date_Time__c >= valueDateTime;
    });
    this.recordsToDisplay = filteredEvents;

  }

  handleLocationSearch(event) {

    let keyword = event.detail.value;
    let filteredEvents = this.result.filter((record,index,arrayObject) => {
      return record.Location.toLowerCase().includes(keyword.toLowerCase());

    }); 
    if(keyword && keyword.length >=2) {
      this.recordsToDisplay = filteredEvents;
    } else {
      this.recordsToDisplay = this.result;
    }

  }
}