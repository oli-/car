<?php

require('includes/bootstrap.php');
error_reporting(E_ALL ^ E_NOTICE);
$session = new Zend_Session_Namespace;

$c = new CarsModel;
$cars = $c->fetchAll($c->select()->order(array('make', 'model')))->toArray();

if(isset($_REQUEST['selectCar'])) {
    $status = array('success' => false);
    if($_REQUEST['selectCar'] == "0") {
        unset($session->car);
        $status['success'] = true;
    }
    else {
        foreach($cars AS &$car) {
            if($car['id'] == $_REQUEST['selectCar']) {
                $session->car = (int) $car['id'];
                $status['success'] = true;
            }
        }
    }
    die(json_encode($status));
}

if(!isset($session->car)) {
    tpl::get()->assign('forceSelect', true);
}
else {
    // get currently selected car
    $car = $c->find($session->car)->current();
    tpl::get()->assign('car', $car->toArray());

    // get reports for the current car
    $r = new ReportsModel;
    $reports = $r->byCar($session->car, 30)->toArray();
    $first = array_shift($reports);
    if(!empty($first)) array_unshift($reports, $first);
    tpl::get()->assign('reports', $reports);

    // get all fuel types
    $f = new FuelsModel;
    $fuels = array();
    foreach($f->fetchAll($f->select()->order('name'))->toArray() AS $fuel)
        $fuels[] = array_merge($fuel, array('selected' => ($fuel['id'] == $first['fuel'])));
    tpl::get()->assign('fuels', $fuels);

    // overall fuel stats
    $stats = array();
    $since = array_shift($r->fetchRow($r->select()->from('reports', 'UNIX_TIMESTAMP(time) AS time')->where('car = ?', $session->car)->order('time')->limit(1))->toArray());
    $stats['since'] = date('F Y', $since);

    $sum = $r->fetchRow($r->select()->from('reports', array('SUM(amount) AS amount', 'SUM(amount*unitprice) AS price', 'SUM(distance) AS distance', 'count(id) AS count'))->where('car = ?', $session->car)->where('distance is not null')->group('car'));
    if($sum !== null) {
        $stats = array_merge($stats, $sum->toArray());
    }
    tpl::get()->assign('stats', $stats);
    
    // tickets
    $t = new TicketsModel;
    $tickets = $t->byCar($session->car, 30)->toArray();
    tpl::get()->assign('tickets', $tickets);
}

tpl::get()->assign('cars', $cars);
tpl::get()->display('index.tpl');
