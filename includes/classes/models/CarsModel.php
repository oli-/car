<?php

class CarsModel extends Zend_Db_Table_Abstract {
    protected $_name = 'cars';
    protected $_primary = 'id';

    protected $_dependentTables = array('ReportsModel', 'TicketsModel');
}
