/**
 * Script used by forum view
 */
function fastreply(subject) {
  if($('message_title')) {
    $('message_title').value = subject;
    $('message_body').focus();
  }
}

