@Component
struct yearSelect{
  private yearModel: yearSelect.Model = new yearSelect.Model();
  scroll_grid:Scroller = new Scroller()
  @State yearStartRange:number = 1970
  @State yearEndRange:number = 2030
  @Link selectedYear:number


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
              .height(20)
              .backgroundColor(Color.Blue)
              .borderRadius(5)
              .onClick((event:ClickEvent)=>{

              })
            }
            else{
              Button({type:ButtonType.Normal}){
                Text(year+'').fontSize(16).fontColor(Color.Black).fontWeight(FontWeight.Regular);
              }
              .width(80)
              .height(20)
              .backgroundColor(Color.White)
              .onClick((event:ClickEvent)=>{
                  this.selectedYear=year;
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