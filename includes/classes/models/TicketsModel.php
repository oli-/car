<?php

class TicketsModel extends Zend_Db_Table_Abstract {
    protected $_name = 'tickets';
    protected $_primary = 'id';

    protected $_referenceMap = array(
        'Cars' => array(
            'columns'       => 'car',
            'refTableClass' => 'Cars',
            'refColumns'    => 'id',
            'onDelete'      => self::CASCADE,
        ),
    );
    
    public function byCar($car, $limit, $offset = 0) {
        $select = $this->select()->from(array('t' => 'tickets'), array('*', 'UNIX_TIMESTAMP(received) AS received'))
                                 ->order('received DESC')
                                 ->order('t.id DESC')
                                 ->limit($limit, $offset)
                                 ->where('t.car = ?', $car)
                                 ->setIntegrityCheck(false);
        return $this->fetchAll($select);
    }
}
