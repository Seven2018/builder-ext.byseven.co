// app/javascript/plugins/flatpickr.js
import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.min.css" // Note this is important!

flatpickr(".datepicker", {

})

flatpickr(".timepicker", {
  enableTime: true,
  noCalendar: true,
  dateFormat: "H:i",
  time_24hr: true
})

