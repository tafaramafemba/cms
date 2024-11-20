document.addEventListener("DOMContentLoaded", function() {
  const newSenderLink = document.getElementById("new-sender-link");
  const newSenderForm = document.getElementById("new-sender-form");
  const newReceiverLink = document.getElementById("new-receiver-link");
  const newReceiverForm = document.getElementById("new-receiver-form");

  if (newSenderLink && newSenderForm) {
    newSenderLink.addEventListener("click", function(event) {
      event.preventDefault();
      newSenderForm.style.display = newSenderForm.style.display === "none" ? "block" : "none";
    });
  }

  if (newReceiverLink && newReceiverForm) {
    newReceiverLink.addEventListener("click", function(event) {
      event.preventDefault();
      newReceiverForm.style.display = newReceiverForm.style.display === "none" ? "block" : "none";
    });
  }
});



