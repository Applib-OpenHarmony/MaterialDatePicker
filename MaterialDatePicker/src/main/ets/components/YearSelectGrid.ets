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

import { DatePickerModel } from './DatePickerModel'

@Component
struct yearSelectGrid {
  @Link parentModel: DatePickerModel
  scroll_grid: Scroller = new Scroller()

  build() {
    Grid(this.scroll_grid) {
      ForEach(this.parentModel.getYearsArray(), (year: number) => {
        GridItem() {
          Button({ type: ButtonType.Normal }) {
            if (year == this.parentModel.selectedYear || year == this.parentModel.rangeStartYear || year == this.parentModel.rangeEndYear) {
              Text(year + '').fontSize("18fp").fontWeight("550vp").fontColor(Color.White).fontWeight(FontWeight.Regular);
            }
            else if (year == this.parentModel.todayYear) {
              Text(year + '')
                .fontSize("18fp")
                .fontWeight("550vp")
                .fontColor(this.parentModel.themeColor)
                .fontWeight(FontWeight.Regular);
            }
            else {
              Text(year + '').fontSize("18fp").fontWeight("550vp").fontColor(Color.Black).fontWeight(FontWeight.Regular);
            }
          }
          .width("72vp")
          .height("36vp")
          .backgroundColor((year == this.parentModel.selectedYear || year == this.parentModel.rangeStartYear || year == this.parentModel.rangeEndYear) ? this.parentModel.themeColor : Color.White)
          .borderColor((year == this.parentModel.todayYear) ? this.parentModel.themeColor : undefined)
          .borderRadius("36vp")
          .borderWidth((year == this.parentModel.todayYear) ? "1vp" : "0vp")
          .onClick((event: ClickEvent) => {
            this.parentModel.currYear = year;
            this.parentModel.showYearList = false;
          })
        }
        .width("88vp")
        .height("52vp")
      })
    }.columnsTemplate('1fr 1fr 1fr')
    .columnsGap("8vp")
    .height("300vp")
    .margin({ left: "24vp", right: "24vp" })
  }
}

export default yearSelectGrid;
