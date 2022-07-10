import calendarDay from './calendarDay'
import {DayState} from './enums'

@Component
struct MaterialDatePickerCalendar{
  private model: MaterialDatePickerCalendar.Model = new MaterialDatePickerCalendar.Model();

  // common link & state variables
  @Link isRangePicker: boolean
  @Link @Watch("isChanged") clicked: boolean
  @State @Watch("isChanged") currMonth: number = new Date().getMonth();
  @State @Watch("isChanged") currYear: number = new Date().getFullYear();
  @State today: number = new Date().getDate();
  @State todayMonth: number = new Date().getMonth();
  @State todayYear: number = new Date().getFullYear();
  @State themeColor:Color = Color.Blue;
  @State typeOfDayArray: DayState[]=[]


  // Single Date Picker link & state variables
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
  @Link cellHeight: number
  @Link cellWidth: number
  @Link gridWidth: number
  @Link gridStartX: number
  @Link gridStartY: number
  @State private drawRange: {
    x: number,
    y: number,
    width: number
  }[] = []

  // common methods
  aboutToAppear(){
    this.makeArray();
    if(this.isRangePicker) this.drawRangeValues();
  }
  isChanged(){
    this.makeArray();
    if(this.isRangePicker) this.drawRangeValues();
  }
  makeArray(){
    this.typeOfDayArray=[]
    let n: number = this.model.getDaysInMonth(this.currYear,this.currMonth)
    if(!this.isRangePicker){
      for(var i=0;i<n;i++){
        if(this.isSelected && this.selectedYear==this.currYear && this.selectedMonth==this.currMonth && i+1==this.selectedDay){
          this.typeOfDayArray.push(DayState.SELECTED_DAY);
        }
        else if(this.currYear==new Date().getFullYear() && this.currMonth==new Date().getMonth() && i+1==new Date().getDate()){
          this.typeOfDayArray.push(DayState.TODAY_DAY);
        }
        else{
          this.typeOfDayArray.push(DayState.NORMAL_DAY);
        }
      }
    }
    else{
      for(var i=0;i<n;i++){
        if(this.isStartSelected && this.startYear==this.currYear && this.startMonth==this.currMonth && i+1==this.startDay){
          this.typeOfDayArray.push(DayState.SELECTED_DAY);
        }
        else if(this.isEndSelected && this.endYear==this.currYear && this.endMonth==this.currMonth && i+1==this.endDay){
          this.typeOfDayArray.push(DayState.SELECTED_DAY);
        }
        else if(this.isStartSelected && this.isEndSelected && this.isInBetween(new Date(this.currYear,this.currMonth,i+1))){
          this.typeOfDayArray.push(DayState.IN_RANGE_DAY);
        }
        else if(this.currYear==new Date().getFullYear() && this.currMonth==new Date().getMonth() && i+1==new Date().getDate()){
          this.typeOfDayArray.push(DayState.TODAY_DAY);
        }
        else{
          this.typeOfDayArray.push(DayState.NORMAL_DAY);
        }
      }
    }
  }

  getTypeOfDay(value:number): DayState{
    return this.typeOfDayArray[value];
  }

  // Single Date Picker methods
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

  // Range Picker methods
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

  onButtonPress2(value:number){
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

      this.drawRangeValues()
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
        this.drawRangeValues();
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

        this.drawRangeValues();
      }
    }
    else {
      this.startDay = value + 1;
      this.startMonth = this.currMonth;
      this.startYear = this.currYear;
      this.isStartSelected = true;
      this.isEndSelected = false;
      this.typeOfDayArray[this.startDay-1]=DayState.SELECTED_DAY;

      this.drawRangeValues();
    }

    this.clicked=!this.clicked;
  }

  drawRangeValues() {
    let minRowSelected = -1
    let maxRowSelected = -1
    let minCellSelected = -1
    let maxCellSelected = -1
    let startRangeIndex = -1
    let endRangeIndex = -1
    let i = 0
    this.drawRange = []
    if(!this.isStartSelected || !this.isEndSelected) return
    let monthOffset = this.model.getStartDayOfMonth(this.currYear, this.currMonth)
    for (i; i < this.typeOfDayArray.length; i++) {
      if (this.typeOfDayArray[i] == DayState.IN_RANGE_DAY) {
        if (startRangeIndex == -1) {
          startRangeIndex = i;
        }
        else {
          endRangeIndex = i ;
        }
      }
      else if (endRangeIndex != -1) {
        break
      }
    }
    if(startRangeIndex==-1) return
    if(startRangeIndex!=-1 && endRangeIndex==-1) endRangeIndex=startRangeIndex
    if (startRangeIndex != -1) {
      minRowSelected = Math.floor((monthOffset + startRangeIndex) / 7)
      minCellSelected = (monthOffset + startRangeIndex) % 7
    }
    if (endRangeIndex != -1) {
      maxRowSelected = Math.floor((monthOffset + endRangeIndex) / 7)
      maxCellSelected = (monthOffset + endRangeIndex) % 7
    }

    let marginBetweenRow = 10
    let columnGap = (this.gridWidth - 2*this.gridStartX - 7*this.cellWidth)/6
    for (i = minRowSelected; i < maxRowSelected + 1; i++) {
      let x;
      let y;
      let width;
      if (minRowSelected == maxRowSelected) {
        if(minCellSelected == 0 || maxCellSelected == 6){
          x = this.gridStartX/2
          width = 7*this.cellWidth + 6*columnGap + this.gridStartX
        }
        else{
          x = (minCellSelected-1)*(this.cellWidth+columnGap) + this.cellWidth/2 + this.gridStartX
          width = ( maxCellSelected - minCellSelected + 2)*(this.cellWidth + columnGap)
        }
      }
      else {
        if (i == minRowSelected) {
          if(minCellSelected==0){
            x = this.gridStartX/2
            width = 7*this.cellWidth + 6*columnGap + this.gridStartX
          }
          else{
            x = (minCellSelected-1)*(this.cellWidth+columnGap) + this.cellWidth/2 + this.gridStartX
            width = (7 - minCellSelected)*(this.cellWidth+columnGap) + this.cellWidth/2 + this.gridStartX/2
          }
        }
        else if (i == maxRowSelected) {
          if(maxCellSelected==6){
            x = this.gridStartX/2
            width = 7*this.cellWidth + 6*columnGap + this.gridStartX
          }
          else{
            x = this.gridStartX/2
            width = (maxCellSelected+1)*(this.cellWidth + columnGap) + this.cellWidth/2 + this.gridStartX/2
          }
        }
        else {
          x = this.gridStartX/2
          width = 7*this.cellWidth + (6*columnGap) + this.gridStartX
        }
      }

      if(i==0){
        y=(i+1)*this.cellHeight;
      }
      else{
        y=(i+1)*(this.cellHeight) + i*marginBetweenRow
      }

      this.drawRange.push({ x, y, width })
    }
  }

  build(){
    Stack(){
      if (this.drawRange.length>0) {
        ForEach(this.drawRange, (rectShape, index) => {
          Shape() {
            Rect().width(rectShape.width).height(this.cellHeight)
          }
          .fill(this.themeColor)
          .enabled(false)
          .opacity(.2)
          .position({ x: rectShape.x, y: rectShape.y })
        })
      }
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
        .height(30)
        .width('100%')

        Grid(){
          // Blank cells to account for the starting day of month
          ForEach(new Array(this.model.getStartDayOfMonth(this.currYear,this.currMonth)), (temp: number) => {
            GridItem() {
            }
          })

          // Month grid
          ForEach([...Array(this.model.getDaysInMonth(this.currYear,this.currMonth)).keys()],(day:number) => {
            GridItem() {
              if(!this.isRangePicker){
                calendarDay({date:day,typeOfDay:this.getTypeOfDay(day),onButtonPress:(value) => this.onButtonPress(value),themeColor:this.themeColor+0})
              }
              else{
                calendarDay({date:day,typeOfDay:this.getTypeOfDay(day),onButtonPress:(value) => this.onButtonPress2(value),themeColor:this.themeColor+0})
              }
            }
            .onAreaChange((oldArea, newArea) => {
              if (this.cellWidth == 0) {
                if (typeof newArea.width == 'number')
                this.cellWidth = newArea.width
                if (typeof newArea.height == 'number')
                this.cellHeight = newArea.height
              }
            })
          })
        }.columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
        .rowsGap(10)
        .height(300)
        .width('100%')
        .margin({bottom: 35})
        .onAreaChange((oldArea, newArea) => {
          if (this.gridWidth == 0) {
            if (typeof newArea.width == 'number')
            this.gridWidth = newArea.width
            if (typeof newArea.position.x == 'number')
            this.gridStartX = newArea.position.x
            if (typeof newArea.position.y == 'number')
            this.gridStartY = newArea.position.y
          }
        })
      }
    }
  }
}

namespace MaterialDatePickerCalendar{
  export class Model{
    weekdays:string[] = ['S','M','T','W','T','F','S'];
    selectedDay: number
    selectedMonth: number
    selectedYear: number
    isSelected: boolean

    // common methods
    getDaysInMonth(year: number, month:number) : number{
      var dt:Date = new Date(year,month+1,1);
      return new Date(dt.getFullYear(),dt.getMonth(),0).getDate();
    }
    getStartDayOfMonth(year: number, month:number) : number{
      var temp = new Date(year,month,1);
      return temp.getDay();
    }
    makeArray(currMonth:number, currYear:number): DayState[]{
      var arr: DayState[] = new Array(this.getDaysInMonth(currYear,currMonth))
      for(var i=0;i<arr.length;i++){
        if(this.isSelected && this.selectedYear==currYear && this.selectedMonth==currMonth && i+1==this.selectedDay){
          arr[i]=DayState.SELECTED_DAY;
        }
        else if(currYear==new Date().getFullYear() && currMonth==new Date().getMonth() && i+1==new Date().getDate()){
          arr[i]=DayState.TODAY_DAY;
        }
        else{
          arr[i]=DayState.NORMAL_DAY;
        }
      }
      return arr;
    }

  }
}

export default MaterialDatePickerCalendar;
