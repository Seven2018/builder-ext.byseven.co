// app/javascript/plugins/flatpickr.js
import flatpickr from "flatpickr"
// import "flatpickr/dist/flatpickr.min.css" // Note this is important!
require("flatpickr/dist/flatpickr.css")

flatpickr(".datepicker", {
  disableMobile: true,
})

// flatpickr(".timepicker", {
//   disableMobile: true,
//   enableTime: true,
//   noCalendar: true,
//   allowInput: true,
//   dateFormat: "H:i",
//   time_24hr: true,
//   minuteIncrement: 15,
// });

