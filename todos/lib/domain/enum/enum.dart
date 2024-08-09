enum PhoneNumberStatus {
  userUnverified,
  userVerified,
  userLockedException,
}

extension PhoneNumberStatusExtensions on PhoneNumberStatus {
  String get status {
    switch (this) {
      case PhoneNumberStatus.userUnverified:
        return 'UserUnverified';
      case PhoneNumberStatus.userVerified:
        return 'UserVerified';
      case PhoneNumberStatus.userLockedException:
        return 'UserLockedException';
      default:
        return '';
    }
  }
}

enum ExchangeType{
  deposit,
  withdraw
}

