@Component
struct DatePickerCalendar{
  private model: DatePickerCalendar.Model = new DatePickerCalendar.Model();

  @Link selectedDay: number
  @Link selectedMonth: number
  @Link selectedYear: number

  @State today: number = new Date().getDate();
  @State todayMonth: number = new Date().getMonth();
  @State todayYear: number = new Date().getFullYear();

  @State currMonth: number = new Date().getMonth();
  @State currYear: number = new Date().getFullYear();

  @Link selectedDateString : string;

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
            Column(){
              // If the date is the selected date: Highlight it
              if((day+1)==this.selectedDay && this.currMonth==this.selectedMonth && this.currYear==this.selectedYear){
                Button({type:ButtonType.Circle}){
                  Text(day+1+'').fontSize(16).fontColor(Color.White)
                }
                .backgroundColor(Color.Blue)
                .width(30)
                .height(30)
                .onClick((event:ClickEvent)=>{
                  this.selectedDateString=String(this.selectedDay).padStart(2,'0')+"-"+String(this.selectedMonth+1).padStart(2,'0')+"-"+String(this.selectedYear)

                });
              }

              // If the date is today's date: Encircle it
              else if((day+1)==this.today && this.currMonth==this.todayMonth && this.currYear==this.todayYear){
                Button({type:ButtonType.Circle}){
                  Text(day+1+'').fontSize(16).fontColor(Color.Black)
                }
                .backgroundColor(Color.White)
                .borderWidth(1)
                .borderRadius(100)
                .width(30)
                .height(30)
                .onClick((event:ClickEvent)=>{
                  this.selectedYear=this.todayYear;
                  this.selectedMonth=this.todayMonth;
                  this.selectedDay=this.today;
                  this.selectedDateString=String(this.selectedDay).padStart(2,'0')+"-"+String(this.selectedMonth+1).padStart(2,'0')+"-"+String(this.selectedYear)

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
                  this.selectedDateString=String(this.selectedDay).padStart(2,'0')+"-"+String(this.selectedMonth+1).padStart(2,'0')+"-"+String(this.selectedYear)

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
    weekdays:string[] = ['S','M','T','W','T','F','S'];

    getDaysInMonth(year: number, month:number) : number{
      var dt:Date = new Date(year,month+1,1);
      return new Date(dt.getFullYear(),dt.getMonth(),0).getDate();
    }
    getStartDayOfMonth(year: number, month:number) : number{
      var temp = new Date(year,month,1);
      return temp.getDay();
    }
  }
}

export default DatePickerCalendar;
