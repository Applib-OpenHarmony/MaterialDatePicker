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

import datePickerSelect from './datePickerSelect'
import datePickerInput from './datePickerInput'
import { DatePickerModel } from './DatePickerModel'
import { CalendarType } from './values'
import { DatePickerOptions } from './Types'

@CustomDialog
@Component
export struct MaterialDatePicker {
  private options: DatePickerOptions = undefined
  @State parentModel: DatePickerModel = undefined

  aboutToAppear() {
    if (this.parentModel == undefined) {
      this.parentModel = new DatePickerModel(this.options);
    }
  }

  controller: CustomDialogController
  confirm: (string) => void
  cancel: () => void

  openDialog() {
    this.controller.open();
  }

  closeDialog() {
    this.controller.close();
    this.cancel();
  }

  update(value: string) {
    this.confirm(value);
  }

  switchCalendar() {
    if (this.parentModel.inputMode == CalendarType.SELECT_DATE) {
      this.parentModel.inputMode = CalendarType.ENTER_DATE;
    }
    else {
      this.parentModel.inputMode = CalendarType.SELECT_DATE;
    }
  }

  build() {
    Column() {
      if (this.parentModel.inputMode == CalendarType.SELECT_DATE) {
        datePickerSelect({
          parentModel: $parentModel,
          closeDialog: () => this.closeDialog(),
          sendDate: (value) => this.update(value),
          switchCalendar: () => this.switchCalendar()
        })
      }
      else {
        datePickerInput({
          parentModel: $parentModel,
          closeDialog: () => this.closeDialog(),
          sendDate: (value) => this.update(value),
          switchCalendar: () => this.switchCalendar()
        })
      }
    }
  }
}
