@Component
struct yearSelect{
  private yearModel: yearSelect.Model = new yearSelect.Model();
  scroll_grid:Scroller = new Scroller()
  @Link yearStartRange:number
  @Link yearEndRange:number
  @Link selectedYear:number
  @Link showYearList: boolean
  @State themeColor: Color = Color.Blue


  build(){
    Grid(this.scroll_grid){
      ForEach(this.yearModel.getYearsArray(this.yearStartRange,this.yearEndRange),(year:number)=>{
        GridItem(){
          Column(){
            if(year==this.selectedYear){
              Button({type:ButtonType.Normal}){
                Text(year+'').fontSize(16).fontColor(Color.White).fontWeight(FontWeight.Regular);
              }
              .width(80)
              .height(30)
              .backgroundColor(this.themeColor)
              .borderRadius(30)
              .onClick((event:ClickEvent)=>{
                this.showYearList=false;
              })
            }
            else{
              Button({type:ButtonType.Normal}){
                Text(year+'').fontSize(16).fontColor(Color.Black).fontWeight(FontWeight.Regular);
              }
              .width(80)
              .height(30)
              .backgroundColor(Color.White)
              .onClick((event:ClickEvent)=>{
                  this.selectedYear=year;
                  this.showYearList=false;
              })
            }

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

namespace yearSelect{
  export class Model{
    getYearsArray(start:number, end:number): number[]{
      var arr :number[] = new Array();
      for(var i=start;i<=end;i++) arr.push(i);
      return arr;
    }

  }
}

export default yearSelect;
