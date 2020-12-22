#!/bin/bash
npm i figlet  &>/dev/null  #<--

echo "var figlet = require('figlet');
 
figlet('NeosAlpha Technologies', function(err, data) {
    if (err) {
        console.log('Something went wrong...');
        console.dir(err);
        return;
    }
    console.log(data)
});
" > test1.js

node test1.js
#choco install jq
res=$(curl -s --location --request POST "https://earthport-test-qa.apigee.net/oauth/token?grant_type=client_credentials" --header "Content-Type: application/x-www-form-urlencoded" --header "Authorization: Basic VDN5VURpMjhNRzVHYlhBdGw1TnRqWDNhMzlTdGtOMHM6RzZvNjhkd2tDMmsxcHBVYw==" --data-urlencode  --data-urlencode | jq -r .access_token)

echo "Access Token Generated is :$res";

UserID=$(curl -s --location --request POST "https://earthport-test-qa.apigee.net/v1/users" --header "Content-Type: application/json" --header "Authorization: Bearer $res" --data-raw '{
  "userID": {"merchantUserID": "userID_1608023854322"},
  "accountCurrency": "any",
  "payerIdentity": {
    "individualIdentity": {
      "name": {
        "familyName": "Smith",
        "givenNames": "John"
      },
      "address": {
        "addressLine1": "1 Main Street",
        "city": "London",
        "country": "GB"
      }
    }
  }
  }' | jq -r ".epUserID , .merchantUserID" )
  echo "New User Created!! USER ID $UserID"
    mmm="https://earthport-test-qa.apigee.net/v1/users/$UserID/bank-accounts"
  # echo $mmm;
BankID= $(curl -s --location --request POST "https://earthport-test-qa.apigee.net/v1/users/3430093929194/bank-accounts" --header "Content-Type: application/json" --header "Authorization: Bearer $res" --data-raw '{"benBankID":{ "merchantBankID": "bankID_1608023854322"},
    "beneficiaryIdentity": {
      "individualIdentity": {
        "name": {
          "familyName": "Smith",
          "givenNames": "John"
        },
        "address": {
          "addressLine1": "ABC",
          "addressLine2": "ABC",
          "addressLine3": "ABC",
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
            "identificationNumber": "ABC123",
            "validFromDate": "2001-01-01",
            "validToDate": "2001-01-01"
          }
        ]
      },
	   "additionalData": [
        {
          "key": "NATIONAL_ID_CARD",
          "value": "TT6789CC"
        }
      ]
    },
    "description": "Bank Account Description",
    "countryCode": "GI",
    "currencyCode": "GBP",
    "bankAccountDetails": [
      {
        "key": "accountNumber",
        "value": "06970093"
      },
      {
        "key": "accountName",
        "value": "account name"
      },
      {
        "key": "bankName",
        "value": "Test Bank"
      },
      {
        "key": "sortCode",
        "value": "800554"
      }
    ]
}')

echo $BankID;
#echo "new beneficiary created : $BankID ---";
sleep 15
#read -p "please wait.............." Enter