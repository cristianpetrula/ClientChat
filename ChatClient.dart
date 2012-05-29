#import('dart:html');
#import('dart:json');
#import('dart:core');
//#import('ui_lib/util/DateUtils.dart');

#source('view/ChatView.dart');
#source('view/View.dart');
#source("view/Participants.dart");

#resource('style.css');

class ChatClient {
  WebSocket ws;
  bool isConnected = false;
  InputElement _nickname;
  DivElement _root;
  ChatView _chatView;
  
  ChatClient() {
  }
  
 
  // Send nickname to server
  sendNick() {
    if ( isConnected == true)
    {
      var name = _nickname.value;
      ws.send(JSON.stringify({"cmd": "setnick", "args": name}));
      _nickname.value = "";             
    }
  }
  
  void focusOnTab( String title)
  {
    _chatView.focusOnTab( title);  
  }
  
  void joinDefaultChannel()
  {
    joinChannel( "YonderIasi", 1);
    joinChannel( "Yonder", 1);
    focusOnTab( "Yonder");
  }
  
  void joinChannel( String channel, int type)
  { 
    if ( !_chatView.findTab( channel))
    {
      sendJoinCommand( channel);
      _chatView.addTab( channel, type);
    }
    else
    {
      focusOnTab( channel);
    }    
  }
  
  void processCommand( String command)
  {
    command = command.substring( 1);
    List<String> parts = command.split( " ");
    var cmd = parts[0];
    if ( cmd.toLowerCase() == "join")
    {
      if ( parts.length == 2)
      {
        var channel = parts[1];
        if ( channel != null && channel.length >= 1)
        {
          joinChannel(channel, 1);
          focusOnTab( channel);
        }
      }
    }
  }
  
  void sendJoinCommand( String channel)
  {
    ws.send(JSON.stringify({"cmd": "joinchannel", "args": channel}));
  }
  // Server sets nickname
  setNick(nick)
  {
    _nickname.value = nick;
  }
  
  buildDate( milisec)
  {
    var date = new Date.fromEpoch(milisec, new TimeZone.local());
    var h = date.hours;
    var m = date.minutes;
    var s = date.seconds;
    var string = "$h:$m:$s";     
    return string;
  }
  
  cleanMessage( message)
  {
    var newMessage = message;
    newMessage = newMessage.replaceAll("\n", "");
    return newMessage;
  }
  
  sendMessage(String channel, String message)
  {    
    message = cleanMessage(message);
    if (!message.isEmpty() && message != "\n")
    {
      ws.send(JSON.stringify({"cmd": "sendmessage", "channel" : channel, "args": message}));      
    }
  }  

  void run() {
    _root = new Element.tag('div');
    document.body.nodes.add(_root);    
    _chatView = new ChatView( _root, this);
    _chatView.ready();
    
    _nickname = document.query("#nickname");
    _nickname.on.keyPress.add((key) {
      if (key.charCode == 13) { // Enter
        sendNick();        
      }  
    });
    
    ws = new WebSocket("ws://192.168.1.123:1337");   
    //ws = new WebSocket("ws://127.0.0.1:1337");   
    ws.on.open.add((a) {
      print("open $a");
      isConnected = true;
      print("You are connected.");
      //_statusBar.innerHTML = "You are connected.";
    });
    
    ws.on.close.add((c) {
      print("close $c");
      isConnected = false;    
      print("You are not connected.");
      //_statusBar.innerHTML = "You are not connected.";
    });
       
    ws.on.message.add((m) {
      var jdata = JSON.parse(m.data);
      var cmd = jdata["cmd"].toLowerCase();
      print( "Data : $jdata \n");     
      if (cmd == "newmessage")
      {
        var nickname = jdata["nickname"];
        var message = jdata["message"];
        var time = jdata["time"];
        var channel = jdata["channel"];
        var date = buildDate(time);
        if ( nickname != null)
        {
          displayMessage( channel, "($date) $nickname > $message");
        }
        else
        {
          displayMessage( channel, "($date) $message");
        }
      }
      else if ( cmd == "history")
      {
        var channel = jdata["channel"];
        var data = jdata["data"];        
        for( final x in data)
        {
          var time = x["time"];
          var author = x["author"];
          var text = x["text"];         
          var line;
          var date = buildDate(time);
          if ( author != null)
          {            
            line = "($date) $author > $text";
          }
          else
          {
            line = "($date) $text";
          }
          print( line);
          displayMessage( channel, line);
        }
      }
      else if ( cmd == "invalidnickname")
      {
          var message = jdata["message"];
          unhideNickPanel(message);
      }
      else if ( cmd == "nicknameaccepted")
      {
        hideNickPanel();
        joinDefaultChannel();
      }
      else if ( cmd == "userjoin")
      {        
        var message = jdata["message"];
        var nickname = jdata["nickname"];
        var time = jdata["time"];
        var channel = jdata["channel"];
        var date = buildDate(time);
        displayMessage( channel, "($date) $message");    
        addParticipant( channel, nickname);
      }
      else if (cmd == "userleft")
      {
        var nickname = jdata["nickname"];
        var message = jdata["message"];
        var time = jdata["time"];
        var channel = jdata["channel"];
        var date = buildDate(time);
        displayMessage( channel, "($date) $message");  
        removeParticipant( channel, nickname);       
      }
      else if ( cmd == "participants")
      {
        var channel = jdata["channel"];
        var participants = jdata["participants"];
        _chatView.setParticipants( channel, participants);
      }      
    });
  }

  void hideNickPanel()
  {    
    document.query('#mainInput').style.zIndex = '-1';
    document.query('#mainInput').style.visibility = 'hidden';
    _root.hidden = false;
    document.query('#errorDiv').innerHTML = "";
  }
  
  void unhideNickPanel( message)
  {
    document.query('#mainInput').style.zIndex = '1';
    document.query('#mainInput').style.visibility = 'visible';
    _root.hidden = true;
    if ( message != null)
    {
      document.query('#errorDiv').innerHTML = message;
    }
  }
  
  void displayMessage(String channel, String message)
  {     
    _chatView.displayMessage( channel, message);   
  }
  
  void addParticipant( String channel, String participant)
  {
    _chatView.addParticipant( channel, participant);
  }
  
  void removeParticipant( String channel, String participant)
  {
    _chatView.removeParticipant( channel, participant);
  }
}

void main() {
  new ChatClient().run();
}
