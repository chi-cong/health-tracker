String mapLogginErrors(String err) {
  switch (err) {
    case 'user-not-found':
      return 'No user found for that email (ᗒᗣᗕ)՞';
    case 'wrong-password':
      return 'Wrong password provided for that user (ᗒᗣᗕ)՞';
    case 'user-disabled':
      return 'This user email is disabled (ᗒᗣᗕ)՞';
    default:
      return 'The provided email is invalid (ᗒᗣᗕ)՞';
  }
}

String mapSignupErrors(String err) {
  switch (err) {
    case 'email-already-in-use':
      return 'No user found for that email ┐( ˘_˘)┌';
    case 'invalid-email':
      return 'Email is invalid. Try something else ┐( ˘_˘)┌';
    case 'weak-password':
      return 'This password is weak. Try something else ┐( ˘_˘)┌';
    default:
      return 'Unable to create account. Please contact the author •ᴗ•';
  }
}
