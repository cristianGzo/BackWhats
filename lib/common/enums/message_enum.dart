enum MessageEnum{
  text('text'),
  image('image'), 
  audio('audio'), 
  video('video'), 
  gift('gif');

  const MessageEnum(this.type);
  final String type;
}


extension ConvertMessage on String{
  MessageEnum toEnum(){
    switch(this){
      case 'audio':
        return MessageEnum.audio;
      case 'image':
        return MessageEnum.image;
      case 'text' :
        return MessageEnum.text;
      case 'gift':
        return MessageEnum.gift;
      case 'video':
        return MessageEnum.video;
      default:
        return MessageEnum.text;
    }
  }
}