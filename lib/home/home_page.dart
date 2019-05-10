import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

var httpClient = new HttpClient();

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('首页'),
            actions: <Widget>[new Container()],
          ),
          body: new MyHomePage()
          // body: new Center(
          //   child: new Text('首页'),
          // ),
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _ipAddress = 'Unknown';
  var _data = {};

  _getIPAddress() async {
    var url = 'https://httpbin.org/ip';
    var httpClient = new HttpClient();

    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        print(data);
        // result = data;
        result = data['origin'];
        print(result);
      } else {
        result =
            'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed getting IP address';
    }

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _ipAddress = result;
    });
  }

  _getWeather() async {
    // var url = 'https://httpbin.org/ip';
    // var url = 'https://www.sojson.com/open/api/weather/json.shtml?city=%E6%88%90%E9%83%BD';
    // var url = 'https://www.tianqiapi.com/api/?version=v1&city=成都';
    var url = 'http://t.weather.sojson.com/api/weather/city/101270101';
    var httpClient = new HttpClient();

    Map result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        print(data);
        // result =jsonEncode(data) ;
        result = data;
        print(result);
      } else {
        // result =
        //     'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      // result = 'Failed getting IP address';
    }

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _data = result;
    });
  }
  // class Card extends StatefulWidget{
  //   final _itemData={}
  // }
  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
      body: new Center(
        child: new ListView(
          children: <Widget>[
            // new Text('Your current IP address is:'),
            // new Text('$_ipAddress.'),
            new RaisedButton(
              onPressed: _getIPAddress,
              child: new Text('获取IP地址'),
            ),
            new RaisedButton(
              onPressed: _getWeather,
              child: new Text('获取天气数据'),
            ),
            new Text(
              '城市：${_data['cityInfo']['city'] ?? ''}',
              style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20.0,
              ),
            ),
            new Text('更新时间：${_data['time'] ?? ''}'),
            new Card()
            // spacer,
          ],
        ),
      ),
    );
  }
}
