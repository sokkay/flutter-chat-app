String handleError(Map<dynamic, dynamic> errors) {
  if (errors.containsKey('error')) {
    return errors['error'];
  } else {
    return errors.entries
        .map((e) => e.value['msg'])
        .reduce((value, element) => element + '\n' + value);
  }
}
