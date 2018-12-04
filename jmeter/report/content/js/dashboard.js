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
    createTable($("#apdexTable"), {"supportsControllersDiscrimination": true, "overall": {"data": [0.7933070866141733, 500, 1500, "Total"], "isController": false}, "titles": ["Apdex", "T (Toleration threshold)", "F (Frustration threshold)", "Label"], "items": [{"data": [0.549618320610687, 500, 1500, "68 /placeorder.jsp"], "isController": false}, {"data": [0.8059701492537313, 500, 1500, "58 /placeorder.jsp"], "isController": false}, {"data": [0.7461538461538462, 500, 1500, "71 /about.jsp"], "isController": false}, {"data": [0.7803030303030303, 500, 1500, "65 /index.jsp"], "isController": false}, {"data": [0.7538461538461538, 500, 1500, "74 /index.jsp"], "isController": false}, {"data": [0.9923076923076923, 500, 1500, "78 /api/v3/addons/compat-override/"], "isController": false}, {"data": [0.7642857142857142, 500, 1500, "47 /about.jsp"], "isController": false}, {"data": [0.835820895522388, 500, 1500, "62 /orderconfirmation.jsp"], "isController": false}, {"data": [0.835820895522388, 500, 1500, "53 /placeorder.jsp"], "isController": false}, {"data": [0.9346153846153846, 500, 1500, "77 /api/v3/addons/search/"], "isController": false}, {"data": [0.7857142857142857, 500, 1500, "50 /index.jsp"], "isController": false}]}, function(index, item){
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
    createTable($("#statisticsTable"), {"supportsControllersDiscrimination": true, "overall": {"data": ["Total", 733, 0, 0.0, 527.6984993178719, 13, 3781, 1619.2, 2232.2999999999993, 3316.1999999999834, 6.0651193579082365, 8.415422600947416, 3.1932232194572006], "isController": false}, "titles": ["Label", "#Samples", "KO", "Error %", "Average", "Min", "Max", "90th pct", "95th pct", "99th pct", "Throughput", "Received", "Sent"], "items": [{"data": ["68 /placeorder.jsp", 131, 0, 0.0, 1314.9770992366414, 117, 4740, 3469.6, 4225.999999999999, 4727.52, 1.103473836719566, 3.1923202616959805, 1.1663783604358302], "isController": false}, {"data": ["58 /placeorder.jsp", 134, 0, 0.0, 537.8208955223879, 112, 3781, 1251.0, 2223.25, 3781.0, 1.1460239809794228, 2.0077802948018406, 0.6110635679831689], "isController": false}, {"data": ["71 /about.jsp", 65, 0, 0.0, 707.5384615384613, 64, 3535, 2174.9999999999995, 2623.599999999999, 3535.0, 0.5709617631299245, 0.47115497055154903, 0.30443859635638554], "isController": false}, {"data": ["65 /index.jsp", 132, 0, 0.0, 638.8560606060612, 121, 2973, 2075.0, 2284.95, 2973.0, 1.1321045996037635, 1.6717069532234965, 0.604747281233651], "isController": false}, {"data": ["74 /index.jsp", 65, 0, 0.0, 708.3230769230772, 121, 2751, 2224.2, 2623.999999999999, 2751.0, 0.5706359518207677, 0.8413450986761246, 0.2981349943594831], "isController": false}, {"data": ["78 /api/v3/addons/compat-override/", 65, 0, 0.0, 66.72307692307693, 13, 505, 341.2, 407.5999999999996, 505.0, 0.5681271905673405, 0.8261146355027051, 0.24744602245413466], "isController": false}, {"data": ["47 /about.jsp", 140, 0, 0.0, 643.0, 64, 3724, 1610.3000000000006, 2355.0, 3724.0, 1.1785503830288744, 0.9902092189999158, 0.6049771392794006], "isController": false}, {"data": ["62 /orderconfirmation.jsp", 134, 0, 0.0, 463.2537313432835, 65, 2345, 1620.0, 2153.25, 2345.0, 1.1263722408082983, 1.147271725745171, 0.7875805902526772], "isController": false}, {"data": ["53 /placeorder.jsp", 134, 0, 0.0, 509.6567164179105, 117, 2403, 1155.0, 2232.25, 2403.0, 1.1500862564692351, 2.020512866589994, 0.6132295859689476], "isController": false}, {"data": ["77 /api/v3/addons/search/", 130, 0, 0.0, 256.5, 108, 1447, 539.6, 707.3999999999987, 1305.639999999999, 1.1361947962278334, 2.478213942748892, 0.7323130522562207], "isController": false}, {"data": ["50 /index.jsp", 140, 0, 0.0, 661.9, 119, 3724, 2184.0, 2658.0, 3724.0, 1.1698936232441148, 1.7265397157994133, 0.6112237191753921], "isController": false}]}, function(index, item){
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
    createTable($("#top5ErrorsBySamplerTable"), {"supportsControllersDiscrimination": false, "overall": {"data": ["Total", 733, 0, null, null, null, null, null, null, null, null, null, null], "isController": false}, "titles": ["Sample", "#Samples", "#Errors", "Error", "#Errors", "Error", "#Errors", "Error", "#Errors", "Error", "#Errors", "Error", "#Errors"], "items": [{"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}, {"data": [], "isController": false}]}, function(index, item){
        return item;
    }, [[0, 0]], 0);

});
