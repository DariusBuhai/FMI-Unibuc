import csv
from datetime import datetime
from datetime import timedelta

from sqlalchemy import column

for index in range(1, 4):
    for year in range(2014, 2017):
        if year == 2014 and index == 3:
            continue

        readerData = []
        with open(f'./demo-data/{year}/meter' + str(index) + '.csv', newline='') as read_f:
            reader = csv.reader(read_f)
            for row in reader:
                readerData.append(row)

        data_len = len(readerData)

        with open(f'./demo-data/{year}/meter' + str(index) + '_new.csv', mode='w') as write_f:
            try:
                writer = csv.writer(write_f, delimiter=',')
                writer.writerow(readerData[0])
                line_index = 1
                while line_index < len(readerData):
                    line_to_insert = readerData[line_index]
                    for column_index in range(1, len(line_to_insert)):
                        line_to_insert[column_index] = float(line_to_insert[column_index])
                    timestamp1 = int(readerData[line_index][0].split(" ")[1].split(":")[1])
                    stop_timestamp = (timestamp1 + 30) % 60

                    step = 1
                    while line_index + step < len(readerData):
                        timestamp2 = int(readerData[line_index + step][0].split(" ")[1].split(":")[1])
                        if timestamp2 == stop_timestamp:
                            break
                        for column_index in range(1, len(line_to_insert)):
                            line_to_insert[column_index] += float(readerData[line_index + step][column_index])

                        step += 1

                    writer.writerow(line_to_insert)
                    line_index += step
            except Exception as e:
                print(e)
