<table class="ui-widget ui-widget-content">
    <thead>
        <tr class="ui-widget-header">
            <th></th>
            <th>Benzin</th>
            <th>Datum</th>
            <th>Distanz</th>
            <th>Menge</th>
            <th>&euro;/Liter</th>
            <th>&Oslash; Verbrauch</th>
        </tr>
    </thead>
    <tbody>
        {foreach $reports as $report}
            <tr>
                <td class="small">#{$report.id}</td>
                <td>{$report.name}</td>
                <td>{$report.time|humanDate}</td>
                <td>{$report.distance} km</td>
                <td>{$report.amount} L</td>
                <td>{$report.unitprice} &euro;/L</td>
                <td>
                    {if $report.distance and $report.amount}
                        {consumption amount=$report.amount distance=$report.distance}
                    {/if}
                </td>
            </tr>
        {/foreach}
    </tbody>
</table>
