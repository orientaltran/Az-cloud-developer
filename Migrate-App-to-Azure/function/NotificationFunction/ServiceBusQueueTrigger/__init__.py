import logging
import azure.functions as func
import psycopg2
import os
from datetime import datetime
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

def main(msg: func.ServiceBusMessage):

    notification_id = int(msg.get_body().decode('utf-8'))
    logging.info('Python ServiceBus queue trigger processed message: %s',notification_id)

    # TODO: Get connection to database
    POSTGRES_URL = 'az-prj3-postgresql-server.postgres.database.azure.com' 
    POSTGRES_USER = 'azpj3@az-prj3-postgresql-server'
    POSTGRES_PW = 'Admin1234' 
    POSTGRES_DB = 'techconfdb'
    POSTGRES_PORT = "5432"
    ADMIN_EMAIL_ADDRESS = 'info@techconf.com'
    SENDGRID_API_KEY = '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'

    db_conn = psycopg2.connect(host=POSTGRES_URL, dbname=POSTGRES_DB, user=POSTGRES_USER, password=POSTGRES_PW, port=POSTGRES_PORT)

    try:
        # TODO: Get notification message and subject from database using the notification_id
        cursor = db_conn.cursor()
        cursor.execute(f"SELECT message, subject FROM notification WHERE id = {notification_id}")
        notification = cursor.fetchone()
        message = notification[0]
        subject = notification[1]

        logging.info('Get notificaion object success: %s',notification)

        # TODO: Get attendees email and name
        cursor.execute("SELECT first_name, last_name, email FROM attendee")
        attendees = cursor.fetchall()

        # TODO: Loop through each attendee and send an email with a personalized subject
        for attendee in attendees:
            email_from = ADMIN_EMAIL_ADDRESS
            email_to = attendee[0]
            first_name = attendee[1]
            email_subject = f'{first_name}, {subject}'
            
            try:
                send_grid = SendGridAPIClient(SENDGRID_API_KEY)
                send_grid.send(Mail(email_from, email_to, email_subject, message))
            except Exception as error:
                print(f"Send email failed: {error}")

        # TODO: Update the notification table by setting the completed date and updating the status with the total number of attendees notified
        status = f"Attendees Notified: {str(len(attendees))}."
        query = "UPDATE notification SET completed_date = CURRENT_DATE, status = %s WHERE id = %s"
        cursor.execute(query, (status, notification_id))
        
        db_conn.commit()
        cursor.close()

    except (Exception, psycopg2.DatabaseError) as error:
        logging.error(error)
    finally:
        # TODO: Close connection
        db_conn.close()
