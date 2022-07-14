import {CalendarType,pickerType} from './values'

export interface DatePickerOptions{
  picker?:pickerType
  inputMode?:CalendarType
  startYear?:number
  endYear?:number
  openAtYear?:number
  openAtMonth?:number
  themeColor?:Color
  titleStyle?:{
    textLabel?:string
    textColor?:Color
  }
  selectedDateStyle?:{
    textColor?:Color
  }
  monthStyle?:{
    textColor?:Color
    todayDateTextColor?:Color
    todayDateBorderWidth?:number
    todayDateBorderColor?:Color
    todayDateFillColor?:Color
    itemFillColor?:Color
    itemStrokeColor?:Color
    itemStrokeWidth?:number
    rangeFillColor?:Color
  }
  cancelButtonStyle?:{
    textColor?:Color
  }
  confirmButtonStyle?:{
    textColor?:Color
    itemFillColor?:Color
  }

}