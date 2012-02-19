<?php

class ReportsModel extends Zend_Db_Table_Abstract {
    protected $_name = 'reports';
    protected $_primary = 'id';

    protected $_referenceMap = array(
        'Cars' => array(
            'columns'       => 'car',
            'refTableClass' => 'Cars',
            'refColumns'    => 'id',
            'onDelete'      => self::CASCADE,
        ),
        'Fuels' => array(
            'columns'       => 'fuel',
            'refTableClass' => 'Fuels',
            'refColumns'    => 'id',
            'onDelete'      => self::CASCADE,
        ),
    );

    public function byCar($car, $limit, $offset = 0) {
        $select = $this->select()->from(array('r' => 'reports'), array('*', 'UNIX_TIMESTAMP(time) AS time'))
                                 ->join(array('f' => 'fuels'), 'f.id = r.fuel', array('name'))
                                 ->order('time DESC')
                                 ->order('r.id DESC')
                                 ->limit($limit, $offset)
                                 ->where('r.car = ?', $car)
                                 ->setIntegrityCheck(false);
        return $this->fetchAll($select);
    }
}
