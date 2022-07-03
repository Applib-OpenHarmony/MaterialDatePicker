import MaterialDatePicker from './MaterialDatePicker'

@CustomDialog
struct MaterialDialog{
  @State isRangePicker: boolean = false;
  @State yearStartRange: number = 1998
  @State yearEndRange: number = 2050

  controller: CustomDialogController
  confirm:(string) => void
  cancel:() =>void

  openDialog(){
    this.controller.open();
  }

  closeDialog(){
    this.controller.close();
    this.cancel();
  }

  update(value:string){
    this.confirm(value);
  }

  build(){
    Column(){
      MaterialDatePicker({isRangePicker:this.isRangePicker && true, openComponent:()=>this.openDialog(),closeComponent:()=>this.closeDialog(),sendDate:(value)=>this.update(value),yearStartRange:this.yearStartRange+0,yearEndRange:this.yearEndRange+0})
    }
  }
}

export default MaterialDialog;