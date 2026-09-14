class AppValidator {
  AppValidator._();


  static String? name(String? value){
    if(value == null || value.isEmpty){
       return "Please Enter Your Name";
    }
    return null;  
  }

 static String? email(String? value){
  if(value == null || value.trim().isEmpty){
    return "Please enter your email";
  }
  if(!value.contains("@")){
      return "Please enter a valid email"; 
  }

  return null;
 }

 static String? password(String? value){
  if(value == null || value.isEmpty){
      return "Please enter your password"; 
  }
  if(value.length < 6){
    return "Password must be at least 6 characters!";
  }
  return null;
 }


 static String? confirmPassword(String? value, String? confirmPassword){
  if (value == null || value.isEmpty) {
    return "Please confirm your password";
  }
                
  if (value != confirmPassword) {
  return "Confirm password doesn't match";
  }
  return null;
 }

 static String? phone(String? value){
    if(value == null || value.trim().isEmpty){
      return "Please enter your number";
    }
    if(value.length < 11){
      return"Please enter a valid number";
    }
    return null;
 }

 static String? address(String? value){
    if(value == null || value.trim().isEmpty){
      return "Please enter your address";
    }
    return null;
 }

 static String? city(String? value){
    if(value == null || value.trim().isEmpty){
      return "Please enter your city/area";
    }
    return null;
 }


}