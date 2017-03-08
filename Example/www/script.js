// Copyright © 2017 DWANGO Co., Ltd.

// FunctionChannel を作成する
var dataBus = new CBB.WebViewDataBus();
var dc = require('@cross-border-bridge/data-channel');
var dataChannel = new dc.DataChannel(dataBus);
var fc = require('@cross-border-bridge/function-channel');
var functionChannel = new fc.FunctionChannel(dataChannel);

// ネイティブ側から実行されるクラスを定義
MyClassJS = (function() {
	function MyClassJS() {
	}
	MyClassJS.prototype.foo = function(a1, a2, a3) {
		console.log("executing MyClassJS.foo(" + a1 + "," + a2 + "," + a3 + ")");
		return a1 + a2 + a3;
	}
	return MyClassJS;
})();

// ネイティブ側からの受け口を作成
functionChannel.bind("MyClassJS", new MyClassJS());

// 正常系: ネイティブ側のメソッド MyClassObjc.foo を実行（同期）
function OnButtonClick() {
	console.log("invoking MyClassObjc.foo()");
	functionChannel.invoke("MyClassObjc", "foo", ["arg1", "arg2", "arg3"], function(error, result) {
		var text = "result: " + result + "\nerror: " + error;
		console.log(text);
		alert(text);
	});
}

// 正常系: ネイティブ側のメソッド MyClassObjc.fooAを実行（非同期）
function OnButtonClickA() {
	console.log("invoking MyClassObjc.fooA()");
	functionChannel.invoke("MyClassObjc", "fooA", ["arg1", "arg2", "arg3"], function(error, result) {
		var text = "result: " + result + "\nerror: " + error;
		console.log(text);
		alert(text);
	});
}

// 異常系: ネイティブ側に未登録のオブジェクトのメソッドを実行
function OnButtonClickE1() {
	console.log("invoking MyClassObjcX.foo()");
	functionChannel.invoke("MyClassObjcX", "foo", ["arg1", "arg2", "arg3"], function(error, result) {
		var text = "result: " + result + "\nerror: " + error;
		console.log(text);
		alert(text);
	});
}

// 異常系: ネイティブ側のオブジェクトに存在しないメソッドを実行
function OnButtonClickE2() {
	console.log("invoking MyClassObjc.fooX()");
	functionChannel.invoke("MyClassObjc", "fooX", ["arg1", "arg2", "arg3"], function(error, result) {
		var text = "result: " + result + "\nerror: " + error;
		console.log(text);
		alert(text);
	});
}

// 正常系: 破棄
function OnButtonClickD() {
    console.log("destroy");
    functionChannel.destroy();
    dataChannel.destroy();
    dataBus.destroy();
}
