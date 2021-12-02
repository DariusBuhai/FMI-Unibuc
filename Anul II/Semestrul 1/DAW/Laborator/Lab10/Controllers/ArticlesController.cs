using Lab10.Models;
using Lab10.Models;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Lab10.Controllers
{
    public class ArticlesController : Controller
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: Article
        [Authorize(Roles = "User,Editor,Admin")]
        public ActionResult Index()
        {
            var articles = db.Articles.Include("Category").Include("User");
            ViewBag.Articles = articles;

            if (TempData.ContainsKey("message"))
            {
                ViewBag.Message = TempData["message"];
            }

            return View();
        }

        [Authorize(Roles = "User,Editor,Admin")]
        public ActionResult Show(int id)
        {
            Article article = db.Articles.Find(id);

            SetAccessRights();

            return View(article);

        }

        [HttpPost]
        [Authorize(Roles = "User,Editor,Admin")]
        public ActionResult Show(Comment comm)
        {
            comm.Date = DateTime.Now;
            comm.UserId = User.Identity.GetUserId();
            try
            {
                if (ModelState.IsValid)
                {
                    db.Comments.Add(comm);
                    db.SaveChanges();
                    return Redirect("/Articles/Show/" + comm.ArticleId);
                }

                else
                {
                    Article a = db.Articles.Find(comm.ArticleId);

                    SetAccessRights();

                    return View(a);
                }

            }

            catch (Exception e)
            {
                Article a = db.Articles.Find(comm.ArticleId);

                SetAccessRights();

                return View(a);
            }

        }

        [Authorize(Roles = "Editor,Admin")]
        public ActionResult New()
        {
            Article article = new Article();

            // preluam lista de categorii din metoda GetAllCategories()
            article.Categ = GetAllCategories();

            // Preluam ID-ul utilizatorului curent
            article.UserId = User.Identity.GetUserId();

            return View(article);
        }

        [HttpPost]
        [Authorize(Roles = "Editor,Admin")]
        public ActionResult New(Article article)
        {
            article.Date = DateTime.Now;
            article.UserId = User.Identity.GetUserId();
            try
            {
                if (ModelState.IsValid)
                {
                    db.Articles.Add(article);
                    db.SaveChanges();
                    TempData["message"] = "Articolul a fost adaugat";
                    return RedirectToAction("Index");
                }
                else
                {
                    article.Categ = GetAllCategories();
                    return View(article);
                }
            }
            catch (Exception e)
            {
                article.Categ = GetAllCategories();
                return View(article);
            }
        }

        [Authorize(Roles = "Editor,Admin")]
        public ActionResult Edit(int id)
        {
            Article article = db.Articles.Find(id);
            article.Categ = GetAllCategories();

            if (article.UserId == User.Identity.GetUserId() || User.IsInRole("Admin"))
            {
                return View(article);
            }

            else
            {
                TempData["message"] = "Nu aveti dreptul sa faceti modificari asupra unui articol care nu va apartine";
                return RedirectToAction("Index");
            }
        }

        [HttpPut]
        [Authorize(Roles = "Editor,Admin")]
        public ActionResult Edit(int id, Article requestArticle)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Article article = db.Articles.Find(id);

                    if (article.UserId == User.Identity.GetUserId() || User.IsInRole("Admin"))
                    {
                        if (TryUpdateModel(article))
                        {
                            article.Title = requestArticle.Title;
                            article.Content = requestArticle.Content;
                            article.CategoryId = requestArticle.CategoryId;
                            db.SaveChanges();
                            TempData["message"] = "Articolul a fost modificat";
                        }
                        return RedirectToAction("Index");
                    }
                    else
                    {
                        TempData["message"] = "Nu aveti dreptul sa faceti modificari asupra unui articol care nu va apartine";
                        return RedirectToAction("Index");
                    }
                }
                else
                {
                    requestArticle.Categ = GetAllCategories();
                    return View(requestArticle);
                }
            }
            catch (Exception e)
            {
                requestArticle.Categ = GetAllCategories();
                return View(requestArticle);
            }
        }

        [HttpDelete]
        [Authorize(Roles = "Editor,Admin")]
        public ActionResult Delete(int id)
        {
            Article article = db.Articles.Find(id);
            if (article.UserId == User.Identity.GetUserId() || User.IsInRole("Admin"))
            {
                db.Articles.Remove(article);
                db.SaveChanges();
                TempData["message"] = "Articolul a fost sters";
                return RedirectToAction("Index");
            }
            else
            {
                TempData["message"] = "Nu aveti dreptul sa stergeti un articol care nu va apartine";
                return RedirectToAction("Index");
            }     
        }

        [NonAction]
        public IEnumerable<SelectListItem> GetAllCategories()
        {
            // generam o lista goala
            var selectList = new List<SelectListItem>();

            // extragem toate categoriile din baza de date
            var categories = from cat in db.Categories
                             select cat;

            // iteram prin categorii
            foreach(var category in categories)
            {
                // adaugam in lista elementele necesare pentru dropdown
                selectList.Add(new SelectListItem
                {
                    Value = category.CategoryId.ToString(),
                    Text = category.CategoryName.ToString()
                });
            }
            /*
            foreach (var category in categories)
            {
                var listItem = new SelectListItem();
                listItem.Value = category.CategoryId.ToString();
                listItem.Text = category.CategoryName.ToString();

                selectList.Add(listItem);
            }*/

            // returnam lista de categorii
            return selectList;
        }

        private void SetAccessRights()
        {
            ViewBag.afisareButoane = false;
            if (User.IsInRole("Editor") || User.IsInRole("Admin"))
            {
                ViewBag.afisareButoane = true;
            }

            ViewBag.esteAdmin = User.IsInRole("Admin");
            ViewBag.utilizatorCurent = User.Identity.GetUserId();
        }
    }
}