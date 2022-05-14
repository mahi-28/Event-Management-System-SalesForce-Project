public class LocationTriggerHandler {
    
    @future(callout=true)
    public static void verifyAddress(String recordId) {
        Event_Location__c loc = [select Id, name, Verified__c, Street__c, City__c, Postal_Code__c, 
                                 State__c From Event_Location__c where Id=:recordId];
        //	street=1600+amphitheatre+pkwy&city=mountain+view&state=CA&candidates=10
        String baseURL = 'https://us-street.api.smartystreets.com/street-address?auth-id=425a4e3c-606c-8c37-8683-f0af4549f5d7&auth-token=oNCo3KYtiSe6efA7giG6';
        baseURL+='&street='+EncodingUtil.urlEncode(loc.Street__c, 'UTF-8')
                 +'&city='+EncodingUtil.urlEncode(loc.City__c, 'UTF-8')
                 +'&state='+EncodingUtil.urlEncode(loc.State__c, 'UTF-8')
                 +'&match=invalid&candidates=10';

        System.debug('baseURL' +baseURL);
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(baseURL);
        //httpReq.setHeader('Content-Type', 'application/json');
        
        Http http = new Http();
        
        HttpResponse httpRes = new HttpResponse();
        
        try {
           httpRes = http.send(httpReq);
            System.debug('ResponseBody' +httpRes.getBody());
            if(httpRes.getStatusCode() == 200 && httpRes.getStatus() == 'OK' ) {
                String responseBody = httpRes.getBody();
                if(!String.isBlank(responseBody) && responseBody.length() > 2) {
                    loc.Verified__c = true;
                } else {
                    loc.Verified__c = false;
                }
                
                update loc;
                
                
            } else  {
                TransactionLogHandler.doHandleExceptionWithError(httpRes.getBody(), 'LocationTriggerHandler');
                
            }
            
        } catch(System.CalloutException ex) {
          System.debug('Exception Occured' +ex.getStackTraceString());

            TransactionLogHandler.doHandleException(ex, 'LocationTriggerHandler');
            
        }     
    }

}