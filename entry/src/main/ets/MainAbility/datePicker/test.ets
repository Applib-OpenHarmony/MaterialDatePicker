import DatePickerCalendar from './DatePickerCalendar'
import DatePickerUI from './DatePickerUI'
import yearSelect from './yearSelect'

@Entry
@Component
struct test{
//  private model:DatePickerCalendar.Model = new DatePickerCalendar.Model();
//  private yearModel: yearSelect.Model = new yearSelect.Model();
  private calendarModel:DatePickerUI.Model = new DatePickerUI.Model();

  build(){
    Column(){

//      DatePickerCalendar({model:this.model})
      DatePickerUI({calendarModel:this.calendarModel})
//      yearSelect({yearModel:this.yearModel,yearStartRange:2000,yearEndRange:2030})
    }
  }
}