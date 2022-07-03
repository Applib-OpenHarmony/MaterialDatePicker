import MaterialDatePickerCalendar from './MaterialDatePickerCalendar'
import yearSelect from './yearSelect'
import textDialog from './textDialog'

enum DayState {
  NOT_SELECTABLE,
  NORMAL_DAY,
  TODAY_DAY,
  SELECTED_DAY,
  IN_RANGE_DAY
}

@Component
struct MaterialDatePicker{

  private model:MaterialDatePickerCalendar.Model = new MaterialDatePickerCalendar.Model();
  private yearModel: yearSelect.Model = new yearSelect.Model();

  private swiperController: SwiperController = new SwiperController ()

  // common link & state variables
  @State isRangePicker: boolean = false;
  @State currYear:number = new Date().getFullYear();
  @State currMonth:number = new Date().getMonth();
  @State showYearList: boolean = false;
  @State yearStartRange:number = 2000
  @State yearEndRange:number = 2100
  @State selectFrom: Date = new Date(this.yearStartRange,0,1);
  @State selectBefore: Date = new Date(this.yearEndRange,11,31);
  weekdays:string[] = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
  months:string[] = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
  @State typeOfDayArray: DayState[]=new Array();

  @State prevIdx: number = this.currMonth

  // Single Date Picker link & state variables
  @State selectedDay: number = new Date().getDate();
  @State selectedMonth: number = new Date().getMonth();
  @State selectedYear: number = new Date().getFullYear();
  @State showSelected: string = String(new Date().getDate()).padStart(2,'0')+"-"+String(new Date().getMonth() + 1).padStart(2,'0')+"-"+String(new Date().getFullYear())
  @State isSelected:boolean =false

  // Range Picker link & state variables
  @State startDay: number = new Date().getDate();
  @State startMonth: number = new Date().getMonth();
  @State startYear: number = new Date().getFullYear();
  @State endDay: number = new Date().getDate();
  @State endMonth: number = new Date().getMonth();
  @State endYear: number = new Date().getFullYear();
  @State isStartSelected:boolean = false;
  @State isEndSelected:boolean = false;

  // Single Date Picker methods
  makeArray(): DayState[]{
    var arr: DayState[] = new Array(this.model.getDaysInMonth(this.currYear,this.currMonth))
    for(var i=0;i<arr.length;i++){
      if(this.isSelected && this.selectedYear==this.currYear && this.selectedMonth==this.currMonth && i+1==this.selectedDay){
        arr[i]=DayState.SELECTED_DAY;
      }
      else if(this.currYear==new Date().getFullYear() && this.currMonth==new Date().getMonth() && i+1==new Date().getDate()){
        arr[i]=DayState.TODAY_DAY;
      }
      else{
        arr[i]=DayState.NORMAL_DAY;
      }
    }
    return arr;
  }

  // Range Picker methods
  isInBetween(currDate: Date):boolean{
    var startDate: Date = new Date(this.startYear,this.startMonth,this.startDay)
    var endDate: Date = new Date(this.endYear,this.endMonth,this.endDay)
    if(startDate<currDate && currDate<endDate) return true;
    else return false;
  }
  makeArray2(): DayState[]{
    var arr: DayState[] = new Array(this.model.getDaysInMonth(this.currYear,this.currMonth))
    for(var i=0;i<arr.length;i++){
      if(this.isStartSelected && this.startYear==this.currYear && this.startMonth==this.currMonth && i+1==this.startDay){
        arr[i]=DayState.SELECTED_DAY;
      }
      else if(this.isEndSelected && this.endYear==this.currYear && this.endMonth==this.currMonth && i+1==this.endDay){
        arr[i]=DayState.SELECTED_DAY;
      }
      else if(this.isStartSelected && this.isEndSelected && this.isInBetween(new Date(this.currYear,this.currMonth,i+1))){
        arr[i]=DayState.IN_RANGE_DAY;
      }
      else if(this.currYear==new Date().getFullYear() && this.currMonth==new Date().getMonth() && i+1==new Date().getDate()){
        arr[i]=DayState.TODAY_DAY;
      }
      else{
        arr[i]=DayState.NORMAL_DAY;
      }
    }
    return arr;
  }

  // common methods
  aboutToAppear(){
    this.typeOfDayArray=(!this.isRangePicker)?this.makeArray():this.makeArray2();
  }

  getSelectedText(): string{
    if(!this.isRangePicker){
      if(this.isSelected){
        let temp: string = this.months[this.selectedMonth]+" "+String(this.selectedDay).padStart(2,'0')+", "+this.selectedYear;
        return temp;
      }
      else return "Selected Date"
    }
    else{
      if(!this.isStartSelected && !this.isEndSelected){
        return "Start date - End date"
      }
      else if(this.isStartSelected && !this.isEndSelected){
        if(this.startYear==new Date().getFullYear()){
          let temp : string = this.months[this.startMonth]+" "+String(this.startDay).padStart(2,'0');
          return temp+" - End date";
        }
        else{
          let temp : string = this.months[this.startMonth]+" "+String(this.startDay).padStart(2,'0')+", "+this.startYear;
          return temp+" - End date";
        }
      }
      else{
        if(this.startYear==this.endYear && this.endYear==new Date().getFullYear()){
          let temp1 : string = this.months[this.startMonth]+" "+String(this.startDay).padStart(2,'0');
          let temp2 : string = this.months[this.endMonth]+" "+String(this.endDay).padStart(2,'0');
          return temp1+" - "+temp2;
        }
        else{
          let temp1 : string = this.months[this.startMonth]+" "+String(this.startDay).padStart(2,'0')+", "+this.startYear;
          let temp2 : string = this.months[this.endMonth]+" "+String(this.endDay).padStart(2,'0')+", "+this.endYear;
          return temp1+" - "+temp2;
        }
      }
    }
  }

  openComponent:()=>void
  closeComponent:()=>void
  sendDate:(string)=>void

  dialogController : CustomDialogController = new CustomDialogController({
    builder: textDialog({confirm:(value)=> this.sendDate(value),cancel:this.exitApp,openPicker:()=>this.openComponent()}),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
  });
  exitApp () {
    console.log("Cancel text dialog!");
  }

  build(){
    Column(){
      //    Date select dialog title and quit button
      Flex({justifyContent:FlexAlign.SpaceBetween}){
        // Dialog Title
        Text((this.isRangePicker)?'Select range':'Select date').fontColor(Color.White).fontSize(15).fontFamily('Times').margin({left:10,top:10})

        //Quit Button
        Button({type:ButtonType.Circle}){
          Image($r("app.media.icon")).width(20).height(20)
        }.width(20).height(20).margin({right:40,top:10})
        .onClick((event:ClickEvent)=>{
          this.closeComponent();
        })
      }
      .backgroundColor(Color.Blue)
      .width('100%')
      .height(60)

      // Selected date and Text Dialog Button
      Row(){
        // Selected date or range
        Text(this.getSelectedText()).fontColor(Color.White).fontSize(26).fontFamily('Times').fontWeight(FontWeight.Bold).margin({left:15})

        // Text dialog button
        Button({type:ButtonType.Circle}){
          Image($r("app.media.icon")).width(20).height(20)
        }.width(20).height(20).margin({right:20,top:10})
        .onClick((event:ClickEvent)=>{
          this.closeComponent();
          this.dialogController.open();
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(Color.Blue)
      .width('100%')
      .height(60)

      // Month and year navigation panel
      Flex({justifyContent:FlexAlign.SpaceBetween}){
        Column(){
          Row(){
            // Current month and year
            Text(this.months[this.currMonth] + " " + this.currYear).fontSize(15).fontFamily('Times New Roman')

            // Button to open year-select grid
            Button({type:ButtonType.Circle}){
              Image('app.media.icon').width(10).height(10)
            }.width(15).height(15).margin({left:5})
            .onClick((event:ClickEvent)=>{
              if(this.showYearList){
                this.showYearList=false;
                if(!this.isRangePicker){
                  this.typeOfDayArray=this.makeArray();
                }
                else {
                  this.typeOfDayArray=this.makeArray2();
                }
              }
              else this.showYearList=true;
            })
          }
        }
        Column(){
          Row(){
            // Navigate to previous month button
            Button({type:ButtonType.Circle}){
              Image($r("app.media.icon")).width(20).height(20)
            }.width(20).height(20).margin({right:10})
            .onClick((event:ClickEvent) =>{
              this.currMonth-=1;
              if(this.currMonth==-1) {
                this.currMonth=11
                this.currYear-=1
              }
              if(!this.isRangePicker){
                this.typeOfDayArray=this.makeArray();
              }
              else {
                this.typeOfDayArray=this.makeArray2();
              }
            })

            // Navigate to next month button
            Button({type:ButtonType.Circle}){
              Image($r("app.media.icon")).width(20).height(20)
            }.width(20).height(20)
            .onClick((event:ClickEvent) =>{
              this.currMonth+=1;
              if(this.currMonth==12) {
                this.currMonth=0
                this.currYear+=1
              }
              if(!this.isRangePicker){
                this.typeOfDayArray=this.makeArray();
              }
              else {
                this.typeOfDayArray=this.makeArray2();
              }
            })
          }
          .justifyContent(FlexAlign.End)
        }
      }
      .height(30)
      .margin({left:15,right:15,top:10,bottom:10})

      Row(){
        // Year Grid
        if(this.showYearList) yearSelect({yearModel:this.yearModel,selectedYear:$currYear,yearStartRange:$yearStartRange,yearEndRange:$yearEndRange});

        // Month Calendar
//        if(!this.showYearList) MaterialDatePickerCalendar({model:this.model,isRangePicker:$isRangePicker,currMonth:this.currMonth+0,currYear:this.currYear+0,selectedYear:$selectedYear,selectedMonth:$selectedMonth,selectedDay:$selectedDay,selectedDateString:$showSelected,isSelected:$isSelected,typeOfDayArray:$typeOfDayArray,startDay:$startDay,startMonth:$startMonth,startYear:$startYear,endDay:$endDay,endMonth:$endMonth,endYear:$endYear,isStartSelected:$isStartSelected,isEndSelected:$isEndSelected})
        if(!this.showYearList){
          Swiper(this.swiperController){
            ForEach([...new Array(12).keys()], (month:number)=>{
              MaterialDatePickerCalendar({model:this.model,isRangePicker:$isRangePicker,currMonth:month,currYear:this.currYear+0,selectedYear:$selectedYear,selectedMonth:$selectedMonth,selectedDay:$selectedDay,selectedDateString:$showSelected,isSelected:$isSelected,typeOfDayArray:$typeOfDayArray,startDay:$startDay,startMonth:$startMonth,startYear:$startYear,endDay:$endDay,endMonth:$endMonth,endYear:$endYear,isStartSelected:$isStartSelected,isEndSelected:$isEndSelected})
            })
          }
          .index(this.currMonth)
          .autoPlay(false)
          .indicator( false ) // enable indicator by default
          .loop( true ) // enable loop playback by default
          .duration(1000)
          .vertical( false ) // default horizontal switch
          .itemSpace(0)
          .onChange((index: number) => {
            if(this.prevIdx==11 && index==0) {
              this.currYear++;
              this.currMonth=0;
            }
            if(this.prevIdx==0 && index==11) {
              this.currYear--;
              this.currMonth=11;
            }
            else{
              this.currMonth=index;
            }
            this.typeOfDayArray=this.makeArray();
            console.log("prevIdx: "+this.prevIdx+", "+"current index: "+index);
            this.prevIdx = index;
          })
        }

      }.width('100%').height(300).margin({bottom:20})

      Flex({justifyContent:FlexAlign.SpaceBetween}){
        // Today button
        Column(){
          Row(){
            Button("Today",{type:ButtonType.Normal}).width(100).backgroundColor(Color.White).fontColor(Color.Black).onClick((event:ClickEvent)=>{
              this.currMonth=new Date().getMonth();
              this.currYear=new Date().getFullYear();
            }).padding(10)
          }
        }

        Column(){
          //Cancel and confirm buttons
          Row(){
            // Cancel button
            Button("Cancel",{type:ButtonType.Normal}).width(100).backgroundColor(Color.White).fontColor(Color.Black).onClick((event:ClickEvent)=>{
              this.closeComponent();
            }).padding(10)

            // Confirm button
            Button("Select",{type:ButtonType.Normal}).width(100).borderRadius(2).fontWeight(20).fontSize(18).onClick((event:ClickEvent)=>{
              if(!this.isRangePicker){
                if(this.isSelected){
                  this.sendDate(this.showSelected);
                }
              }
              else{
                if(this.isStartSelected && this.isEndSelected){
                  this.sendDate(String(this.startDay).padStart(2,'0')+"/"+String(this.startMonth+1).padStart(2,'0')+"/"+this.startYear+" - "+String(this.endDay).padStart(2,'0')+"/"+String(this.endMonth+1).padStart(2,'0')+"/"+this.endYear);
                }
              }
              this.closeComponent();
            }).padding(10)
          }
        }.justifyContent(FlexAlign.End).margin({right:5})
      }

    }.height(550)
  }
}


export default MaterialDatePicker;
