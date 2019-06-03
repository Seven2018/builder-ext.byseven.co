//= require rails-ujs
//= require_tree .
require bootstrap-sprockets
require jquery
require jquery_ujs
$(function() {
    $('input.datepicker').data({behaviour: "datepicker"}).datepicker();
});

