<<<<<<< HEAD
# RailsApiDoc

rails api document generation

## Installation

Add this line to your application's Gemfile:

    gem 'api_doc_generation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api_doc_generation

## Usage

`rake doc:api [opts=xxx]`

__参数说明:__

  * CODES_PATH
    指定生成代码路径，默认为app/controllers/api
  * OUT_FORMAT
    simple_html 或者 detailed_html， 默认使用detailed_html 模板
  * SHOW_BASE
    是否为*BaseController结尾的controller生成文档，默认为false

__代码注释格式:__
d

  # 文件说明
  # About: xxxx
  # Host: 定义api host
  # Other: ...
  class Api::UsersController < class Api::BaseController
    # 取得所有用户
    # 
    # Params:
    #   page: [Integer] 类似page, per_page等可以不写描述，能自己生成说明
    #   per_page: [Integer] 每页数量
    # Return:
    #   count: [Integer] 数据总条数
    #   items: [Array] 当前页数据的数组
    # Level: read
    def list
      # ...
    end

    # (api说明)取得一个用户的信息
    # 
    # Params:
    #   user_id: [String:required] #用户的id, required生成文档显示必传参数
    # Return:
    #   name: [String] xxx
        address: [Object]
          zip: [Integer] 邮编
          detail: [String] 详细地址 #支持返回值嵌套Object
    # Error:
    #   info: [String] 自己定义的错误信息
    #   other: [String] 如果不设置的，将生成默认的
    def show
      # ...
    end

    # 自定义路由
    # 
    # Path: /path/to/api
    # Method: POST
    # Params:
    #   user_id: [String] 用户的id
    # Return:
    #   name: [String] xxx
    # Other: 自定义的信息
    # Other2: 更多的自定义信息..
    def update
      # ...
    end
  end
```

上面已经给出了api说明，参数，返回，错误信息,而api地址和请求方法将会自动从Rails中查找出来

__总的来说，注释格式有三种__

1. 只一层

```
# 层级1: 说明
```

2. 两层

```
# 层级1:
#   层级2: 说明
#   层级2: 说明
```

3. 超过两层

```
# 层级1:
#   层级2: 说明
#     层级3
#       更多的层级，这些层级只会显示在层级2中，等于就是层级2的说明
#   字段2: 说明
```


上面的格式可以任意组合，要注意的是，解析时层级是按 （空格 / 2）来计算的

## Level
  * 默认level显示所有
  * 输出时只会显示指定level的api
  * 所有的level为:
    ```read search update create delete```
  * 使用：
    ``` rake doc:api LEVEL=read,search```



## 注意
为加强文档规范化，以下情况的controller将不再生成显示出来：

1. 当前Controller没有文件说明
2. 当前controller的actions数量为0
3. 当前action没有Return说明

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
=======
# rails_api_doc_generation
>>>>>>> ed970dd7ee536bd7b8b5bd30746f49994be8fa89
