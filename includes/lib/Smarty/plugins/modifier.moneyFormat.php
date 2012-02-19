<?php

function smarty_modifier_moneyFormat($val, $currencySymbol = '&euro;', $symbolBeforeAmount = false) {
    $val = (float) $val;
    
    if($symbolBeforeAmount) {
        $format = '%2$s %1$.2f';
    }
    else {
        $format = '%1$.2f %2$s';
    }
    return sprintf($format, $val, $currencySymbol);
}
