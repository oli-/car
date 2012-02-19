<?php

require('includes/bootstrap.php');

$status = array('success' => false,
                'msg' => '',
                'errorFields' => array());

$session = new Zend_Session_Namespace;
if(isset($session->car)) {
    $error = array();

    if($_POST['action'] == 'refuel') {
        $f = new FuelsModel;
        $fuel = (int) $_POST['fuel'];
        if(null === $f->find($fuel)->current())
            $error[] = 'fuel';

        $time = strtotime($_POST['time']);
        if($time === false)
            $error[] = 'time';

        $distance = (float) $_POST['distance'];
        if($distance < 1)
            $error[] = 'distance';

        $amount = (float) $_POST['amount'];
        if($amount < 1)
            $error[] = 'amount';

        $unitprice = (float) $_POST['unitprice'];
        if($unitprice < 0.01)
            $error[] = 'unitprice';

        if(empty($error)) {
            $r = new ReportsModel;
            // insert data set
            $data = array(
                'car' => $session->car,
                'fuel' => $fuel,
                'time' => new Zend_Db_Expr('FROM_UNIXTIME(' . $time . ')'),
                'distance' => $distance,
                'amount' => $amount,
                'unitprice' => $unitprice,
            );

            if($r->insert($data))
                $status['success'] = true;
        }
        else {
            $status['success'] = false;
            $status['errorFields'] = $error;
        }
    }
    
    elseif($_POST['action'] == 'ticket') {
        $time = strtotime($_POST['received']);
        if($time === false)
            $error[] = 'received';
        
        $amount = (float) $_POST['amount'];
        if($amount < 1)
            $error[] = 'amount';
        
        $reason = $_POST['reason'];
        if(empty($reason))
            $error[] = 'reason';
        
        $location = $_POST['location'];
        if(empty($location))
            $error[] = 'location';
        
        if(empty($error)) {
            $t = new TicketsModel;
            // insert data set
            $data = array(
                'car'      => $session->car,
                'received' => new Zend_Db_Expr('FROM_UNIXTIME(' . $time . ')'),
                'amount'   => $amount,
                'reason'   => $reason,
                'location' => $location,
            );
            
            if($t->insert($data))
                $status['success'] = true;
        }
        else {
            $status['success'] = false;
            $status['errorFields'] = $error;
        }
    }
    $status['success'] = empty($error);
}
else {
    $status['success'] = false;
    $status['msg'] = 'Kein Auto gewählt';
}

die(json_encode($status));
