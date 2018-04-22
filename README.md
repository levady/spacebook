## Simple Friend Management API Server

The app is deployed on Heroku. You can start using it by going to https://spacebook-api.herokuapp.com.

## APIs

***Add a friend***
----
Create a friend connection between 2 email addresses. Calling this API will create 2 relationship records, 1 for each email address. Friendship should be a 2 way relationship. Adding a friend will also automatically subscribing both parties to receive updates.

* **URL**

  https://spacebook-api.herokuapp.com/relationships

* **Method:**

  `POST`
  
* **JSON Request**

  **Required:**
  ```
  { friends: [email_address1, email_address2] }
  ```

* **Success Response:**
  ```
  { success: true }
  ```
    
* **Error Response:**
  ```
  { success: false, errors: { friends: ["emails must be valid"] }}
  ```
    
***Friends list***
----
Returns a list of friends from an email address.

* **URL**

  https://spacebook-api.herokuapp.com/friends

* **Method:**

  `POST`
  
* **JSON Request**

  **Required:**
  ```
  { email: email_address }
  ```

* **Success Response:**
  ```
  { 
    success: true,
    friends: ["kratos@gow.com", "atreus@gow.com"],
    count: 2
  }
  ```
    
* **Error Response:**
  ```
  { success: false, errors: { email: ["can't be blank"] }}
  ```
  
***Common friends list***
----
Returns a list of common friends between email addresses.

* **URL**

  https://spacebook-api.herokuapp.com/common_friends

* **Method:**

  `POST`
  
* **JSON Request**

  **Required:**
  ```
  { friends: [email_address1, email_address2] }
  ```

* **Success Response:**
  ```
  { 
    success: true,
    friends: ["kratos@gow.com", "atreus@gow.com"],
    count: 2
  }
  ```
    
* **Error Response:**
  ```
  { success: false, errors: { friends: ["must provide 2 emails"] }}
  ```
  
***Following an email address to get updates***
----
Following an email address will create one relationship record for the requestor. Following is not necessarily same as creating a friend connection. This is done by updating `following` to `true`. Following an email will make us eligible to get an updates from the target.

* **URL**

  https://spacebook-api.herokuapp.com/follow

* **Method:**

  `POST`
  
* **JSON Request**

  **Required:**
  ```
  { requestor: email_address, target: email_address }
  ```

* **Success Response:**
  ```
  {  success: true }
  ```
    
* **Error Response:**
  ```
  { success: false, errors: { requestor: ["can't be blank"], target: ["email must be valid"] }}
  ```
  
***Blocking an email address***
----
Blocking an email address will stop the requestor from getting an update from the target but they will remain as a friend if they're already connected as friends. This can be done by updating `block` to `true` and `following` to `false`. Blocking an email address for non connected parties will just prevent them to create a friend connection.

* **URL**

  https://spacebook-api.herokuapp.com/block

* **Method:**

  `POST`
  
* **JSON Request**

  **Required:**
  ```
  { requestor: email_address, target: email_address }
  ```

* **Success Response:**
  ```
  {  success: true }
  ```
    
* **Error Response:**
  ```
  { success: false, errors: { requestor: ["can't be blank"], target: ["email must be valid"] }}
  ```
  
***Update recipients***
----
Returns a list of recipients that are eligible to receive updates from the `sender` email, including email mentions in the text update.

* **URL**

  https://spacebook-api.herokuapp.com/recipients

* **Method:**

  `POST`
  
* **JSON Request**

  **Required:**
  ```
  { sender: email_address, text: string with emails }
  ```

* **Success Response:**
  ```
  {  
    success: true,
    recipients: ["futaba@phantom-thief.com", "makoto@phantom-thief.com"],
    count: 2
  }
  ```
    
* **Error Response:**
  ```
  { success: false, errors: { sender: ["email must valid"], text: ["can't be blank"] }}
  ```
