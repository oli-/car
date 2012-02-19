<?php

function smarty_function_consumption($params) {
    $amount = (float) $params['amount'];
    $distance = (float) $params['distance'];

    switch($params['mode']) {
        case 'gallon':
        case 'km':
        default:
            @$val = $amount / $distance * 100;
            if($params['raw'])
                return $val;
            return round($val, 2) . ' L/100km';
    }
}
