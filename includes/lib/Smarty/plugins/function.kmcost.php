<?php

function smarty_function_kmcost($params) {
    $amount = (float) $params['amount'];
    $distance = (float) $params['distance'];
    $ppl = (float) $params['unitprice'];

    $val = $amount / $distance * $ppl;
    return round($val, 3) . ' &euro;/km';
}
