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
      return 'Email đã tồn tại ┐( ˘_˘)┌';
    case 'invalid-email':
      return 'Email không hợp lệ ┐( ˘_˘)┌';
    case 'weak-password':
      return 'Mật khẩu yếu, Hãy thử mật khẩu khác ┐( ˘_˘)┌';
    default:
      return 'Tại tài khoản thất bại.Hãy liên hệ với tác giả  •ᴗ•';
  }
}
