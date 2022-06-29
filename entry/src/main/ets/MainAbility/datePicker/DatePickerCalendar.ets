import calendarDay from './calendarDay'

enum DayState {
  NOT_SELECTABLE,
  NORMAL_DAY,
  TODAY_DAY,
  SELECTED_DAY,
  IN_RANGE_DAY
}

@Component
struct DatePickerCalendar{
  private model: DatePickerCalendar.Model = new DatePickerCalendar.Model();

  @Link selectedDay: number
  @Link selectedMonth: number
  @Link selectedYear: number
  @Link selectFrom: Date
  @Link selectBefore: Date
  @Link isSelected:boolean

  @State today: number = new Date().getDate();
  @State todayMonth: number = new Date().getMonth();
  @State todayYear: number = new Date().getFullYear();

  @Link currMonth: number
  @Link currYear: number

  @Link selectedDateString : string;

  @Link typeOfDayArray: DayState[]


  getTypeOfDay(value:number): DayState{
    return this.typeOfDayArray[value];
  }

  onButtonPress(value:number){
    if(this.isSelected){
      if(this.selectedDay==this.today && this.selectedMonth==this.todayMonth && this.selectedYear==this.todayYear){
        this.typeOfDayArray[this.selectedDay-1]=DayState.TODAY_DAY
      }
      else this.typeOfDayArray[this.selectedDay-1]=DayState.NORMAL_DAY;
      this.selectedDay=value+1;
      this.selectedMonth=this.currMonth;
      this.selectedYear=this.currYear;
      this.typeOfDayArray[value]=DayState.SELECTED_DAY
      this.selectedDateString=String(this.selectedDay).padStart(2,'0')+"/"+String(this.selectedMonth+1).padStart(2,'0')+"/"+String(this.selectedYear)
    }
    else{
      this.isSelected=true;
      this.selectedDay=value+1;
      this.selectedMonth=this.currMonth;
      this.selectedYear=this.currYear;
      this.typeOfDayArray[value]=DayState.SELECTED_DAY
      this.selectedDateString=String(this.selectedDay).padStart(2,'0')+"/"+String(this.selectedMonth+1).padStart(2,'0')+"/"+String(this.selectedYear)
    }
  }

  build(){
    Column() {
      Grid() {
        // Weekdays row
        ForEach(this.model.weekdays, (days: string) => {
          GridItem() {
            Column() {
              Text(days).fontSize(18).fontWeight(FontWeight.Bold).fontColor(Color.Gray);
            }
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsGap(5)
      .rowsGap(10)
      .height(30)
      .width('100%')
      .margin({ left: 15, right: 15 })

      Grid(){
        // Blank cells to account for the starting day of month
        ForEach(new Array(this.model.getStartDayOfMonth(this.currYear,this.currMonth)), (temp: number) => {
          GridItem() {
            Column() {
            }
          }
        })

        // Month grid
        ForEach([...Array(this.model.getDaysInMonth(this.currYear,this.currMonth)).keys()],(day:number) => {
          GridItem() {
            calendarDay({date:day,typeOfDay:this.getTypeOfDay(day),onButtonPress:(value) => this.onButtonPress(value)})
          }
        })
      }.columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsGap(5)
      .rowsGap(10)
      .height(300)
      .width('100%')
      .margin({left:15,right:15})

    }

  }
}

namespace DatePickerCalendar{
  export class Model{
    weekdays:string[] = ['S','M','T','W','T','F','S'];

    getDaysInMonth(year: number, month:number) : number{
      var dt:Date = new Date(year,month+1,1);
      return new Date(dt.getFullYear(),dt.getMonth(),0).getDate();
    }
    getStartDayOfMonth(year: number, month:number) : number{
      var temp = new Date(year,month,1);
      return temp.getDay();
    }
    selectable(selectFrom:Date, selectBefore:Date, currDate:Date): boolean{
      if(selectFrom<=currDate && currDate<=selectBefore) return true;
      else return false;
    }
  }
}

export default DatePickerCalendar;
