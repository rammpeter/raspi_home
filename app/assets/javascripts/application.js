// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery.ui.touch-punch.js
//= require jquery_ujs
// require turbolinks

//= require jquery_table2CSV
//= require flot/jquery.flot
//= require flot/jquery.flot.resize
//= require flot/jquery.flot.crosshair
//= require flot/jquery.flot.time
//= require flot/jquery.flot.stack
//= require jquery.event.drag-2.2
//= require slick.core
//= require slick.grid
//= require slick.dataview

//= require_tree .


$.datepicker.setDefaults({
    dateFormat: "dd.mm.yy",
    dayNamesMin: [ "So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
    dayNames: [ "Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag" ],
    firstDay: 1,
    monthNames: [ "Januar", "Februar", "Marts", "April", "Maj", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember" ]
});