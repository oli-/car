<?php

define('BASE', realpath(dirname(__FILE__) . '/../'));
define('INCLUDES', BASE . '/includes');
define('CLASSES', INCLUDES . '/classes');
define('MODELS', CLASSES . '/models');
define('LIBRARY', INCLUDES . '/lib');

set_include_path(get_include_path() . PATH_SEPARATOR . LIBRARY);

function debug(&$var) {
    echo '<pre>';
    var_dump($var);
    echo '</pre>';
}

function myAutoload($className) {
    $include = null;
    if(0 === strpos($className, 'Zend')) {
        $pieces = explode('_', $className);
        $filename = array_pop($pieces) . '.php';
        $path = LIBRARY . '/' . implode('/', $pieces);
        $include = $path . '/' . $filename;
    }
    elseif('Model' === substr($className, -5)) {
        $include = sprintf('%s/%s.php', MODELS, $className);
    }
    else {
        $include = sprintf('%s/%s.class.php', CLASSES, $className);
    }

    if($include !== null)
        if(is_file($include))
            require_once($include);
    return false;
}

spl_autoload_register('myAutoload');

// init db
Zend_Db_Table::setDefaultAdapter(
    Zend_Db::factory('Pdo_Mysql', array(
    'host'     => 'localhost',
    'username' => 'cars',
    'password' => 'Nm23sthFC4ULeYBE',
    'dbname'   => 'cars',
    ))
);

// init smarty
define('SMARTY_DIR', LIBRARY . '/Smarty/');
define('TEMPLATES', BASE . '/templates');
DEFINE('TEMPLATES_COMPILED', SMARTY_DIR . 'compiled');

require(LIBRARY . '/Smarty/Smarty.class.php');
tpl::init();
