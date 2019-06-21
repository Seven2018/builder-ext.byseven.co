import "bootstrap";
import "../plugins/flatpickr";
import {initSortable} from "../plugins/init_sortable";
import {initTree} from "../plugins/tree";

initSortable();
global.initSortable = initSortable;

