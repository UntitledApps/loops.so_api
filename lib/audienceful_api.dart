import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:dio/dio.dart';

String loopsAPIKey = "";
Dio dio = Dio();
int apiRequestCounter = 0;
void main() async {
  Timer.periodic(const Duration(seconds: 1), (timer) {
    if (apiRequestCounter > 0) {
      apiRequestCounter = 0;
    }
  });
}

/// Find detailed Information about the API here: https://loops.so/docs/api-reference/api
///
/// ### Authencation
///
/// Get your Loops API Key -> https://loops.so/docs/api-reference/api#authentication
///
/// In your main method of your app write:
///
/// loopsAPIKey = "Your-API-Key-here";
///
/// FORGETTING THIS Will LEAD TO ERROR
///
/// It's reccommend to get your API Key from a .env file for more saftey. Don'f forget to put your .env under asset: in
/// the pubspec.yaml if you want to get access on it.
///
/// ### Rate Limiting: (Taken from the docs)
///
/// To ensure the quality of service for all users, our API is rate limited.
/// This means there’s a limit to the number of requests your application can make to our API in a certain time frame.
/// The baseline rate limit is 10 requests per second per team.
///
/// The package has a backoff strategy implemeted. If the the rate limit is hit an API Request will delayed by 1 second and then will try to send again
///
/// Note though that this isn't 100% accurate and requests may fail sometimes.
/// If you know that you very likley to use more than 10 API Requests per second ask the Loops Team to higher the limit
/// -> https://loops.so/docs/api-reference/api#rate-limiting
class LoopsAPI {
  final String authorization = 'Bearer loopsAPIKey';

  /// ### POST Request
  /// Put your custom properties in the `customFields` array. Note: Custom Fields only support bool, String and num types. Using other types
  /// will result in an error.
  Future<void> createContact({
    required String email,
    String? firstName,
    String? lastName,
    bool? subscribed = true,
    String? userGroup,
    String? userId,
    Map<String, dynamic>? customFields,
  }) async {
    if (apiRequestCounter < 10) {
      try {
        Response response = await dio.post(
          "https//app.loops.so/api/v1/contacts/create",
          data: {
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "subscribed": subscribed,
            "userGroup": userGroup,
            "userId": userId,
            for (var customField in customFields!.entries)
              customField.key: customField.value,
          },
          options: Options(contentType: 'application/json'),
        );
        debugPrint("Successfully created a contact!${response.data}");
        apiRequestCounter++;
        return response.data;
      } catch (error) {
        // Handle errors
        throw Exception(
            'The Loops API Package got an Error when trying to create a contact: $error');
      }
    } else {
      Future.delayed(
          const Duration(seconds: 1),
          () => createContact(
              email: email,
              firstName: firstName,
              lastName: lastName,
              subscribed: subscribed,
              userGroup: userGroup,
              userId: userId,
              customFields: customFields));
    }
  }

  /// ### PUT Request
  Future<void> updateContact({
    required String email,
    String? firstName,
    String? lastName,
    bool? subscribed = true,
    String? userGroup,
    String? userId,
    Map<String, dynamic>? customFields,
  }) async {
    if (apiRequestCounter < 10) {
      try {
        Response response = await dio.post(
          "https://app.loops.so/api/v1/contacts/update",
          data: {
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "subscribed": subscribed,
            "userGroup": userGroup,
            "userId": userId,
            for (var customField in customFields!.entries)
              customField.key: customField.value,
          },
          options: Options(contentType: 'application/json'),
        );
        debugPrint("Successfully updated a contact!${response.data}");
        apiRequestCounter++;
        return response.data;
      } catch (error) {
        // Handle errors
        throw Exception(
            'The Loops API Package got an Error when trying to update a contact: $error');
      }
    } else {
      Future.delayed(
          const Duration(seconds: 1),
          () => updateContact(
              email: email,
              firstName: firstName,
              lastName: lastName,
              subscribed: subscribed,
              userGroup: userGroup,
              userId: userId,
              customFields: customFields));
    }
  }

  /// ### GET Request
  /// Find a Contact by their E-Mail Address
  /// If no contacts are found an empty list is going to be returned
  /// #### The EMail Address is being encoded to be used in the URL by the package already!
  /// #### You don't need to encode it yourself.
  Future<void> findContact({required String email}) async {
    if (apiRequestCounter < 10) {
      try {
        String encodedEmail = Uri.encodeComponent(email);
        Response response = await dio.post(
          "https://app.loops.so/api/v1/contacts/find",
          data: {
            "email": encodedEmail,
          },
          options: Options(contentType: 'application/json'),
        );
        debugPrint("Successfully found a contact!${response.data}");
        apiRequestCounter++;
        return response.data;
      } catch (error) {
        // Handle errors
        throw Exception(
            'The Loops API Package got an Error when trying to find a contact: $error');
      }
    } else {
      Future.delayed(
          const Duration(seconds: 1), () => findContact(email: email));
    }
  }

  /// ### POST Request
  /// You can delete a contact by using either their email or userId value.
  /// Using none will result in an error
  Future<void> deleteContact(String? email, String? userId) async {
    if (apiRequestCounter < 10) {
      try {
        Response response = await dio.post(
          "https://app.loops.so/api/v1/contacts/delete",
          data: {
            "email": email,
            "userId": userId,
          },
          options: Options(contentType: 'application/json'),
        );
        debugPrint("Successfully deleted a contact!${response.data}");
        return response.data;
      } catch (error) {
        // Handle errors
        throw Exception(
            'The Loops API Package got an Error when trying to delete a contact: $error');
      }
    } else {
      Future.delayed(
          const Duration(seconds: 1), () => deleteContact(email, userId));
    }
  }

  /// ### POST Request
  /// Custom properties can be added to a contact by using the `customFields` array.
  /// To correctly delcare a custom Property you need to provide a `name` and a `value`.
  /// Note: Custom Fields only support bool, String and num types. Using other types
  Future<void> sendEvent(
      {required String email,
      required String eventName,
      Map<String, dynamic>? contactProperties}) async {
    if (apiRequestCounter < 10) {
      try {
        Response response =
            await dio.post("https://app.loops.so/api/v1/events/send",
                data: {
                  "email": email,
                  "eventName": eventName,
                  for (var contactProperty in contactProperties!.entries)
                    contactProperty.key: contactProperty.value,
                },
                options: Options(contentType: 'application/json'));

        debugPrint("Successfully send an event!${response.data}");
        apiRequestCounter++;
        return response.data;
      } catch (error) {
        // Handle errors
        throw Exception(
            'The Loops API Package got an Error when trying to send an event: $error');
      }
    } else {
      Future.delayed(
          const Duration(seconds: 1),
          () => sendEvent(
              email: email,
              eventName: eventName,
              contactProperties: contactProperties));
    }
  }

  /// ### POST Request
  Future<void> sendTransactionalEMail(
      {required String email,
      required String transactionalId,
      dynamic dataVariables}) async {
    if (apiRequestCounter < 10) {
      try {
        Response response =
            await dio.post("https://app.loops.so/api/v1/transactional",
                data: {
                  "email": email,
                  "transactionalId": transactionalId,
                  for (var dataVariable in dataVariables!.entries)
                    dataVariable.key: dataVariable.value,
                },
                options: Options(contentType: 'application/json'));

        debugPrint("Successfully send a transactional E-Mail!${response.data}");
        apiRequestCounter++;
        return response.data;
      } catch (error) {
        // Handle errors
        throw Exception(
            'The Loops API Package got an Error when trying to send a transactional E-Mail: $error');
      }
    } else {
      Future.delayed(
          const Duration(seconds: 1),
          () => sendTransactionalEMail(
              email: email,
              transactionalId: transactionalId,
              dataVariables: dataVariables));
    }
  }

  /// ### GET Request
  /// This endpoint will return a list of custom field objects
  ///  containing key and label attributes.
  /// If your account has no custom fields, an empty list will be returned.

  Future<void> listCustomFields() async {
    if (apiRequestCounter < 10) {
      try {
        Response response = await dio.post(
            "https://app.loops.so/api/v1/customfields",
            data: {},
            options: Options(contentType: 'application/json'));

        debugPrint("Successfully listed Custom Fields!${response.data}");
        apiRequestCounter++;
        return response.data;
      } catch (error) {
        // Handle errors
        throw Exception(
            'The Loops API Package got an Error when trying to list custom fields : $error');
      }
    } else {
      Future.delayed(const Duration(seconds: 1), () => listCustomFields());
    }
  }
}
