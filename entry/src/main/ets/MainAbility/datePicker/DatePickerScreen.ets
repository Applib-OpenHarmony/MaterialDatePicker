import DatePickerUI from './DatePickerUI'

@Entry
@Component
struct DatePickerScreen{
  @State showSelected :string = 'dd-mm-yyyy'

  dialogController : CustomDialogController = new CustomDialogController({
    builder: DatePickerUI({confirm: this.onAccept,cancel:this.exitApp}),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
  });

  onAccept (value:string) {
    this.showSelected=value+"";
    console.log("onAccept="+value);
    console.log(this.showSelected);
  }
  exitApp () {
    console.log("Cancel dialog!");
  }

  getShowSelected():string{
    return this.showSelected;
  }


  build(){
    Column(){
      Flex({justifyContent:FlexAlign.Start}){ Button({type:ButtonType.Circle}){
        Image($r("app.media.icon")).width(20).height(20)
      }.width(20).height(20).margin({left:10})
        Text('Date Picker').fontFamily("San Francisco").fontSize(25).fontWeight(FontWeight.Bold).margin({left:20,bottom:20})
      }
      Divider().width('100%').strokeWidth(4).color(0xEAEAEA)
      Flex({justifyContent:FlexAlign.Start}){
        Text("Select Date").fontFamily("Times New Roman").fontSize(20).margin({left:15,top:20,bottom:20})
      }
      Flex({justifyContent:FlexAlign.Start}){
        Text("Start").fontFamily("Times New Roman").fontSize(15).margin({left:15,bottom:10})
      }
      Flex({justifyContent:FlexAlign.Start}){
        Column(){
          Row(){
            Text(this.showSelected).fontSize(15)
          }.justifyContent(FlexAlign.Start).width('100%')
        }.justifyContent(FlexAlign.Center).borderWidth(1).borderColor(Color.Grey).width('75%').height(30).margin({left:15})
        Column(){
          Row(){
            Button({type:ButtonType.Circle}){
              Image($r("app.media.icon")).width(20).height(20)
            }.width(20).height(20)
            .onClick(() => {
              this.dialogController.open()
            })
          }
        }.justifyContent(FlexAlign.Center)
        .borderWidth(1).borderColor(Color.Grey).width('10%').height(30)
      }
    }

  }
}
