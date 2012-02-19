<!DOCTYPE HTML>
<html>
    <head>
        <title>Auto {block name='title'}{/block}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        
        <link rel="shortcut icon" href="images/car.png" type="image/png">
        
        <link rel="stylesheet" type="text/css" href="css/redmond/jquery-ui-1.8.16.custom.css">
        <link rel="stylesheet" type="text/css" href="css/site.css">
        <link rel="stylesheet" type="text/css" href="fancybox/jquery.fancybox.css">
        
        <script type="text/javascript" src="js/jquery-1.6.4.min.js"></script>
        <script type="text/javascript" src="js/jquery.cookie.js"></script>
        <script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>
        <script type="text/javascript" src="js/flot/jquery.flot.min.js"></script>
        <script type="text/javascript" src="fancybox/jquery.fancybox.pack.js"></script>
        {block name='head'}{/block}
        <script type="text/javascript">
            {block name='script'}
                $(function() {

                });
            {/block}
        </script>
    </head>
    <body>
        <div id="container">
            {block name='body'}
            {/block}
        </div>
    </body>
</html>
