import calendarItemStyle from './calendarItemStyle'


@Component
struct DatePickerCalendar{
  private model: DatePickerCalendar.Model = new DatePickerCalendar.Model();

  @State selectedDay: number = new Date().getDate();
  @State selectedMonth: number = new Date().getMonth();
  @State selectedYear: number = new Date().getFullYear();

  @State today: number = new Date().getDate();
  @State todayMonth: number = new Date().getMonth();
  @State todayYear: number = new Date().getFullYear();

  @State currMonth: number = new Date().getMonth();
  @State currYear: number = new Date().getFullYear();

  @Link selectedDateString : string;

  build(){
    Column() {
      Grid() {
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
        ForEach(new Array(this.model.getStartDayOfMonth(this.currYear,this.currMonth)), (temp: number) => {
          GridItem() {
            Column() {
            }
          }
        })
        ForEach([...Array(this.model.getDaysInMonth(this.currYear,this.currMonth)).keys()],(day:number) => {
          GridItem() {
            Column(){
              if((day+1)==this.selectedDay && this.currMonth==this.selectedMonth && this.currYear==this.selectedYear){
                Button({type:ButtonType.Circle}){
                  Text(day+1+'').fontSize(16).fontColor(Color.White)
                }
                .backgroundColor(Color.Blue)
                .width(30)
                .height(30)
                .onClick((event:ClickEvent)=>{

                });
              }
              else if((day+1)==this.today && this.currMonth==this.todayMonth && this.currYear==this.todayYear){
                Button({type:ButtonType.Circle}){
                  Text(day+1+'').fontSize(16).fontColor(Color.Black)
                }
                .backgroundColor(Color.White)
                .borderWidth(2)
                .borderRadius(100)
                .width(30)
                .height(30)
                .onClick((event:ClickEvent)=>{
                  this.selectedYear=this.todayYear;
                  this.selectedMonth=this.todayMonth;
                  this.selectedDay=this.today;
                  this.model.selectedDate= new Date(this.selectedYear,this.selectedMonth,this.selectedDay);
                  this.selectedDateString=this.model.selectedDate.toDateString();
                });
              }
              else{
                Button({type:ButtonType.Circle}){
                  Text(day+1+'').fontSize(16).fontColor(Color.Black)
                }
                .backgroundColor(Color.White)
                .width(30)
                .height(30)
                .onClick((event:ClickEvent)=>{
                  this.selectedYear=this.currYear;
                  this.selectedMonth=this.currMonth;
                  this.selectedDay=day+1;
                  this.model.selectedDate= new Date(this.selectedYear,this.selectedMonth,this.selectedDay);
                  this.selectedDateString=this.model.selectedDate.toDateString();
                });
              }
            }
          }
        })
      }.columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsGap(5)
      .rowsGap(10)
      .height(250)
      .width('100%')
      .margin({left:15,right:15})

    }

  }
}

namespace DatePickerCalendar{
  export class Model{
    selectedDate: Date = new Date();

    daysInMonth : number = 30
    startDayOfMonth : number = 1
    weekdays:string[] = ['S','M','T','W','T','F','S'];

    getDaysInMonth(year: number, month:number) : number{
      var dt:Date = new Date(year,month+1,1);
      this.daysInMonth = new Date(dt.getFullYear(),dt.getMonth(),0).getDate();
      return this.daysInMonth;
    }
    getStartDayOfMonth(year: number, month:number) : number{
      var temp = new Date(year,month,1);
      this.startDayOfMonth=temp.getDay();
      return this.startDayOfMonth;
    }
  }
}

export default DatePickerCalendar;