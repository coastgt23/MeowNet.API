import sqlite3
conn=sqlite3.connect('meownet2.db')
conn.execute("UPDATE SubRooms SET data_blob = '' WHERE data_blob = '{}'")
conn.commit()
conn.close()
