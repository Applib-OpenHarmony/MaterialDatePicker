import {DayState} from './enums'

@Component
struct calendarDay {
  @State themeColor: Color = Color.Blue
  @State backColor : Color = Color.White
  @State fontColor : Color = Color.Black
  @State boundary : number = 0
  @State date: number = 1
  @State typeOfDay: DayState = 1


  onButtonPress: (number) => void

  getBackColor(): Color{
    if(this.typeOfDay==2){
      return this.themeColor
    }
    else if(this.typeOfDay==3){
      return 0xdeccff;
    }
    else{
      return Color.White;
    }
  }

  getFontColor() : Color{
    if(this.typeOfDay==2){
      return Color.White
    }
    else{
      return Color.Black;
    }
  }

  getBorderWidth() : number{
    if(this.typeOfDay==1) return 1;
    else return 0;
  }

  getOpacity() : number{
    if(this.typeOfDay==3) return 0.2
    else return 1
  }

  build() {
    Column() {
      Button({ type: ButtonType.Circle }) {
        Text(this.date+1+ '').fontSize(16).fontColor(this.getFontColor())
      }
      .backgroundColor(this.getBackColor())
      .borderWidth(this.getBorderWidth())
      .borderRadius(100)
      .width(30)
      .height(30)
      .onClick((event: ClickEvent) => {
        this.onButtonPress(this.date);
      });
    }
  }
}

export default calendarDay;
