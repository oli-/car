{extends 'html.tpl'}

{block name='script' append}
    $(function() {
        var disableTabs = [];
        {if $forceSelect}
            for(var i = 1; i < $('#tabs li').length; i++) //>
                disableTabs.push(i);
        {/if}

        $('#container').tabs({ disabled: disableTabs });
        $('#currentCar').button();

        $('#refuel-add').dialog({
            autoOpen: false,
            width: 230,
            modal: true,
            title: 'Tankrechnung buchen',
            buttons: {
                'Buchen': function() {
                    var t = $(this);
                    $.post('book.php', $('#refuel-add form').serialize(), function(data) {
                        t.find('.ui-state-error').removeClass('ui-state-error');
                        $('#refuel-add-message').html('');

                        if(data['success']) {
                            //t.dialog('close');
                            t.find('input').val('');
                            window.location.reload();
                        }
                        else {
                            if(data['msg']) {
                                $('#refuel-add-message').html(data['msg']);
                            }
                            for(var i in data['errorFields']) {
                                $('#refuel-add *[name=' + data['errorFields'][i] + ']').addClass('ui-state-error');
                            }
                        }
                    }, 'json');
                },
                'Abbrechen': function() {
                    $(this).dialog('close');
                },
            },
            close: function() {
                $('#refuel-add-message').html('');
                $(this).find('.ui-state-error').removeClass('ui-state-error');
            },
        });
        $('#refuel-add-trigger').button()
                                .click(function() {
                                    $('#refuel-add').dialog('open');
                                    $('#distance-input').focus();
                                });


        $('#ticket-add').dialog({
            autoOpen: false,
            width: 500,
            modal: true,
            title: 'Strafzettel buchen',
            buttons: {
                'Buchen': function() {
                    var t = $(this);
                    $.post('book.php', $('#ticket-add form').serialize(), function(data) {
                        t.find('.ui-state-error').removeClass('ui-state-error');
                        $('#ticket-add-message').html('');

                        if(data['success']) {
                            //t.dialog('close');
                            t.find('input').val('');
                            window.location.reload();
                        }
                        else {
                            if(data['msg']) {
                                $('#ticket-add-message').html(data['msg']);
                            }
                            for(var i in data['errorFields']) {
                                $('#ticket-add *[name=' + data['errorFields'][i] + ']').addClass('ui-state-error');
                            }
                        }
                    }, 'json');
                },
                'Abbrechen': function() {
                    $(this).dialog('close');
                },
            },
            close: function() {
                $('#ticket-add-message').html('');
                $(this).find('.ui-state-error').removeClass('ui-state-error');
            },
        });
        $('#ticket-add-trigger').button()
                                .click(function() {
                                    $('#ticket-add').dialog('open');
                                    $('#distance-input').focus();
                                });


        $('#carSelect ul a').click(function(e) {
            var data = { selectCar: $(this).attr('rel') };
            $.post(location.href, data, function(data) {
                $.cookie('selectCar', null);
                if(data['success']) {
                    $.cookie('selectCar', data['selectCar'], { expires: 365 });
                    window.location.reload();
                }
            }, 'json');
        });

        $('.time-select').datepicker({
            dateFormat: 'dd.mm.yy',
        });

        $('.numonly').keyup(function() {
            var val = $(this).val().replace(/,/g, '.');
            var val = val.replace(/[^0-9.]/g, '');
            $(this).val(val);
        });
        $('#distance-input').keyup(function() {
            if($(this).val().match(/\.\d$/)) {
                $('#amount-input').focus();
            }
        });
        $('#amount-input').keyup(function() {
            if($(this).val().match(/\.\d\d$/)) {
                $('#unitprice-input').focus();
            }
        });

        var refuelPlot = $.plot('#refuel-chart', [], {
            xaxis: {
                mode: 'time',
            },
            series: {
                lines: { show: true },
                points: { show: true },
            },
            grid: {
                hoverable: true,
                clickable: true,
                markings: [
                    { yaxis: { from: {consumption amount=$stats.amount distance=$stats.distance raw=true}, to: {consumption amount=$stats.amount distance=$stats.distance raw=true} }, color: '#999999' }
                ],
            },
        });
        $('#refuel-chart-picker').buttonset().click(function(e) {
            var picker = this;
            window.setTimeout(function() {
                var data = {
                    'chart': $(picker).find('input:checked').val(),
                };
                $.post('chart.php', data, function(data) {
                    refuelPlot.setData(data);
                    refuelPlot.setupGrid();
                    refuelPlot.draw();
                }, 'json');
            }, 500);
        }).triggerHandler('click');
        
        $('#refuel-chart').bind('plothover', function (event, pos, item) {
            $('#dataTable tr').removeClass('highlight');
            if(item !== null) {
                var i = item['dataIndex'] + 1;
                $('#dataTable tbody tr:nth-last-child(' + i + ')').addClass('highlight');
            }
        });
        $('#dataTable tr').mouseover(function() {
            refuelPlot.highlight(0, parseInt($(this).attr('rel')));
        });
        $('#dataTable tr').mouseout(function() {
            refuelPlot.unhighlight();
        });
        
        $('.fancybox').fancybox({
            fitToView: true,
            autoSize: true,
            closeClick: false,
            type: 'iframe',
        });
    });
{/block}

{block name='body'}
    {if $car}
        <button id="currentCar">{$car.make} {$car.model} ({$car.plate})</button>
    {/if}
    <ul id="tabs">
        <li><a href="#carSelect">Auto wählen</a></li>
        <li><a href="#refuels">Tanken</a></li>
        <li><a href="#tickets">Strafzettel</a></li>
    </ul>

    <div id="carSelect">
        <ul>
            {foreach $cars as $car}
                <li><a href="#refuels" rel="{$car.id}">{$car.make} {$car.model} ({$car.plate})</a></li>
                <li style="margin-top: 1em;" class="grey"><a href="#" rel="0">-- keins --</a></li>
            {/foreach}
        </ul>
    </div>

    <div id="refuels">
        <div id="refuel-chart-picker">
            <input type="radio" name="refuel-chart-picker" id="refuel-chart-picker-avgcons" value="avgcons" checked> <label for="refuel-chart-picker-avgcons">&Oslash; Verbrauch</label>
            <input type="radio" name="refuel-chart-picker" id="refuel-chart-picker-fuelcost" value="fuelcost" checked> <label for="refuel-chart-picker-fuelcost">Benzinpreis</label>
        </div>
        <div id="refuel-chart"></div>

        <table class="ui-widget ui-widget-content" style="float: right; width: 250px;">
            <thead>
                <tr class="ui-widget-header">
                    <th colspan="2">Statistiken seit {$stats.since}</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="strong">Menge</td>
                    <td>{$stats.amount|number_format:2:',':'.'} L</td>
                </tr>
                <tr>
                    <td class="strong">Kosten</td>
                    <td>{$stats.price|number_format:2:',':'.'} &euro;</td>
                </tr>
                <tr>
                    <td class="strong">Kilometer</td>
                    <td>{$stats.distance|number_format:1:',':'.'}</td>
                </tr>
                <tr>
                    <td class="strong">#</td>
                    <td>{$stats.count|number_format:0:',':'.'}</td>
                </tr>
                <tr>
                    <td class="strong">&Oslash; Verbrauch</td>
                    <td>{if $stats.distance}{consumption amount=$stats.amount distance=$stats.distance}{/if}</td>
                </tr>
            </tbody>
        </table>

        <table class="ui-widget ui-widget-content" id="dataTable">
            <thead>
                <tr class="ui-widget-header">
                    <th></th>
                    <th>Benzin</th>
                    <th>Datum</th>
                    <th>Distanz</th>
                    <th>Menge</th>
                    <th>&euro;/Liter</th>
                    <th>&Oslash; Verbrauch</th>
                    <th>Preis pro km</th>
                </tr>
            </thead>
            <tbody>
                {foreach $reports as $report}
                    <tr rel="{$report@total - $report@iteration}">
                        <td class="small">#{$report.id}</td>
                        <td>{$report.name}</td>
                        <td>{$report.time|humanDate}</td>
                        {if $report.distance}
                            <td>{$report.distance} km</td>
                        {else}
                            <td class="grey centered">---</td>
                        {/if}
                        <td>{$report.amount|number_format:2:',':'.'} L</td>
                        <td>{$report.unitprice|roundResult} &euro;/L</td>
                        <td>
                            {if $report.distance and $report.amount}
                                {consumption amount=$report.amount distance=$report.distance}
                            {/if}
                        </td>
                        <td>
                            {if $report.distance and $report.amount and $report.unitprice}
                                {kmcost amount=$report.amount distance=$report.distance unitprice=$report.unitprice}
                            {/if}
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
        <br>
        <button id="refuel-add-trigger">Tankrechnung buchen</button>

        <div class="clear"></div>

        <div id="refuel-add">
            <div id="refuel-add-message"></div>
            <form>
                <input type="hidden" name="action" value="refuel">
                <label for="fuel-dropdown">Benzin</label>
                <select name="fuel" id="fuel-dropdown" class="text ui-widget-content ui-corner-all">
                    {foreach $fuels AS $fuel}
                        <option value="{$fuel.id}" {if $fuel.selected}selected{/if}>{$fuel.name}</option>
                    {/foreach}
                </select>

                <label for="time-select">Datum</label>
                <input type="text" name="time" value="{'d.m.Y'|date}" class="ui-widget-content ui-corner-all time-select">

                <label for="distance-input">Distanz (km)</label>
                <input type="text" name="distance" id="distance-input" class="ui-widget-content ui-corner-all numonly">

                <label for="amount-input">Menge (L)</label>
                <input type="text" name="amount" id="amount-input" class="ui-widget-content ui-corner-all numonly">

                <label for="unitprice-input">Preis pro Liter</label>
                <input type="text" name="unitprice" id="unitprice-input" class="ui-widget-content ui-corner-all numonly">
            </form>
        </div>
    </div>
    
    <div id="tickets">
        <table class="ui-widget ui-widget-content" id="dataTable">
            <thead>
                <tr class="ui-widget-header">
                    <th>Datum</th>
                    <th>Strafe</th>
                    <th>Grund</th>
                    <th>Ort</th>
                </tr>
            </thead>
            <tbody>
                {foreach $tickets as $ticket}
                    <tr>
                        <td>{$ticket.received|humanDate}</td>
                        <td>{$ticket.amount|moneyFormat}</td>
                        <td>{$ticket.reason}</td>
                        <td>{$ticket.location}&nbsp;<a class="fancybox" href="{$ticket.location|embedGoogleMaps}"><img src="images/map_go.png" alt="Karte" title="Auf Karte zeigen"></a></td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
        <br>
        <button id="ticket-add-trigger">Strafzettel buchen</button>
        
        <div class="clear"></div>

        <div id="ticket-add">
            <div id="ticket-add-message"></div>
            <form>
                <input type="hidden" name="action" value="ticket">
                <label for="time-select">Datum</label>
                <input type="text" name="received" id="received-input" value="{'d.m.Y'|date}" class="ui-widget-content ui-corner-all time-select">

                <label for="fee-input">Strafe</label>
                <input type="text" name="amount" id="fee-input" class="ui-widget-content ui-corner-all numonly">
                
                <label for="reason-input">Grund</label>
                <input type="text" name="reason" id="reason-input" class="text ui-widget-content ui-corner-all">

                <label for="location-input">Ort</label>
                <input type="text" name="location" id="location-input" class="text ui-widget-content ui-corner-all">
            </form>
        </div>
    </div>
{/block}
