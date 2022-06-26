import rangePickerCalendar from './rangePickerCalendar'
import yearSelect from './yearSelect'

@CustomDialog
struct rangePicker{

  @State currYear:number = new Date().getFullYear();
  @State currMonth:number = new Date().getMonth();
  @State startDay: number = new Date().getDate();
  @State startMonth: number = new Date().getMonth();
  @State startYear: number = new Date().getFullYear();
  @State endDay: number = new Date().getDate();
  @State endMonth: number = new Date().getMonth();
  @State endYear: number = new Date().getFullYear();
  @State today: number = new Date().getDate();
  @State todayMonth: number = new Date().getMonth();
  @State todayYear: number = new Date().getFullYear();

  @State componentTitle: string = 'Selected Range'
  @State showYearList: boolean = false;
  @State yearStartRange:number = 2000
  @State yearEndRange:number = 2100
  @State selectFrom: Date = new Date(this.yearStartRange,0,1);
  @State selectBefore: Date = new Date(this.yearEndRange,11,31);

  @State isStartSelected:boolean = false;
  @State isEndSelected:boolean = false;


  weekdays:string[] = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
  months:string[] = ['January','February','March','April','May','June','July','August','September','October','November','December']

  private model:rangePickerCalendar.Model = new rangePickerCalendar.Model();
  private yearModel: yearSelect.Model = new yearSelect.Model();

  controller: CustomDialogController
  cancel: () => void
  confirm: (string) => void

  build(){
    Column(){

      // Date select dialog title and quit button
      Flex({justifyContent:FlexAlign.SpaceBetween}){
        // Dialog Title
        Text(this.componentTitle).fontColor(Color.White).fontSize(15).fontFamily('Times').margin({left:10,top:10})

        //Quit Button
        Button({type:ButtonType.Circle}){
          Image($r("app.media.icon")).width(20).height(20)
        }.width(20).height(20).margin({right:40,top:10})
        .onClick((event:ClickEvent)=>{
          this.controller.close()
          this.cancel()
        })
      }
      .backgroundColor(Color.Blue)
      .width('100%')
      .height(60)

      // Selected date in (Day, Month Date) format
      Row(){
        if(!this.isStartSelected && !this.isEndSelected){
          Text("Start date - End date").fontColor(Color.White).fontSize(30).fontFamily('Times').fontWeight(FontWeight.Bold).margin({left:15})
        }
        if(this.isStartSelected && !this.isEndSelected){
          if(this.startYear==this.todayYear){
            Text(this.months[this.startMonth]+" "+this.startDay+" - End date").fontColor(Color.White).fontSize(28).fontFamily('Times').fontWeight(FontWeight.Bold).margin({left:15})
          }
          else{
            Text(this.months[this.startMonth]+" "+this.startDay+", "+this.startYear+" - End date").fontColor(Color.White).fontSize(22).fontFamily('Times').fontWeight(FontWeight.Bold).margin({left:15})
          }
        }
        if(this.isStartSelected && this.isEndSelected){
          if(this.startYear==this.todayYear && this.endYear==this.todayYear){
            Text(this.months[this.startMonth]+" "+this.startDay+" - "+this.months[this.endMonth]+" "+this.endDay).fontColor(Color.White).fontSize(30).fontFamily('Times').fontWeight(FontWeight.Bold).margin({left:15})
          }
          else{
            Text(this.months[this.startMonth]+" "+this.startDay+", "+this.startYear+" - "+this.months[this.endMonth]+" "+this.endDay+", "+this.endYear).fontColor(Color.White).fontSize(30).fontFamily('Times').fontWeight(FontWeight.Bold).margin({left:15})
          }
        }

        Button({type:ButtonType.Circle}){
          Image($r("app.media.icon")).width(20).height(20)
        }.width(20).height(20).margin({right:20,top:10})
        .onClick((event:ClickEvent)=>{
          this.controller.close()
          this.cancel()

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
              if(this.showYearList) this.showYearList=false;
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
        if(!this.showYearList) rangePickerCalendar({model:this.model,currMonth:this.currMonth+0,currYear:this.currYear+0,startDay:$startDay,startMonth:$startMonth,startYear:$startYear,endDay:$endDay,endMonth:$endMonth,endYear:$endYear,isStartSelected:$isStartSelected,isEndSelected:$isEndSelected});

      }.width('100%').height(300).margin({bottom:20})

      //Cancel and confirm buttons
      Row(){
        // Cancel button
        Button("Cancel",{type:ButtonType.Normal}).width(100).backgroundColor(Color.White).fontColor(Color.Black).onClick((event:ClickEvent)=>{
          this.controller.close()
          this.cancel()
        }).padding(10)

        // Confirm button
        Button("Select",{type:ButtonType.Normal}).width(100).borderRadius(2).fontWeight(20).fontSize(18).onClick((event:ClickEvent)=>{
          if(this.isStartSelected && this.isEndSelected){
            this.confirm(String(this.startDay).padStart(2,'0')+"/"+String(this.startMonth+1).padStart(2,'0')+"/"+this.startYear+" - "+String(this.endDay).padStart(2,'0')+"/"+String(this.endMonth+1).padStart(2,'0')+"/"+this.endYear)
            this.controller.close()
          }
          else{
            this.controller.close()
          }

        }).padding(10)
      }.justifyContent(FlexAlign.End).width('100%').height(40).margin({right:20,bottom:30})

    }.height(550)
  }
}

export default rangePicker