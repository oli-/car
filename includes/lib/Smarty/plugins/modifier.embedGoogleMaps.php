<?php

function smarty_modifier_embedGoogleMaps($location, $zoom = 12) {
    return sprintf(
        'http://maps.google.de/maps?f=q&amp;source=s_q&amp;q=%s&amp;t=m&amp;z=%d&amp;output=embed',
        urlencode($location), $zoom
        
    );
}
