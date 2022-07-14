import {DatePickerModel} from './DatePickerModel'

@Component
struct yearSelectGrid{
  @Link parentModel: DatePickerModel
  scroll_grid:Scroller = new Scroller()

  build(){
    Grid(this.scroll_grid){
      ForEach(this.parentModel.getYearsArray(),(year:number)=>{
        GridItem(){
          Column(){
            Button({type:ButtonType.Normal}){
               if(year==this.parentModel.selectedYear || year==this.parentModel.rangeStartYear || year==this.parentModel.rangeEndYear){
                 Text(year+'').fontSize(16).fontColor(Color.White).fontWeight(FontWeight.Regular);
               }
               else if(year==this.parentModel.todayYear){
                 Text(year+'').fontSize(16).fontColor(this.parentModel.themeColor).fontWeight(FontWeight.Regular);
               }
               else{
                 Text(year+'').fontSize(16).fontColor(Color.Black).fontWeight(FontWeight.Regular);
               }
            }
            .width(80)
            .height(30)
            .backgroundColor((year==this.parentModel.selectedYear || year==this.parentModel.rangeStartYear || year==this.parentModel.rangeEndYear)?this.parentModel.themeColor:Color.White)
            .borderColor((year==this.parentModel.todayYear)?this.parentModel.themeColor:undefined)
            .borderRadius(30)
            .borderWidth((year==this.parentModel.todayYear)?1:0)
            .onClick((event:ClickEvent)=>{
              this.parentModel.currYear=year;
              this.parentModel.showYearList=false;
            })
          }
        }
      })
    }.columnsTemplate('1fr 1fr 1fr')
    .columnsGap(10)
    .rowsGap(10)
    .height(300)
    .width('90%')
    .margin({left:15,right:15})
  }
}

export default yearSelectGrid;