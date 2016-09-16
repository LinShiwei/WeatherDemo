
## Introduction
[OpenWeatherMap](http://openweathermap.org) provides a [city list](http://bulk.openweathermap.org/sample/) that contains cities all over the world. There are up to two hundred thousand cities in the list, but in this weatherDemo, we only need cities in China. So we should select the Chinese cities out. 

[get_sorted_CN_city.py]() can select Chinese cities from `city.list.json`, then sort and put them in a `.txt` file.

## Usage
Put `city.list.json` and `get_sorted_CN_city.py` in the same directory and run in terminal:

```python
$ python get_sorted_CN_city.py
```





