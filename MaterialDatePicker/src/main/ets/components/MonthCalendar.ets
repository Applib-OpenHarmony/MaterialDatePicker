import calendarDay from './calendarDay'
import {DayState,pickerType} from './values'
import {DatePickerModel} from './DatePickerModel'

@Component
struct MonthCalendar{

  @Link @Watch("isChanged") parentModel: DatePickerModel
  @State @Watch("isChanged") currMonth: number = new Date().getMonth();
  @State @Watch("isChanged") currYear: number = new Date().getFullYear();
  @State model : MonthCalendarModel = undefined


  aboutToAppear(){
    this.model = new MonthCalendarModel(this.parentModel,this.currMonth,this.currYear);
  }
  isChanged(){
    this.model.makeTypeOfDayArray();
    if(this.parentModel.picker == 1) this.model.drawRangeValues();
  }

  build(){
    Stack(){
      if (this.model.drawRange.length>0) {
        ForEach(this.model.drawRange, (rectShape, index) => {
          Shape() {
            Rect().width(rectShape.width).height(this.parentModel.cellHeight)
          }
          .fill(this.parentModel.rangeFillColor)
          .enabled(false)
          .position({ x: rectShape.x, y: rectShape.y })
        })
      }
      Column() {
        Grid() {
          ForEach(this.parentModel.weekdays, (days: string) => {
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
          ForEach(new Array(this.model.getStartDayOfMonth(this.currYear,this.currMonth)), (temp: number) => {
            GridItem() {
            }
          })
          ForEach([...Array(this.model.getDaysInMonth(this.currYear,this.currMonth)).keys()],(day:number) => {
            GridItem() {
              calendarDay({
                  parentModel: $parentModel,
                  date:day,
                  typeOfDay:this.model.getTypeOfDay(day),
                  onButtonPress:(selected_date) => this.model.onButtonPress(selected_date)
              })
            }
            .onAreaChange((oldArea, newArea) => {
              if (this.parentModel.cellWidth == 0) {
                if (typeof newArea.width == 'number')
                this.parentModel.cellWidth = newArea.width
                if (typeof newArea.height == 'number')
                this.parentModel.cellHeight = newArea.height
              }
            })
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
        .rowsGap(10)
        .height(300)
        .width('100%')
        .margin({bottom: 35})
        .onAreaChange((oldArea, newArea) => {
          if (this.parentModel.gridWidth == 0) {
            if (typeof newArea.width == 'number')
            this.parentModel.gridWidth = newArea.width
            if (typeof newArea.position.x == 'number')
            this.parentModel.gridStartX = newArea.position.x
            if (typeof newArea.position.y == 'number')
            this.parentModel.gridStartY = newArea.position.y
          }
        })
      }
    }
  }
}

class MonthCalendarModel {
  currMonth: number
  currYear: number
  typeOfDayArray: DayState[]=[]
  drawRange: {
    x: number,
    y: number,
    width: number
  }[] = []
  parentModel: DatePickerModel
  constructor(pModel: DatePickerModel, month: number, year: number) {
    this.parentModel = pModel
    this.currMonth = month
    this.currYear = year
    this.makeTypeOfDayArray();
    if(this.parentModel.picker == 1) this.drawRangeValues();
  }

  makeTypeOfDayArray(){
    this.typeOfDayArray=[]
    let n: number = this.getDaysInMonth(this.currYear,this.currMonth)
    if(this.parentModel.picker == 0){
      for(var i=0;i<n;i++){
        if(this.parentModel.isSelected && this.parentModel.selectedYear==this.currYear && this.parentModel.selectedMonth==this.currMonth && i+1==this.parentModel.selectedDay){
          this.typeOfDayArray.push(DayState.SELECTED_DAY);
        }
        else if(this.currYear==this.parentModel.todayYear && this.currMonth==this.parentModel.todayMonth && i+1==this.parentModel.todayDate){
          this.typeOfDayArray.push(DayState.TODAY_DAY);
        }
        else{
          this.typeOfDayArray.push(DayState.NORMAL_DAY);
        }
      }
    }
    else{
      for(var i=0;i<n;i++){
        if(this.parentModel.isStartSelected && this.parentModel.rangeStartYear==this.currYear && this.parentModel.rangeStartMonth==this.currMonth && i+1==this.parentModel.rangeStartDay){
          this.typeOfDayArray.push(DayState.SELECTED_DAY);
        }
        else if(this.parentModel.isEndSelected && this.parentModel.rangeEndYear==this.currYear && this.parentModel.rangeEndMonth==this.currMonth && i+1==this.parentModel.rangeEndDay){
          this.typeOfDayArray.push(DayState.SELECTED_DAY);
        }
        else if(this.parentModel.isStartSelected && this.parentModel.isEndSelected && this.isInBetween(new Date(this.currYear,this.currMonth,i+1))){
          this.typeOfDayArray.push(DayState.IN_RANGE_DAY);
        }
        else if(this.currYear==this.parentModel.todayYear && this.currMonth==this.parentModel.todayMonth && i+1==this.parentModel.todayDate){
          this.typeOfDayArray.push(DayState.TODAY_DAY);
        }
        else{
          this.typeOfDayArray.push(DayState.NORMAL_DAY);
        }
      }
    }
  }

  getDaysInMonth(year: number, month:number) : number{
    var dt:Date = new Date(year,month+1,1);
    return new Date(dt.getFullYear(),dt.getMonth(),0).getDate();
  }
  getStartDayOfMonth(year: number, month:number) : number{
    var temp = new Date(year,month,1);
    return temp.getDay();
  }
  getTypeOfDay(day:number): DayState{
    return this.typeOfDayArray[day];
  }
  isInBetween(currDate: Date):boolean{
    var startDate: Date = new Date(this.parentModel.rangeStartYear,this.parentModel.rangeStartMonth,this.parentModel.rangeStartDay)
    var endDate: Date = new Date(this.parentModel.rangeEndYear,this.parentModel.rangeEndMonth,this.parentModel.rangeEndDay)
    if(startDate<currDate && currDate<endDate) return true;
    else return false;
  }

  isAhead(currDate:Date):boolean{
    var startDate: Date = new Date(this.parentModel.rangeStartYear,this.parentModel.rangeStartMonth,this.parentModel.rangeStartDay)
    if(currDate>=startDate) return true;
    else return false;
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
    if(!this.parentModel.isStartSelected || !this.parentModel.isEndSelected) return
    let monthOffset = this.getStartDayOfMonth(this.currYear, this.currMonth)
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
    let columnGap = (this.parentModel.gridWidth - 2*this.parentModel.gridStartX - 7*this.parentModel.cellWidth)/6
    for (i = minRowSelected; i < maxRowSelected + 1; i++) {
      let x;
      let y;
      let width;
      if (minRowSelected == maxRowSelected) {
        if(minCellSelected == 0 || maxCellSelected == 6){
          x = this.parentModel.gridStartX/2
          width = 7*this.parentModel.cellWidth + 6*columnGap + this.parentModel.gridStartX
        }
        else{
          x = (minCellSelected-1)*(this.parentModel.cellWidth+columnGap) + this.parentModel.cellWidth/2 + this.parentModel.gridStartX
          width = ( maxCellSelected - minCellSelected + 2)*(this.parentModel.cellWidth + columnGap)
        }
      }
      else {
        if (i == minRowSelected) {
          if(minCellSelected==0){
            x = this.parentModel.gridStartX/2
            width = 7*this.parentModel.cellWidth + 6*columnGap + this.parentModel.gridStartX
          }
          else{
            x = (minCellSelected-1)*(this.parentModel.cellWidth+columnGap) + this.parentModel.cellWidth/2 + this.parentModel.gridStartX
            width = (7 - minCellSelected)*(this.parentModel.cellWidth+columnGap) + this.parentModel.cellWidth/2 + this.parentModel.gridStartX/2
          }
        }
        else if (i == maxRowSelected) {
          if(maxCellSelected==6){
            x = this.parentModel.gridStartX/2
            width = 7*this.parentModel.cellWidth + 6*columnGap + this.parentModel.gridStartX
          }
          else{
            x = this.parentModel.gridStartX/2
            width = (maxCellSelected+1)*(this.parentModel.cellWidth + columnGap) + this.parentModel.cellWidth/2 + this.parentModel.gridStartX/2
          }
        }
        else {
          x = this.parentModel.gridStartX/2
          width = 7*this.parentModel.cellWidth + (6*columnGap) + this.parentModel.gridStartX
        }
      }

      if(i==0){
        y=(i+1)*this.parentModel.cellHeight;
      }
      else{
        y=(i+1)*(this.parentModel.cellHeight) + i*marginBetweenRow
      }

      this.drawRange.push({ x, y, width })
    }
  }

  onButtonPress(selected_date:number){
    if(this.parentModel.picker==0){
      if(this.parentModel.isSelected){
        if(this.parentModel.selectedDay==this.parentModel.todayDate && this.parentModel.selectedMonth==this.parentModel.todayMonth && this.parentModel.selectedYear==this.parentModel.todayYear){
          this.typeOfDayArray[this.parentModel.selectedDay-1]=DayState.TODAY_DAY
        }
        else this.typeOfDayArray[this.parentModel.selectedDay-1]=DayState.NORMAL_DAY;

        this.parentModel.setSelectedDate(selected_date)
        this.typeOfDayArray[selected_date]=DayState.SELECTED_DAY
      }
      else{
        this.parentModel.setSelectedDate(selected_date)
        this.typeOfDayArray[selected_date]=DayState.SELECTED_DAY
      }
    }
    else{
      if (this.parentModel.isStartSelected && this.parentModel.isEndSelected) {
        if(this.parentModel.rangeStartMonth==this.currMonth && this.parentModel.rangeStartYear==this.currYear){
          for(var i=this.parentModel.rangeStartDay;i<this.parentModel.rangeEndDay-1;i++){
            if(this.currYear==this.parentModel.todayYear && this.currMonth==this.parentModel.todayMonth && i+1==this.parentModel.todayDate){
              this.typeOfDayArray[i]=DayState.TODAY_DAY
            }
            else{
              this.typeOfDayArray[i]=DayState.NORMAL_DAY
            }
          }
        }
        else{
          for(var i=0;i<this.parentModel.rangeEndDay-1;i++){
            if(this.currYear==this.parentModel.todayYear && this.currMonth==this.parentModel.todayMonth && i+1==this.parentModel.todayDate){
              this.typeOfDayArray[i]=DayState.TODAY_DAY
            }
            else{
              this.typeOfDayArray[i]=DayState.NORMAL_DAY
            }
          }
        }
        if(this.parentModel.rangeEndYear==this.currYear && this.parentModel.rangeEndMonth==this.currMonth) {
          if(this.parentModel.rangeEndDay==this.parentModel.todayDate && this.parentModel.rangeEndMonth==this.parentModel.todayMonth && this.parentModel.rangeEndYear==this.parentModel.todayYear){
            this.typeOfDayArray[this.parentModel.rangeEndDay-1]=DayState.TODAY_DAY
          }
          else this.typeOfDayArray[this.parentModel.rangeEndDay-1]=DayState.NORMAL_DAY;
        }
        this.parentModel.rangeEndDay = null; this.parentModel.rangeEndMonth = null; this.parentModel.rangeEndYear = null;
        this.parentModel.isEndSelected = false;
        if(this.parentModel.rangeStartYear==this.currYear && this.parentModel.rangeStartMonth==this.currMonth) {
          if(this.parentModel.rangeStartDay==this.parentModel.todayDate && this.parentModel.rangeStartMonth==this.parentModel.todayMonth && this.parentModel.rangeStartYear==this.parentModel.todayYear){
            this.typeOfDayArray[this.parentModel.rangeStartDay-1]=DayState.TODAY_DAY
          }
          else this.typeOfDayArray[this.parentModel.rangeStartDay-1]=DayState.NORMAL_DAY;
        }
        this.parentModel.setRangeStartDay(selected_date);
        this.typeOfDayArray[this.parentModel.rangeStartDay-1]=DayState.SELECTED_DAY;

        this.drawRangeValues()
      }

      else if (this.parentModel.isStartSelected && !this.parentModel.isEndSelected) {
        if (this.isAhead(new Date(this.currYear, this.currMonth, selected_date + 1))) {
          this.parentModel.setRangeEndDay(selected_date);
          this.typeOfDayArray[this.parentModel.rangeEndDay-1]=DayState.SELECTED_DAY;
          if(this.parentModel.rangeStartMonth==this.currMonth && this.parentModel.rangeStartYear==this.currYear){
            for(var i=this.parentModel.rangeStartDay;i<this.parentModel.rangeEndDay-1;i++){
              this.typeOfDayArray[i]=DayState.IN_RANGE_DAY;
            }
          }
          else{
            for(var i=0;i<this.parentModel.rangeEndDay-1;i++){
              this.typeOfDayArray[i]=DayState.IN_RANGE_DAY;
            }
          }
          this.drawRangeValues();
        }
        else {
          if(this.parentModel.rangeStartYear==this.currYear && this.parentModel.rangeStartMonth==this.currMonth) {
            if(this.parentModel.rangeStartDay==this.parentModel.todayDate && this.parentModel.rangeStartMonth==this.parentModel.todayMonth && this.parentModel.rangeStartYear==this.parentModel.todayYear){
              this.typeOfDayArray[this.parentModel.rangeStartDay-1]=DayState.TODAY_DAY
            }
            else this.typeOfDayArray[this.parentModel.rangeStartDay-1]=DayState.NORMAL_DAY;
          }
          this.parentModel.setRangeStartDay(selected_date);
          this.typeOfDayArray[this.parentModel.rangeStartDay-1]=DayState.SELECTED_DAY;

          this.drawRangeValues();
        }
      }
      else {
        this.parentModel.setRangeStartDay(selected_date);
        this.parentModel.isEndSelected = false;
        this.typeOfDayArray[this.parentModel.rangeStartDay-1]=DayState.SELECTED_DAY;

        this.drawRangeValues();
      }

      this.parentModel.clicked=!this.parentModel.clicked;
    }
  }
}


export default MonthCalendar;