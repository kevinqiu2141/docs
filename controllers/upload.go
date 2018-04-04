package controllers

import (
	"github.com/astaxie/beego"
	"os"
	"io"
)

type UploaderController struct {
	BaseController
}

func (u *UploaderController) Read() {
	u.Prepare()
	u.Data["BookName"] = u.Ctx.Input.Param(":bookname")
	u.TplName = "document/upload.tpl"
}

func (u *UploaderController) Upload() {
	u.Prepare()
	f, h, err := u.GetFile("uploadname")
	if f == nil {
		beego.Error("Can't Get File from form")
	}
    if err != nil {
        beego.Error(err)
    }
	defer f.Close()
	var uploadpath string
	uploadpath = "uploads/" + u.Ctx.Input.Param(":bookname")
	var result bool
	result, err = PathExists(uploadpath)
	if result != true {
		os.Mkdir(uploadpath, 0777)
	}
	beego.Debug(uploadpath)
	var file *os.File
	file, err = os.Create(uploadpath + "/" + h.Filename)
	if err != nil {
		beego.Error(os.Getenv("PWD"))
	}
	defer file.Close()
	io.Copy(file, f)
	u.TplName = "document/upload_finish.tpl"
}

func PathExists(path string) (bool, error) {
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
}
