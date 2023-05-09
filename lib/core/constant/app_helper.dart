class Helper {
  static String? isValidPhoneNumber(String phoneNumber) {
    // Check if the phone number is exactly 10 digits long

    if (phoneNumber.length != 10) {
      return "Invalid Number";
    }

    // Check if the phone number contains only digits
    if (!RegExp(r'^\d{10}$').hasMatch(phoneNumber)) {
      return "Invalid Number";
    }

    // Check if the phone number starts with a valid prefix
    if (!RegExp(r'^[6789]').hasMatch(phoneNumber)) {
      return "Enter Valid Number";
    }

    // If all checks pass, the phone number is valid
    return null;
  }

  static String? isValidName(String name) {
    // Check if the name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(name)) {
      return "Enter Valid Name";
    }

    // If all checks pass, the name is valid
    return null;
  }

  static String getTime(DateTime date) {
    String min = date.minute >= 0 && date.minute <= 9
        ? "0${date.minute.toString()}"
        : date.minute.toString();
    int hour = date.hour;
    String suffix = hour >= 12 && hour <= 23 ? "PM" : "AM";
    String hours =
        hour >= 0 && hour <= 9 ? "0${hour.toString()}" : hour.toString();

    return "$hours :$min $suffix";
  }
}
