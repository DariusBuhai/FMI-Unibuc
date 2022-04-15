from app.user.user import UserObject
from flask import Blueprint, jsonify, request, Response

app_user = Blueprint('user', __name__)


@app_user.route("/user/statistics", methods=['GET'])
def getStatistics():
    """
    Returns consumption data for all devices for a given month in a year
    ---
    parameters:
      - in: query 
        name: month
        schema:
            required: false
            type: integer
            format: int32
        description: the month for which the statistics are wanted
        style: form
        explode: true
        
      - in: query
        name: year
        schema:
          required: false
          type: integer
          format: int32
        description: the year for which the statistics are wanted
        style: form
        explode: true
        
      responses:
        "200":
          description: a list of consumption data for each device
          content:
            application/json
        "400":
          description: Invalid request
    """

    month = int(request.args.get("month", '-1'))
    year = int(request.args.get("year", "-1"))
    if month == -1 or year == -1:
        return Response("Invalid request", status=400)

    userObj = UserObject(UserObject.getMockUser())
    statistics = userObj.getMonthlyStatistics(month, year)

    return jsonify(statistics)


@app_user.route("/user/unoptimized_devices")
def getUnoptimizedDevices():
    """
    Returns which devices can be optimized for a better energy consumption
    ---

    parameters:
      - name: month
        in: query
        description: the month for which the statistics are wanted
        required: false
        style: form
        explode: true
        schema:
          type: integer
          format: int32
      - name: year
        in: query
        description: the year for which the statistics are wanted
        required: false
        style: form
        explode: true
        schema:
          type: integer
          format: int32
      responses:
        "200":
          description: a list of consumption data for each device with energy reduction tips
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UnoptimizedDevice'
        "400":
          description: Invalid request 
    """
    month = int(request.args.get("month", '-1'))
    year = int(request.args.get("year", "-1"))
    if month == -1 or year == -1:
        return Response("Invalid request", status=400)

    userObj = UserObject(UserObject.getMockUser())

    return jsonify(userObj.getUnoptimizedDevices(year, month))
