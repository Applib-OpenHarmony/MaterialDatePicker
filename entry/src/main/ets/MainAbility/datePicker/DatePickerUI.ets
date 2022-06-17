import DatePickerCalendar from './DatePickerCalendar'
import yearSelect from './yearSelect'

@Component
struct DatePickerUI{
  private calendarModel: DatePickerUI.Model = new DatePickerUI.Model();
  private model:DatePickerCalendar.Model = new DatePickerCalendar.Model();
  private yearModel: yearSelect.Model = new yearSelect.Model();

  @State currYear:number = new Date().getFullYear();
  @State currMonth:number = new Date().getMonth();
  @State showSelected: string = new Date().toDateString()+''
  @State showYearList: boolean = false;


  build(){
    Column(){
      //Date select dialog title
      Row(){
        Text(this.calendarModel.componentTitle).fontColor(Color.White).fontSize(15).fontFamily('Times').margin({left:15})
      }
      .justifyContent(FlexAlign.Start)
      .backgroundColor(Color.Blue)
      .width('100%')
      .height(60)

      // Selected date
      Row(){
        Text(this.showSelected).fontColor(Color.White).fontSize(25).fontFamily('Times').fontWeight(FontWeight.Bold).margin({left:15})
      }
      .justifyContent(FlexAlign.Start)
      .backgroundColor(Color.Blue)
      .width('100%')
      .height(40)


      Flex({justifyContent:FlexAlign.SpaceBetween}){
        Column(){
          Row(){
            Text(this.calendarModel.months[this.currMonth] + " " + this.currYear).fontSize(15).fontFamily('Times New Roman')
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
            // month-back button
            Button({type:ButtonType.Circle}){
              Image($r("app.media.icon")).width(20).height(20)
            }.width(20).height(20).margin({right:10})
            .onClick((event:ClickEvent) =>{
              this.currMonth-=1;
              console.log(this.model.selectedDate.toDateString())
              if(this.currMonth==-1) {
                this.currMonth=11
                this.currYear-=1
              }
            })

            // month-forward button
            Button({type:ButtonType.Circle}){
              Image($r("app.media.icon")).width(20).height(20)
            }.width(20).height(20)
            .onClick((event:ClickEvent) =>{
              this.currMonth+=1;
              console.log(this.model.selectedDate.toDateString())
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


      // Year Grid
      if(this.showYearList) yearSelect({yearModel:this.yearModel,selectedYear:$currYear});

      // Month Calendar
      if(!this.showYearList) DatePickerCalendar({model:this.model,currMonth:this.currMonth+0,currYear:this.currYear+0,selectedDateString: $showSelected})

      //Cancel and confirm buttons

    }
  }
}

namespace DatePickerUI{
  export class Model {
    componentTitle: string = 'Select date'
    months:string[] = ['January','February','March','April','May','June','July','August','September','October','November','December']

    setComponentTitle(title: string): Model{
      this.componentTitle = title;
      return this;
    }
  }
}

export default DatePickerUI;