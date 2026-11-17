import json
import os

def lambda_handler(event, context):
    """
    AWS Lambda handler for the FAT77 and Asset Pipeline API.
    Reads MAIN.LIB and returns pipeline status and configuration.
    """
    domain = "trafo.com"
    trafo_flow = "main -> trafo.com -> zudus.lib"
    
    try:
        if os.path.exists("MAIN.LIB"):
            with open("MAIN.LIB", "r") as f:
                for line in f:
                    line = line.strip()
                    if line.startswith("DOMAIN ="):
                        domain = line.split("=", 1)[1].strip()
                    elif line.startswith("TRAFO ="):
                        trafo_flow = line.split("=", 1)[1].strip()
    except Exception as e:
        print(f"Error reading MAIN.LIB: {e}")

    response_body = {
        "status": "success",
        "pipeline": "FAT77 Advanced 64-Sector Architecture",
        "domain": domain,
        "trafoFlow": trafo_flow,
        "imageSize": "32768 bytes",
        "signature": "FAT77-ADVANCED-SIG"
    }

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(response_body)
    }
