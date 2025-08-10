from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
app=FastAPI(title='Sample AI Service')
class Item(BaseModel):
    text:str
@app.get('/health')
def health():
    return {'status':'ok'}
@app.post('/classify')
def classify(item:Item):
    score=len(item.text)%100/100.0
    label='positive' if score>0.5 else 'negative'
    return {'label':label,'score':score}
if __name__=='__main__':
    uvicorn.run(app,host='0.0.0.0',port=8000)
