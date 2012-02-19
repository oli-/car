<?php

class tpl {
    protected static $smarty = null;

    protected function __construct() { }

    public static function get() {
        if(self::$smarty === null) {
            self::init();
        }
        return self::$smarty;
    }

    public static function init() {
        if(self::$smarty === null) {
            self::$smarty = new Smarty;
            self::$smarty->setTemplateDir(TEMPLATES);
            self::$smarty->setCompileDir(TEMPLATES_COMPILED);
        }
    }
}
