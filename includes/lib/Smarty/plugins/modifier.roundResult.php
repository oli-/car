<?php

function smarty_modifier_roundResult($num, $decimals = 2) {
    $pieces = explode('.', $num);
    $num = $pieces[0] . ',';
    $num .= substr($pieces[1], 0, 2);
    $num .= '<span class="small grey">' . substr($pieces[1], 2) . '</span>';


    return $num;
}
