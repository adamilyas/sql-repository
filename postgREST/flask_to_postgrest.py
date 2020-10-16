import requests as rq
import json
from flask import Flask, Response, request
import os
app = Flask(__name__)

API_ENDPOINT = 'http://localhost:3000/rpc/insights'

@app.route('/rpc/insights', methods=["GET", "POST"])
def test_method():
    # return []
    return json.dumps([{"results": {"id": 1}}])

@app.route('/', methods=["GET", "POST"])
def call_postgrest():
    payload = json.dumps(request.json)
    app.logger.info(f'Payload: {payload}')


    try:
        url_call =  rq.post(API_ENDPOINT,
                            data=payload,
                            headers={
                                'Content-Type': 'application/json',
                                'Prefer': 'params=single-object'    
                                }
                )
    except rq.ConnectionError as e:
        # what if the connection to DB got problem
        app.logger.info('Connection error occurred.')
        response = {"code": 500, "message": "Connection error occurred."}
        return Response(json.dumps(response), status=500)


    db_response = url_call.json()
    app.logger.info(f'Received response from DB: {db_response}')
    # what if no data is returned.
    if len(db_response) == 0:
        payload_to_return = {"code": 404, "message": "Data Not Found"}
        status_to_return = 404
    else:
        payload_to_return = db_response[0]["result"] # looks like: {"id": 1}
        status_to_return = 200

    response = Response(json.dumps(payload_to_return), status=status_to_return)
    return response

if __name__ == "__main__":
    app.run(debug=True)
