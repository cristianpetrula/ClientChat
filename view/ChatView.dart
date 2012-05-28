class ChatView
{
  Element _root;
  DivElement _mainDiv;
  DivElement _container;
  DivElement _containerTabs;
  DivElement _containerPanels;
  
  Map<String, Element> _tabs;
  Map<String, Element> _panels;
  Map<String, View> _views;
  ChatClient _client;
  
  ChatView( this._root, this._client)
  {
    _tabs = new HashMap<String, DivElement>();
    _panels = new HashMap<String, DivElement>();
    _views = new HashMap<String, View>();
  }
  
  void ready()
  {
    _mainDiv = new Element.tag('div');
    _mainDiv.id = "mainDiv";     
   
    _container = new Element.tag( 'div');
    _container.id = "container";       
      
    _containerTabs = new Element.tag( 'div');
    _containerTabs.id = "containerTabs";
    _container.nodes.add( _containerTabs);
    
    _containerPanels = new Element.tag( 'div');
    _containerPanels.id = "containerPanels";
    _container.nodes.add( _containerPanels);
    
    _mainDiv.nodes.add( _container);    
    _root.nodes.add( _mainDiv);   
  }
  
  void createPanel( String title, int type)
  {
    Element div = new Element.tag( 'div');
    div.id = "panel";
    Element key = new Element.tag( 'div');
    key.id = "key";
    key.innerHTML = title;
    key.hidden = true;    
    div.nodes.add( key);
    View view = new View( div, type, _client, title.toLowerCase());
    view.ready();
    _views[title.toLowerCase()] = view;
    _panels[title.toLowerCase()] = div;
    _containerPanels.nodes.add( div);
  }
  
  void createTab( String title)
  {
    Element div = new Element.tag('div');
    div.id = "tab";    
    div.innerHTML = title;    
    Element key = new Element.tag('div');
    key.id = "key";
    key.innerHTML = title;
    key.hidden = true;
    div.nodes.add( key);
    div.on.click.add( (event)
      { 
        DivElement e = event.target;
        Element k = e.query( "#key");
        String sk = k.innerHTML;
        focusOnTab( sk);
        //print( sk);         
      });
    _tabs[ title.toLowerCase()] = div;
    _containerTabs.nodes.add( _tabs[ title.toLowerCase()]);
  }
  
  void renderTabs()
  {
    Iterator<String> it = _tabs.getKeys().iterator();
    while ( it.hasNext())
    {
      String key = it.next();
      Element e = _tabs[ key];
      _container.nodes.add(e);     
    }    
  }  
  
  void renderPannles()
  {
    Iterator<String> it = _panels.getKeys().iterator();
    while ( it.hasNext())
    {
      String key = it.next();
      Element e = _panels[ key];
      _container.nodes.add(e);     
    }   
  }
  
  void addTab( title, type)
  {    
    createTab(title);
    createPanel(title, type);
    
  }
  
  void displayMessage(String channel, String message)
  {
    if ( channel != null && message != null)
    {
      View view = _views[channel.toLowerCase()];
      if ( view != null)
      {
        view.displayMessage( message);
      }
    }
  }
  
  bool findTab( title)
  {
    if ( title != null)
    {
      title = title.toLowerCase();
      Element e = _tabs[ title];
      if ( e != null)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
  }
  
  void focusOnTab(String title)
  {
    Iterator<String> it = _panels.getKeys().iterator();
    while ( it.hasNext())
    {
      String key = it.next();
      Element e = _panels[ key];
      if ( !e.hidden)
        e.hidden = true;           
    }   
    
    if ( title != null)
    {
      title = title.toLowerCase();
      Element e = _panels[ title];
      if ( e != null)
      {
        e.hidden = false;
        e.query( "#mainOut").scrollByLines( 1000);
      }
    }
    
    it = _tabs.getKeys().iterator();
    while ( it.hasNext())
    {
      String key = it.next();
      Element e = _tabs[ key];
      if ( e != null)
      {
        e.id = "tab";        
      }      
    }
    
    if ( title != null)
    {
      Element e = _tabs[ title];
      print( e);
      if ( e != null)
      {      
         e.id = "tabfocus";         
      }      
    }
  }  
  
}
