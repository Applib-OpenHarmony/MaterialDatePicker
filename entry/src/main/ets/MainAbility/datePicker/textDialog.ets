@CustomDialog
struct textDialog{
  controller: CustomDialogController
  cancel: () => void
  confirm: (string) => void
  openPicker:() => void

  @State yearStartRange:number = 1900
  @State yearEndRange:number = 2100
  @State inputDate: string = "dd/mm/yyyy"

  isValidDateFormat(value: string):boolean{
    var temp = value.split("/")
    if(temp.length!=3) return false;
    var date = parseInt(temp[0])
    var month = parseInt(temp[1])
    var year = parseInt(temp[2])
    if(String(date)=="NaN" || date<1 || date>31) return false;
    if(String(month)=="NaN" || month<1 || month>12) return false;
    if(String(year)=="NaN" || year<this.yearStartRange || year>this.yearEndRange) return false;
    var dt:Date = new Date(year,month,1);
    var maxDays:number = new Date(dt.getFullYear(),dt.getMonth(),0).getDate();
    if(date>maxDays) return false;
    return true;
  }

  build() {
    Column() {
//    Date select dialog title and quit button
      Flex({justifyContent:FlexAlign.Start}){
        // Dialog Title
        Text("INPUT DATE").fontColor(Color.White).fontSize(12).fontFamily('Times').margin({left:15,top:10})

      }
      .backgroundColor(Color.Blue)
      .width('100%')
      .height(60)

      Row(){
        Text("Enter Date").fontColor(Color.White).fontSize(40).fontFamily('Times').fontWeight(10).margin({left:15})
        Button({type:ButtonType.Circle}){
          Image($r("app.media.icon")).width(20).height(20)
        }.width(20).height(20).margin({right:20,top:10})
        .onClick((event:ClickEvent)=>{
          this.controller.close()
          this.cancel()
          this.openPicker()
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(Color.Blue)
      .width('100%')
      .height(60)
      .margin({bottom:20})


      TextInput({ placeholder: 'dd/mm/yyyy' })
        .type(InputType.Number)
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 15, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal })
        .enterKeyType(EnterKeyType.Next)
        .caretColor(Color.Blue)
        .width('90%')
        .height(40)
        .margin({bottom:20})
        .fontSize( 15 )
        .fontColor(Color.Black)
        .maxLength(10)
        .onChange((value: string) => {
          this.inputDate=value;
        })
        .onSubmit((enterKey) => {

        })

      //Cancel and confirm buttons
      Row(){
        // Cancel button
        Button("Cancel",{type:ButtonType.Normal}).width(100).backgroundColor(Color.White).fontColor(Color.Black).onClick((event:ClickEvent)=>{
          this.controller.close()
          this.cancel()
        }).padding(10)

        // Confirm button
        Button("Ok",{type:ButtonType.Normal}).width(100).borderRadius(2).fontWeight(20).fontSize(18).onClick((event:ClickEvent)=>{
          if(this.isValidDateFormat(this.inputDate)){
            this.confirm(this.inputDate)
            this.controller.close()
          }
          else{
            AlertDialog.show(
              {
                title: 'Invalid Date',
                message: 'Input the correct date in dd/mm/yyyy format',
                primaryButton: {
                  value: 'OK',
                  action: () => {
//                    console.info('Callback when the first button is clicked')
                  }
                },
                cancel: () => {
//                  console.info('Closed callbacks')
                }
              }
            )
          }
        }).padding(10)
      }.justifyContent(FlexAlign.End).width('100%').height(40).margin({right:20,bottom:30})

    }.height(250)
  }
}

export default textDialog