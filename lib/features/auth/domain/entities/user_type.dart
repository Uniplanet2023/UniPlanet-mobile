enum UserType {
  student,
  local,
  admin,
  advertiser,
}

String getUserType(UserType userType) {
  switch (userType) {
    case UserType.student:
      return 'student';
    case UserType.local:
      return 'local';
    case UserType.admin:
      return 'admin';
    case UserType.advertiser:
      return 'advertiser';
    default:
      return 'unknow';
  }
}
