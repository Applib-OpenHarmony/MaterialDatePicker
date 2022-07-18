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
          .fontSize(15)
          .fontWeight(550)
          .fontFamily('Times')
          .margin({ left: 10, top: 10 })
        Button({ type: ButtonType.Circle }) {
          Image($r("app.media.close")).width(30).height(30)
        }
        .width(30)
        .height(30)
        .margin({ right: 40, top: 10 })
        .backgroundColor(this.parentModel.themeColor)
        .onClick((event: ClickEvent) => {
          this.closeDialog();
        })
      }
      .backgroundColor(this.parentModel.themeColor)
      .width('100%')
      .height(60)

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text(this.parentModel.getSelectedDateText())
          .fontColor(this.parentModel.selectedDateColor)
          .fontSize(26)
          .fontFamily('Times')
          .fontWeight(FontWeight.Bold)
          .margin({ left: 10, top: 10 })
        Button({ type: ButtonType.Circle }) {
          Image($r("app.media.edit")).width(25).height(25)
        }
        .width(30)
        .height(30)
        .margin({ right: 40, top: 10 })
        .backgroundColor(this.parentModel.themeColor)
        .onClick((event: ClickEvent) => {
          this.switchCalendar();
        })
      }
      .backgroundColor(this.parentModel.themeColor)
      .width('100%')
      .height(60)

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Column() {
          Row() {
            Text(this.parentModel.month[this.parentModel.currMonth] + " " + this.parentModel.currYear)
              .fontSize(16)
              .fontWeight(550)
            Button({ type: ButtonType.Circle }) {
              Image($r("app.media.arrow_drop_down")).width(20).height(20)
            }
            .width(20)
            .height(20)
            .margin({ left: 10, right: 15 })
            .backgroundColor(Color.White)
            .onClick((event: ClickEvent) => {
              this.parentModel.showYearList = !this.parentModel.showYearList;
            })
          }
        }

        Column() {
          Row() {
            Button({ type: ButtonType.Circle }) {
              Image($r("app.media.arrow_back")).width(20).height(20)
            }
            .width(20)
            .height(20)
            .margin({ right: 15 })
            .backgroundColor(Color.White)
            .onClick((event: ClickEvent) => {
              this.swiperController.showPrevious()
            })

            Button({ type: ButtonType.Circle }) {
              Image($r("app.media.arrow_forward")).width(20).height(20)
            }.width(20).height(20).backgroundColor(Color.White)
            .onClick((event: ClickEvent) => {
              this.swiperController.showNext()
            })
          }
        }
      }
      .height(30)
      .margin({ left: 24, right: 24, top: 18, bottom: 10 })

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
      }.width('100%').height(350).alignItems(VerticalAlign.Top)

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Column() {
          Row() {
            Button("Today", { type: ButtonType.Normal })
              .width(100)
              .backgroundColor(Color.White)
              .fontWeight(550)
              .fontColor(Color.Grey)
              .onClick((event: ClickEvent) => {
                this.parentModel.currMonth = this.parentModel.todayMonth;
                this.parentModel.currYear = this.parentModel.todayYear;
              })
              .padding(10)
          }
        }

        Column() {
          Row() {
            Button("Cancel", { type: ButtonType.Normal })
              .width(100)
              .backgroundColor(Color.White)
              .fontWeight(550)
              .fontColor(this.parentModel.cancelButtonTextColor)
              .onClick((event: ClickEvent) => {
                this.closeDialog();
              })
              .padding(10)
            Button("Select", { type: ButtonType.Normal })
              .width(100)
              .backgroundColor(this.parentModel.confirmButtonFillColor)
              .fontWeight(550)
              .fontColor(this.parentModel.confirmButtonTextColor)
              .borderRadius(2)
              .fontWeight(20)
              .fontSize(18)
              .onClick((event: ClickEvent) => {
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
          }.margin({right:12})
        }
      }.margin({bottom:15})

    }
    .clip(true)
    .borderRadius('22vp')
//    .height('88%')
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
