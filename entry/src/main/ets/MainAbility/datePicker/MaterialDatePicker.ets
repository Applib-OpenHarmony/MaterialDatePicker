import MaterialDatePickerCalendar from './MaterialDatePickerCalendar'
import yearSelect from './yearSelect'
import textDialog from './textDialog'
import {DayState} from './enums'

@Component
struct MaterialDatePicker{

  private model:MaterialDatePickerCalendar.Model = new MaterialDatePickerCalendar.Model();
  private yearModel: yearSelect.Model = new yearSelect.Model();

  // common link & state variables
  @State isRangePicker: boolean = false;
  @State clicked: boolean = false;
  @State currYear:number = new Date().getFullYear();
  @State currMonth:number = new Date().getMonth();
  @State showYearList: boolean = false;
  @State yearStartRange:number = 2000
  @State yearEndRange:number = 2100
  @State themeColor: Color = 0x5e00ff
  weekdays:string[] = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
  months:string[] = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

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
  @State cellHeight: number = 0
  @State cellWidth: number = 0
  @State gridWidth: number = 0
  @State gridStartX: number = 0
  @State gridStartY: number = 0

  // Single Date Picker methods

  // Range Picker methods

  // common methods
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
    builder: textDialog({confirm:(value)=> this.sendDate(value),cancel:this.exitApp,openPicker:()=>this.openComponent(),isRangePicker:this.isRangePicker&&true,themeColor:this.themeColor+0}),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
  });
  exitApp () {
    console.log("Cancel text dialog!");
  }

  private swiperController: SwiperController = new SwiperController ()
  @State prevIdx: number = this.currMonth

  build(){
    Column(){
      //    Date select dialog title and quit button
      Flex({justifyContent:FlexAlign.SpaceBetween}){
        // Dialog Title
        Text((this.isRangePicker)?'Select range':'Select date').fontColor(Color.White).fontSize(15).fontFamily('Times').margin({left:10,top:10})

        //Quit Button
        Button({type:ButtonType.Circle}){
          Image($r("app.media.close")).width(30).height(30)
        }.width(30).height(30).margin({right:40,top:10}).backgroundColor(this.themeColor)
        .onClick((event:ClickEvent)=>{
          this.closeComponent();
        })
      }
      .backgroundColor(this.themeColor)
      .width('100%')
      .height(60)

      // Selected date and Text Dialog Button
      Row(){
        // Selected date or range
        Text(this.getSelectedText()).fontColor(Color.White).fontSize(26).fontFamily('Times').fontWeight(FontWeight.Bold).margin({left:15})

        // Text dialog button
        Button({type:ButtonType.Circle}){
          Image($r("app.media.edit")).width(25).height(25)
        }.width(30).height(30).margin({right:20,top:10}).backgroundColor(this.themeColor)
        .onClick((event:ClickEvent)=>{
          this.closeComponent();
          this.dialogController.open();
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(this.themeColor)
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
              Image($r("app.media.arrow_drop_down")).width(20).height(20)
            }.width(20).height(20).margin({left:10,right:15}).backgroundColor(Color.White)
            .onClick((event:ClickEvent)=>{
              if(this.showYearList){
                this.showYearList=false;
              }
              else this.showYearList=true;
            })
          }
        }
        Column(){
          Row(){
            // Navigate to previous month button
            Button({type:ButtonType.Circle}){
              Image($r("app.media.arrow_back")).width(20).height(20)
            }.width(20).height(20).margin({right:15}).backgroundColor(Color.White)
            .onClick((event:ClickEvent) =>{
              this.currMonth-=1;
              if(this.currMonth==-1) {
                this.currMonth=11
                this.currYear-=1
              }
            })

            // Navigate to next month button
            Button({type:ButtonType.Circle}){
              Image($r("app.media.arrow_forward")).width(20).height(20)
            }.width(20).height(20).backgroundColor(Color.White)
            .onClick((event:ClickEvent) =>{
              this.currMonth+=1;
              if(this.currMonth==12) {
                this.currMonth=0
                this.currYear+=1
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
        if(this.showYearList) {
          yearSelect({
          yearModel:this.yearModel,
          selectedYear:$currYear,
          yearStartRange:$yearStartRange,
          yearEndRange:$yearEndRange,
          showYearList:$showYearList,
          themeColor:this.themeColor+0
          })
        }

        // Month Calendar
        // if(!this.showYearList) MaterialDatePickerCalendar({model:this.model,isRangePicker:$isRangePicker,currMonth:this.currMonth+0,currYear:this.currYear+0,selectedYear:$selectedYear,selectedMonth:$selectedMonth,selectedDay:$selectedDay,selectedDateString:$showSelected,isSelected:$isSelected,startDay:$startDay,startMonth:$startMonth,startYear:$startYear,endDay:$endDay,endMonth:$endMonth,endYear:$endYear,isStartSelected:$isStartSelected,isEndSelected:$isEndSelected,themeColor:this.themeColor+0})
        if(!this.showYearList) {
          Swiper(this.swiperController) {
            ForEach([...new Array(12).keys()], (month: number) => {
              if ((month - this.currMonth) >= -1 && (month - this.currMonth) <= 1) {
                MaterialDatePickerCalendar({
                  model: this.model,
                  isRangePicker: $isRangePicker,
                  clicked: $clicked,
                  currMonth: month,
                  currYear: this.currYear + 0,
                  selectedYear: $selectedYear,
                  selectedMonth: $selectedMonth,
                  selectedDay: $selectedDay,
                  selectedDateString: $showSelected,
                  isSelected: $isSelected,
                  startDay: $startDay,
                  startMonth: $startMonth,
                  startYear: $startYear,
                  endDay: $endDay,
                  endMonth: $endMonth,
                  endYear: $endYear,
                  isStartSelected: $isStartSelected,
                  isEndSelected: $isEndSelected,
                  themeColor: this.themeColor + 0,
                  gridWidth: $gridWidth,
                  gridStartX: $gridStartX,
                  gridStartY: $gridStartY,
                  cellWidth: $cellWidth,
                  cellHeight: $cellHeight
                })
              } else {
                PlaceHolderComponent()
              }
            })
          }
          .index(this.currMonth)
          .autoPlay(false)
          .indicator(false) // enable indicator by default
          .loop(true) // enable loop playback by default
          .duration(1000)
          .vertical(false) // default horizontal switch
          .itemSpace(0)
          .onChange((index: number) => {
            if (this.prevIdx == 11 && index == 0) {
              this.currYear++;
              this.currMonth = 0;
            }
            if (this.prevIdx == 0 && index == 11) {
              this.currYear--;
              this.currMonth = 11;
            }
            else {
              this.currMonth = index;
            }
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
            Button("Select",{type:ButtonType.Normal}).width(100).backgroundColor(this.themeColor).borderRadius(2).fontWeight(20).fontSize(18).onClick((event:ClickEvent)=>{
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

@Component
struct PlaceHolderComponent {
  build() {
    Column() {
    }
  }
}

export default MaterialDatePicker;
