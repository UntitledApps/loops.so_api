# Loops API Flutter Package

A Flutter package for interacting with the [Loops API](https://loops.so/docs/api-reference/api). The Loops API allows you to manage contacts, send events, and perform various operations related to customer engagement.

## Features

- **Create Contacts**: Easily create new contacts with customizable properties such as email, first name, last name, and more.

- **Update Contacts**: Update existing contact details, including first name, last name, subscription status, and custom fields.

- **Find Contacts**: Retrieve contact information by email address. The package takes care of URL encoding for you.

- **Delete Contacts**: Delete contacts by providing either their email address or userId.

- **Send Events**: Send custom events associated with a contact, providing flexibility for tracking user interactions.

- **Send Transactional Emails**: Seamlessly send transactional emails using the Loops API.

- **List Custom Fields**: Retrieve a list of custom field objects, including key and label attributes.

## Getting Started

1. **Authentication**: Obtain your Loops API Key from [Loops Dashboard](https://loops.so/docs/api-reference/api#authentication).

2. **Installation**: Add the package to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     loops_api_flutter: ^0.0.4

     Usage: Initialize the LoopsAPI class with your API key and start making API requests.
   ```

3. **Use the API**: Set the API Key in your Main method and then use the API Calls you would like:

   ```dart

   import 'package:loops_api_flutter/loops_api_flutter.dart';
   void main() {
   // Initialize the LoopsAPI instance with your API key
   loopsAPIKey = LoopsAPI(apiKey: 'Your-API-Key-here');

   // Example: Create a new contact
   loopsAPI.createContact(
   email: 'john.doe@example.com',
   firstName: 'John',
   lastName: 'Doe',
   subscribed: true,
   userGroup: 'BetaUsers',
   userId: '12345',
   );

   // Example: Update an existing contact
   loopsAPI.updateContact(
   email: 'john.doe@example.com',
   firstName: 'John',
   lastName: 'UpdatedDoe',
   subscribed: false,
   userGroup: 'AlphaUsers',
   );

   // Example: Find a contact by email
   loopsAPI.findContact(email: 'john.doe@example.com');

   // Example: Delete a contact
   loopsAPI.deleteContact(email: 'john.doe@example.com', userId: '12345');

   loopsAPI.sendEvent(
   email: 'john.doe@example.com',
   eventName: 'AppOpened',
   contactProperties: {'platform': 'iOS', 'version': '1.0.0'},
   );

   // Example: Send a transactional email
   loopsAPI.sendTransactionalEMail(
   email: 'john.doe@example.com',
   transactionalId: 'order_confirmation',
   dataVariables: {'orderTotal': 50.0, 'productName': 'Widget X'},
   );

   // Example: List custom fields
   loopsAPI.listCustomFields();
   }
   ```

### Rate Limiting

To ensure the quality of service, the Loops API enforces rate limiting. This package includes a backoff strategy, delaying API requests if the rate limit is reached.

### Note

It's recommended to store your API key securely, such as in a .env file.
For more details on API usage and rate limiting, refer to the Loops API Documentation.
Feel free to explore the package, contribute, and report any issues or suggestions!
Contribute here: https://github.com/UntitledApps/loops.so_api
