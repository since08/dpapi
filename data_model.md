# 数据模型
## 用户模块
### 用户基本信息

**模型类名:** User

**模型表名:** users


| Field         | Type         | Null | Key | memo                  | 
|---------------|--------------|------|-----|-----------------------|
| id            | int(11)      | NO   | PRI | 数据主键               |  
| user_uuid     | varchar(32)  | NO   | UNI | 用户数据唯一id          |  
| user_name     | varchar(32)  | NO   | UNI | 用户名                 |  
| nick_name     | varchar(32)  | NO   |     | 昵称                   | 
| password      | varchar(32)  | NO   |     |                       | 
| password_salt | varchar(255) | NO   |     |                       | 
| gender        | int(11)      | YES  |     | 性别 （1 男， 2 　女 ）  | 
| email         | varchar(64)  | YES  | UNI | 邮箱                   | 
| mobile        | varchar(16)  | YES  | UNI | 手机                   | 
| avatar        | varchar(255) | YES  |     | 头像                   | 
| birthday      | date         | YES  |     | 生日                   | 
| reg_date      | datetime     | YES  |     | 注册时间                | 
| last_visit    | datetime     | YES  |     | 上次访问时间            | 
| created_at    | datetime     | NO   |     |                       |
| updated_at    | datetime     | NO   |     |                       |

## 合作伙伴模块

### 合作伙伴信息

**模型类名:** Affiliate
**模型表名:** affiliates


## 赛事模块

## 牌手模块