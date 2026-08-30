class SecurityState {
  final bool authenticated;

  SecurityState({this.authenticated = false});

  SecurityState copyWith({bool? authenticated}) {
    return SecurityState(authenticated: authenticated ?? this.authenticated);
  }
}
