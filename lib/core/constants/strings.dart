class Strings {
  // Main
  static String appTitle = 'Polaris Assignment';
  // Splash Screen
  static String splashScreenWelcomeMessage = 'Welcome to the app';
  // Home Screen
  String editTextComponentType = 'EditText';
  static String checkBoxesComponentType = 'CheckBoxes';
  static String dropDownComponentType = 'DropDown';
  static String radioGroupComponentType = 'RadioGroup';
  static String captureImagesComponentType = 'CaptureImages';
  static String dataSubmitSuccessFully = 'Data submitted successfully';
  static String dataNotAvailable =
      'Data not available in local, please connect to internet';

  static String submit = 'Submit';
  static String formError = 'Please enter all the fields';

  // Dynamic widgets

  static String validationError(formFieldName) =>
      'Please select $formFieldName';
  static String validationTextError(formFieldName) =>
      'Please enter $formFieldName';

  // AWS S3 Related

  static const region = 'ap-south-1';
  static const bucketId = 'polaris-assignment-aayush';
  static const imagesLocalUpload = 'images_local_upload';
}
