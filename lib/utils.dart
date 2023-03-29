String capitalize(text) {
  return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
}

String serverName(text) {
  return text.trim().toLowerCase().replaceAll(' ', '_');
}

String uiName(text) {
  return capitalize(text.replaceAll('_', ' '));
}
