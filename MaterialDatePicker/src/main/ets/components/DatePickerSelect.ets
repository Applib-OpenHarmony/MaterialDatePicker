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

import MonthCalendar from './MonthCalendar'
import yearSelectGrid from './YearSelectGrid'
import { PickerType } from './Values'
import { DatePickerModel } from './DatePickerModel'

@Component
struct datePickerSelect {
  @Link parentModel: DatePickerModel
  private swiperController: SwiperController = new SwiperController()
  closeDialog: () => void
  sendDate: (string) => void
  switchCalendar: () => void

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text(this.parentModel.titleText)
          .fontColor(this.parentModel.titleTextColor)
          .fontSize("15fp")
          .fontWeight("550vp")
          .fontFamily('Times')
          .margin({ left: "10vp", top: "10vp" })
        Button({ type: ButtonType.Circle }) {
          Image($r("app.media.close")).width("30vp").height("30vp")
        }
        .width("30vp")
        .height("30vp")
        .margin({ right: "40vp", top: "10vp" })
        .backgroundColor(this.parentModel.themeColor)
        .onClick(() => {
          this.closeDialog();
        })
      }
      .backgroundColor(this.parentModel.themeColor)
      .width('100%')
      .height("60vp")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text(this.parentModel.getSelectedDateText())
          .fontColor(this.parentModel.selectedDateColor)
          .fontSize("26fp")
          .fontFamily('Times')
          .fontWeight(FontWeight.Bold)
          .margin({ left: "10vp", top: "10vp" })
        Button({ type: ButtonType.Circle }) {
          Image($r("app.media.edit")).width("25vp").height("25vp")
        }
        .width("30vp")
        .height("30vp")
        .margin({ right: "40vp", top: "10vp" })
        .backgroundColor(this.parentModel.themeColor)
        .onClick(() => {
          this.switchCalendar();
        })
      }
      .backgroundColor(this.parentModel.themeColor)
      .width('100%')
      .height("60vp")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Column() {
          Row() {
            Text(this.parentModel.month[this.parentModel.currMonth] + " " + this.parentModel.currYear)
              .fontSize("16fp")
              .fontWeight("550vp")
            Button({ type: ButtonType.Circle }) {
              Image($r("app.media.arrow_drop_down")).width("20vp").height("20vp")
            }
            .width("20vp")
            .height("20vp")
            .margin({ left: "10vp", right: "15vp" })
            .backgroundColor(Color.White)
            .onClick(() => {
              this.parentModel.showYearList = !this.parentModel.showYearList;
            })
          }
        }

        Column() {
          Row() {
            Button({ type: ButtonType.Circle }) {
              Image($r("app.media.arrow_back")).width("20vp").height("20vp")
            }
            .width("20vp")
            .height("20vp")
            .margin({ right: "15vp" })
            .backgroundColor(Color.White)
            .onClick(() => {
              this.swiperController.showPrevious()
            })

            Button({ type: ButtonType.Circle }) {
              Image($r("app.media.arrow_forward")).width("20vp").height("20vp")
            }.width("20vp").height("20vp").backgroundColor(Color.White)
            .onClick(() => {
              this.swiperController.showNext()
            })
          }
        }
      }
      .height("30vp")
      .margin({ left: "24vp", right: "24vp", top: "18vp", bottom: "10vp" })

      Row() {
        if (this.parentModel.showYearList) {
          yearSelectGrid({
            parentModel: $parentModel
          })
        }

        if (!this.parentModel.showYearList) {
          Swiper(this.swiperController) {
            ForEach([...new Array(12).keys()], (month: number) => {
              if ((month - this.parentModel.currMonth) >= -1 && (month - this.parentModel.currMonth) <= 1) {
                MonthCalendar({
                  parentModel: $parentModel,
                  currMonth: month,
                  currYear: this.parentModel.currYear
                })
              } else {
                PlaceHolderComponent()
              }
            })
          }
          .index(this.parentModel.currMonth)
          .autoPlay(false)
          .indicator(false)
          .loop(true)
          .duration(1000)
          .vertical(false)
          .itemSpace(0)
          .onChange((index: number) => {
            if (this.parentModel.prevIdx == 11 && index == 0) {
              this.parentModel.currYear++;
              this.parentModel.currMonth = 0;
            }
            if (this.parentModel.prevIdx == 0 && index == 11) {
              this.parentModel.currYear--;
              this.parentModel.currMonth = 11;
            }
            else {
              this.parentModel.currMonth = index;
            }
            this.parentModel.prevIdx = index;
          })
        }
      }.width('100%').height("350vp").alignItems(VerticalAlign.Top)

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Column() {
          Row() {
            Button("Today", { type: ButtonType.Normal })
              .width("100vp")
              .backgroundColor(Color.White)
              .fontWeight("550vp")
              .fontColor(Color.Grey)
              .onClick(() => {
                this.parentModel.currMonth = this.parentModel.todayMonth;
                this.parentModel.currYear = this.parentModel.todayYear;
              })
              .padding(10)
          }
        }

        Column() {
          Row() {
            Button("Cancel", { type: ButtonType.Normal })
              .width("100vp")
              .backgroundColor(Color.White)
              .fontWeight("550vp")
              .fontColor(this.parentModel.cancelButtonTextColor)
              .onClick(() => {
                this.closeDialog();
              })
              .padding(10)
            Button("Select", { type: ButtonType.Normal })
              .width("100vp")
              .backgroundColor(this.parentModel.confirmButtonFillColor)
              .fontWeight("550vp")
              .fontColor(this.parentModel.confirmButtonTextColor)
              .borderRadius("2vp")
              .fontWeight("20vp")
              .fontSize("18fp")
              .onClick(() => {
                if (this.parentModel.picker == PickerType.DATE_PICKER) {
                  if (this.parentModel.isSelected) {
                    this.sendDate(this.parentModel.selectedDate);
                  }
                }
                else {
                  if (this.parentModel.isStartSelected && this.parentModel.isEndSelected) {
                    this.sendDate(this.parentModel.selectedRange);
                  }
                }
                this.closeDialog();
              })
              .padding(10)
          }.margin({right:"12vp"})
        }
      }.margin({bottom:"15vp"})

    }
    .clip(true)
    .borderRadius("22vp")

  }
}

@Component
struct PlaceHolderComponent {
  build() {
    Column() {
    }
  }
}

export default datePickerSelect
