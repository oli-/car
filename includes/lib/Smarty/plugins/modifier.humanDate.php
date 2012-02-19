<?php

function smarty_modifier_humanDate($time) {
    $time = (int) $time;
    $str = date('(D) ', $time);
    $str .= date('d.m.', $time);
    if(date('Y') != date('Y', $time)) {
        $str .= date('y', $time);
    }
    else {
        if(date('Hi', $time) != '0000')
            $str .= date(', H:i', $time);
    }

    return $str;
}
