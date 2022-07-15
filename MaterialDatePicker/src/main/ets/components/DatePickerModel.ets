/*
 * Copyright (C) 2022 Application Library Engineering Group
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CalendarType, DayState, pickerType } from './values'
import { DatePickerOptions } from './Types'

export class DatePickerModel implements DatePickerOptions {
  clicked: boolean = false;
  todayDate: number = new Date().getDate();
  todayMonth: number = new Date().getMonth();
  todayYear: number = new Date().getFullYear();
  currYear: number = this.todayYear
  currMonth: number = this.todayMonth
  showYearList: boolean = false;
  prevIdx: number = this.currMonth
  selectedDay: number = undefined
  selectedMonth: number = undefined
  selectedYear: number = undefined
  isSelected: boolean = false
  selectedDate: string = "Select date"
  rangeStartDay: number = undefined
  rangeStartMonth: number = undefined
  rangeStartYear: number = undefined
  rangeEndDay: number = undefined
  rangeEndMonth: number = undefined
  rangeEndYear: number = undefined
  isStartSelected: boolean = false;
  isEndSelected: boolean = false;
  selectedRange: string = "Select range"
  cellHeight: number = 0
  cellWidth: number = 0
  gridWidth: number = 0
  gridStartX: number = 0
  gridStartY: number = 0

  inputMode: CalendarType = CalendarType.ENTER_DATE
  picker: pickerType = pickerType.DATE_PICKER
  startYear: number = 1900
  endYear: number = 2100
  themeColor: Color = 0x5e00ff
  titleText: string = (this.picker == pickerType.DATE_PICKER) ? "Select date" : "Select range"
  titleTextColor: Color = Color.White
  selectedDateColor: Color = Color.White
  textColor: Color = Color.Black
  todayDateTextColor: Color = this.themeColor
  todayDateBorderWidth: number = 1
  todayDateBorderColor: Color = this.themeColor
  todayDateFillColor: Color = Color.White
  itemFillColor: Color = this.themeColor
  itemStrokeColor: Color = undefined
  itemStrokeWidth: number = 0
  rangeFillColor: Color = 0xece0fd
  cancelButtonTextColor: Color = Color.Grey
  confirmButtonTextColor: Color = Color.White
  confirmButtonFillColor: Color = this.themeColor

  month: string[] = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  weekdays: string[] = ['S', 'M', 'T', 'W', 'T', 'F', 'S']

  constructor(options: DatePickerOptions) {
    if (options != undefined) {
      if (options.inputMode != undefined) this.inputMode = options.inputMode
      if (options.picker != undefined) this.picker = options.picker
      if (options.startYear != undefined) this.startYear = options.startYear
      if (options.endYear != undefined) this.endYear = options.endYear
      if (options.openAtMonth != undefined) this.currMonth = options.openAtMonth
      if (options.openAtYear != undefined) this.currYear = options.openAtYear
      if (options.themeColor != undefined) this.themeColor = options.themeColor
      if (options["titleStyle"] != undefined) {
        if (options["titleStyle"].textLabel != undefined) this.titleText = options["titleStyle"].textLabel
        if (options["titleStyle"].textColor != undefined) this.titleTextColor = options["titleStyle"].textColor
      }
      if (options["selectedDateStyle"] != undefined) {
        if (options["selectedDateStyle"].textColor != undefined) this.selectedDateColor = options["selectedDateStyle"].textColor
      }
      if (options["monthStyle"] != undefined) {
        if (options["monthStyle"].textColor != undefined) this.textColor = options["monthStyle"].textColor
        if (options["monthStyle"].todayDateTextColor != undefined) this.todayDateTextColor = options["monthStyle"].todayDateTextColor
        if (options["monthStyle"].todayDateBorderWidth != undefined) this.todayDateBorderWidth = options["monthStyle"].todayDateBorderWidth
        if (options["monthStyle"].todayDateBorderColor != undefined) this.todayDateBorderColor = options["monthStyle"].todayDateBorderColor
        if (options["monthStyle"].todayDateFillColor != undefined) this.todayDateFillColor = options["monthStyle"].todayDateFillColor
        if (options["monthStyle"].itemFillColor != undefined) this.itemFillColor = options["monthStyle"].itemFillColor
        if (options["monthStyle"].itemStrokeColor != undefined) this.itemStrokeColor = options["monthStyle"].itemStrokeColor
        if (options["monthStyle"].itemStrokeWidth != undefined) this.itemStrokeWidth = options["monthStyle"].itemStrokeWidth
        if (options["monthStyle"].rangeFillColor != undefined) this.rangeFillColor = options["monthStyle"].rangeFillColor
      }
      if (options["cancelButtonStyle"] != undefined) {
        if (options["cancelButtonStyle"].textColor != undefined) this.cancelButtonTextColor = options["cancelButtonStyle"].textColor
      }
      if (options["confirmButtonStyle"] != undefined) {
        if (options["confirmButtonStyle"].textColor != undefined) this.confirmButtonTextColor = options["confirmButtonStyle"].textColor
        if (options["confirmButtonStyle"].itemFillColor != undefined) this.confirmButtonFillColor = options["confirmButtonStyle"].itemFillColor
      }
    }
  }

  setSelectedDate(selected_date: number) {
    this.isSelected = true
    this.selectedDay = selected_date + 1;
    this.selectedMonth = this.currMonth;
    this.selectedYear = this.currYear;
    this.selectedDate = String(this.selectedDay).padStart(2, '0') + "/" + String(this.selectedMonth + 1)
      .padStart(2, '0') + "/" + String(this.selectedYear)
  }

  setRangeStartDay(selected_date: number) {
    this.rangeStartDay = selected_date + 1;
    this.rangeStartMonth = this.currMonth;
    this.rangeStartYear = this.currYear;
    this.isStartSelected = true;
  }

  setRangeEndDay(selected_date: number) {
    this.rangeEndDay = selected_date + 1;
    this.rangeEndMonth = this.currMonth;
    this.rangeEndYear = this.currYear;
    this.isEndSelected = true;
    this.selectedRange = String(this.rangeStartDay).padStart(2, '0') + "/" + String(this.rangeStartMonth + 1)
      .padStart(2, '0') + "/" + this.rangeStartYear + " - " + String(this.rangeEndDay)
      .padStart(2, '0') + "/" + String(this.rangeEndMonth + 1).padStart(2, '0') + "/" + this.rangeEndYear;
  }

  getSelectedDateText(): string{
    if (this.picker == pickerType.DATE_PICKER) {
      if (this.isSelected) {
        let temp: string = this.month[this.selectedMonth] + " " + String(this.selectedDay)
          .padStart(2, '0') + ", " + this.selectedYear;
        return temp;
      }
      else return "Selected Date"
    }
    else {
      if (!this.isStartSelected && !this.isEndSelected) {
        return "Start date - End date"
      }
      else if (this.isStartSelected && !this.isEndSelected) {
        if (this.rangeStartYear == new Date().getFullYear()) {
          let temp: string = this.month[this.rangeStartMonth] + " " + String(this.rangeStartDay).padStart(2, '0');
          return temp + " - End date";
        }
        else {
          let temp: string = this.month[this.rangeStartMonth] + " " + String(this.rangeStartDay)
            .padStart(2, '0') + ", " + this.rangeStartYear;
          return temp + " - End date";
        }
      }
      else {
        if (this.rangeStartYear == this.rangeEndYear && this.rangeEndYear == new Date().getFullYear()) {
          let temp1: string = this.month[this.rangeStartMonth] + " " + String(this.rangeStartDay).padStart(2, '0');
          let temp2: string = this.month[this.rangeEndMonth] + " " + String(this.rangeEndDay).padStart(2, '0');
          return temp1 + " - " + temp2;
        }
        else {
          let temp1: string = this.month[this.rangeStartMonth] + " " + String(this.rangeStartDay)
            .padStart(2, '0') + ", " + this.rangeStartYear;
          let temp2: string = this.month[this.rangeEndMonth] + " " + String(this.rangeEndDay)
            .padStart(2, '0') + ", " + this.rangeEndYear;
          return temp1 + " - " + temp2;
        }
      }
    }
  }

  getFontColor(typeOfDay: DayState): Color{
    if (typeOfDay == DayState.TODAY_DAY) {
      return this.todayDateTextColor
    }
    else if (typeOfDay == DayState.SELECTED_DAY) {
      return Color.White
    }
    else {
      return this.textColor
    }
  }

  getBackgroundColor(typeOfDay: DayState): Color{
    if (typeOfDay == DayState.NORMAL_DAY) {
      return Color.White
    }
    else if (typeOfDay == DayState.TODAY_DAY) {
      return this.todayDateFillColor
    }
    else if (typeOfDay == DayState.SELECTED_DAY) {
      return this.itemFillColor
    }
    else {
      return this.rangeFillColor
    }
  }

  getBorderWidth(typeOfDay: DayState): number{
    if (typeOfDay == DayState.TODAY_DAY) {
      return this.todayDateBorderWidth
    }
    else {
      return 0
    }
  }

  getYearsArray(): number[]{
    var arr: number[] = new Array();
    for (var i = this.startYear;i <= this.endYear; i++) arr.push(i);
    return arr;
  }
}
