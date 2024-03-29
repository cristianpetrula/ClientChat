class View
{
  Element _root;  
  DivElement _container;
  DivElement _mainOut;
  DivElement _statusBar;
  DivElement _container2;
  DivElement _participantsDiv;
  
  InputElement _input;  
  ChatClient _client;
  String _title;
  Participants _participants;
  /*
  0 - system
  */
  int _type;
  
  Map<String, String> _emoticons;
  
  View( this._root, this._type, this._client, this._title)
  {    
    _emoticons = new HashMap<String, String>();
    _emoticons[ ";;)"] = "img/5.gif";
    _emoticons[ "=))"] = "img/24.gif";
    _emoticons[ ":)"] = "img/1.gif";
    _emoticons[ ":("] = "img/2.gif";
    _emoticons[ ";)"] = "img/3.gif";
    _emoticons[ ":d"] = "img/4.gif";
    _emoticons[ ":D"] = "img/4.gif";   
    
  }
  
  void ready()
  {    
    _container = new Element.tag('div');
    _container.id = "viewcontainer";
    
    _container2 = new Element.tag('div');
    _container2.id = "container2";
    
    _mainOut = new Element.tag('div');
    _mainOut.id = "mainOut";    
    
    _participantsDiv = new Element.tag('div');
    _participantsDiv.id = "participants";
    
    _participants = new Participants( _participantsDiv);
    _participants.ready();
    
    _container2.nodes.add( _mainOut);
    _container2.nodes.add( _participantsDiv);
    
    _container.nodes.add( _container2);
    
    _statusBar = new Element.tag('div');
    _statusBar.id = "statusBar";
    _statusBar.innerHTML = "Status bar";
    _statusBar.hidden = true;
    _container.nodes.add( _statusBar);
    
    _input = new Element.tag('input');
    _input.id = "inputMsg";
    _input.type = "text";
    _input.on.keyPress.add((key) 
    {
      if (key.charCode == 13) 
      { // Enter   
       
        if ( _input.value.startsWith( "/"))
        {
          _client.processCommand( _input.value);
          _input.value = "";
        }
        else
        {
          _client.sendMessage( _title, _input.value);
          _input.value = "";
        }
      }      
    });
    _container.nodes.add( _input);
    
    _root.nodes.add( _container);
    
  }
  
  void displayMessage(message)
  {
    String messageWithEmoticons = addEmoticons( message);
    _mainOut.innerHTML = _mainOut.innerHTML + "<br/>$messageWithEmoticons";    
    _mainOut.scrollByLines( 10);
  }
  
  void setParticipants( List participants)
  {
    _participants.setParticipants( participants);
  }
  
  void addParticipant( String participant)
  {
    _participants.addParticipant( participant);
  }
  
  void removeParticipant( String participant)
  {
    _participants.removeParticipant( participant);
  }
  
  String addEmoticons( String message)
  {
    String result = message;
    Iterator<String> it = _emoticons.getKeys().iterator();
    while( it.hasNext())
    {
      String key = it.next();
      String url = _emoticons[ key];
      String a = "<img src=\"$url\"/>";
      result = result.replaceAll(key, a);
    }
    return result;
  }
}
