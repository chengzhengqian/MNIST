console.log('server started!');

var http=require('http');
var net=require('net');
var fs=require('fs');
var url=require('url');
var port=10116;
var current_result=""
function sendCmd(cmd){
    var client=new net.Socket();
    client.connect(port,'127.0.0.1',function(){
	console.log(port+"--->");
	client.write(cmd+"\n");
    });
    client.on('data',function(data){
	current_result=""+data;
	console.log(current_result);
	client.destroy();
    });
}

// sendCmd("123")
// console.log(result)
function respondResult(res){
    res.writeHeader(200,{'Content-Type':'application/json'});	
    res.write(JSON.stringify({ result: current_result }));
    res.end()
}

http.createServer(function(req,res){
    res.writeHead(200,{'Content-Type':'text/plain'});
    console.log(req.url);	// this gives request url
    var q=url.parse(req.url,true);
    // console.log(q);	// this gives request url, q.query return 
    console.log("------------");
    if(q.pathname=="/"){
	console.log("return show.html")
	fs.readFile('./template/show.html',function(err,data){
	res.writeHead(200, {'Content-Type': 'text/html','Content-Length':data.length});
        res.write(data);
        res.end();
    });}
    else if(q.pathname=="/_add_point"){
	console.log("add point");
	console.log(q.query);
	sendCmd("ADD,"+q.query.x+","+q.query.y)
	respondResult(res)
    }
    else if(q.pathname=="/_predict"){
	console.log("predict");
	console.log(q.query);
	sendCmd("PREDICT")
	respondResult(res)
    }
    else if(q.pathname=="/_clean"){
	console.log("CLEAN");
	console.log(q.query);
	sendCmd("CLEAN");
	respondResult(res);
    }
    else{
	respondResult(res);
    }
}).listen(10101);
