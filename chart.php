<?php

require('includes/bootstrap.php');

$session = new Zend_Session_Namespace;

if($_REQUEST['chart'] == 'avgcons') {
    $r = new ReportsModel;
    $select = $r->select()->from('reports', array('distance', 'amount', '(UNIX_TIMESTAMP(time) * 1000) AS time'))
                          ->where('car = ?', $session->car)
                          ->where('distance is not null')
                          ->order('time')
                          ->order('id');
    $data = array();
    foreach($r->fetchAll($select)->toArray() AS $set) {
        $val = (float) $set['amount'] / (float) $set['distance'] * 100;
        $data[] = array((int) $set['time'], $val);
    }
    echo json_encode(array($data));
}
elseif($_REQUEST['chart'] == 'fuelcost') {
    $r = new ReportsModel;
    $select = $r->select()->from(array('r' => 'reports'), array('(UNIX_TIMESTAMP(time) * 1000 + r.id) AS time', 'unitprice'))
                          ->join(array('f' => 'fuels'), 'f.id = r.fuel', array('name'))
                          ->where('car = ?', $session->car)
                          ->order('time')
                          ->setIntegrityCheck(false);
    $data = array();
    $ref = array();
    foreach($r->fetchAll($select)->toArray() AS $entry) {
        if(!isset($ref[$entry['name']])) {
            $ref[$entry['name']] = array('label' => $entry['name'], 'data' => array());
            $data[] =& $ref[$entry['name']];
        }

        foreach($ref AS $key => &$rel) {
            if($key == $entry['name'])
                $rel['data'][] = array((int) $entry['time'], (float) $entry['unitprice']);
            else
                $rel['data'][] = null;
        }
    }

    echo json_encode($data);
}
