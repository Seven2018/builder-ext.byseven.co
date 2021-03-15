import "bootstrap";
require("../plugins/flatpickr")
// import {initSortable} from "../plugins/init_sortable.js";
import 'easy-autocomplete/dist/jquery.easy-autocomplete';
import 'stylesheets/application';
// initSortable();
// global.initSortable = initSortable;


try {
  require("trix")
  require("@rails/actiontext")
}
catch(err) {
}
