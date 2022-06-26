@Component
struct rangePickerCalendar{
  private model: rangePickerCalendar.Model = new rangePickerCalendar.Model();

  @State currYear:number = new Date().getFullYear();
  @State currMonth:number = new Date().getMonth();

  @Link startDay: number
  @Link startMonth: number
  @Link startYear: number

  @Link endDay: number
  @Link endMonth: number
  @Link endYear: number

  @State today: number = new Date().getDate();
  @State todayMonth: number = new Date().getMonth();
  @State todayYear: number = new Date().getFullYear();

  @Link isStartSelected:boolean
  @Link isEndSelected:boolean

  months:string[] = ['January','February','March','April','May','June','July','August','September','October','November','December']

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


      Grid() {
        // Blank cells to account for the starting day of month
        ForEach(new Array(this.model.getStartDayOfMonth(this.currYear, this.currMonth)), (temp: number) => {
          GridItem() {
            Column() {
            }
          }
        })

        ForEach([...Array(this.model.getDaysInMonth(this.currYear, this.currMonth)).keys()], (day: number) => {
          // cases
          if ((this.isStartSelected && this.startYear == this.currYear && this.startMonth == this.currMonth && this.startDay == day + 1)) {
            GridItem() {
              Column() {
                Button({ type: ButtonType.Circle }) {
                  Text(day + 1 + '').fontSize(16).fontColor(Color.White)
                }
                .backgroundColor(Color.Blue)
                .width(30)
                .height(30)
                .onClick((event: ClickEvent) => {
                  // if end date is not selected, then make enddate==startdate
                  if (!this.isEndSelected) {
                    this.endDay = day + 1;
                    this.endMonth = this.currMonth;
                    this.endYear = this.currYear;
                    this.isEndSelected = true;

                  }

                  // if an end date is selected and a range is selected, then re-intialise it by making enddate==null
                  else {
                    this.endDay = null
                    this.endMonth = null;
                    this.endYear = null;
                    this.startDay = day + 1;
                    this.startMonth = this.currMonth;
                    this.startYear = this.currYear;
                    this.isStartSelected = true;
                    this.isEndSelected = false;
                  }
                });
              }
            }
          }

          else if ((this.isEndSelected && this.endYear == this.currYear && this.endMonth == this.currMonth && this.endDay == day + 1)) {
            GridItem() {
              Column() {
                Button({ type: ButtonType.Circle }) {
                  Text(day + 1 + '').fontSize(16).fontColor(Color.White)
                }
                .backgroundColor(Color.Blue)
                .width(30)
                .height(30)
                .onClick((event: ClickEvent) => {
                  // re-initialize start date and make end date null
                  this.endDay = null
                  this.endMonth = null;
                  this.endYear = null;
                  this.startDay = day + 1;
                  this.startMonth = this.currMonth;
                  this.startYear = this.currYear;
                  this.isStartSelected = true;
                  this.isEndSelected = false;
                });
              }
            }
          }

          else if (this.isStartSelected && this.isEndSelected && this.isInBetween(new Date(this.currYear, this.currMonth, day + 1))) {
            GridItem() {
              Column() {
                Button({ type: ButtonType.Circle }) {
                  Text(day + 1 + '').fontSize(16).fontColor(Color.Black)
                }
                .backgroundColor(Color.White)
                .width(30)
                .height(30)
                .onClick((event: ClickEvent) => {
                  // re-initialize start date and make end date null
                  this.endDay = null
                  this.endMonth = null;
                  this.endYear = null;
                  this.startDay = day + 1;
                  this.startMonth = this.currMonth;
                  this.startYear = this.currYear;
                  this.isStartSelected = true;
                  this.isEndSelected = false;
                });
              }
            }.backgroundColor(Color.Blue - 2)
          }

          else if (this.todayYear == this.currYear && this.todayMonth == this.currMonth && this.today == day + 1) {
            GridItem() {
              Column() {
                Button({ type: ButtonType.Circle }) {
                  Text(day + 1 + '').fontSize(16).fontColor(Color.Black)
                }
                .backgroundColor(Color.White)
                .borderWidth(1)
                .borderRadius(100)
                .width(30)
                .height(30)
                .onClick((event: ClickEvent) => {
                  // same as else
                  if (this.isStartSelected && this.isEndSelected) {
                    this.endDay = null
                    this.endMonth = null;
                    this.endYear = null;
                    this.startDay = day + 1;
                    this.startMonth = this.currMonth;
                    this.startYear = this.currYear;
                    this.isStartSelected = true;
                    this.isEndSelected = false;
                  }
                  else if (this.isStartSelected && !this.isEndSelected) {
                    if (this.isAhead(new Date(this.currYear, this.currMonth, day + 1))) {
                      this.endDay = day + 1;
                      this.endMonth = this.currMonth;
                      this.endYear = this.currYear;
                      this.isEndSelected = true;
                    }
                    else {
                      this.startDay = day + 1;
                      this.startMonth = this.currMonth;
                      this.startYear = this.currYear;
                      this.isStartSelected = true;
                      this.isEndSelected = false;
                    }
                  }
                  else {
                    this.startDay = day + 1;
                    this.startMonth = this.currMonth;
                    this.startYear = this.currYear;
                    this.isStartSelected = true;
                    this.isEndSelected = false;
                  }
                });

              }
            }
          }

          else {
            GridItem() {
              Column() {
                Button({ type: ButtonType.Circle }) {
                  Text(day + 1 + '').fontSize(16).fontColor(Color.Black)
                }
                .backgroundColor(Color.White)
                .width(30)
                .height(30)
                .onClick((event: ClickEvent) => {
                  if (this.isStartSelected && this.isEndSelected) {
                    this.endDay = null
                    this.endMonth = null;
                    this.endYear = null;
                    this.startDay = day + 1;
                    this.startMonth = this.currMonth;
                    this.startYear = this.currYear;
                    this.isStartSelected = true;
                    this.isEndSelected = false;

                  }
                  else if (this.isStartSelected && !this.isEndSelected) {
                    if (this.isAhead(new Date(this.currYear, this.currMonth, day + 1))) {
                      this.endDay = day + 1;
                      this.endMonth = this.currMonth;
                      this.endYear = this.currYear;
                      this.isEndSelected = true;

                    }
                    else {
                      this.startDay = day + 1;
                      this.startMonth = this.currMonth;
                      this.startYear = this.currYear;
                      this.isStartSelected = true;
                      this.isEndSelected = false;
                    }
                  }
                  else {
                    this.startDay = day + 1;
                    this.startMonth = this.currMonth;
                    this.startYear = this.currYear;
                    this.isStartSelected = true;
                    this.isEndSelected = false;
                  }
                });
              }
            }
          }


        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsGap(5)
      .rowsGap(10)
      .height(300)
      .width('100%')
      .margin({ left: 15, right: 15, bottom: 35 })

    }
  }
}

namespace rangePickerCalendar{
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
    getYearsArray(startYear:number , endYear:number):number[]{
      var arr:number[] = new Array();
      for(var i=startYear;i<=endYear;i++) arr.push(i);
      return arr;
    }
  }
}

export default rangePickerCalendar;