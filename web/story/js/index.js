var box = document.getElementById('box').textContent,
    rs = document.getElementById('render'),
    f = [
      'arial','verdana','monospace',
      'consolas','impact','helveltica'
    ],
    c = [
      '1ABC9C','3498DB','34495E','E67E22',
      'E74C3C','2ECC71','E74C3C','95A5A6','D35400'
    ];
var out = '';
console.info(box.length);
for (var i = 0; i < box.length; i++) {
  // Random array fonts
  var r = f[Math.floor(Math.random() * f.length)],
      // Random array colors
      sh = c[Math.floor(Math.random() * c.length)],
      st = 'color:#'+sh+
      ';font-family: '+r
  out += '<span style="'+st+'">'+box[i]+'</span>';
}
rs.innerHTML = out;



var box = document.getElementById('box1').textContent,
    rs = document.getElementById('render1'),
    f = [
        'arial','verdana','monospace',
        'consolas','impact','helveltica'
    ],
    c = [
        '1ABC9C','3498DB','34495E','E67E22',
        'E74C3C','2ECC71','E74C3C','95A5A6','D35400'
    ];
var out1 = '';
console.info(box.length);
for (var i = 0; i < box.length; i++) {
    // Random array fonts
    var r = f[Math.floor(Math.random() * f.length)],
    // Random array colors
        sh = c[Math.floor(Math.random() * c.length)],
        st = 'color:#'+sh+
            ';font-family: '+r
    out1 += '<span style="'+st+'">'+box[i]+'</span>';
}
rs.innerHTML = out1;