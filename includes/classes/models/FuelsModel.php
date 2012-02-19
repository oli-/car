<?php

class FuelsModel extends Zend_Db_Table_Abstract {
    protected $_name = 'fuels';
    protected $_primary = 'id';

    protected $_dependentTables = array('ReportsModel');
}
