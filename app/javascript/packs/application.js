import "bootstrap";
import "../plugins/flatpickr";
import {initSortable} from "../plugins/init_sortable";

initSortable();
global.initSortable = initSortable;
