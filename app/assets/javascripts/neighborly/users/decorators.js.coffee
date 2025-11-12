ready = ->
  $("#user_birthday").datepicker(
    dateFormat: "dd/mm/yy"
    changeMonth: true
    changeYear: true
    yearRange: "-100y:c+nn"
    maxDate: "-1d"
  )
  $(".event-date-datepicker").datepicker(
    dateFormat: "dd/mm/yy"
    changeMonth: true
    changeYear: true
    yearRange: "0y:c+nn"
    minDate: "0d"
    maxDate: "+300d"
  )
$(document).ready(ready)
$(document).on('page:load', ready)
