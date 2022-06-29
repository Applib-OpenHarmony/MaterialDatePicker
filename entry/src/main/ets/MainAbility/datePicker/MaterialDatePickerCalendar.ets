import calendarDay from './calendarDay'

enum DayState {
  NOT_SELECTABLE,
  NORMAL_DAY,
  TODAY_DAY,
  SELECTED_DAY,
  IN_RANGE_DAY
}

@Component
struct MaterialDatePickerCalendar{
  private model:MaterialDatePickerCalendar.Model = new MaterialDatePickerCalendar.Model()

  // Common link & state variables
  @Link isRangePicker: boolean
  @Link selectFrom: Date
  @Link selectBefore: Date
  @Link currMonth: number
  @Link currYear: number
  @Link typeOfDayArray: DayState[]
  @State today: number = new Date().getDate();
  @State todayMonth: number = new Date().getMonth();
  @State todayYear: number = new Date().getFullYear();


  // Single-Date Picker link & state variables
  @Link selectedDay: number
  @Link selectedMonth: number
  @Link selectedYear: number
  @Link isSelected:boolean
  @Link selectedDateString : string;

  // Range Picker link & state variables
  @Link startDay: number
  @Link startMonth: number
  @Link startYear: number
  @Link endDay: number
  @Link endMonth: number
  @Link endYear: number
  @Link isStartSelected:boolean
  @Link isEndSelected:boolean

  // Common methods
  getTypeOfDay(value:number): DayState{
    return this.typeOfDayArray[value];
  }

  // Single-Date Picker methods
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

  // Range-Picker methods
  isInBetween(currDate: Date):boolean{
    var startDate: Date = new Date(this.startYear,this.startMonth,this.startDay)
    var endDate: Date = new Date(this.endYear,this.endMonth,this.endDay)
    if(startDate<currDate && currDate<endDate) return true;
    else return false;
  }
  isAhead(currDate:Date):boolean{
    var startDate: Date = new Date(this.startYear,this.startMonth,this.startDay)
    if(currDate>=startDate) return true;
    else return false;
  }
  onRangeButtonPress(value:number){
    if (this.isStartSelected && this.isEndSelected) {
      if(this.startMonth==this.currMonth && this.startYear==this.currYear){
        for(var i=this.startDay;i<this.endDay-1;i++){
          if(this.currYear==this.todayYear && this.currMonth==this.todayMonth && i+1==this.today){
            this.typeOfDayArray[i]=DayState.TODAY_DAY
          }
          else{
            this.typeOfDayArray[i]=DayState.NORMAL_DAY
          }
        }
      }
      else{
        for(var i=0;i<this.endDay-1;i++){
          if(this.currYear==this.todayYear && this.currMonth==this.todayMonth && i+1==this.today){
            this.typeOfDayArray[i]=DayState.TODAY_DAY
          }
          else{
            this.typeOfDayArray[i]=DayState.NORMAL_DAY
          }
        }
      }
      if(this.endYear==this.currYear && this.endMonth==this.currMonth) {
        if(this.endDay==this.today && this.endMonth==this.todayMonth && this.endYear==this.todayYear){
          this.typeOfDayArray[this.endDay-1]=DayState.TODAY_DAY
        }
        else this.typeOfDayArray[this.endDay-1]=DayState.NORMAL_DAY;
      }
      this.endDay = null; this.endMonth = null; this.endYear = null;
      this.isEndSelected = false;
      if(this.startYear==this.currYear && this.startMonth==this.currMonth) {
        if(this.startDay==this.today && this.startMonth==this.todayMonth && this.startYear==this.todayYear){
          this.typeOfDayArray[this.startDay-1]=DayState.TODAY_DAY
        }
        else this.typeOfDayArray[this.startDay-1]=DayState.NORMAL_DAY;
      }
      this.startDay = value + 1;
      this.startMonth = this.currMonth;
      this.startYear = this.currYear;
      this.isStartSelected = true;
      this.typeOfDayArray[this.startDay-1]=DayState.SELECTED_DAY;
    }

    else if (this.isStartSelected && !this.isEndSelected) {
      if (this.isAhead(new Date(this.currYear, this.currMonth, value + 1))) {
        this.endDay = value + 1;
        this.endMonth = this.currMonth;
        this.endYear = this.currYear;
        this.isEndSelected = true;
        this.typeOfDayArray[this.endDay-1]=DayState.SELECTED_DAY;
        if(this.startMonth==this.currMonth && this.startYear==this.currYear){
          for(var i=this.startDay;i<this.endDay-1;i++){
            this.typeOfDayArray[i]=DayState.IN_RANGE_DAY;
          }
        }
        else{
          for(var i=0;i<this.endDay-1;i++){
            this.typeOfDayArray[i]=DayState.IN_RANGE_DAY;
          }
        }
      }
      else {
        if(this.startYear==this.currYear && this.startMonth==this.currMonth) {
          if(this.startDay==this.today && this.startMonth==this.todayMonth && this.startYear==this.todayYear){
            this.typeOfDayArray[this.startDay-1]=DayState.TODAY_DAY
          }
          else this.typeOfDayArray[this.startDay-1]=DayState.NORMAL_DAY;
        }
        this.startDay = value + 1;
        this.startMonth = this.currMonth;
        this.startYear = this.currYear;
        this.isStartSelected = true;
        this.isEndSelected = false;
        this.typeOfDayArray[this.startDay-1]=DayState.SELECTED_DAY;
      }
    }
    else {
      this.startDay = value + 1;
      this.startMonth = this.currMonth;
      this.startYear = this.currYear;
      this.isStartSelected = true;
      this.isEndSelected = false;
      this.typeOfDayArray[this.startDay-1]=DayState.SELECTED_DAY;
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
            // Single-Date Picker
            if(!this.isRangePicker){
              calendarDay({date:day,typeOfDay:this.getTypeOfDay(day),onButtonPress:(value) => this.onButtonPress(value)})
            }
            // Range-Picker
            else{
              calendarDay({date:day,typeOfDay:this.getTypeOfDay(day),onButtonPress:(value) => this.onRangeButtonPress(value)})
            }

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

namespace MaterialDatePickerCalendar{
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

export default MaterialDatePickerCalendar;