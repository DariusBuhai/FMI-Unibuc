using System;
using Lab10.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Lab10.Models;
using Microsoft.AspNet.Identity;

namespace Lab10.Controllers
{
    public class CommentsController : Controller
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: Comments
        public ActionResult Index()
        {
            return View();
        }

        [HttpDelete]
        [Authorize(Roles = "User,Editor,Admin")]
        public ActionResult Delete(int id)
        {
            Comment comm = db.Comments.Find(id);
            if (comm.UserId == User.Identity.GetUserId() || User.IsInRole("Admin"))
            {
                db.Comments.Remove(comm);
                db.SaveChanges();
                return Redirect("/Articles/Show/" + comm.ArticleId);
            }
            else
            {
                TempData["message"] = "Nu aveti dreptul sa faceti modificari";
                return RedirectToAction("Index", "Articles");
            }
                
        }

        [Authorize(Roles = "User,Editor,Admin")]
        public ActionResult Edit(int id)
        {
            Comment comm = db.Comments.Find(id);

            if (comm.UserId == User.Identity.GetUserId() || User.IsInRole("Admin"))
            {
                return View(comm);
            }
            else
            {
                TempData["message"] = "Nu aveti dreptul sa faceti modificari";
                return RedirectToAction("Index", "Articles");
            }  
            
        }

        [HttpPut]
        [Authorize(Roles = "User,Editor,Admin")]
        public ActionResult Edit(int id, Comment requestComment)
        {
            try
            {
                Comment comm = db.Comments.Find(id);

                if (comm.UserId == User.Identity.GetUserId() || User.IsInRole("Admin"))
                {
                    if (TryUpdateModel(comm))
                    {
                        comm.Content = requestComment.Content;
                        db.SaveChanges();
                    }
                    return Redirect("/Articles/Show/" + comm.ArticleId);
                }
                else
                {
                    TempData["message"] = "Nu aveti dreptul sa faceti modificari";
                    return RedirectToAction("Index", "Articles");
                }      
            }
            catch (Exception e)
            {
                return View(requestComment);
            }
        }    
    }
}