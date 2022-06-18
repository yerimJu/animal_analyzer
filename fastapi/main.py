from typing import Optional

from fastapi import FastAPI
from model import inference

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/cat_analyzer/")
def read_item(img_src: Optional[str] = None):
    args={'weight_path': 'C: \\Users\\thdck\\OneDrive\\바탕 화면\\animal_analyzer\\fastapi\\model\\3-1.56-0.50.h5', 
        'input_size': 244, 
        'classes': 6, 
        'label': 'C:\\Users\\thdck\\OneDrive\\바탕 화면\\animal_analyzer\\fastapi\\model\\label.json', 
        'input_data': 'https://images.theconversation.com/files/443350/original/file-20220131-15-1ndq1m6.jpg'}
    if img_src:
        args['input_data'] = img_src
        
    app_inf = inference.Inference(args)
    result_dict = app_inf.inference(args["input_data"])
    # print(result_dict)
    result_dict['output'] = str(result_dict['output'])

    return result_dict