const supertest = require('supertest');
var expect = require("chai").expect;
var _ = require('lodash');
var response;
var output;
var milliseconds = new Date().getTime();
var check = require('check-types');
var input101 = {
 "userID": {"merchantUserID": "userID_"+milliseconds},
 "managedMerchantIdentity": "ABCCORP",
 "accountCurrency": "GBP",
 "payerIdentity": {
   "individualIdentity": {
     "name": {
       "familyName": "Smith",
       "givenNames": "John"
     },
     "address": {
       "addressLine1": "ABC",
        "city": "ABC",
       "country": "GB",
       "postcode": "EC1A 4HY",
       "province": "ABC"
     },
     "birthInformation": {
       "cityOfBirth": "ABC",
       "countryOfBirth": "GB",
       "dateOfBirth": "2001-01-01"
     },
     "identification": [
        {
          "idType": "Passport",
          "identificationCountry": "GB",
          "identificationNumber": "180397E52078",
          "validFromDate": "2001-01-01",
          "validToDate": "2001-01-01"
        }
      ]
   }
 }
};

///////////////////////// post /users /////////////////////

describe('101', function() {
   it('Get access token', function(done) {

       supertest.agent("https://earthport-test-qa.apigee.net/oauth/")
       .post('/token?grant_type=client_credentials')
       .set('Accept', 'application/json')
      // .set('grant_type', 'client_credentials')
       .set('Authorization', 'Basic VDN5VURpMjhNRzVHYlhBdGw1TnRqWDNhMzlTdGtOMHM6RzZvNjhkd2tDMmsxcHBVYw==')
       .end(function(err,res){
           if (err) return done(err);
           
           else{
               expect(res.statusCode).to.equal(200);
               token = res.text.access_token;
               data = JSON.parse(res.text);
               access_token = data['access_token'];
               console.log(access_token);
           }
           done();
       });
 }).timeout(18000);

 it('Create User ', (done)=> {
           supertest.agent("https://earthport-test-qa.apigee.net/v1")
          .set('Content-Type', 'application/json')
      //.get('users/3409890158262')
          .post("/users")
          .set('Authorization', 'Bearer ' + access_token).send(input101)
      //.set("merchant_id", 'neosalpha')
          .end((err, res) => {
           expect(true).to.be.true;
           expect(res.statusCode).to.equal(200);
           //console.log(res.text);
       response=res.text;
           done();
        });
}).timeout(18000);

  it('checking epUserID:', (done)=> {
    var json=JSON.parse(response);
    //expect((_.has(json, 'epUserID:'))).to.equal(true);
  //console.log(json.epUserID);
  var value = json.epUserID;
  
  //expect((check.float(value)) ||(check.integer(value))).to.equal(true);
  expect((check.integer(value))).to.equal(true);
    done();
    });
  
it('checking merchantUserID:', (done)=> {
    var json=JSON.parse(response);
    console.log(JSON.stringify(json));
  //expect((_.has(json, 'merchantUserID:'))).to.equal(true);
    expect((_.has(json, 'merchantUserID:'))|| (check.string(json.merchantUserID))).to.equal(true);
    done();
    });

});
