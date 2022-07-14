import datePickerSelect from './datePickerSelect'
import datePickerInput from './datePickerInput'
import {DatePickerModel} from './DatePickerModel'
import {CalendarType} from './values'
import {DatePickerOptions} from './Types'

@CustomDialog
@Component
export struct MaterialDatePicker{
  private options: DatePickerOptions = undefined
  @State parentModel: DatePickerModel = undefined

  aboutToAppear() {
    if (this.parentModel == undefined) {
      this.parentModel = new DatePickerModel(this.options);
    }
  }

  controller: CustomDialogController
  confirm:(string) => void
  cancel:() => void

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

  switchCalendar(){
    if(this.parentModel.inputMode==CalendarType.SELECT_DATE){
      this.parentModel.inputMode=CalendarType.ENTER_DATE;
    }
    else{
      this.parentModel.inputMode=CalendarType.SELECT_DATE;
    }
  }


  build(){
    Column(){
      if(this.parentModel.inputMode==CalendarType.SELECT_DATE){
        datePickerSelect({
          parentModel:$parentModel,
          closeDialog:()=>this.closeDialog(),
          sendDate:(value)=>this.update(value),
          switchCalendar:()=>this.switchCalendar()
        })
      }
      else{
        datePickerInput({
          parentModel:$parentModel,
          closeDialog:()=>this.closeDialog(),
          sendDate:(value)=>this.update(value),
          switchCalendar:()=>this.switchCalendar()
        })
      }
    }
  }
}
