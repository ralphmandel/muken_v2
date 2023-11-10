//Formula to convert a number between 0-10 to the invervals 0.1 - 0.7

      //var interval_converted = (status_value / 10) * 0.6 + 0.1

// Data points (adjust these values as needed)
var dataPoints = [0.7, 0.5, 0.5, 0.3, 0.7, 0.3, 0.5, 0.1, 0.5, 0.3];

// Get the graph container element
var graphContainer = $.GetContextPanel().FindChildTraverse("spider-graph");
var graphLine = $.GetContextPanel().FindChildTraverse("spider-line");


// Calculate the number of data points
var numDataPoints = dataPoints.length;

// Create an array to store the coordinates of data points
var dataPointCoordinates = [];

// Create the graph segments
for (let i = 0; i < numDataPoints; i++) {
    var angle = (Math.PI * 2 * i) / numDataPoints;
    var value = dataPoints[i];

    // Calculate the position of each data point on the graph
    var x = Math.cos(angle) * (value * 100) + 150; // 150 is the center X coordinate
    var y = Math.sin(angle) * (value * 100) + 150; // 150 is the center Y coordinate

    // Create a segment element
    var segment = $.CreatePanel("Panel", graphContainer, "segment" + i, { class: "segment", html: "true"});
    segment.style.position = x + 'px ' + y + 'px ' + '0px';

    // Store the coordinates in the array
    dataPointCoordinates.push({ x, y });

}

for (let i = 0; i < numDataPoints; i++) {
  var startPoint = dataPointCoordinates[i];
  var endPoint = dataPointCoordinates[(i + 1) % numDataPoints]; // Connect to the next point or back to the first point

  // Create a line element
  var line = $.CreatePanel("Panel", graphLine, "line" + i, { class: "line", html: "true"});
  line.style.width = Math.sqrt((startPoint.x - endPoint.x) ** 2 + (startPoint.y - endPoint.y) ** 2) + 'px'; // Calculate the length of the line
  line.style.transform = "rotateZ( " + `${Math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)}` * (180/Math.PI) + "deg)"; // Calculate the angle of rotation
  line.style.position = (startPoint.x - 50) + 'px ' + (startPoint.y - 50) + 'px ' + '0px';
}