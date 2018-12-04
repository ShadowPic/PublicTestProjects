/*
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
var showControllersOnly = false;
var seriesFilter = "";
var filtersOnlySampleSeries = true;

/*
 * Add header in statistics table to group metrics by category
 * format
 *
 */
function summaryTableHeader(header) {
    var newRow = header.insertRow(-1);
    newRow.className = "tablesorter-no-sort";
    var cell = document.createElement('th');
    cell.setAttribute("data-sorter", false);
    cell.colSpan = 1;
    cell.innerHTML = "Requests";
    newRow.appendChild(cell);

    cell = document.createElement('th');
    cell.setAttribute("data-sorter", false);
    cell.colSpan = 3;
    cell.innerHTML = "Executions";
    newRow.appendChild(cell);

    cell = document.createElement('th');
    cell.setAttribute("data-sorter", false);
    cell.colSpan = 7;
    cell.innerHTML = "Response Times (ms)";
    newRow.appendChild(cell);

    cell = document.createElement('th');
    cell.setAttribute("data-sorter", false);
    cell.colSpan = 2;
    cell.innerHTML = "Network (KB/sec)";
    newRow.appendChild(cell);
}

/*
 * Populates the table identified by id parameter with the specified data and
 * format
 *
 */
function createTable(table, info, formatter, defaultSorts, seriesIndex, headerCreator) {
    var tableRef = table[0];

    // Create header and populate it with data.titles array
    var header = tableRef.createTHead();

    // Call callback is available
    if(headerCreator) {
        headerCreator(header);
    }

    var newRow = header.insertRow(-1);
    for (var index = 0; index < info.titles.length; index++) {
        var cell = document.createElement('th');
        cell.innerHTML = info.titles[index];
        newRow.appendChild(cell);
    }

    var tBody;

    // Create overall body if defined
    if(info.overall){
        tBody = document.createElement('tbody');
        tBody.className = "tablesorter-no-sort";
        tableRef.appendChild(tBody);
        var newRow = tBody.insertRow(-1);
        var data = info.overall.data;
        for(var index=0;index < data.length; index++){
            var cell = newRow.insertCell(-1);
            cell.innerHTML = formatter ? formatter(index, data[index]): data[index];
        }
    }

    // Create regular body
    tBody = document.createElement('tbody');
    tableRef.appendChild(tBody);

    var regexp;
    if(seriesFilter) {
        regexp = new RegExp(seriesFilter, 'i');
    }
    // Populate body with data.items array
    for(var index=0; index < info.items.length; index++){
        var item = info.items[index];
        if((!regexp || filtersOnlySampleSeries && !info.supportsControllersDiscrimination || regexp.test(item.data[seriesIndex]))
                &&
                (!showControllersOnly || !info.supportsControllersDiscrimination || item.isController)){
            if(item.data.length > 0) {
                var newRow = tBody.insertRow(-1);
                for(var col=0; col < item.data.length; col++){
                    var cell = newRow.insertCell(-1);
                    cell.innerHTML = formatter ? formatter(col, item.data[col]) : item.data[col];
                }
            }
        }
    }

    // Add support of columns sort
    table.tablesorter({sortList : defaultSorts});
}

$(document).ready(function() {

    // Customize table sorter default options
    $.extend( $.tablesorter.defaults, {
        theme: 'blue',
        cssInfoBlock: "tablesorter-no-sort",
        widthFixed: true,
        widgets: ['zebra']
    });

    var data = {"OkPercent": 100.0, "KoPercent": 0.0};
    var dataset = [
        {
            "label" : "KO",
            "data" : data.KoPercent,
            "color" : "#FF6347"
        },
        {
            "label" : "OK",
            "data" : data.OkPercent,
            "color" : "#9ACD32"
        }];
    $.plot($("#flot-requests-summary"), dataset, {
        series : {
            pie : {
                show : true,
                radius : 1,
                label : {
                    show : true,
                    radius : 3 / 4,
                    formatter : function(label, series) {
                        return '<div style="font-size:8pt;text-align:center;padding:2px;color:white;">'
                            + label
                            + '<br/>'
                            + Math.round10(series.percent, -2)
                            + '%</div>';
                    },
                    background : {
                        opacity : 0.5,
                        color : '#000'
                    }
                }
            }
        },
        legend : {
            show : true
        }
    });

    // Creates APDEX table
    createTable($("#apdexTable"), {"supportsControllersDiscrimination": true, "overall": {"data": [0.7005988023952096, 500, 1500, "Total"], "isController": false}, "titles": ["Apdex", "T (Toleration threshold)", "F (Frustration threshold)", "Label"], "items": [{"data": [0.4182692307692308, 500, 1500, "68 /placeorder.jsp"], "isController": false}, {"data": [0.6698113207547169, 500, 1500, "58 /placeorder.jsp"], "isController": false}, {"data": [0.7980769230769231, 500, 1500, "71 /about.jsp"], "isController": false}, {"data": [0.7169811320754716, 500, 1500, "65 /index.jsp"], "isController": false}, {"data": [0.6666666666666666, 500, 1500, "74 /index.jsp"], "isController": false}, {"data": [0.9901960784313726, 500, 1500, "78 /api/v3/addons/compat-override/"], "isController": false}, {"data": [0.5555555555555556, 500, 1500, "47 /about.jsp"], "isController": false}, {"data": [0.6981132075471698, 500, 1500, "62 /orderconfirmation.jsp"], "isController": false}, {"data": [0.7407407407407407, 500, 1500, "53 /placeorder.jsp"], "isController": false}, {"data": [0.8872549019607843, 500, 1500, "77 /api/v3/addons/search/"], "isController": false}, {"data": [0.75, 500, 1500, "50 /index.jsp"], "isController": false}]}, function(index, item){
        switch(index){
            case 0:
                item = item.toFixed(3);
                break;
            case 1:
            case 2:
                item = formatDuration(item);
                break;
        }
        return item;
    }, [[0, 0]], 3);

    // Create statistics table
    createTable($("#statisticsTable"), {"supportsControllersDiscrimination": true, "overall": {"data": ["Total", 579, 0, 0.0, 685.3713298791017, 13, 4696, 2229.0, 2522.0, 2960.00000000001, 4.754553367603344, 6.606604333295012, 2.5030659016817487], "isController": false}, "titles": ["Label", "#Samples", "KO", "Error %", "Average", "Min", "Max", "90th pct", "95th pct", "99th pct", "Throughput", "Received", "Sent"], "items": [{"data": ["68 /placeorder.jsp", 104, 0, 0.0, 1675.711538461538, 118, 4785, 3424.0, 4480.75, 4777.25, 0.8977203083323982, 2.5854135825514244, 0.9434003935079284], "isController": false}, {"data": ["58 /placeorder.jsp", 106, 0, 0.0, 787.5849056603774, 117, 3478, 2306.5999999999995, 2554.0, 3478.0, 0.9369006266627776, 1.6414059806963117, 0.49955834195105137], "isController": false}, {"data": ["71 /about.jsp", 52, 0, 0.0, 551.2692307692308, 63, 2715, 1636.9000000000005, 2500.0999999999995, 2715.0, 0.45167118337850043, 0.3727169433152665, 0.2408324864498645], "isController": false}, {"data": ["65 /index.jsp", 106, 0, 0.0, 752.0000000000001, 122, 3287, 2384.7999999999993, 2595.0, 3287.0, 0.9336656948322485, 1.3773943075019157, 0.4987452490949608], "isController": false}, {"data": ["74 /index.jsp", 51, 0, 0.0, 824.6078431372548, 127, 3433, 2542.0, 2581.8, 3433.0, 0.45343006508055056, 0.6688492850697038, 0.23689949689267042], "isController": false}, {"data": ["78 /api/v3/addons/compat-override/", 51, 0, 0.0, 79.52941176470588, 13, 985, 350.8, 464.0, 985.0, 0.4529508415116124, 0.6586365263777255, 0.19728132354900307], "isController": false}, {"data": ["47 /about.jsp", 108, 0, 0.0, 1140.7592592592594, 64, 4696, 2393.8000000000006, 2495.0, 4696.0, 0.9084714967067908, 0.7673278583205054, 0.46387971479883244], "isController": false}, {"data": ["62 /orderconfirmation.jsp", 106, 0, 0.0, 695.4528301886793, 64, 2813, 2191.1, 2622.0, 2813.0, 0.9372734185721612, 0.9546642339558244, 0.6553591481422534], "isController": false}, {"data": ["53 /placeorder.jsp", 108, 0, 0.0, 693.9259259259263, 117, 2787, 2388.0, 2510.0, 2787.0, 0.9270067980498524, 1.6285988571207854, 0.4942829216164252], "isController": false}, {"data": ["77 /api/v3/addons/search/", 102, 0, 0.0, 310.9509803921568, 109, 1506, 570.4, 778.8499999999996, 1493.9999999999995, 0.9041030322906602, 1.9719864478722555, 0.5827226575310896], "isController": false}, {"data": ["50 /index.jsp", 108, 0, 0.0, 670.8703703703699, 121, 2755, 1706.0000000000023, 2265.0, 2755.0, 0.9428197293758185, 1.3919276516804888, 0.4925864797031864], "isController": false}]}, function(index, item){
        switch(index){
            // Errors pct
            case 3:
                item = item.toFixed(2) + '%';
                break;
            // Mean
            case 4:
            // Mean
            case 7:
            // Percentile 1
            case 8:
            // Percentile 2
            case 9:
            // Percentile 3
            case 10:
            // Throughput
            case 11:
            // Kbytes/s
            case 12:
            // Sent Kbytes/s
                item = item.toFixed(2);
                break;
        }
        return item;
    }, [[0, 0]], 0, summaryTableHeader);

    // Create error table
    createTable($("#errorsTable"), {"supportsControllersDiscrimination": false, "titles": ["Type of error", "Number of errors", "% in errors", "% in all samples"], "items": []}, function(index, item){
        switch(index){
            case 2:
            case 3:
                item = item.toFixed(2) + '%';
                break;
        }
        return item;
    }, [[1, 1]]);

        // Create top5 errors by sampler
    createTable($("#top5ErrorsBySamplerTable"), {"supportsControllersDiscrimination": false, "overall": {"data": ["Total", 579, 0, null, null, null, null, null, null, null, null, null, null], "isController": false}, "titles": ["Sample", "#Samples", "#Errors", "Error", "#Errors", "Error", "#Errors", "Error", "#Errors", "Error", "#Errors", "Error", "#Errors"], "items": [{"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}]}, function(index, item){
        return item;
    }, [[0, 0]], 0);

});
