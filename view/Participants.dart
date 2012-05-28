class Participants 
{
  DivElement _root;
  Map<String, DivElement> _participantsList;
  
  Participants( this._root)
  {
    _participantsList = new HashMap<String, DivElement>();
  }
  
  void ready()
  {    
  }
  
  void setParticipants( List participants)
  {
    if ( participants != null)
    {
      Iterator it = participants.iterator();
      while ( it.hasNext())
      {
        var p = it.next();
        var nickName = p["nickname"];
        DivElement pdiv = new Element.tag( 'div');
        pdiv.id = "participant";
        pdiv.innerHTML = nickName.toString();        
        _participantsList[ nickName.toString()] = pdiv;
      }
      displayParticipants();
    }
  }
  
  void addParticipant( String participant)
  {
    DivElement div = _participantsList[ participant];
    if ( div == null)
    {
      div = new Element.tag( 'div');
      div.id = "participant";
      div.innerHTML = participant.toString();
      _root.nodes.add( div);
      _participantsList[ participant.toString()] = div;
    }
  }
  
  void removeParticipant( String participant)
  {
    DivElement div = _participantsList[ participant];
    if ( div != null)
    {
      _participantsList.remove( participant);    
      _root.nodes.clear();
      displayParticipants();
    }
  }
  
  void displayParticipants()
  {
    Iterator it = _participantsList.getKeys().iterator();
    while( it.hasNext())
    {
      var key = it.next();
      _root.nodes.add( _participantsList[key]);
    }
  }
}
