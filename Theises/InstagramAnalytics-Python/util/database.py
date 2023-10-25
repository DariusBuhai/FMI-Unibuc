import pymysql
from pymysql.constants import CLIENT

from util.general import getGeneralSettings


class Database:
    def __init__(self, database='database'):
        self.general_settings = getGeneralSettings()

        self.database = pymysql.connect(
            host=self.general_settings[database]['host'],
            user=self.general_settings[database]['username'],
            password=self.general_settings[database]['password'],
            client_flag=CLIENT.MULTI_STATEMENTS
        )

        self.cursor = self.database.cursor()
        self.cursor.execute('use ' + self.general_settings[database]['database'])

    def __del__(self):
        try:
            self.cursor.close()
            self.database.close()
        except Exception:
            pass

    def commit(self):
        self.execute("COMMIT;")

    def useDatabase(self, database=None):
        if database is None:
            database = self.general_settings['database']['database']
        self.cursor.execute(f'use {database}')

    def _getTableColumns(self, table):
        self.cursor.execute(f"SELECT * FROM {table}")
        return [x[0] for x in self.cursor.description]

    def select(self, query, data=None):
        if data is None:
            data = []
        self.cursor.execute(query, data)
        columnNames = [x[0] for x in self.cursor.description]
        results = self.cursor.fetchall()

        answers = list()
        for result in results:
            ans = dict()
            for index, value in enumerate(result):
                ans[columnNames[index]] = value
            answers.append(ans)
        return answers

    def selectOne(self, query, data=None):
        if data is None:
            data = []
        self.cursor.execute(query, data)
        columnNames = [x[0] for x in self.cursor.description]
        result = self.cursor.fetchone()
        if result is None:
            return None
        ans = dict()
        for index, value in enumerate(result):
            ans[columnNames[index]] = value
        return ans

    def execute(self, query, data=None):
        if data is None:
            data = ()
        self.cursor.execute(query, data)
        self.cursor.connection.commit()
        return self.cursor.lastrowid

    def update(self, table: str, columns: dict, where: dict, filter_data: list = None):
        table_columns = self._getTableColumns(table)
        data = list()
        data_queries = list()
        where_queries = list()
        for key in columns.keys():
            if (filter_data is None or key in filter_data) and key in table_columns:
                data_queries.append(f"`{key}` = %s")
                data.append(columns[key])
        for key in where.keys():
            where_queries.append(f"`{key}` = %s")
            data.append(where[key])
        if len(data_queries) == 0:
            return
        query = f"UPDATE {table} SET {', '.join(data_queries)} WHERE {' AND '.join(where_queries)}"
        return self.execute(query, tuple(data))

    def insert(self, table: str, columns: dict, filter_data: list = None, check_table_column=True):
        table_columns = None
        if check_table_column:
            table_columns = self._getTableColumns(table)
        data = list()
        data_queries = list()
        for key in columns.keys():
            if (filter_data is None or key in filter_data) and (not check_table_column or key in table_columns):
                data_queries.append(f"`{key}`")
                data.append(columns[key])
        query = f"INSERT INTO {table} ({', '.join(data_queries)}) VALUES ({', '.join(['%s' for _ in range(len(data_queries))])})"
        return self.execute(query, tuple(data))
