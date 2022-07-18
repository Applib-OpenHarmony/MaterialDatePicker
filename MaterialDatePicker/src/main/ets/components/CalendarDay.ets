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

import { DayState } from './Values'
import { DatePickerModel } from './DatePickerModel'

@Component
struct calendarDay {
  @Link parentModel: DatePickerModel
  @State date: number = 1
  @State typeOfDay: DayState = 1
  onButtonPress: (number) => void

  build() {
    Column() {
      Button({ type: ButtonType.Circle }) {
        Text(this.date + 1 + '')
          .fontSize("17fp")
          .fontFamily('Times')
          .fontWeight("550vp")
          .fontColor(this.parentModel.getFontColor(this.typeOfDay))
      }
      .backgroundColor(this.parentModel.getBackgroundColor(this.typeOfDay))
      .borderWidth(this.parentModel.getBorderWidth(this.typeOfDay))
      .borderColor(this.parentModel.todayDateBorderColor)
      .borderRadius("100vp")
      .width("40vp")
      .height("40vp")
      .onClick((event: ClickEvent) => {
        this.onButtonPress(this.date);
      })
    }
  }
}

export default calendarDay;
