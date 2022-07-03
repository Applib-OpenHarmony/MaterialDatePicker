import MaterialDialog from './MaterialDialog'

@Entry
@Component
struct testScreen{
  private isRangePicker: boolean =false;
  @State showSelectedDate: string = "Select date";
  @State showSelectedRange: string = "Select range";

  dialogController : CustomDialogController = new CustomDialogController({
    builder: MaterialDialog({confirm:(value)=> this.onAccept(value),cancel:this.exitApp,isRangePicker:this.isRangePicker}),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
  });
  onAccept (value:string) {
    console.log("onAccept="+value);
    if(!this.isRangePicker){
      this.showSelectedDate=value;
    }
    else{
      this.showSelectedRange=value;
    }
  }
  exitApp () {
    console.log("Cancel dialog!");
  }

  build(){
    Column(){
      Flex({justifyContent:FlexAlign.Start}){
        Button({type:ButtonType.Circle}){
          Image($r("app.media.menu")).width(30).height(30)
        }.width(30).height(30).margin({left:10}).backgroundColor(Color.White)
        Text('Date Picker').fontFamily("San Francisco").fontSize(25).fontWeight(FontWeight.Bold).margin({left:20,bottom:20})
      }
      Divider().width('100%').strokeWidth(4).color(0xEAEAEA)
      Flex({justifyContent:FlexAlign.Start}){
        Text("Select Date").fontFamily("Times New Roman").fontSize(20).margin({left:15,top:20,bottom:20})
      }
      Flex({justifyContent:FlexAlign.Start}){
        Text("Start").fontFamily("Times New Roman").fontSize(15).margin({left:15,bottom:15})
      }
      Flex({justifyContent:FlexAlign.Start}){
        Column(){
          Row(){
            Text(this.showSelectedDate).fontSize(15)
          }.justifyContent(FlexAlign.Start).width('100%')
        }.justifyContent(FlexAlign.Center).borderWidth(1).borderColor(Color.Grey).width('75%').height(30).margin({left:15})
        Column(){
          Row(){
            Button({type:ButtonType.Circle}){
              Image($r("app.media.calendar")).width(20).height(20)
            }.width(20).height(20).backgroundColor(Color.White)
            .onClick(() => {
              this.isRangePicker = false;
              this.dialogController.open()
            })
          }
        }.justifyContent(FlexAlign.Center)
        .borderWidth(1).borderColor(Color.Grey).width('10%').height(30)
      }.margin({bottom:15})

      Flex({justifyContent:FlexAlign.Start}){
        Text("Select Range").fontFamily("Times New Roman").fontSize(20).margin({left:15,top:20,bottom:20})
      }
      Flex({justifyContent:FlexAlign.Start}){
        Text("Start - End").fontFamily("Times New Roman").fontSize(15).margin({left:15,bottom:15})
      }
      Flex({justifyContent:FlexAlign.Start}){
        Column(){
          Row(){
            Text(this.showSelectedRange).fontSize(15)
          }.justifyContent(FlexAlign.Start).width('100%')
        }.justifyContent(FlexAlign.Center).borderWidth(1).borderColor(Color.Grey).width('75%').height(30).margin({left:15})
        Column(){
          Row(){
            Button({type:ButtonType.Circle}){
              Image($r("app.media.range_calendar")).width(20).height(20)
            }.width(20).height(20).backgroundColor(Color.White)
            .onClick(() => {
              this.isRangePicker = true;
              this.dialogController.open()
            })
          }
        }.justifyContent(FlexAlign.Center)
        .borderWidth(1).borderColor(Color.Grey).width('10%').height(30)
      }.margin({bottom:15})
    }

  }
}
