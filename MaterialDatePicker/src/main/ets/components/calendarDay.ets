import {DayState} from './values'
import {DatePickerModel} from './DatePickerModel'

@Component
struct calendarDay {
  @Link parentModel: DatePickerModel
  @State date: number = 1
  @State typeOfDay: DayState = 1
  onButtonPress: (number) => void


  build() {
    Column() {
      Button({ type: ButtonType.Circle }) {
        Text(this.date+1+ '').fontSize(16).fontColor(this.parentModel.getFontColor(this.typeOfDay))
      }
      .backgroundColor(this.parentModel.getBackgroundColor(this.typeOfDay))
      .borderWidth(this.parentModel.getBorderWidth(this.typeOfDay))
      .borderColor(this.parentModel.todayDateBorderColor)
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